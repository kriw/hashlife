import std.stdio;
import std.typecons;
import simple;
import hashlife;
import base;
import dlangui;

mixin APP_ENTRY_POINT;

/// entry point for dlangui based application
extern (C) int UIAppMain(string[] args) {

    //tform.instance.uiLanguage = "en";
    Platform.instance.uiTheme = "theme_default";

    auto sc = Tuple!(int, "x",int, "y")(400,400);
    auto window = Platform.instance.createWindow("life game",null,1u,sc.x,sc.y);
    Node n = new Node(0);
    auto lifegame = new NodeManager(n,sc.x,sc.y);
    window.mainWidget = lifegame;
    window.show;
    return Platform.instance.enterMessageLoop();

}

