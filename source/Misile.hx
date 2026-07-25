package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.util.FlxCollision;
// TODO: make the rotation
class Misile extends FlxSprite {
    var playstate:PlayState = cast flixel.FlxG.state;
    var moving:Bool = false;
    var _radius:Int;
    var collision:Array<Int>;

    public function new(x:Float = -50, y:Float = -50) {
        super(x, y);

        loadGraphic(AssetPaths.misile__png, false, 10, 20);
        drag.x = drag.y = 400;
        collision = playstate.terrain.giveCollision();
    }

    public function launch(power:Int, angleLaunch:Int, radiusExplosion:Int, _x:Float, _y:Float) {
        x = _x;
        y = _y;
        visible = true;
        
        _radius = radiusExplosion;
        
        var SPEED = power;
        velocity.set(Math.cos(angleLaunch * Math.PI / 180) * SPEED, Math.sin(angleLaunch * Math.PI / 180) * -1 * SPEED);
        acceleration.set(0, 800);
        angle = angleLaunch;
        moving = true;
    }

    function parable() {
		// TODO: Tilemap collision
		if (x > collision[Std.int(x)]) {
            trace("overlap");
            cast(FlxG.state, PlayState).explode(_radius);
            moving = false;
            velocity.set(0, 0);
            acceleration.set(0, 0);
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