module hashlife.Patterns.HalfAdder;

import std.typecons;

import hashlife.Field;
import hashlife.Patterns.Pattern;
import hashlife.Patterns.Glider;
import hashlife.Patterns.Eater;
import hashlife.Patterns.ANDGate;
import hashlife.Patterns.ORGate;

class HalfAdder {

    alias Pos = Tuple!(int, "x",int, "y");
    //input value A B
    int A,B;

    this(int A,int B){
        this.A = A;
        this.B = B;
    }

    void setToField(ref Field field,int x,int y){
        Pos nandPos;
        nandPos.x = 95 + x;
        nandPos.y = 45 + y;

        Pos orPos;
        orPos.x = 235 + x;
        orPos.y = 120 + y;

        Pos andGliderPos;
        andGliderPos.x = 484 + x;
        andGliderPos.y = 45 + y;

        Pos leftUpPos;
        leftUpPos.x = x;
        leftUpPos.y = y;

        Pos andGliderLDPos;
        andGliderLDPos.x = 434 + x;
        andGliderLDPos.y = 75 + y;

        Pos eaterPos;
        eaterPos.x = 340 + x;
        eaterPos.y = 170 + y;


        auto andGate = new ANDGate(A,B,"reverse");
        auto andGate_leftup = new ANDGate(A,B,"");
        auto notGlider = new Glider("");
        auto andGlider_rightDown = new Glider("reverse");
        auto orGate = new ORGate(A,B,"");
        auto eater = new Eater("reverse");

        orGate.setToField(field,orPos.x,orPos.y);
        notGlider.setToField(field,nandPos.x,nandPos.y);
        andGate.setToField(field,nandPos.x+52,nandPos.y);
        andGate_leftup.setToField(field,leftUpPos.x,
                leftUpPos.y);
        andGlider_rightDown.setToField(field,
                andGliderLDPos.x,andGliderLDPos.y);
        eater.setToField(field,eaterPos.x,eaterPos.y);
    }
}
