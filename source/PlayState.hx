package;

import flixel.util.FlxColor;
import flixel.text.FlxText;
import flixel.FlxState;
import flixel.FlxSprite;
import flixel.FlxG;
import haxe.Timer;

class PlayState extends FlxState
{
	// TODO: Make the turn system work
	public var turn:String = "P1"; 
	/* 	"P1": Player one's turn
	 	"P2": Player two's turn
		"i1": Intermission and P1 next
		"i2": Intermission and P2 next
	*/

	var player:Player;
	var player2:Player2;
	@:allow(Misile)
	var ground:Ground;
	var misile:Misile;
	var explosionSprite:FlxSprite;
	var indicator:FlxSprite;

	@:allow(Misile)
	var rightWall:FlxSprite;
	@:allow(Misile)
	var leftWall:FlxSprite;

	var textPower:FlxText;
	var textAngle:FlxText;

	override public function create()
	{
		super.create();

		player = new Player(50, 252);
		player = new Player2(100, 250);

		ground = new Ground(0, 270);
		misile = new Misile();
		explosionSprite = new FlxSprite(player.x, player.y);
		explosionSprite.visible = false;
		explosionSprite.makeGraphic(10, 10, FlxColor.ORANGE);

		textPower = new FlxText(10, 10, 300, "Power: 0");
		textAngle = new FlxText(10, 30, 300, "Angle: 0");
		textPower.color = textAngle.color = FlxColor.WHITE;

		indicator = new FlxSprite(player.x, player.y - 20);
		indicator.makeGraphic(8, 40, FlxColor.GREEN);

		rightWall = new FlxSprite(FlxG.width - 10, FlxG.height - 1000);
		rightWall.makeGraphic(10, 1000, FlxColor.GREEN);
		leftWall = new FlxSprite(0, FlxG.height - 1000);
		leftWall.makeGraphic(10, 1000, FlxColor.GREEN);

		add(player);
		add(player2);

		add(ground);
		add(misile);
		add(explosionSprite);
		add(indicator);

		add(rightWall);
		add(leftWall);

		add(textAngle);
		add(textPower);
	}

	public function triggerLaunch(_power:Int, _angle:Int) {
		misile.launch(_power, _angle, 10, player.x, player.y);
		turn = (turn == "P2") ? "i1" : "i2";
	}

	function updateText() {
		textPower.text = "Power: " + Std.string(player.powerAdjust);
		textAngle.text = "Angle: " + Std.string(player.angleAdjust);
	}

	public function explode(radius:Int) {
        misile.velocity.x = misile.velocity.y = 0;
        var diameter = radius*2;

        explosionSprite.setGraphicSize(diameter, diameter);
		explosionSprite.x = misile.x - radius / 2;
		explosionSprite.y = misile.y - radius / 2;
		explosionSprite.visible = true;
        Timer.delay(() -> {
            explosionSprite.visible = false;
            misile.visible = false;
			turn = (turn == "i1") ? "P1" : "P2";
        }, 2000);
    }

	// Update the angle of the indicator
	function updateIndicator() {
		indicator.angle = player.angleAdjust * -1 + 90; // TODO: Fis this
	}

	override public function update(elapsed:Float)
	{
		super.update(elapsed);
		updateText();
		updateIndicator();
	}
}
