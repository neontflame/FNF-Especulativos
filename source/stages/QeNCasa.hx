package stages;

import flixel.FlxSprite;
import flixel.math.FlxPoint;
import flixel.FlxObject;
import stages.elements.*;

class QeNCasa extends BasicStage
{
	var sofa:FlxSprite;
	
	public override function init()
	{
		name = 'qencasa';
		startingZoom = 0.7;

		var bg:FlxSprite = new FlxSprite(-500, -200).makeGraphic(2300, 1000, 0xFF222222);
		bg.antialiasing = true;
		bg.scrollFactor.set(0, 0);
		bg.active = false;
		addToBackground(bg);

		var oBgInteiro:FlxSprite = new FlxSprite(-1101, 244).loadGraphic(Paths.image("qen/stage/chao"));
		oBgInteiro.updateHitbox();
		oBgInteiro.antialiasing = true;
		oBgInteiro.active = false;
		oBgInteiro.scrollFactor.set(0.9, 0.9);
		addToBackground(oBgInteiro);

		sofa = new FlxSprite(-535, 252);
		sofa.frames = Paths.getSparrowAtlas("qen/stage/sofa");
		sofa.animation.addByPrefix('idle', 'sofaQueixao', 24, false);
		sofa.antialiasing = true;
		sofa.scrollFactor.set(0.95, 0.95);
		addToBackground(sofa);
		
		dad().y -= 50;
		gf().y -= 50;
		boyfriend().y -= 50;
		
		dad().x += 100;
		gf().x += 200;
		boyfriend().x += 200;
	}
	
	public override function beat(curBeat:Int)
	{
		sofa.animation.play('idle', true);
	}
}
