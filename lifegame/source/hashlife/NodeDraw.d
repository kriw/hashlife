module hashlife.NodeDraw;

import std.stdio;
import std.container;
import std.typecons;
import hashlife.Node;
import dlangui;

class NodeDraw{

    private int start;
    private int screenSize;
    private int cellSize;
    private immutable drawStep = 1;
    int height;
    RedBlackTree!ulong empList;

    this(int height, int start, int cellSize){
        this.height = height;
        this.start = start;
        this.cellSize = cellSize;
        this.screenSize = start*4;
        empList = new RedBlackTree!ulong();
    }
private:

    ulong drawRec(Node n, int x1, int x2, int y1, int y2, DrawBuf buf){
        if(n.getHash() in empList)
            return 0;

        if(n.level < n.height){
            int s = 0;
            s += drawRec(n.nw, x1, (x1+x2)/2, y1, (y1+y2)/2, buf);
            s += drawRec(n.ne, (x1+x2)/2, x2, y1, (y1+y2)/2, buf);
            s += drawRec(n.sw, x1, (x1+x2)/2, (y1+y2)/2, y2, buf);
            s += drawRec(n.se, (x1+x2)/2, x2, (y1+y2)/2, y2, buf);
            if(s == 0) {
                empList.insert(n.getHash());
            }
            return s;
        }else{
            assert(n.height == n.level,"Height and length are different.");
            int nx = (x2 - start) / 2;
            int ny = (y2 - start) / 2;
            if(n.cell == 1){
                buf.fillRect(Rect(nx*cellSize, ny*cellSize,
                            (nx+1)*cellSize, (ny+1)*cellSize), 0x00ff00);
            }
            return n.cell;
        }
    }

public:
    void draw(Node n,DrawBuf buf){
        buf.fillRect(Rect(0, 0, screenSize*cellSize, screenSize*cellSize), 0x000000);
        drawRec(n, 0, screenSize-1, 0, screenSize-1, buf);
    }
}
