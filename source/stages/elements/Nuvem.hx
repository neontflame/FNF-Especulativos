package stages.elements;

import flixel.FlxG;
import flixel.FlxSprite;

class Nuvem extends FlxSprite
{
	var limit:Float;
	
	public function new(x:Float, y:Float, _limit:Float)
	{
		super(x, y);
		limit = _limit;
		loadGraphic(Paths.image("qen/onibus/nuvens000" + FlxG.random.int(1, 4)));
		updateHitbox();
	}

	override function update(elapsed:Float)
	{
		x += 10;
		if (x > limit)
			destroy();
	}
}