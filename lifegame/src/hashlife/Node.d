module hashlife.Node;

import std.bigint;

class Node{
    Node nw,ne,sw,se;
    public static const int height = 10;
    BigInt hash;
    int level;
    int cell;
    this(int level){
        this.level = level;

        if(level < height){
            this.nw = new Node(level+1);
            this.ne = new Node(level+1);
            this.sw = new Node(level+1);
            this.se = new Node(level+1);
            long shift = 1 << 2*(height - this.nw.level);
            BigInt h1 = BigInt(this.nw.hash);
            BigInt h2 = BigInt(this.ne.hash);
            BigInt h3 = BigInt(this.sw.hash);
            BigInt h4 = BigInt(this.se.hash);
            this.hash = (h1 << shift*3) + (h2 << shift*2) + (h3 << shift) + h4;
        }else{
            this.nw = null;
            this.ne = null;
            this.sw = null;
            this.se = null;
            this.cell = 0;
            hash = "1";
        }
    }

    BigInt getHash(){
        return hash;
    }
}

