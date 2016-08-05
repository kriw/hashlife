module hashlife.Patterns.Eater;

import hashlife.Patterns.Pattern;
import hashlife.Field;

import std.string;
import std.stdio;
import std.algorithm;
import std.conv;

class Eater : Pattern{

    int[][] pattern;

    this(string option){
        super();
        pattern = getFieldFromFile("Resource/eater.txt");
        /* pattern = rotate(pattern,0); */

        auto opts = option.split();
        foreach( opt ; opts ){
            if(cmp( opt , "reverse" ) == 0){
                pattern = super.reverse(pattern);
            }
        }

    }

    void setToField(ref Field f,int x,int y){
        int startPos = f.getSize/4;
        foreach(i;0..pattern.length){
            foreach(j;0..pattern[i].length){
                int nx = to!int(j + x + startPos);
                int ny = to!int(i + y + startPos);
                f.setCell( nx ,ny,pattern[i][j]);
            }
        }
    }

    int[][] getField(){
        return pattern;
    }
}
