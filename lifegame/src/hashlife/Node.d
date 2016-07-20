module hashlife.Node;

import std.bigint;

class Node{
    Node nw,ne,sw,se;
    public static const int height = 7;
    private BigInt hash;
    int level;
    public int cell;

    this(int level,bool isInit = true){
        this.level = level;
        hash = 0;
        if( isInit ){
            Init(level);
        }else{
        }
    }

    BigInt calcHash(){
        if( hash == 0 ){
            long shift = 1 << 2*(height - this.nw.level);
            BigInt h1 = this.nw.calcHash();
            BigInt h2 = this.ne.calcHash();
            BigInt h3 = this.sw.calcHash();
            BigInt h4 = this.se.calcHash();
            return (h1 << shift*3) + (h2 << shift*2) + (h3 << shift) + h4;
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
            calcHash();
        }else{
            this.nw = null;
            this.ne = null;
            this.sw = null;
            this.se = null;
            this.cell = 0;
            hash = 1;
        }

    }

    BigInt getHash(){
        return hash;
    }
}

