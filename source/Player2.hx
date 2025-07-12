package;

import flixel.FlxG;

class Player2 extends Player {
    var increaseAngle2:Bool = false;
    var decreaseAngle2:Bool = false;
    var increasePower2:Bool = false;
    var decreasePower2:Bool = false;
    var fire2:Bool = false;

    @:allow(PlayState)
    var angleAdjust2:Int = 90;
    @:allow(PlayState)
    var powerAdjust2:Int = 1000;

    public function new(x:Float, y:Float) {
        super(x, y);
    }

    override function ajustAndSend() {
        increaseAngle2 = FlxG.keys.pressed.LEFT;
        decreaseAngle2 = FlxG.keys.pressed.RIGHT;
        increasePower2 = FlxG.keys.pressed.UP;
        decreasePower2 = FlxG.keys.pressed.DOWN;
        fire2 = FlxG.keys.pressed.SPACE;

        if (increaseAngle2 && (0 <= angleAdjust2 && angleAdjust2 <= 180)) {
            angleAdjust2++;
        }

        if (increasePower2 && (0 <= powerAdjust2 && powerAdjust2 <= 2000)) {
            powerAdjust2 += 15;
        }

        if (decreaseAngle2 && (0 <= angleAdjust2 && angleAdjust2 <= 180)) {
            angleAdjust2--;
        }

        if (decreasePower2 && (0 <= powerAdjust2 && powerAdjust2 <= 2000)) {
            powerAdjust2 -= 15;
        }

        if (fire2) {
            cast(FlxG.state, PlayState).triggerLaunch(powerAdjust2, angleAdjust2);
        }
    }
}