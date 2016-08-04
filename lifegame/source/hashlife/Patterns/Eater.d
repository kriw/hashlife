module hashlife.Patterns.Eater;

import hashlife.Patterns.Pattern;

import std.string;
import std.stdio;
import std.algorithm;

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

    int[][] getField(){
        return pattern;
    }
}
