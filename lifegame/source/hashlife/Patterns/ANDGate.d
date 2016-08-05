module hashlife.Patterns.ANDGate;

import std.conv;
import std.algorithm;

import hashlife.Field;
import hashlife.Patterns.Pattern;
import hashlife.Patterns.Glider;
import hashlife.Patterns.Eater;

class ANDGate : Pattern{

    Glider[] glider;
    Eater eater;
    bool isReverse = false;


    this(int A,int B,string opt){
        string opt1 = A == 0 ? "eater" : "";
        string opt2 = B == 0 ? "eater" : "";

        /* opt1 ~= " " ~ opt; */
        /* opt2 ~= " " ~ opt; */
        if( cmp(opt,"reverse") == 0){
            isReverse = true;
        }
        eater = new Eater( isReverse ? "reverse" : "");


        if( isReverse ){
            glider ~= new Glider("");
            glider ~= new Glider("reverse " ~ opt2);
            glider ~= new Glider("reverse " ~ opt1);
        }else{
            glider ~= new Glider(opt1);
            glider ~= new Glider(opt2);
            glider ~= new Glider("reverse");
        }
    }

    void setToField(ref Field f,int x,int y){
        int dx = 46;
        int startPos = f.getSize/4;
        foreach( k ; 0..glider.length ){
            auto pattern = glider[k].getField();
            foreach(i;0..pattern.length){
                foreach(j;0..pattern[i].length){
                    int nx = to!int(j + x + startPos + dx * k);
                    if(isReverse){
                        nx = k >= 1 ? nx+1 : nx ;
                    }else{
                        nx = k>=2 ? nx+1 : nx;
                    }
                    int ny = to!int(i + y + startPos);
                    f.setCell( nx ,ny,pattern[i][j]);
                }
            }
        }

        auto pattern = eater.getField();
        foreach(i ; 0..pattern.length){
            foreach(j;0..pattern[i].length){
                int nx = to!int(j + x + startPos + 40);
                int ny = to!int(i + y + startPos + 71);
                nx += isReverse ? 45 : 0;
                f.setCell( nx ,ny,pattern[i][j]);
            }
        }
    }

}
