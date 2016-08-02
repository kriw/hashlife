import std.stdio;
import std.typecons;
import std.algorithm;

import simple;
import hashlife;
import window;
import dlangui;

mixin APP_ENTRY_POINT;

/// entry point for dlangui based application
extern (C) int UIAppMain(string[] args) {

    //tform.instance.uiLanguage = "en";
    Platform.instance.uiTheme = "theme_default";

    int settingWidth = 200;
    auto lifesc = Tuple!(int, "x",int, "y")(600,600);
    auto sc = Tuple!(int, "x",int, "y")(lifesc.x+settingWidth,lifesc.y);
    auto window = Platform.instance.createWindow("life game",null,1u,sc.x,sc.y);

    /* string lifestyle = "Simple"; */

    /* string lifestyle = "HashLife"; */
    /* Widget lifegame; */

    /* auto layout = parseML(q{ */
    /*         TableLayout { */
    /*             colCount: 2 */
    /*             margins: 30;padding: 20 */
    /*             Button {text: "button1"} */
    /*             Button {text:"button2"} */
    /*             Button {text:"button3"} */
    /*             HorizontalLayout { */
    /*             Button {text:"button4"} */
    /*             Button {text:"button5"} */
    /*         } */
    /*     } */
    /* }) */

    /* if( cmp(lifestyle , "Simple") == 0 ){ */
    /*  */
    /*     lifegame = new SimpleLife(100,sc.x,sc.y); */
    /*  */
    /* }else if( cmp(lifestyle , "HashLife") == 0 ){ */
    /*  */
    /*     Node n = new Node(0); */
    /*     lifegame = new NodeManager(n,sc.x,sc.y); */
    /*  */
    /* } */

    /* window.mainWidget = lifegame; */
    window.mainWidget = new GameWindow( lifesc.x, lifesc.y);
    window.show;

    return Platform.instance.enterMessageLoop();

}

