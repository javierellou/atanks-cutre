package;

import flixel.util.FlxColor;
import flixel.FlxSprite;

class Ground extends FlxSprite {
    public function new(x, y) {
        super(x, y);

        makeGraphic(640, 300, FlxColor.PURPLE);
    }
}