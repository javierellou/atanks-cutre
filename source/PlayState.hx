package;

import flixel.util.FlxColor;
import flixel.text.FlxText;
import flixel.FlxState;
import flixel.FlxSprite;
import flixel.FlxG;
import haxe.Timer;

// TODO: Add Sprites and all that stuff
class PlayState extends FlxState
{
	public var turn:String = "P1"; 
	/* 	"P1": Player one's turn
	 	"P2": Player two's turn
		"i1": Intermission and P1 next
		"i2": Intermission and P2 next
    */

	var wind:Float = 0;

	var player:Player;
	var player2:Player2;

	@:allow(Misile)
	var ground:Ground;
	var misile:Misile;
	var explosionSprite:FlxSprite;

	var indicator:FlxSprite;
	var indicator2:FlxSprite;

	@:allow(Misile)
	var rightWall:FlxSprite;
	@:allow(Misile)
	var leftWall:FlxSprite;

	var textPower:FlxText;
	var textAngle:FlxText;
	var textWind:FlxText;

	override public function create()
	{
		super.create();

		player = new Player(50, 252);
		player2 = new Player2(530, 250);

		ground = new Ground(0, 270);
		misile = new Misile();
		explosionSprite = new FlxSprite(player.x, player.y);
		explosionSprite.visible = false;
		explosionSprite.makeGraphic(10, 10, FlxColor.ORANGE);

		textPower = new FlxText(10, 10, 300, "Power: 0");
		textAngle = new FlxText(10, 30, 300, "Angle: 0");
		textWind = new FlxText(550, 10, 300, "Wind: 0");
		textPower.color = textAngle.color = textWind.color = FlxColor.WHITE;

		randomWind();

		indicator = new FlxSprite(player.x + player.width/2, player.y - 20);
		indicator.makeGraphic(8, 40, FlxColor.GREEN);

		indicator2 = new FlxSprite(player2.x + player2.width/2, player2.y - 20);
		indicator2.makeGraphic(8, 40, FlxColor.RED);

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
		add(indicator2);

		add(rightWall);
		add(leftWall);

		add(textWind);
		add(textAngle);
		add(textPower);
	}

	public function triggerLaunch(_power:Int, _angle:Int):Void {
		var xpos:Float = (turn == "P1") ? player.x + player.width/2: player2.x + player.width/2;
		var ypos:Float = (turn == "P1") ? player.y : player2.y;
		misile.launch(_power, _angle, 10, xpos, ypos);
		turn = (turn == "P2") ? "i1" : "i2";
	}

	function updateText():Void {
		if (turn == "P1") {
			textPower.text = "Power: " + Std.string(player.powerAdjust);
			textAngle.text = "Angle: " + Std.string(player.angleAdjust);
		} else if (turn == "P2") {
			textPower.text = "Power: " + Std.string(player2.powerAdjust2);
			textAngle.text = "Angle: " + Std.string(player2.angleAdjust2);
		}
	}

	public function explode(radius:Int):Void {
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

			randomWind();
        }, 2000);
    }

	// Update the angle of the indicator
	function updateIndicator():Void {
		indicator.angle = player.angleAdjust * -1 + 90;
		indicator2.angle = player2.angleAdjust2 * -1 + 90;
	}

	function randomWind():Void {
		wind = Std.random(200) - 100;
		textWind.text = "Wind: " + wind;

		misile.acceleration.x = wind;
	}

	override public function update(elapsed:Float)
	{
		super.update(elapsed);
		updateText();
		updateIndicator();
		trace(misile.acceleration.y);
	}
}
