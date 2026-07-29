package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.input.mouse.FlxMouseEvent;

class MenuState extends FlxState {
    var background:FlxSprite;
    var button:FlxSprite;

    override public function create() {
        super.create();

        FlxG.sound.playMusic("assets/music/titleSong.ogg");

        background = new FlxSprite(0, 0, "assets/images/fondoinicio.png");

        button = new FlxSprite(400, 200, "assets/images/startButton.png");
        FlxMouseEvent.add(button, onDown, null, onOver, onOut);

        add(background);
        add(button);
    }

    function onDown(button:FlxSprite):Void {
      FlxG.sound.volume = 0;
      FlxG.switchState(PlayState.new);
    }

    function onOver(button:FlxSprite):Void {
		button.scale.x = button.scale.y = 1.2;
	  }

	  function onOut(button:FlxSprite):Void {
		button.scale.x = button.scale.y = 1.0;
	  }
}
