package;

import flixel.FlxSprite;
import flixel.util.FlxColor;
import flixel.FlxG;

class Player2 extends FlxSprite {
    var playstate:PlayState = cast flixel.FlxG.state;
    var increaseAngle2:Bool = false;
    var decreaseAngle2:Bool = false;
    var increasePower2:Bool = false;
    var decreasePower2:Bool = false;
    var fire2:Bool = false;

    var moveright2:Bool = false;
    var moveleft2:Bool = false;

    @:allow(PlayState)
    var angleAdjust2:Int = 90;
    @:allow(PlayState)
    var powerAdjust2:Int = 1000;

    public var life = 100;
    public var fuel = 100;

    public function new(x:Float, y:Float) {
        super(x, y);

        //makeGraphic(35, 18, FlxColor.RED);
        loadGraphic(AssetPaths.player2__png, false, 35, 18);
    }

    function ajustAndSend2() {
        increaseAngle2 = FlxG.keys.pressed.LEFT;
        decreaseAngle2 = FlxG.keys.pressed.RIGHT;
        increasePower2 = FlxG.keys.pressed.UP;
        decreasePower2 = FlxG.keys.pressed.DOWN;
        fire2 = FlxG.keys.pressed.SPACE;
        moveright2 = FlxG.keys.justPressed.E;
        moveleft2 = FlxG.keys.justPressed.Q;

        if (playstate.turn == "P2") {
            // Preventing the values to go over the limit
            if (angleAdjust2 > 180) angleAdjust2 = 180;
            else if (angleAdjust2 < 0) angleAdjust2 = 0;
            if (increaseAngle2 && (0 <= angleAdjust2 && angleAdjust2 <= 180)) {
                angleAdjust2++;
            }

            if (powerAdjust2 < 0) powerAdjust2 = 0;
            else if (powerAdjust2 > 2000) powerAdjust2 = 2000;

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
            if (fuel > 0) {
                if (moveleft2) {
                    x -= 2;
                    y = playstate.terrainCollision[Std.int(x)+12]-10;
                    fuel--;
                }

                if (moveright2) {
                    x += 2;
                    y = playstate.terrainCollision[Std.int(x)+12]-10;
                    fuel--;
                }
            }
        }
    }

    override function update(elapsed:Float) {
        super.update(elapsed);
        ajustAndSend2();
        
    }
}