module simple.simple;

import std.stdio;
import std.conv;
import dlangui;

class SimpleLife : Widget{

    int row;
    int col;
    int cellsize = 10;
    Field field;

public:
    this(int row,int col){
        field = new Field(row,col);
        this.row = row;
        this.col = col;
    }

    override void onDraw(DrawBuf buf){
        update();
        foreach(i ; 0..row){
            foreach(j ; 0..col){
                if(field.getNowCell(j,i)){
                    draw(buf,j,i);
                }
            }
        }
    }

    void draw(DrawBuf buf,int x,int y){
        buf.fillRect( Rect(cellsize*x,cellsize*y,cellsize*(x+1),cellsize*(y+1)),0xff0000 );
    }

    void update(){
        foreach(i ; 0..row){
            foreach(j ; 0..col){
                field.update(j,i);
            }
        }
        field.nextGen();
    }

    void output(){
        foreach(i ; 0..row){
            foreach(j ; 0..col){
                write( field.getNowCell(j,i) );
            }
            writeln("");
        }

        readln();
    }


    class Field{

        private int[][] field;
        private int row;
        private int col;
        private int now;

    public:
        this(int row,int col){
            field ~= new int[ (row+2)*(col+2)*2 ];
            field ~= new int[ (row+2)*(col+2)*2 ];
            this.row = row;
            this.col = col;
            this.now = 0;

            setFieldFromFile("Resource/glider_gun.txt",1,1);

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
                        setNowCell( to!int(x+col) ,y+row,c);
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

        int getNowCell(int x,int y){
            return field[now][ calcPos(x,y) ];
        }

        void setNowCell(int x,int y,int c){
            field[now][ calcPos(x,y) ] = c;
        }

        int getCell(int x,int y,int gen){
            return field[gen][ calcPos(x,y) ];
        }

        void setCell(int x,int y,int c,int gen){
            field[gen][ calcPos(x,y) ] = c;
        }

        void update(int x,int y){
            int self = getNowCell(x,y);
            int c = -getCell(x,y,now);
            int next = (now+1)%2;

            foreach(dx ; -1..2){
                foreach( dy ; -1..2 ){
                    int nx = x+dx;
                    int ny = y+dy;
                    c += getNowCell(nx,ny);
                }
            }

            if( self == 1 ){
                if(c == 2 || c == 3){
                    setCell(x,y,1,next);
                }else{
                    setCell(x,y,0,next);
                }
            }else if(self == 0){
                if(c == 3){
                    setCell(x,y,1,next);
                }else{
                    setCell(x,y,0,next);
                }
            }

        }

    }
}
