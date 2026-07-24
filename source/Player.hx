package;

import flixel.FlxG;
import flixel.util.FlxColor;
import flixel.FlxSprite;
import PlayState;

class Player extends FlxSprite {
    var playstate:PlayState = cast flixel.FlxG.state;
    var increaseAngle:Bool = false;
    var decreaseAngle:Bool = false;
    
    var increasePower:Bool = false;
    var decreasePower:Bool = false;

    var fire:Bool = false;
    @:allow(PlayState)
    var angleAdjust:Int = 90;
    @:allow(PlayState)
    var powerAdjust:Int = 1000;

    public var life = 100;

    public function new(x:Float, y:Float) {
        super(x, y);

        //makeGraphic(35, 18, FlxColor.GREEN);
        loadGraphic(AssetPaths.player1__png, false, 35, 18);
    }

    function ajustAndSend() {
        increaseAngle = FlxG.keys.pressed.LEFT;
        decreaseAngle = FlxG.keys.pressed.RIGHT;
        increasePower = FlxG.keys.pressed.UP;
        decreasePower = FlxG.keys.pressed.DOWN;
        fire = FlxG.keys.pressed.SPACE;

        if (playstate.turn == "P1") {
            if (increaseAngle && (0 <= angleAdjust && angleAdjust <= 180)) {
                angleAdjust++;
            }

            if (increasePower && (0 <= powerAdjust && powerAdjust <= 2000)) {
                powerAdjust += 15;
            }

            if (decreaseAngle && (0 <= angleAdjust && angleAdjust <= 180)) {
                angleAdjust--;
            }

            if (decreasePower && (0 <= powerAdjust && powerAdjust <= 2000)) {
                powerAdjust -= 15;
            }

            if (fire) {
                cast(FlxG.state, PlayState).triggerLaunch(powerAdjust, angleAdjust);
            }
        }
        
    }

    override function update(elapsed:Float) {
        super.update(elapsed);
        ajustAndSend();
    }
}