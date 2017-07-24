module hashlife.Node;

import std.bigint;
import std.stdio;
import dlangui;

class Node {
    Node nw,ne,sw,se;
    public static const byte height = 13;
    public static Node[] emp;
    private int hash;
    byte level;
    public byte cell;

    static const int MOD = 104729;
    static const int a  = 7;
    static const int P1 = 2;
    private bool onHash;

    this(int level, bool isInit = true){
        this.level = level.to!byte();
        hash = 0;
        onHash = false;
        if(isInit){
            Init(level);
            calcHash(true);
        }
    }

    ulong calcHash(bool isForce=false){
        if(level == height) return this.cell;
        if(isForce || !onHash) {
            ulong B = pow(4, (height - this.nw.level), MOD);
            ulong Q0 = 1;
            ulong Q1 = pow(P1, B, MOD);
            ulong Q2 = pow(Q1, 2, MOD);
            ulong Q3 = pow(Q1, 3, MOD);
            ulong h1 = this.nw.calcHash(isForce) * Q0 % MOD;
            ulong h2 = this.ne.calcHash(isForce) * Q1 % MOD;
            ulong h3 = this.sw.calcHash(isForce) * Q2 % MOD;
            ulong h4 = this.se.calcHash(isForce) * Q3 % MOD;
            ulong h =  h1 + h2 + h3 + h4 + a;
            hash = h % MOD;
            onHash = true;
            return hash;
        }else{
            return hash;
        }
    }

    void Init(int level){

        if(level < height){
            this.nw = new Node(level+1);
            this.ne = new Node(level+1);
            this.sw = new Node(level+1);
            this.se = new Node(level+1);
        }else{
            this.nw = emp[level+1];
            this.ne = emp[level+1];
            this.sw = emp[level+1];
            this.se = emp[level+1];
            this.cell = 0;
            hash = this.cell;
        }

    }


    ulong getHash(){
        return hash;
    }

    bool eq(Node b) {
        if(this.level != b.level)
            return false;
        else if(this.level == this.height)
            return this.cell == b.cell;
        else {
            bool nw_matched = this.nw == b.nw || this.nw.eq(b.nw);
            bool ne_matched = this.ne == b.ne || this.ne.eq(b.ne);
            bool sw_matched = this.sw == b.sw || this.sw.eq(b.sw);
            bool se_matched = this.se == b.se || this.se.eq(b.se);
            return nw_matched && ne_matched && sw_matched && se_matched;
        }
    }
}

Node[][Node.MOD][Node.height+1] pool;
Node optimize(ref Node n) {
    foreach(ref tn ; pool[n.level][n.getHash()]) {
        if(n == tn)
            return tn;
    }
    foreach(ref tn ; pool[n.level][n.getHash()]) {
        if(n.eq(tn))
            return tn;
    }
    pool[n.level][n.getHash()] ~= n;
    if(n.level == n.height)
        return n;
    n.nw = optimize(n.nw);
    n.ne = optimize(n.ne);
    n.sw = optimize(n.sw);
    n.se = optimize(n.se);
    return n;
}

ulong pow(ulong a, ulong b, ulong mod){
    ulong ret = 1;
    for(; b > 0; b >>= 1){
        if(b & 1){
            ret *= a;
            ret %= mod;
        }
        a *= a;
        a %= mod;
    }
    return ret % mod;
}

