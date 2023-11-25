package usefulshits;

import flixel.FlxSprite;
import flixel.math.FlxMath;
import CoolUtil;

class ProjectSprite extends FlxSprite
{
	// for menu shit
	public var targetX:Float = 0;
	public var isMenuItem:Bool = false;

	public function new(x:Float, y:Float, image:String = "")
	{
		super(x, y);
		if (CoolUtil.exists(Paths.file(image, "images", "png")))
			loadGraphic(Paths.image(image));
		else
			loadGraphic(Paths.image('menu/freeplay/songs/placeholder'));
	}

	override function update(elapsed:Float)
	{
		if (isMenuItem)
		{
			var scaledX = FlxMath.remapToRange(targetX, 0, 1, 0, 1.3);
			x = FlxMath.lerp(x, (targetX * 226) + 92, 0.1);
		}

		super.update(elapsed);
	}
}
