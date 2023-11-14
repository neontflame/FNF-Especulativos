package stages;

import flixel.FlxSprite;
import flixel.math.FlxPoint;
import flixel.FlxObject;
import stages.elements.*;

class Gramado extends BasicStage
{
	public override function init()
	{
		name = 'gramado';
		startingZoom = 0.7;

		var ceuProvavel:FlxSprite = new FlxSprite(-815, -426).loadGraphic(Paths.image("weekOld/stage/ceuProvavel"));
		ceuProvavel.antialiasing = true;
		ceuProvavel.scrollFactor.set(0.5, 0.5);
		ceuProvavel.active = false;
		addToBackground(ceuProvavel);

		var nuvens:FlxSprite = new FlxSprite(-856, 170).loadGraphic(Paths.image("weekOld/stage/nuvens"));
		nuvens.updateHitbox();
		nuvens.antialiasing = true;
		nuvens.scrollFactor.set(0.75, 0.75);
		nuvens.active = false;
		addToBackground(nuvens);

		var chao:FlxSprite = new FlxSprite(-858, 682).loadGraphic(Paths.image("weekOld/stage/chao"));
		chao.updateHitbox();
		chao.antialiasing = true;
		chao.scrollFactor.set(1, 1);
		chao.active = false;
		addToBackground(chao);
	}
}
