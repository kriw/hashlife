import std.stdio;
import simple;
import hashlife;

void main(){

    writeln("Conway's lifegame");
    /* SimpleLife cells = new SimpleLife(20,40); */
    Node n = new Node(0);
    NodeManager nm = new NodeManager(n);
    nm.nextGen(n);

    /* while(true){ */
    /*     cells.output(); */
    /*     cells.update(); */
    /* } */

}
