package usefulshits;

import flixel.FlxSprite;

class SwagStrum extends FlxSprite
{
	// because yknow. modcharts
	public var modAngle:Float = 0; // The angle set by modcharts
	public var modSpeed:Float = 0; // custom scroll speed shit woohoo
	public var modifiedByLua:Bool = false;

	public function new(x:Float, y:Float)
	{
		super(x, y);
	}

	/*
	// nos sequer precisamos disso?
	override function update(elapsed:Float)
	{
		super.update(elapsed);
	}
	*/
	
	public function playAnim(AnimName:String, ?force:Bool = false):Void
	{
		animation.play(AnimName, force);

		updateHitbox();
		offset.set(frameWidth / 2, frameHeight / 2);

		offset.x -= 54;
		offset.y -= 56;
	}
}
