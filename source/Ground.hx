package;

import flixel.util.FlxColor;
import flixel.FlxSprite;
import flixel.util.FlxSpriteUtil;

class Ground extends FlxSprite {
    var map = Std.random(2);

    public function new(x, y) {
        super(x, y);

        //makeGraphic(640, 300, FlxColor.PURPLE);
        /*
        if (map == 0 || map == 1) {
            loadGraphic("assets/images/Terrain1(1).png");
        } else {
            loadGraphic("assets/images/Terrain2.png");
        }
        */
    }

    public function destroyTerrain(x, y, radius) {
        FlxSpriteUtil.drawCircle(this, x, y, radius, FlxColor.TRANSPARENT);
        dirty = true;
    }
}