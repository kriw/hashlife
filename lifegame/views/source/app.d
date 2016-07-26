import std.stdio;
import simple;
import hashlife;
import base;
import dlangui;

mixin APP_ENTRY_POINT;

/// entry point for dlangui based application
extern (C) int UIAppMain(string[] args) {

    //tform.instance.uiLanguage = "en";
    Platform.instance.uiTheme = "theme_default";
    auto window = Platform.instance.createWindow("life game",null,1u,800u,800u);
    /* auto lifegame = new SimpleLife(60,60); */
    Node n = new Node(0);
    auto lifegame = new NodeManager(n);
    window.mainWidget = lifegame;
    window.show;
    return Platform.instance.enterMessageLoop();

}

