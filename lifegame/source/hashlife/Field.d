module hashlife.Field;

import hashlife.Patterns;

import std.algorithm;
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

        auto orGate = new ORGate(0,0,"");
        orGate.setToField(this,3,3);

    }

    int getCellSize(){ return cellsize; }

    public void setScreen(int x,int y){
        screen.x = x;
        screen.y = y;
        int temp = min(screen.x,screen.y);
        cellsize = 2*temp/this.size;
    }

    int getSize(){
        return size;
    }

    void setField(int[][] pattern,int x,int y){
        foreach(i;0..pattern.length){
            foreach(j;0..pattern[i].length){
                int nx = to!int(j + x);
                int ny = to!int(i + y);
                setCell( nx ,ny,pattern[i][j]);
            }
        }
    }

    void setFieldFromFile(string fname,int x,int y,int angle,string option){

        /* auto pat = pm.getPattern(fname,angle); */
        /*  */
        /* if( cmp(option , "reverse" ) == 0 ){ */
        /*     pat = pm.reverse(pat); */
        /* } */

        /* setField(pat,x,y); */
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
