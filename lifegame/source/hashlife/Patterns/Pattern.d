module hashlife.Patterns.Pattern;

import std.stdio;
import std.conv;
import std.string;
import std.typecons;
import dlangui;

class Pattern {

    immutable int[] angleList = [0,90,180,270];
    this(){
    }

protected:

    int[][] getPattern(string fname,int angle){

        auto temp = getFieldFromFile(fname);
        temp = rotate(temp,angle);
        
        return  temp ;
    }


    int[][] rotate(int[][] pattern,int angle){
        int[][] ret;

        switch( angle ){
            case 0:
                ret = pattern;
                break;
            case 90:
                foreach(i;0..pattern[0].length){
                    ret ~= new int[pattern.length];
                    foreach(j;0..pattern.length){
                        ret[i][j] = pattern[j][pattern[0].length-i-1];
                    }
                }
                break;
            case 180:
                foreach(i;0..pattern.length){
                    ret ~= new int[pattern[0].length];
                    foreach(j;0..pattern[0].length){
                        ret[i][j] = pattern[pattern.length-i-1][pattern[0].length-j-1];
                    }
                }
                break;
            case 270:
                foreach(i;0..pattern[0].length){
                    ret ~= new int[pattern.length];
                    foreach(j;0..pattern.length){
                        ret[i][j] = pattern[pattern.length-j-1][i];
                    }
                }
                break;
            default:
                assert(false,"angle must 0 or 90 or 180 or 270.");
        }

        return ret;
    }

    int[][] getFieldFromFile(string fname){
        auto f1 = File(fname,"r");
        string s = f1.readln().chomp();
        int sz = 0;

        int[][] pattern;

        while( s.length > 1){
            auto len = s.length;
            pattern ~= new int[len];
            foreach(col;0..len){
                int c = to!int(s[col]-'0');
                if( c == 1 || c == 0){
                    pattern[sz][col] = c;
                }
            }
            sz++;
            s = f1.readln().chomp();
        }

        return pattern;
    }

    int[][] reverse(int[][] pattern){
        int[][] ret;
        foreach(i ; 0..pattern.length){
            ret ~= new int[pattern[i].length];
            foreach(j ; 0..pattern[i].length){
                ret[i][pattern[i].length-j-1] = pattern[i][j];
            }
        }
        return ret;
    }
}
