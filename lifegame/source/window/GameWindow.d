module window.GameWindow;

import dlangui;
import hashlife;
import window.LifeWindow;
import window.SettingWindow;

import std.typecons;

class GameWindow : FrameLayout {

    this(int width,int height){
        super("GAME");

        /* auto setting = new SettingWindow(20,20); */
        /* setting.backgroundColor = 0x000000; */
        /* addChild(setting); */

        addChild(new LifeWindow(width, height));
    }
}
