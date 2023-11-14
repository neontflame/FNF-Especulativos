package stages;

import flixel.FlxSprite;
import flixel.math.FlxPoint;
import flixel.FlxObject;
import stages.elements.*;

class BigHawnt extends BasicStage
{
	var fogo:FlxSprite;
	
	public override function init()
	{
		name = 'bighawnt';
		startingZoom = 0.6;

		var bgBranco:FlxSprite = new FlxSprite(-2000, -1000).makeGraphic(4280, 3720, 0xFFFFFFFF);
		bgBranco.updateHitbox();
		bgBranco.scrollFactor.set(0, 0);
		bgBranco.active = false;
		addToBackground(bgBranco);
		
		var grawnt:FlxSprite = new FlxSprite(-143, 749).loadGraphic(Paths.image("salsicha/stage/bawnt"));
		grawnt.antialiasing = true;
		grawnt.scrollFactor.set(1, 1);
		grawnt.active = false;
		addToBackground(grawnt);
		
		fogo = new FlxSprite(-50, 360).loadGraphic(Paths.image("salsicha/stage/lol"));
		fogo.antialiasing = true;
		fogo.scrollFactor.set(1, 1);
		fogo.active = false;
		fogo.visible = false;
		addToForeground(fogo);
	}
	
	public override function beat(curBeat:Int)
	{
		if (curBeat >= 99)
			fogo.visible = true;
	}
}
