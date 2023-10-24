package stages;

import flixel.FlxSprite;
import flixel.math.FlxPoint;
import flixel.FlxObject;
import stages.elements.*;

class CoisasBar extends BasicStage
{
	var coisas:FlxSprite;

	public override function init()
	{
		var mainPath:String = "especula/stage/";
		name = 'coisasbar';
		startingZoom = 0.8;

		// var.setGraphicSize(Std.int(var.width * timesIWantToMultiply));
		// var.updateHitbox();

		var bg:FlxSprite = new FlxSprite(-784, -41).loadGraphic(Paths.image(mainPath + "bgTijolos"));
		bg.antialiasing = true;
		bg.scrollFactor.set(0.85, 0.975);
		bg.active = false;

		var cadeiras:FlxSprite = new FlxSprite(489, 667).loadGraphic(Paths.image(mainPath + "cadeiras"));
		cadeiras.antialiasing = true;
		cadeiras.scrollFactor.set(0.95, 0.95);
		cadeiras.active = false;

		var barMesa:FlxSprite = new FlxSprite(481, 503).loadGraphic(Paths.image(mainPath + "barMesa"));
		barMesa.antialiasing = true;
		barMesa.scrollFactor.set(0.9325, 0.9325);
		barMesa.active = false;

		var meuManoSush:FlxSprite = new FlxSprite(187, 645).loadGraphic(Paths.image(mainPath + "sushiCaidoTodoFodido"));
		meuManoSush.antialiasing = true;
		meuManoSush.scrollFactor.set(0.921, 0.921);
		meuManoSush.active = false;

		var adega:FlxSprite = new FlxSprite(517, 116).loadGraphic(Paths.image(mainPath + "adegaFunny"));
		adega.antialiasing = true;
		adega.scrollFactor.set(0.875, 0.875);
		adega.active = false;

		coisas = new FlxSprite(814, 162);
		coisas.frames = Paths.getSparrowAtlas(mainPath + "coisas");
		coisas.animation.addByPrefix('idle', 'coisas', 24, false);
		coisas.scrollFactor.set(0.915, 0.915);
		coisas.antialiasing = true;

		var chao:FlxSprite = new FlxSprite(-612, 740).loadGraphic(Paths.image(mainPath + "chao"));
		chao.antialiasing = true;
		chao.scrollFactor.set(0.975, 0.975);
		chao.active = false;

		var escarradeira:FlxSprite = new FlxSprite(32, 618).loadGraphic(Paths.image(mainPath + "escarradeira"));
		escarradeira.antialiasing = true;
		escarradeira.scrollFactor.set(0.92, 0.92);
		escarradeira.active = false;

		// layering xdd
		addToBackground(bg);
		addToBackground(adega);
		addToBackground(chao);
		addToBackground(escarradeira);
		addToBackground(coisas);
		addToBackground(meuManoSush);
		addToBackground(barMesa);
		addToBackground(cadeiras);

		gf().x += 740;
		gf().y += 220;
		boyfriend().x += 665;
		boyfriend().y += 50;
		dad().y += 50;
	}

	public override function beat(curBeat:Int)
	{
		coisas.animation.play('idle', true);
	}
}
