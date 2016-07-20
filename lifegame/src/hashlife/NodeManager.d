module hashlife.NodeManager;

import std.stdio;
import std.bigint;
import hashlife.Node;

class NodeManager{
    Node node;
    this(Node n){
        this.node = n;
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

        return ret;
    }

    void extendNode(){
        Node[] emp = new Node[12];
        int level = node.level;
        foreach(ref n ; emp){
            n = new Node(level+1);
        }
        node.sw = createNode(node.sw,emp[0],emp[1],emp[2]);
        node.se = createNode(emp[3],node.se,emp[4],emp[5]);
        node.nw = createNode(emp[6],emp[7],node.sw,emp[8]);
        node.ne = createNode(emp[9],emp[10],emp[11],node.sw);
    }
}

