package stages;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.math.FlxPoint;
import flixel.FlxObject;
import flixel.group.FlxGroup;
import flixel.group.FlxGroup.FlxTypedGroup;
import stages.elements.*;

class Busao extends BasicStage
{
	var barras:FlxSprite;
	var cadeiras:FlxSprite;
	var chaoeteto:FlxSprite;
	var fundo:FlxSprite;
	var nuvens:FlxTypedGroup<Nuvem>;
	
	var busFora:FlxSprite;
	
	var escadas:FlxSprite;
	

	public override function init()
	{
		name = 'busao';
		startingZoom = 0.8;

		nuvens = new FlxTypedGroup<Nuvem>();
		addToBackground(nuvens);

		fundo = new FlxSprite(-553, 34).loadGraphic(Paths.image("qen/onibus/onibusFundo"));
		fundo.antialiasing = true;
		fundo.scrollFactor.set(0.8, 0.8);
		fundo.active = false;
		addToBackground(fundo);
		
		chaoeteto = new FlxSprite(-485, -86).loadGraphic(Paths.image("qen/onibus/onibusChaoeTeto"));
		chaoeteto.antialiasing = true;
		chaoeteto.scrollFactor.set(0.9, 0.9);
		chaoeteto.active = false;
		addToBackground(chaoeteto);

		cadeiras = new FlxSprite(-416, 330).loadGraphic(Paths.image("qen/onibus/onibusCadeiras"));
		cadeiras.antialiasing = true;
		cadeiras.scrollFactor.set(0.95, 0.95);
		cadeiras.active = false;
		addToBackground(cadeiras);
		
		barras = new FlxSprite(94, 217).loadGraphic(Paths.image("qen/onibus/onibusBarras"));
		barras.antialiasing = true;
		barras.scrollFactor.set(0.99, 0.99);
		barras.active = false;
		addToBackground(barras);

		busFora = new FlxSprite(-578, 709).loadGraphic(Paths.image("qen/onibus/busaoOut"));
		busFora.antialiasing = true;
		busFora.scrollFactor.set(0.99, 0.99);
		busFora.active = false;
		busFora.visible = false;
		addToBackground(busFora);
		
		escadas = new FlxSprite(559, 216).loadGraphic(Paths.image("qen/onibus/escadas"));
		escadas.antialiasing = true;
		escadas.scrollFactor.set(1, 1);
		escadas.active = false;
		escadas.visible = false;
		addToBackground(escadas);
		
		dad().y -= 17;
		gf().y -= 10;
		boyfriend().y -= 17;

		dad().x += 112;
		gf().x += 200;
		boyfriend().x += 386;
	}
	
	public override function update(elapsed:Float)
	{
		if (FlxG.random.int(0, 30) == 1) {
			var nuvem:Nuvem = new Nuvem(-952, FlxG.random.int(-36, 994), 2386);
			nuvens.add(nuvem);
		}
	}
	
	public override function beat(curBeat:Float)
	{
		switch (curBeat) {
			case 254:
				fundo.visible = false;
				chaoeteto.visible = false;
				cadeiras.visible = false;
				barras.visible = false;
				busFora.visible = true;
			case 352:
				busFora.visible = false;
				escadas.visible = true;
				nuvens.visible = false;
		}
	}
}
