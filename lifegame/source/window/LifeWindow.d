module window.LifeWindow;

import dlangui;
import hashlife;

class LifeWindow : HorizontalLayout {

    this(int width,int height){
        super("LIFE GAME");

        Node n = new Node(0);
        auto lifegame = new NodeManager(n,width,height);

        addChild( lifegame );

        /* backgroundImageId = "tx_fabric.tiled"; */
    }

}
