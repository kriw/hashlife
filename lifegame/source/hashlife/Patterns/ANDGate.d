module hashlife.Patterns.ANDGate;

import std.conv;

import hashlife.Field;
import hashlife.Patterns.Pattern;
import hashlife.Patterns.Glider;
import hashlife.Patterns.Eater;

class ANDGate : Pattern{

    Glider[] glider;
    Eater eater;


    this(int A,int B,string opt){
        string opt1 = A == 1 ? "eater" : "";
        string opt2 = B == 1 ? "eater" : "";
        opt1 ~= " " ~ opt;
        opt2 ~= " " ~ opt;
        glider ~= new Glider(opt1);
        glider ~= new Glider(opt2);
        glider ~= new Glider("reverse" ~ " " ~ opt);
        eater = new Eater(opt);
    }

    void setToField(ref Field f,int x,int y){
        int dx = 47;
        int startPos = f.getSize/4;
        foreach( k ; 0..glider.length ){
            auto pattern = glider[k].getField();
            foreach(i;0..pattern.length){
                foreach(j;0..pattern[i].length){
                    int nx = to!int(j + x + startPos + dx * k);
                    int ny = to!int(i + y + startPos);
                    f.setCell( nx ,ny,pattern[i][j]);
                }
            }
        }

        auto pattern = eater.getField();
        foreach(i ; 0..pattern.length){
            foreach(j;0..pattern[i].length){
                int nx = to!int(j + x + startPos + 41);
                int ny = to!int(i + y + startPos + 71);
                f.setCell( nx ,ny,pattern[i][j]);
            }
        }
    }

}
