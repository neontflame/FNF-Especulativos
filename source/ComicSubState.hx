package;

import flixel.tweens.FlxTween;
import config.*;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.graphics.FlxGraphic;
import flixel.sound.FlxSound;
import flixel.util.FlxColor;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.text.FlxText;

class ComicSubState extends MusicBeatSubstate
{
	/* 	levou um tempinho pra eu fazer mas eu consegui regardless
		pode usar a vontade mas me da credito!
						-neon
	*/
    var comicPages:FlxTypedGroup<FlxSprite>;
	
	var timeLeftToCool:Float = 2;
	var pageCount:Int = 2;
	var curPage:Int = 1;
	
	var currentCut:String = "cut1";
	
	var addZoom:Float = 0;
	
	var zoomShits:Array<Float> = [];
	
	var controlShits:Array<Bool> = [false, false, false, false, // arrow keys
								false, false, // q/e (zoom)
								false, false]; // z/x (prosseguir e voltar)
								
	public function new(x:Float, y:Float, cutscene:String, count:Int)
	{
		pageCount = count;
		currentCut = cutscene;
		
		super();

		FlxTween.globalManager.active = false;

		var bg:FlxSprite = new FlxSprite().makeGraphic(FlxG.width, FlxG.height, 0xFF000000);
		bg.alpha = 0.6;
		bg.scrollFactor.set();
		add(bg);
		
		comicPages = new FlxTypedGroup<FlxSprite>();
		add(comicPages);
		
		var bar:FlxSprite = new FlxSprite(0, 695).makeGraphic(FlxG.width, 25, 0xFF000000);
		bar.alpha = 0.5;
		bar.scrollFactor.set();
		add(bar);

		var instructions:FlxText = new FlxText(10, bar.y + 3, FlxG.width, "Setas para mover a página, Q / E para mudar o zoom, Z / X para avançar/voltar uma página", 16);
		instructions.setFormat(Paths.font("vcr"), 16, FlxColor.WHITE, FlxTextAlign.LEFT, FlxTextBorderStyle.OUTLINE, 0xAF000000);
		instructions.antialiasing = false;
		instructions.scrollFactor.set();
		add(instructions);
		
        for (i in 0...count) {
            var comic = new FlxSprite();
			var comicGraphix:FlxGraphic = FlxGraphic.fromAssetKey(Paths.image('cutscenes/' + currentCut + '/pag' + (i+1)));
			
			trace(Paths.image('cutscenes/' + currentCut + '/pag' + (i+1)));
			
            comic.loadGraphic(comicGraphix);
            comic.ID = (i+1);

			comic.updateHitbox();
			
			trace(640 / comicGraphix.height);

			if (comicGraphix.height > 640) {
				zoomShits.push(640 / comicGraphix.height);
				comic.scale.set(640 / comicGraphix.height, 640 / comicGraphix.height);
			} else {
				zoomShits.push(1);
			}
			
			comic.screenCenter(XY);
			comic.antialiasing = true;
            comicPages.add(comic);
        }
		
		trace(zoomShits);
		changeSel();
		
		cameras = [FlxG.cameras.list[FlxG.cameras.list.length - 1]];
	}
	
	function changeSel(count:Int = 0){
		addZoom = 0;
		curPage += count;
		trace(curPage);
		
		for (comic in comicPages) {
			comic.updateHitbox();
			
			comic.scale.set(zoomShits[comic.ID - 1], zoomShits[comic.ID - 1]);
			comic.screenCenter(XY);
            comic.alpha = (comic.ID == curPage) ? 1 : 0;
		}
	}
	
	function addPosZoom(?xPos:Int = 0, ?yPos:Int = 0, ?zoom:Float = 0){
		for (comic in comicPages) {
			comic.x += xPos;
			comic.y += yPos;
			addZoom += zoom;
			
			comic.scale.set(0.158 + addZoom, 0.158 + addZoom);
		}
	}
	
	override function update(elapsed:Float)
	{
		controlShits = [FlxG.keys.pressed.LEFT, FlxG.keys.pressed.DOWN, FlxG.keys.pressed.UP, FlxG.keys.pressed.RIGHT,
					FlxG.keys.pressed.Q, FlxG.keys.pressed.E,
					FlxG.keys.justPressed.Z, FlxG.keys.justPressed.X];
					
		if (timeLeftToCool > 0)
			timeLeftToCool = timeLeftToCool - 0.1;

		super.update(elapsed);
		
		//setas
		if (controlShits[0])
			addPosZoom(-2,0,0);
		if (controlShits[1])
			addPosZoom(0,2,0);
		if (controlShits[2])
			addPosZoom(0,-2,0);
		if (controlShits[3])
			addPosZoom(2,0,0);
			
		//Q e E
		if (controlShits[4])
			addPosZoom(0,0,-0.002);
		if (controlShits[5])
			addPosZoom(0,0,0.002);
			
		//Z
		if (controlShits[6] && timeLeftToCool < 0.1)
		{
			if (curPage > 1) {
				timeLeftToCool = 2;
				changeSel(-1);
			}
		}
		
		//X
		if (controlShits[7] && timeLeftToCool < 0.1)
		{
			if (curPage >= pageCount) {
				FlxTween.globalManager.active = true;
				close();
			} else {
				timeLeftToCool = 2;
				changeSel(1);
			}
		}
	}
	
	override function destroy()
	{
		super.destroy();
	}
}
