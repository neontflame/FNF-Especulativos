package;

import flixel.FlxG;
import flixel.FlxState;
import flixelExtensions.FlxUIStateExt;
import flixel.FlxSprite;
import transition.data.*;

class ScratchCatState extends FlxUIStateExt
{
	var sprite1:FlxSprite;
	
	override public function create():Void
	{
		customTransIn = new BasicTransition();
		
		FlxG.mouse.visible = true;
		
		var bgBranco:FlxSprite = new FlxSprite(0, 0).makeGraphic(1280, 720, 0xFFFFFFFF);
		bgBranco.updateHitbox();
		add(bgBranco);
		
		sprite1 = new FlxSprite(0, 0).loadGraphic(Paths.image('cat'));
		sprite1.screenCenter(XY);
		add(sprite1);
		
		super.create();
	}

	override public function update(elapsed:Float)
	{
		super.update(elapsed);
	}
}
