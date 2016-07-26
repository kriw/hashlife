module hashlife.NodeDraw;

import std.stdio;
import hashlife.Node;

class NodeDraw{

    int height;
    this(int height){
        this.height = height;
    }

    void draw(Node node,int level,int x1,int x2,int y1,int y2){

        if(x1!=x2 && y1!=y2 &&  level < height ){
            draw(node.nw,level+1,x1,(x1+x2)/2,y1,(y1+y2)/2);
            draw(node.ne,level+1,x1,(x1+x2)/2,(y1+y2)/2,y2);
            draw(node.sw,level+1,(x1+x2)/2,x2,y1,(y1+y2)/2);
            draw(node.se,level+1,(x1+x2)/2,x2,(y1+y2)/2,y2);
        }else{
            assert(x1==x2 && y1==y2);
        }
    }

}
