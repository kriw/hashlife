module window.SettingWindow;

import dlangui;

class SettingWindow : HorizontalLayout {
     private TextWidget[] _labels;

    this(int x,int y){
        auto layout = parseML(q{
                TableLayout {
                    colCount: 2
                    margins: 0;padding: 0
                    HSpacer { layoutWeight: 50 }
                    Button {text: "button1"}
                    Button {text:"button2"}
                    Button {text:"button3"}
                    HSpacer { layoutWeight: 10 }
                    HorizontalLayout {
                    Button {text:"button4"}
                    Button {text:"button5"}
                    }
            }
        });

        addChild( layout );

        /* addChild( new VSpacer() ); */
        /* addChild( new VSpacer() ); */
        /* addChild( new Button("btn1", "Button 1"d) );  */
        /* addChild( new Button("btn2", "Button 2"d) );  */
        /* addChild( new Button("btn3", "Button 3"d) );  */

        /* addChild(createTextWidget("Level:"d, 0x008000)); */
        /* addChild( new VSpacer() ); */
        /* addChild(createTextWidget("Level:"d, 0x008000)); */
        /* backgroundImageId = "tx_fabric.tiled"; */
    }

    TextWidget createTextWidget(dstring str, uint color) {
        TextWidget res = new TextWidget(null, str);
        res.layoutWidth(FILL_PARENT).alignment(Align.Center).fontSize(18.pointsToPixels).textColor(color);
        _labels ~= res;
        return res;
    }
}
