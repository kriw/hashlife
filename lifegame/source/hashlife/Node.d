module hashlife.Node;

import std.bigint;
import std.stdio;
import dlangui;

class Node{
    Node nw,ne,sw,se;
    public static const int height = 8;
    private ulong[2] hash;
    int level;
    public int cell;
    public bool mark;

    static const ulong MOD1 = 1000000007;
    static const ulong MOD2 = 1000000009;

    static const ulong a  = 7;
    static const ulong P1 = 2;
    private bool onHash1;
    private bool onHash2;

    this(int level,bool isInit = true){
        this.level = level;
        hash = [-1,-1];
        mark = false;
        onHash1 = false;
        onHash2 = false;
        if( isInit ){
            Init(level);
            calcHash1(true);
            calcHash2(true);
        }
    }

    ulong calcHash1(bool isForce=false){
        if( level == height ) return this.cell;
        if( isForce || !onHash1){
            ulong B = pow(4,(height - this.nw.level),MOD1);
            ulong Q0 = 1;
            ulong Q1 = pow(P1,B,MOD1);
            ulong Q2 = pow(Q1,2,MOD1);
            ulong Q3 = pow(Q1,3,MOD1);
            ulong h1 = this.nw.calcHash1(isForce)*Q0%MOD1;
            ulong h2 = this.ne.calcHash1(isForce)*Q1%MOD1;
            ulong h3 = this.sw.calcHash1(isForce)*Q2%MOD1;
            ulong h4 = this.se.calcHash1(isForce)*Q3%MOD1;
            ulong h =  h1 + h2 + h3  + h4 + a;
            hash[0] = h % MOD1;
            onHash1 = true;
            return hash[0];
        }else{
            return hash[0];
        }
    }

    ulong calcHash2(bool isForce=false){
        if( level == height ) return this.cell;
        if( isForce || !onHash2){
            ulong B = pow(4,(height - this.nw.level),MOD2);
            ulong Q0 = 1;
            ulong Q1 = pow(P1,B,MOD2);
            ulong Q2 = pow(Q1,2,MOD2);
            ulong Q3 = pow(Q1,3,MOD2);
            ulong h1 = this.nw.calcHash2(isForce)*Q0%MOD2;
            ulong h2 = this.ne.calcHash2(isForce)*Q1%MOD2;
            ulong h3 = this.sw.calcHash2(isForce)*Q2%MOD2;
            ulong h4 = this.se.calcHash2(isForce)*Q3%MOD2;
            ulong h =  h1 + h2  + h3  + h4 + a;
            hash[1] = h % MOD2;
            onHash2 = true;
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
        }else{
            this.nw = null;
            this.ne = null;
            this.sw = null;
            this.se = null;
            this.cell = 0;
            hash = [this.cell , this.cell];
        }

    }

    ulong getHash1(){
        return hash[0];
    }
    ulong getHash2(){
        return hash[1];
    }
}

ulong pow(ulong a,ulong b,ulong mod){
    ulong ret = 1;
    for(;b>0;b>>=1){
        if(b&1){
            ret *= a;
            ret %= mod;
        }
        a *= a;
        a %= mod;
    }
    return ret%mod;
}

