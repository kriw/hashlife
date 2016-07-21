module hashlife.Node;

import std.bigint;
import std.stdio;

class Node{
    Node nw,ne,sw,se;
    public static const int height = 6;
    private long[2] hash;
    int level;
    public int cell;

    static const long MOD1 = 1000000007;
    static const long MOD2 = 1000000009;

    static const long a  = 7;
    static const long P0 = 1;
    static const long P1 = 100003;
    static const long P2 = 10000600009;
    static const long P3 = 1000090002700027;

    this(int level,bool isInit = true){
        this.level = level;
        hash = [0,0];
        if( isInit ){
            Init(level);
        }else{
        }
    }

    long calcHash1(){
        if( level == height ) return hash[0];
        if( hash[0] == 0){
            long h1 = this.nw.calcHash1();
            long h2 = this.ne.calcHash1();
            long h3 = this.sw.calcHash1();
            long h4 = this.se.calcHash1();
            long h =  h1*P0 + h2*P1  + h3*P2  + h4*P3 + a;
            hash[0] = h % MOD1;
            return hash[0];
        }else{
            return hash[0];
        }
    }

    long calcHash2(){
        if( level == height ) return hash[1];
        if( hash[1] == 0){
            long h1 = this.nw.calcHash2();
            long h2 = this.ne.calcHash2();
            long h3 = this.sw.calcHash2();
            long h4 = this.se.calcHash2();
            long h =  h1*P0 + h2*P1  + h3*P2  + h4*P3 + a;
            hash[1] = h % MOD2;
            return hash[1];
        }else{
            return hash[1];
        }
    }
    void Init(int level){

        if(level < height){
            this.nw = new Node(level+1);
            this.ne = new Node(level+1);
            this.sw = new Node(level+1);
            this.se = new Node(level+1);
            calcHash1();
            calcHash2();
        }else{
            this.nw = null;
            this.ne = null;
            this.sw = null;
            this.se = null;
            this.cell = 0;
            hash = [this.cell , this.cell];
        }

    }

    long getHash1(){
        return hash[0];
    }
    long getHash2(){
        return hash[1];
    }
}

