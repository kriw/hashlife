module hashlife.NodeDraw;

import std.stdio;
import std.container;
import std.typecons;
import hashlife.Node;
import dlangui;

class NodeDraw{

    alias HashType = Tuple!(ulong,ulong);

    private int start;
    private int fieldSize;
    private int cellSize;
    private immutable drawStep = 1;
    int height;
    RedBlackTree!HashType empList;

    this(int height,int start,int cellSize){
        this.height = height;
        this.start = start;
        this.cellSize = cellSize;
        this.fieldSize = start*4;
        empList = new RedBlackTree!HashType();
        setEmpList();
    }
private:

    void setEmpList(){
        assert(empList !is null);
        Node temp = new Node(0);
        while(temp.nw !is null){
            HashType ht = HashType(temp.calcHash1(),temp.calcHash2());
            empList.insert( ht );
            temp = temp.nw;
        }
    }

    void drawRec(Node n,int x1,int x2,int y1,int y2,DrawBuf buf){
        if( HashType(n.getHash1(),n.getHash2()) in empList ) {
            return;
        }

        if(n.level < n.height){
            drawRec(n.nw,x1,(x1+x2)/2,y1,(y1+y2)/2,buf);
            drawRec(n.ne,(x1+x2)/2,x2,y1,(y1+y2)/2,buf);
            drawRec(n.sw,x1,(x1+x2)/2,(y1+y2)/2,y2,buf);
            drawRec(n.se,(x1+x2)/2,x2,(y1+y2)/2,y2,buf);
        }else{
            assert(x2-x1==1 && y2-y1==1,"Index is incoreect.");
            assert(n.height == n.level,"Height and length are different.");
            int nx = x2 - start;
            int ny = y2 - start;
            if( n.cell == 1){
                buf.fillRect(Rect(nx*cellSize, ny*cellSize, (nx+1)*cellSize, (ny+1)*cellSize), 0x00ff00);
            }
        }
    }

public:
    void draw(Node n,DrawBuf buf){
        buf.fillRect(Rect(0, 0, fieldSize*cellSize, fieldSize*cellSize), 0x000000);
        drawRec(n,-1,fieldSize-1,-1,fieldSize-1,buf);
    }
}
