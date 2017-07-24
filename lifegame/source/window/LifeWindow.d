module window.LifeWindow;

import dlangui;
import hashlife;

class LifeWindow : HorizontalLayout {

    this(int width,int height){
        super("LIFE GAME");

        auto lifegame = new NodeManager(width, height);

        addChild(lifegame);

        /* backgroundImageId = "tx_fabric.tiled"; */
    }

}
