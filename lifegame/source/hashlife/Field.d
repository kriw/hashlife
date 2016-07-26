module hashlife.Field;

import std.stdio;
import std.conv;
import dlangui;

class Field{

    private int[] field;
    private int row;
    private int col;
    private int now;
    private int startX;
    private int startY;
    private immutable int cellsize = 10;

    public:
    this(int row,int col){
        field = new int[ (row+2)*(col+2)*2 ];
        this.row = row;
        this.col = col;
        this.startY = row/4;
        this.startX = col/4;
        this.now = 0;

        setFieldFromFile("Resource/glider_gun.txt",startX+1,startY+1);
        /* setCell(startX+2,startY+2,1); */
        /* setCell(startX+2,startY+3,1); */
        /* setCell(startX+3,startY+2,1); */
        /* setCell(startX+3,startY+3,1); */
    }

    public void drawGUI(DrawBuf buf){
        foreach(i;startX..row-startX){
            foreach(j;startY..col-startY){
                if(getCell(j,i)){
                    int nx = j - startX;
                    int ny = i - startY;
                    buf.fillRect(Rect(nx*cellsize,ny*cellsize,(nx+1)*cellsize,(ny+1)*cellsize),0x00ff00);
                }
            }
        }
    }

    void draw(){
        foreach(i;0..row){
            foreach(j;0..col){
                write(getCell(j,i));
            }
            writeln("");
        }
    }

    int getRow(){
        return row;
    }
    int getCol(){
        return col;
    }
    void setFieldFromFile(string fname,int x,int y){
        auto f1 = File(fname,"r");
        string s = f1.readln();
        int row = 0;

        while( s.length > 1){
            auto len = s.length;
            foreach(col;0..len){

                int c = to!int(s[col]-'0');
                if( c == 1 || c == 0){
                    write(c);
                    setCell( to!int(x+col) ,y+row,c);
                }
            }
            row++;
            s = f1.readln();
        }
    }

    void nextGen(){
        now = (now+1)%2;
    }

    int calcPos(int x,int y){
        return 2*(y+1)*col + x+1;
    }

    int getCell(int x,int y){
        return field[ calcPos(x,y) ];
    }

    void setCell(int x,int y,int c){
        field[ calcPos(x,y) ] = c;
    }
    
}
