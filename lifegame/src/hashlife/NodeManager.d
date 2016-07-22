module hashlife.NodeManager;

import std.stdio;
import std.bigint;

import hashlife.Node;
import hashlife.Field;

class NodeManager{
    Node _node;
    Node[long][long] memo;
    Field field;

    this(Node n){
        _node = n;
        int size = 1<<(n.height);
        field = new Field(size,size);
        setFieldToNode();
    }

    void update(){
        _node = nextGen(_node);
        extendNode();
        draw();
    }

    void draw(){
        setNodeToField();
        field.draw();
    }

    void setFieldToNode(){
        int row = field.getRow();
        int col = field.getCol();
        recSetFieldToNode(_node,-1,col-1,-1,row-1);
        _node.calcHash1();
        _node.calcHash2();
    }

    void recSetFieldToNode(Node n,int x1,int x2,int y1,int y2){
        if(n.level < n.height){
            recSetFieldToNode(n.nw,x1,(x1+x2)/2,y1,(y1+y2)/2);
            recSetFieldToNode(n.ne,(x1+x2)/2,x2,y1,(y1+y2)/2);
            recSetFieldToNode(n.sw,x1,(x1+x2)/2,(y1+y2)/2,y2);
            recSetFieldToNode(n.se,(x1+x2)/2,x2,(y1+y2)/2,y2);
        }else{
            assert(x2-x1==1 && y2-y1==1,"Index is incoreect.");
            assert(n.height == n.level,"Height and length are different.");
            /* if( field.getCell(x1,y1) == 1){ */
            /*     writef("x1: %d y1: %d\n",x1,y1); */
            /* } */
            n.cell = field.getCell(x2,y2);
            /* if(n.cell == 1){ */
            /*     n.mark = true; */
            /*     writeln("===SET==="); */
            /*     writef("x1: %d y1: %d\n",x1,y1); */
            /*     writef("x2: %d y2: %d\n",x2,y2); */
            /*     writeln("========="); */
            /* } */
        }
    }
    void setNodeToField(){
        int row = field.getRow();
        int col = field.getCol();
        recSetNodeToField(_node,0,col-1,0,row-1);
    }

    void recSetNodeToField(Node n,int x1,int x2,int y1,int y2){
        if(n.level < n.height){
            recSetNodeToField(n.nw,x1,(x1+x2)/2,y1,(y1+y2)/2);
            recSetNodeToField(n.ne,(x1+x2+1)/2,x2,y1,(y1+y2)/2);
            recSetNodeToField(n.sw,x1,(x1+x2)/2,(y1+y2+1)/2,y2);
            recSetNodeToField(n.se,(x1+x2+1)/2,x2,(y1+y2+1)/2,y2);
        }else{
            /* writef("x1: %d y1: %d\n",x1,y1); */
            /* writef("x2: %d y2: %d\n",x2,y2); */
            assert(x1==x2 && y1==y2,"Index is incoreect.");
            assert(n.height == n.level,"Height and length are different.");
            field.setCell(x1,y1,n.cell);
        }
    }


    Node createNode(Node nw,Node ne,Node sw,Node se){
        assert( nw.level == ne.level &&
                ne.level == sw.level &&
                sw.level == se.level , "nodes level are different" );
        int level = nw.level;
        Node ret = new Node(level - 1);
        ret.nw = nw;
        ret.ne = ne;
        ret.sw = sw;
        ret.se = se;

        ret.calcHash1();
        ret.calcHash2();
        return ret;
    }

    Node createLeaf(int cells){
        Node ret = new Node(_node.height-1);
        ret.nw.cell = cells >> 3;
        ret.ne.cell = cells >> 2 & 1;
        ret.sw.cell = cells >> 1 & 1;
        ret.se.cell = cells & 1;
        return ret;
    }

    Node createEmpNode(int level){
        return new Node(level,false);
    }

    void extendNode(){
        int level = _node.level;
        Node emp = new Node(level+1);
        Node pEmp = createEmpNode(0);
        pEmp.nw = createNode(emp,emp,emp,_node.nw);
        pEmp.ne = createNode(emp,emp,_node.ne,emp);
        pEmp.sw = createNode(emp,_node.sw,emp,emp);
        pEmp.se = createNode(_node.se,emp,emp,emp);

        _node = pEmp;
        _node.calcHash1();
        _node.calcHash2();
    }

    Node centeredSubnode(Node node){
        with( node ){
            return createNode( nw.se, ne.sw, sw.ne, se.nw);
        }
    }

    Node centeredHorizontal(Node w, Node e) {
        return createNode(w.ne.se, e.nw.sw, w.se.ne, e.sw.nw);
    }

    Node centeredVertical(Node n, Node s) {
        return createNode(n.sw.se, n.se.sw, s.nw.ne, s.ne.nw);
    }

    Node centeredSubSubnode(Node node) {
        with( node ){
            return createNode(nw.se.se, ne.sw.sw, sw.ne.ne, se.nw.nw);
        }
    }

    Node nextGen(Node node){
        /* if( node.getHash1() in memo && */
        /*         node.getHash2() in memo[node.getHash1()] ) { */
        /*     return memo[node.getHash1()][node.getHash2()]; */
        /* } */
        if( this._node.height-node.level == 2){ 

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
            int upright = p02 << 3 || p03 << 2 || p12 << 1 | p13;
            int left = p10 << 3 | p11 << 2 | p20 << 1 | p21;
            int right = p12 << 3 | p13 << 2 | p22 << 1 | p23;
            int downleft = p20 << 3 | p21 << 2 | p30 << 1 | p31;
            int down = p21 << 3 | p22 << 2 | p31 << 1 | p32;
            int downright = p22 << 3 | p23 << 2 | p32 << 1 | p33;
            /* with( node ){ */
            /*     if( ne.ne.mark || ne.nw.mark ||  */
            /*             ne.sw.mark || ne.se.mark || */
            /*             nw.ne.mark || nw.nw.mark ||  */
            /*             nw.sw.mark || nw .se.mark || */
            /*             sw.ne.mark || sw.nw.mark ||  */
            /*             sw.sw.mark || sw .se.mark || */
            /*             se.ne.mark || se.nw.mark ||  */
            /*             se.sw.mark || se.se.mark ){ */
            /*         writeln("MARK"); */
            /*         writef("%d%d%d%d\n",p00,p01,p02,p03); */
            /*         writef("%d%d%d%d\n",p10,p11,p12,p13); */
            /*         writef("%d%d%d%d\n",p20,p21,p22,p23); */
            /*         writef("%d%d%d%d\n",p30,p31,p32,p33); */
            /*     } */
            /*  */
            /* } */

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
            /* writef("p: %d\n",p); */
            /* writeln(  (s2 & p) | s3 ); */
            return createLeaf( (s2 & p) | s3 );
        }else{
            with( node ){
                Node 
                        n00 = centeredSubnode(nw),
                        n01 = centeredHorizontal(nw, ne),
                        n02 = centeredSubnode(ne),

                        n10 = centeredVertical(nw, sw),
                        n11 = centeredSubSubnode( node ),
                        n12 = centeredVertical(ne, se),

                        n20 = centeredSubnode(sw),
                        n21 = centeredHorizontal(sw,se),
                        n22 = centeredSubnode(se);

                Node next =  createNode(
                        nextGen(createNode( n00, n01, n10, n11)),
                        nextGen(createNode( n01, n02, n11, n12)),
                        nextGen(createNode( n10, n11, n20, n21)),
                        nextGen(createNode( n11, n12, n21, n22))
                        );
                memo[node.getHash1()][node.getHash2()] = next;
                return next;
            }

        }
    }

}

