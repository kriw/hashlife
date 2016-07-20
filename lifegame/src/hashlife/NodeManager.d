module hashlife.NodeManager;

import std.stdio;
import std.bigint;
import hashlife.Node;

class NodeManager{
    Node _node;
    Node[BigInt] memo;
    this(Node n){
        _node = n;
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

        ret.calcHash();
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


    void extendNode(){
        Node[] emp = new Node[12];
        int level = _node.level;
        foreach(ref n ; emp){
            n = new Node(level+1);
        }
        _node.sw = createNode(_node.sw,emp[0],emp[1],emp[2]);
        _node.se = createNode(emp[3],_node.se,emp[4],emp[5]);
        _node.nw = createNode(emp[6],emp[7],_node.sw,emp[8]);
        _node.ne = createNode(emp[9],emp[10],emp[11],_node.sw);
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
        writeln(node.level);
        if( node.getHash() in memo ) {
            return memo[node.getHash()];
        }
        if( this._node.height-node.level == 2){ int p00 = node.nw.nw.cell;

            int p01 = node.nw.ne.cell;
            int p02 = node.ne.nw.cell;
            int p03 = node.ne.ne.cell;
            int p10 = node.nw.sw.cell;
            int p11 = node.nw.se.cell;
            int p12 = node.ne.sw.cell;
            int p13 = node.ne.se.cell;
            int p20 = node.sw.ne.cell;
            int p21 = node.sw.nw.cell;
            int p22 = node.se.ne.cell;
            int p23 = node.se.nw.cell;
            int p30 = node.sw.sw.cell;
            int p31 = node.sw.se.cell;
            int p32 = node.se.sw.cell;
            int p33 = node.se.sw.cell;
            int p = p11 << 3 | p12 << 2 | p21 << 1 | p22;
            int upleft = p00 << 3 | p01 << 2 | p10 << 1 | p11;
            int up = p01 << 3 | p02 << 2 | p11 << 1 | p12;
            int upright = p02 << 3 || p03 << 2 || p12 << 1 | p13;
            int left = p10 << 3 | p11 << 2 | p20 << 1 | p21;
            int right = p12 << 3 | p13 << 2 | p22 << 1 | p23;
            int downleft = p20 << 3 | p21 << 2 | p30 << 1 | p31;
            int down = p21 << 3 | p22 << 2 | p31 << 1 | p32;
            int downright = p22 << 3 | p23 << 2 | p32 << 1 | p33;

            int s1,s2,s3;
            s1 = upleft;

            s2 = s1 & up;
            s1 = s1 ^ up;

            s3 = s2 & upright;
            s2 = ( s1 & upright ) ^ s2;
            s1 = s1 ^ upright;

            s3 = s2 & left;
            s2 = ( s1 & left ) ^ s2;
            s1 = s1 ^ left;

            s3 = s2 & right;
            s2 = ( s1 & right ) ^ s2;
            s1 = s1 ^ right;

            s3 = s2 & downleft;
            s2 = ( s1 & downleft ) ^ s2;
            s1 = s1 ^ downleft;

            s3 = s2 & down;
            s2 = ( s1 & down ) ^ s2;
            s1 = s1 ^ down;

            s3 = s2 & downright;
            s2 = ( s1 & downright ) ^ s2;
            s1 = s1 ^ downright;
            return _node;
        }else{
            with( node ){
                Node 
                    n00 = centeredSubnode(nw),
                        n01 = centeredHorizontal(nw, ne),
                        n02 = centeredSubnode(ne),
                        n10 = centeredVertical(nw, sw),
                        n11 = centeredSubSubnode( node ),
                        n12 = centeredVertical(nw, se),
                        n20 = centeredSubnode(sw),
                        n21 = centeredHorizontal(sw,se),
                        n22 = centeredSubnode(se);

                Node next =  createNode(
                        nextGen(createNode( n00, n01, n10, n11)),
                        nextGen(createNode( n01, n02, n11, n12)),
                        nextGen(createNode( n10, n11, n20, n21)),
                        nextGen(createNode( n11, n12, n21, n22))
                        );
                memo[node.getHash()] = next;
                return next;
            }

        }
    }

}

