package;

import flixel.FlxG;
import flixel.ui.FlxButton;
import flixel.FlxSprite;
import flixel.FlxState;

class MenuState extends FlxState {
    var background:FlxSprite;
    var button:FlxButton;

    override public function create() {
        super.create();

        background = new FlxSprite(0, 0, "assets/images/fondoinicio.png");
        button = new FlxButton(400, 200, "Play", clickPlay);

        add(background);
        add(button);
    }

    function clickPlay():Void {
        FlxG.switchState(PlayState.new);
    }
}