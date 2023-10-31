package stages;

import flixel.FlxSprite;
import flixel.math.FlxPoint;
import flixel.FlxObject;
import stages.elements.*;

class Street extends BasicStage
{
	public override function init()
	{
		name = 'street';
		startingZoom = 0.935;

		var bg:FlxSprite = new FlxSprite(-514, -156).loadGraphic(Paths.image("yotsu/stage/bg"));
		bg.antialiasing = true;
		bg.scrollFactor.set(0.05, 0.05);
		bg.active = false;
		addToBackground(bg);

		var grass:FlxSprite = new FlxSprite(-523, -80).loadGraphic(Paths.image("yotsu/stage/grass"));
		grass.antialiasing = true;
		grass.scrollFactor.set(0.75, 1);
		grass.active = false;
		addToBackground(grass);

		var gateAndWall:FlxSprite = new FlxSprite(-610, -18).loadGraphic(Paths.image("yotsu/stage/gateAndWall"));
		gateAndWall.antialiasing = true;
		gateAndWall.active = false;
		addToBackground(gateAndWall);
		
		var floor:FlxSprite = new FlxSprite(-817, 570).loadGraphic(Paths.image("yotsu/stage/floorCool"));
		floor.antialiasing = true;
		floor.active = false;
		addToBackground(floor);
		
		boyfriend().y -= 189;
		dad().y -= 189;
		gf().y -= 33;
		
		dad().x -= 10;
		boyfriend().x += 25;
		gf().x += 55;
		
		gf().scrollFactor.set(0.99, 0.99);
	}
}
