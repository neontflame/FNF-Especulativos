package usefulshits;

import flixel.FlxSprite;

class SwagStrum extends FlxSprite
{
	// because yknow. modcharts
	public var modAngle:Float = 0; // The angle set by modcharts
	public var strumY:Float = 0; // The angle set by modcharts
	
	public function new(x:Float, y:Float)
	{
		strumY = y;
		super(x, y);
	}
	
	override function update(elapsed:Float)
	{
		super.update(elapsed);
	}
}