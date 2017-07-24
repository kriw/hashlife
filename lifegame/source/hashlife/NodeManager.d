module hashlife.NodeManager;

import std.stdio;

import hashlife.NodeDraw;
import hashlife.Node;
import hashlife.Field;
import utils;

import dlangui;
import memutils.hashmap;

class NodeManager : Widget {
    Node _node;
    Node[] emp;
    NodeDraw drawer;
    Node[Node][Node.MOD] memo;
    Node[Node][Node.MOD] memoPow2;
    int speed;

    this(int sizex, int sizey){
        initEmpNode();
        Node.emp = emp;
        int size = 1 << (Node.height);
        _node = extendNode(createField());

        int start = size / 4;
        int cellsize = max(2 * min(sizex, sizey) / size, 1);
        int screenSize = max(sizex, sizey);
        drawer = new NodeDraw(_node.height, screenSize, cellsize);
        
        speed = 0;
    }

    void initEmpNode(){
        int templevel = 0;
        foreach(i; 0.._node.height+2){
            emp ~= createEmpNode(i);
        }
        foreach(i; 1.._node.height+2){
            emp[i-1].nw = emp[i];
            emp[i-1].ne = emp[i];
            emp[i-1].sw = emp[i];
            emp[i-1].se = emp[i];
        }
    }

    override @property bool animating(){
        return true;
    }

    int abc = 0;
    override void onDraw(DrawBuf buf){
        drawer.draw(_node, buf);
        update();
        writef("update: %d\n", abc++);
    }

    void update(){
        _node = nextGen(_node, speed);
        _node = extendNode(_node);
    }

    string[] metaPix;
    Node createField() {
        int row = 2048;
        int col = 2048;
        metaPix = parse("otcametapixel.rle", 2058, 2058);
        Node onNode = recSetFieldToNode(2, 0, col-1 , 0, row-1);

        metaPix = parse("otcametapixeloff.rle", 2058, 2058);
        Node offNode = recSetFieldToNode(2, 0, col-1 , 0, row-1);

        return createNode(onNode, offNode, onNode, onNode);
    }

    Node recSetFieldToNode(int level, int x1, int x2, int y1, int y2){
        if(level < Node.height-1){
            Node n = new Node(level, false);
            n.nw = recSetFieldToNode(level+1, x1, (x1+x2)/2, y1, (y1+y2)/2);
            n.ne = recSetFieldToNode(level+1, (x1+x2+1)/2, x2, y1, (y1+y2)/2);
            n.sw = recSetFieldToNode(level+1, x1, (x1+x2)/2, (y1+y2+1)/2, y2);
            n.se = recSetFieldToNode(level+1, (x1+x2+1)/2, x2, (y1+y2+1)/2, y2);
            n.calcHash(true);
            return optimize(n);
        }else{
            /* assert(x1==x2-1 && y1==y2-1, "Index is incoreect."); */
            /* assert(Node.height-1 == level, "Height and length are different."); */
            int ny1 = y1;
            int ny2 = y2;
            int nx1 = x1;
            int nx2 = x2;
            byte nw = metaPix[ny1][nx1] == 'o' ? 1 : 0;
            byte ne = metaPix[ny1][nx2] == 'o' ? 1 : 0;
            byte sw = metaPix[ny2][nx1] == 'o' ? 1 : 0;
            byte se = metaPix[ny2][nx2] == 'o' ? 1 : 0;
            Node n = createLeaf(nw << 3 | ne << 2 | sw << 1 | se << 0);
            n.calcHash(true);
            return optimize(n);
        }
    }


    Node createNode(Node nw,Node ne,Node sw,Node se){
        assert( nw.level == ne.level &&
                ne.level == sw.level &&
                sw.level == se.level , "nodes level are different" );
        int level = nw.level;
        Node ret = new Node(level - 1, false);
        ret.nw = nw;
        ret.ne = ne;
        ret.sw = sw;
        ret.se = se;

        ret.calcHash(false);
        return optimize(ret);
    }

    Node createLeaf(int cells){
        Node ret = new Node(_node.height-1);
        ret.nw.cell = (cells >> 3).to!byte();
        ret.ne.cell = cells >> 2 & 1;
        ret.sw.cell = cells >> 1 & 1;
        ret.se.cell = cells & 1;

        ret.calcHash(true);
        return ret;
    }

    Node createEmpNode(int level){
        return new Node(level, false);
    }

    Node extendNode(Node n){
        int level = n.level;
        Node pEmp = createEmpNode(0);
        pEmp.nw = createNode(emp[level+1], emp[level+1], emp[level+1], n.nw);
        pEmp.ne = createNode(emp[level+1], emp[level+1], n.ne, emp[level+1]);
        pEmp.sw = createNode(emp[level+1], n.sw, emp[level+1], emp[level+1]);
        pEmp.se = createNode(n.se, emp[level+1], emp[level+1], emp[level+1]);

        n = pEmp;
        n.calcHash();
        return optimize(n);
    }

    Node centeredSubnode(Node node){
        with(node) {
            return createNode(nw.se, ne.sw, sw.ne, se.nw);
        }
    }

    Node centeredHorizontal(Node w, Node e) {
        return createNode(w.ne.se, e.nw.sw, w.se.ne, e.sw.nw);
    }

    Node centeredVertical(Node n, Node s) {
        return createNode(n.sw.se, n.se.sw, s.nw.ne, s.ne.nw);
    }

