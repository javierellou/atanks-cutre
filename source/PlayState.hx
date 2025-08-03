package;

import flixel.util.FlxCollision;
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
	var misileIndicator:FlxSprite; // It indicates where the misile is when it's out of the screen

	@:allow(Misile)
	var rightWall:FlxSprite;
	@:allow(Misile)
	var leftWall:FlxSprite;

	var textPower:FlxText;
	var textAngle:FlxText;
	var textWind:FlxText;

	var textP1Life:FlxText;
	var textP2Life:FlxText;

	override public function create()
	{
		super.create();

		player = new Player(50, 252);
		player2 = new Player2(530, 250);

		ground = new Ground(0, 270);
		misile = new Misile();
		explosionSprite = new FlxSprite(player.x, player.y);
		explosionSprite.visible = false;
		explosionSprite.loadGraphic(AssetPaths.explosion__png, false, 32, 32);

		textPower = new FlxText(10, 10, 300, "Power: 0");
		textAngle = new FlxText(10, 30, 300, "Angle: 0");
		textWind = new FlxText(550, 10, 300, "Wind: 0");
		textP1Life = new FlxText(player.x, player.y - 10, 300, "100");
		textP2Life = new FlxText(player2.x, player.y - 10, 300, "100");

		textPower.color = textAngle.color = textWind.color = 
		textP1Life.color = textP2Life.color = FlxColor.WHITE;

		randomWind();

		indicator = new FlxSprite(player.x + 24, player.y - 11);
		indicator.loadGraphic(AssetPaths.Indicator__png, false, 5, 40);

		indicator2 = new FlxSprite(player2.x + 10, player2.y - 15);
		indicator2.loadGraphic(AssetPaths.Indicator__png, false, 5, 40);

		misileIndicator = new FlxSprite(0, 20);
		misileIndicator.makeGraphic(18, 18, FlxColor.WHITE);

		rightWall = new FlxSprite(FlxG.width - 10, FlxG.height - 1000);
		rightWall.makeGraphic(10, 1000, FlxColor.GREEN);
		leftWall = new FlxSprite(0, FlxG.height - 1000);
		leftWall.makeGraphic(10, 1000, FlxColor.GREEN);

		add(misile);

		add(indicator);
		add(indicator2);
		add(misileIndicator);

		add(ground);

		add(player);
		add(player2);

		add(explosionSprite);

		add(rightWall);
		add(leftWall);

		add(textWind);
		add(textAngle);
		add(textPower);
		add(textP1Life);
		add(textP2Life);
	}

	public function triggerLaunch(_power:Int, _angle:Int):Void {
		var xpos:Float = (turn == "P1") ? player.x + 24: player2.x + 10;
		var ypos:Float = (turn == "P1") ? player.y - 1 : player2.y - 7;
		misile.launch(_power, _angle, 16, xpos, ypos);
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

		textP1Life.text = Std.string(player.life);
		textP2Life.text = Std.string(player2.life);
	}

	public function explode(radius:Int):Void {
        misile.velocity.x = misile.velocity.y = 0;
    	var diameter = radius * 2;

    	explosionSprite.setGraphicSize(diameter, diameter);
    	explosionSprite.updateHitbox(); // <- asegúrate de que width/height se actualicen

    	explosionSprite.x = (misile.x + misile.width / 2) - radius;
    	explosionSprite.y = misile.y;
    	explosionSprite.visible = true;
		misile.visible = false;

		if (FlxCollision.pixelPerfectCheck(player, explosionSprite)) {
			player.life -= 20;
		}
		if (FlxCollision.pixelPerfectCheck(player2, explosionSprite)) {
			player2.life -= 20;
		}

		if (player.life <= 0 || player2.life <= 0) {
			die();
		}

        Timer.delay(() -> {
            explosionSprite.visible = false;
			turn = (turn == "i1") ? "P1" : "P2";

			randomWind();
        }, 2000);

		
    }

	// Update the angle of the indicator
	function updateIndicator():Void {
		indicator.angle = player.angleAdjust * -1 + 90;
		indicator2.angle = player2.angleAdjust2 * -1 + 90;
		if (misile.y < 0) {
			misileIndicator.visible = true;
			misileIndicator.x = misile.x;
		} else {
			misileIndicator.visible = false;
		}
	}

	function randomWind():Void {
		wind = Std.random(200) - 100;
		textWind.text = "Wind: " + wind;

		misile.acceleration.x = wind;
	}

	function die():Void {
		var whoDied:FlxSprite = (player.life == 0) ? player : player2;

		explode(100);
		whoDied.destroy();
		if (whoDied == player) {
			indicator.destroy();
			textP1Life.destroy();
		} else {
			indicator2.destroy(); 
			textP2Life.destroy();
		}

		// TODO: Go to main menu
	}

	override public function update(elapsed:Float)
	{
		super.update(elapsed);
		updateText();
		updateIndicator();
		misile.acceleration.x = wind;
	}
}
