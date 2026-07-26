package;

import flixel.util.FlxCollision;
import flixel.util.FlxColor;
import flixel.text.FlxText;
import flixel.FlxState;
import flixel.FlxSprite;
import flixel.FlxG;
import haxe.Timer;

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
	var terrain:Terrain;

	@:allow(Player)
	@:allow(Player2)
	var terrainCollision:haxe.ds.Vector<Int>;

	var misile:Misile;
	var explosionSprite:FlxSprite;

	var indicator:FlxSprite;
	var indicator2:FlxSprite;
	var misileIndicator:FlxSprite; // It indicates where the misile is when it's out of the screen

	var textPower:FlxText;
	var textAngle:FlxText;
	var textWind:FlxText;
	var textFuel:FlxText;

	var textP1Life:FlxText;
	var textP2Life:FlxText;

	var sky:FlxSprite;

	override public function create()
	{
		super.create();

		sky = new FlxSprite(0, 0);
		sky.loadGraphic("assets/images/sky.jpg", false, FlxG.width, FlxG.height);
		
		var randomPosition:Float = Std.random(FlxG.width);
		player = new Player(randomPosition, 0);
		randomPosition = Std.random(FlxG.width);
		player2 = new Player2(randomPosition, 0);

		terrain = new Terrain(0, 0);
		terrainCollision = terrain.giveCollision();
		player.y = terrainCollision[Std.int(player.x)]-6;
		player.x -= 12;
		player2.y = terrainCollision[Std.int(player2.x)]-6;
		player.x -= 12;
		
		misile = new Misile();
		explosionSprite = new FlxSprite(player.x, player.y);
		explosionSprite.visible = false;
		explosionSprite.loadGraphic(AssetPaths.explosion__png, false, 32, 32);

		textPower = new FlxText(10, 10, 300, "Power: 0");
		textAngle = new FlxText(10, 30, 300, "Angle: 0");
		textWind = new FlxText(FlxG.width - 70, 10, 300, "Wind: 0");
		textFuel = new FlxText(FlxG.width - 70, 30, 300, "Fuel: 100");
		textP1Life = new FlxText(player.x, player.y - 10, 300, "100");
		textP2Life = new FlxText(player2.x, player2.y - 10, 300, "100");

		textPower.color = textAngle.color = textWind.color = 
		textP1Life.color = textP2Life.color = textFuel.color = FlxColor.BLACK;

		randomWind();

		indicator = new FlxSprite(player.x + 24, player.y - 11);
		indicator.loadGraphic(AssetPaths.Indicator__png, false, 5, 40);

		indicator2 = new FlxSprite(player2.x + 10, player2.y - 15);
		indicator2.loadGraphic(AssetPaths.Indicator__png, false, 5, 40);

		misileIndicator = new FlxSprite(0, 20);
		misileIndicator.makeGraphic(18, 18, FlxColor.BLACK);

        add(terrain);
		//add(sky);

		add(misile);

		add(indicator);
		add(indicator2);
		add(misileIndicator);

		//add(ground);

		add(player);
		add(player2);

		add(explosionSprite);

		add(textWind);
		add(textAngle);
		add(textPower);
		add(textP1Life);
		add(textP2Life);
		add(textFuel);
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
			textFuel.text = "Fuel: " + Std.string(player.fuel);
		} else if (turn == "P2") {
			textPower.text = "Power: " + Std.string(player2.powerAdjust2);
			textAngle.text = "Angle: " + Std.string(player2.angleAdjust2);
			textFuel.text = "Fuel: " + Std.string(player2.fuel);
		}

		textP1Life.text = Std.string(player.life);
		textP2Life.text = Std.string(player2.life);
	}

	public function explode(radius:Int, isPlayerExplosion:Bool = false):Void {
        misile.velocity.x = misile.velocity.y = 0;
    	var diameter = radius * 2;

    	explosionSprite.setGraphicSize(diameter, diameter);
    	explosionSprite.updateHitbox();

    	explosionSprite.x = (misile.x + misile.width / 2) - radius;
		if (isPlayerExplosion) {
			explosionSprite.y = misile.y - 80;
		} else {
    		explosionSprite.y = misile.y - 10; // So it doesn't go underground
		}
    	explosionSprite.visible = true;
		misile.visible = false;

		if (FlxCollision.pixelPerfectCheck(player, explosionSprite)) {
			player.life -= 20;
		}
		if (FlxCollision.pixelPerfectCheck(player2, explosionSprite)) {
			player2.life -= 20;
		}

		//ground.destroyTerrain(explosionSprite.x, explosionSprite.y, radius);

		if ((player.life <= 0 || player2.life <= 0) && !isPlayerExplosion) {
			die();
			return;
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
		indicator.setPosition(player.x + 24, player.y - 11);
		indicator2.setPosition(player2.x + 10, player2.y -15);
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

		explode(100, true);
		if (whoDied == player) {
			player.destroy();
			indicator.destroy();
			textP1Life.destroy();
		} else {
			player2.destroy();
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

		// Make the misile always point forward in the parable
		misile.angle = Math.atan2(misile.velocity.y, misile.velocity.x) * 180 / Math.PI + 90;
	}
}