    Node centeredSubSubnode(Node node) {
        with(node){
            return createNode(nw.se.se, ne.sw.sw, sw.ne.ne, se.nw.nw);
        }
    }

    Node nextGen(Node node, int speed){
        
        if(this._node.height-node.level == 2){ 
            if(node in memo[node.getHash()])
                return memo[node.getHash()][node];

            int p00 = node.nw.nw.cell;
            int p01 = node.nw.ne.cell;
            int p02 = node.ne.nw.cell;
            int p03 = node.ne.ne.cell;

            int p10 = node.nw.sw.cell;
            int p11 = node.nw.se.cell;
            int p12 = node.ne.sw.cell;
            int p13 = node.ne.se.cell;

            int p20 = node.sw.nw.cell;
            int p21 = node.sw.ne.cell;
            int p22 = node.se.nw.cell;
            int p23 = node.se.ne.cell;

            int p30 = node.sw.sw.cell;
            int p31 = node.sw.se.cell;
            int p32 = node.se.sw.cell;
            int p33 = node.se.se.cell;
            int p = p11 << 3 | p12 << 2 | p21 << 1 | p22;
            int upleft = p00 << 3 | p01 << 2 | p10 << 1 | p11;
            int up = p01 << 3 | p02 << 2 | p11 << 1 | p12;
            int upright = p02 << 3 | p03 << 2 | p12 << 1 | p13;
            int left = p10 << 3 | p11 << 2 | p20 << 1 | p21;
            int right = p12 << 3 | p13 << 2 | p22 << 1 | p23;
            int downleft = p20 << 3 | p21 << 2 | p30 << 1 | p31;
            int down = p21 << 3 | p22 << 2 | p31 << 1 | p32;
            int downright = p22 << 3 | p23 << 2 | p32 << 1 | p33;
            int s1,s2,s3;
            int c;
            s1 = s2 = s3 = 0;

            s2 = upleft & up;
            s1 = upleft ^ up;

            c = (s1 & upright) & s2;
            s3 = s3 ^ c;
            s2 = ( s1 & upright ) ^ s2;
            s1 = s1 ^ upright;

            c = (s1 & left) & s2;
            s3 = s3 ^ c;
            s2 = ( s1 & left ) ^ s2;
            s1 = s1 ^ left;

            c = (s1 & right) & s2;
            s3 = s3 ^ c;
            s2 = ( s1 & right ) ^ s2;
            s1 = s1 ^ right;

            c = (s1 & downleft) & s2;
            s3 = s3 ^ c;
            s2 = ( s1 & downleft ) ^ s2;
            s1 = s1 ^ downleft;

            c = (s1 & down) & s2;
            s3 = s3 ^ c;
            s2 = ( s1 & down ) ^ s2;
            s1 = s1 ^ down;

            c = (s1 & downright) & s2;
            s3 = s3 ^ c;
            s2 = ( s1 & downright ) ^ s2;
            s1 = s1 ^ downright;

            int ss3 = ~s3 & s2 & s1;
            int ss2 = ~s3 & s2 & (~s1);
            Node next = createLeaf((ss2 & p) | ss3);
            return memo[node.getHash()][node] = optimize(next);

        }else{
            Node next;
            if(this._node.height-node.level > 2 + speed){
                if(node in memo[node.getHash()])
                    return memo[node.getHash()][node];

                with(node){
                    Node    n00 = centeredSubnode(nw),
                            n01 = centeredHorizontal(nw, ne),
                            n02 = centeredSubnode(ne),

                            n10 = centeredVertical(nw, sw),
                            n11 = centeredSubSubnode(node),
                            n12 = centeredVertical(ne, se),

                            n20 = centeredSubnode(sw),
                            n21 = centeredHorizontal(sw, se),
                            n22 = centeredSubnode(se);

                    next =  createNode(
                                nextGen(createNode(n00, n01, n10, n11) ,speed),
                                nextGen(createNode(n01, n02, n11, n12) ,speed),
                                nextGen(createNode(n10, n11, n20, n21) ,speed),
                                nextGen(createNode(n11, n12, n21, n22) ,speed)
                            );
                }
                return memo[node.getHash()][node] = next;
            }else{
                if(node in memoPow2[node.getHash()])
                    return memoPow2[node.getHash()][node];

                with(node){
                    Node    n00 = nextGen(nw, speed),
                            n01 = nextGen(createNode(nw.ne,ne.nw,nw.se,ne.sw), speed),
                            n02 = nextGen(ne, speed),

                            n10 = nextGen(createNode(nw.sw, nw.se, sw.nw, sw.ne), speed),
                            n11 = nextGen(createNode(nw.se, ne.sw, sw.ne, se.nw), speed),
                            n12 = nextGen(createNode(ne.sw, ne.se, se.nw, se.ne), speed),

                            n20 = nextGen(sw, speed),
                            n21 = nextGen(createNode(sw.ne, se.nw, sw.se, se.sw), speed),
                            n22 = nextGen(se, speed);

                    next =  createNode(
                                nextGen(createNode(n00, n01, n10, n11), speed),
                                nextGen(createNode(n01, n02, n11, n12), speed),
                                nextGen(createNode(n10, n11, n20, n21), speed),
                                nextGen(createNode(n11, n12, n21, n22), speed)
                            );

                }
                return memoPow2[node.getHash()][node] = next;
            }
        }

    }
}

