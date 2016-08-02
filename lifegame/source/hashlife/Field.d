module hashlife.Field;

import std.stdio;
import std.conv;
import std.typecons;
import dlangui;

class Field{

    alias Size = Tuple!(int, "x",int, "y");
    private int[] field;
    private int size;
    private int now;
    Size start;
    Size screen;
    private int cellsize;

    public:
    this(int ss,int sx,int sy){
        this.size = ss;
        this.start.y = this.size/4;
        this.start.x = this.size/4;
        this.now = 0;
        field = new int[ (size+2)*(size+2)*2 ];
        setScreen(sx,sy);
        /* setFieldFromFile("Resource/glider_gun.txt",start.x+1,start.y+1); */
        /* setFieldFromFile("Resource/snark.txt",start.x+250,start.y+250); */
        /* setFieldFromFile("Resource/twinbees.txt",start.x+50,start.y+50); */
        setFieldFromFile("Resource/rpentmino.txt",start.x+50,start.y+50);

    }

    int getCellSize(){ return cellsize; }

    public void setScreen(int x,int y){
        screen.x = x;
        screen.y = y;
        auto temp = min(screen.x,screen.y);
        cellsize = 2*temp/this.size;
    }

    int getSize(){
        return size;
    }

    void setFieldFromFile(string fname,int x,int y){
        auto f1 = File(fname,"r");
        string s = f1.readln();
        int sz = 0;

        while( s.length > 1){
            auto len = s.length;
            foreach(col;0..len){

                int c = to!int(s[col]-'0');
                if( c == 1 || c == 0){
                    setCell( to!int(x+col),y+sz,c);
                }
            }
            sz++;
            s = f1.readln();
        }
    }

    int calcPos(int x,int y){
        return 2*(y+1)*size + x+1;
    }

    int getCell(int x,int y){
        return field[ calcPos(x,y) ];
    }

    void setCell(int x,int y,int c){
        field[ calcPos(x,y) ] = c;
    }
    
}
