package;

import flixel.util.FlxColor;
import flixel.FlxG;
import flixel.FlxSprite;
import openfl.display.BitmapData;

class Terrain extends FlxSprite {
    var perlin:Perlin = new Perlin();
    var terrainData:BitmapData = new BitmapData(FlxG.width, FlxG.height, true);
    var collision:haxe.ds.Vector<Int> = new haxe.ds.Vector(FlxG.width);

    public function new(x, y) {
        super(x, y);

        generateTerrain();
    }

    function generateTerrain():Void {
        var a:Int = 0;
        var skips:Int = Std.random(4)+2;
        var escale:Int = Std.random(80);
        for (x in 0...FlxG.width) {
            if (x%skips != 0) continue;
            var noiseFloat:Float = 300 + (perlin.noise2d(a / 50, 0, 3, 2) * escale);
            for (y in Std.int(noiseFloat) ... FlxG.height) {
                for(n in 0...skips)
                terrainData.setPixel32(x+n, y, FlxColor.MAGENTA);
            }
            for (n in 0...skips) {
                collision[x+n] = Std.int(noiseFloat);
                terrainData.setPixel32(x+n, Std.int(noiseFloat), FlxColor.GREEN);
            }
            a++;
            trace(x, noiseFloat);
            loadGraphic(terrainData);
        }
    }

    public function giveCollision():haxe.ds.Vector<Int> {
        return collision;
    }
}