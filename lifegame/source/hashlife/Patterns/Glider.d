module hashlife.Patterns.Glider;

import hashlife.Patterns.Pattern;

import std.string;
import std.stdio;
import std.algorithm;

class Glider : Pattern{

    int[][] pattern;

    this(string option){
        super();
        pattern = getFieldFromFile("Resource/glider_gun.txt");
        /* pattern = rotate(pattern,0); */

        auto opts = option.split();
        foreach( opt ; opts ){
            if(cmp( opt , "reverse" ) == 0){
                pattern = super.reverse(pattern);
            }else if(cmp(opt , "eater" ) == 0){
                pattern = getFieldFromFile("Resource/glider_gun_eater.txt");
            }
        }

    }

    int[][] getField(){
        return pattern;
    }
}
