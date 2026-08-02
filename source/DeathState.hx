package;

import flixel.FlxSprite;
import haxe.ds.Vector;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import flixel.FlxG;
import flixel.effects.particles.FlxEmitter;
import flixel.FlxState;
import flixel.addons.effects.FlxTrailArea;
import flixel.input.mouse.FlxMouseEvent;


class DeathState extends FlxState {
    var explosion:FlxEmitter;
    var message:FlxText;
    var playstate:PlayState = cast FlxG.state;
    var titleButton:FlxSprite;

    override function create() {
        super.create();

        var trailArea:FlxTrailArea = new FlxTrailArea(0, 0, FlxG.width, FlxG.height);
        
        explosion = new FlxEmitter(FlxG.width/2, FlxG.height/2, 100);
        
        explosion.makeParticles(2, 2, FlxColor.WHITE, 200);
        explosion.color.set(FlxColor.RED, FlxColor.PINK, FlxColor.BLUE, FlxColor.CYAN);
        explosion.scale.set(1, 1, 1, 1, 4, 4, 8, 8);

        explosion.start(true);
        add(trailArea);
        add(explosion);

        message = new FlxText(FlxG.width/2, 30, 0, "WTF, NOBODY WON!!??", 64);
        message.color = FlxColor.WHITE;

        // Diffent messages depending on who won:
        var lifes:haxe.ds.Vector<Int> = playstate.sendPlayersLife();
        if (lifes[0] == lifes[1]) {
            message.text = "DRAW";
            message.color = FlxColor.PURPLE;
        } else if (lifes[1] == 0) {
            message.text = "PLAYER 1 WON";
            message.color = FlxColor.LIME;
        } else {
            message.text = "PLAYER 2 WON";
            message.color = FlxColor.RED;
        }
        message.x -= message.fieldWidth/2;
        add(message);

        titleButton = new FlxSprite(FlxG.width/2, 400, "assets/images/titleButton.png");
        titleButton.x -= titleButton.width/2;
        titleButton.scale.set(2, 2);
        FlxMouseEvent.add(titleButton, onDown, null, onOver, onOut);
        add(titleButton);

        explosion.start(false, 0.01); // This is to loop the makeParticle or something like that (it works)
    }

    override function update(elapsed:Float) {
        super.update(elapsed);

        updateMouse();
    }

    function updateMouse():Void {
        explosion.x = FlxG.mouse.x;
        explosion.y = FlxG.mouse.y;
    }

    function onDown(titleButton:FlxSprite):Void {
      FlxG.sound.resume();
      FlxG.switchState(MenuState.new);
    }

    function onOver(titleButton:FlxSprite):Void {
		titleButton.scale.x = titleButton.scale.y = 2.2;
	  }

	  function onOut(titleButton:FlxSprite):Void {
		titleButton.scale.x = titleButton.scale.y = 2.0;
	  }
}