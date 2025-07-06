package;

import flixel.util.FlxColor;
import flixel.text.FlxText;
import flixel.FlxState;
import flixel.FlxSprite;

class PlayState extends FlxState
{
	var player:Player;
	@:allow(Misile)
	var ground:Ground;
	var misile:Misile;
	var explosionSprite:FlxSprite;

	var textPower:FlxText;
	var textAngle:FlxText;

	override public function create()
	{
		super.create();

		player = new Player(50, 240);
		ground = new Ground(0, 270);
		misile = new Misile();
		explosionSprite = new FlxSprite(-50, -50);
		explosionSprite.makeGraphic(0, 0, FlxColor.ORANGE);

		textPower = new FlxText(10, 10, 300, "Power: 0");
		textAngle = new FlxText(10, 30, 300, "Angle: 0");
		textPower.color = textAngle.color = FlxColor.WHITE;

		add(player);
		add(ground);
		add(misile);
		add(explosionSprite);

		add(textAngle);
		add(textPower);
	}

	public function triggerLaunch(_power:Int, _angle:Int) {
		trace("Power: " + _power);
		misile.launch(_power, _angle, 10, player.x, player.y);
	}

	function updateText() {
		textPower.text = "Power: " + Std.string(player.powerAdjust);
		textAngle.text = "Angle: " + Std.string(player.angleAdjust);
	}

	// TODO: Fix the explosion
	public function explode(radius:Int) {
        misile.velocity.x = misile.velocity.y = 0;
        var diameter = radius*2;

        explosionSprite.setGraphicSize(diameter, diameter);
		explosionSprite.x = misile.x - radius;
        /*Timer.delay(() -> {
            explosionSprite.destroy();
            this.destroy();
        }, 2000);*/
    }

	override public function update(elapsed:Float)
	{
		super.update(elapsed);
		updateText();
		trace("X: " + misile.x);
		trace("Y: " + misile.y);
	}
}
