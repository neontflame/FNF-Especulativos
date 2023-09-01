package stages;

import flixel.FlxSprite;
import flixel.math.FlxPoint;
import flixel.FlxObject;
import stages.elements.*;

class AdicioneVoce extends BasicStage
{
	public override function init()
	{
		name = 'adicioneVoce';
		startingZoom = 0.75;

		var bg:FlxSprite = new FlxSprite(-354, -494).loadGraphic(Paths.image("scdm/stage/ceuBrabo"));
		bg.antialiasing = true;
		bg.scrollFactor.set(0.5, 0.5);
		bg.active = false;
		addToBackground(bg);

		var fundoBrabo:FlxSprite = new FlxSprite(-1294, -341).loadGraphic(Paths.image("scdm/stage/fundoBrabo"));
		fundoBrabo.antialiasing = true;
		fundoBrabo.scrollFactor.set(0.8, 1);
		fundoBrabo.active = false;
		addToBackground(fundoBrabo);
		
		var ruaBraba:FlxSprite = new FlxSprite(-2016, 517).loadGraphic(Paths.image("scdm/stage/ruaBraba"));
		ruaBraba.updateHitbox();
		ruaBraba.antialiasing = true;
		ruaBraba.scrollFactor.set(1, 1);
		ruaBraba.active = false;
		addToBackground(ruaBraba);
		
		boyfriend().x += 160;
		gf().x += 150;
		
		boyfriend().y -= 160;
		dad().y -= 160;
		gf().y -= 160;
	}
}
