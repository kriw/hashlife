module hashlife.NodeDraw;

import std.stdio;
import hashlife.Node;

class NodeDraw{

    int height;
    this(int height){
        this.height = height;
    }

    void draw(Node node,int level){

        if( level < height ){
            draw(node.nw,level+1);
            draw(node.ne,level+1);
            draw(node.sw,level+1);
            draw(node.se,level+1);
        }else{
        }
    }

}
