package;

import flixel.FlxG;
import flixel.util.FlxColor;
import flixel.util.FlxCollision;
import flixel.FlxSprite;

class Misile extends FlxSprite {
    var playstate:PlayState = cast flixel.FlxG.state;
    var moving:Bool = false;
    var _radius:Int;

    public function new(x:Float = -50, y:Float = -50) {
        super(x, y);

        makeGraphic(10, 10, FlxColor.YELLOW);
        drag.x = drag.y = 400;
    }

    public function launch(power:Int, angle:Int, radiusExplosion:Int, _x:Float, _y:Float) {
        x = _x;
        y = _y;
        visible = true;
        
        _radius = radiusExplosion;
        
        var SPEED = power;
        velocity.set(Math.cos(angle * Math.PI / 180) * SPEED, Math.sin(angle * Math.PI / 180) * -1 * SPEED);
        acceleration.set(0, 800);
        moving = true;
    }

    function parable() {
        if (FlxCollision.pixelPerfectCheck(this, playstate.ground)) {
            cast(FlxG.state, PlayState).explode(_radius);
            moving = false;
            velocity.set(0, 0);
            acceleration.y = 0;
        }
        
        if (FlxCollision.pixelPerfectCheck(this, playstate.leftWall) || FlxCollision.pixelPerfectCheck(this, playstate.rightWall)) {
            velocity.x *= -1;
        }
    }

    override function update(elapsed:Float) {
        super.update(elapsed);
        if (moving) {
            parable();
        }
    }
}