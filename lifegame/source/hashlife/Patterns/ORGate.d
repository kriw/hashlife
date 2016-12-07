module hashlife.Patterns.ORGate;

import std.conv;

import hashlife.Field;
import hashlife.Patterns.Pattern;
import hashlife.Patterns.Glider;
import hashlife.Patterns.Eater;

class ORGate : Pattern{

    Glider[] glider;
    Eater eater;


    this(int A,int B,string opt){
        string opt1 = A == 0 ? "eater" : "";
        string opt2 = B == 0 ? "eater" : "";
        glider ~= new Glider("");
        glider ~= new Glider(opt1);
        glider ~= new Glider(opt2);
        glider ~= new Glider("reverse");
        eater = new Eater("reverse");
    }

    void setToField(Field f,int x,int y){
        int dx = 40;
        int startPos = f.getSize/4;
        foreach( k ; 0..glider.length ){
            auto pattern = glider[k].getField();
            foreach(i;0..pattern.length){
                foreach(j;0..pattern[i].length){
                    int nx = to!int(j + x + startPos + (dx * k));
                    nx = k <= 2 ? nx+1 : nx;
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
                nx += 86;
                f.setCell( nx ,ny,pattern[i][j]);
            }
        }
    }

}
