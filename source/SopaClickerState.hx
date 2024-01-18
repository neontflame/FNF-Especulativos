package;

import flixel.FlxG;
import flixel.FlxState;
import flixelExtensions.FlxUIStateExt;
import flixel.FlxSprite;
import flixel.FlxCamera;
import flixel.text.FlxText;
import flixel.util.FlxTimer;

class SopaClickerState extends FlxUIStateExt
{
	// tecnicalidades!!!!
	public static var instance:SopaClickerState = null;
	var mouseCoiso:FlxSprite;
	
	private var camHUD:FlxCamera;
	private var camGame:FlxCamera;
		
	// o verdadeiro foda
	var pontos:Int = 0;
	var pontosTexto:FlxText;
	
	var sprite1:FlxSprite;
	var encostador:FlxSprite;
	
	var timer:FlxTimer;
	
	var encostadorTomAtivado:Bool = false;
	
	public static var versao:Int = 1;
	public static var trolagem:Bool = false;
	
	override public function create():Void
	{
		instance = this;
		
		var timer:FlxTimer = new FlxTimer();
		
		FlxG.mouse.visible = true;
		FlxG.sound.music.stop();
		
		// cameras
		camGame = new FlxCamera();
		
		camHUD = new FlxCamera();
		camHUD.bgColor.alpha = 0;

		FlxG.cameras.reset(camGame);
		FlxG.cameras.add(camHUD, false);
		FlxG.cameras.setDefaultDrawTarget(camGame, true);
		
		var bgBranco:FlxSprite = new FlxSprite(0, 0).makeGraphic(1280, 720, 0xFFFFFFFF);
		bgBranco.updateHitbox();
		add(bgBranco);

		mouseCoiso = new FlxSprite(0, 0).makeGraphic(2, 2, 0xFFFFFFFF);
		mouseCoiso.updateHitbox();
		add(mouseCoiso);
		
		sprite1 = new FlxSprite(0, 0);
		if (versao == 1)
			sprite1.loadGraphic(Paths.image('sopaClicker/costume1'));
		if (versao == 2)
			sprite1.loadGraphic(Paths.image('sopaClicker/costume1tom'));			
		sprite1.screenCenter(XY);
		add(sprite1);
		
		encostador = new FlxSprite(744, 326).loadGraphic(Paths.image('sopaClicker/encostador'));	
		if (versao == 2)
			add(encostador);
		
		var pontosCounter:FlxSprite = new FlxSprite(35, 26).loadGraphic(Paths.image('sopaClicker/pontuacao'));
		add(pontosCounter);
		
		pontosTexto = new FlxText(146, 35, 104, "teeeeest", 25);
		pontosTexto.setFormat(Paths.font("arialbd"), 25, 0xFFFFFFFF, CENTER);
		add(pontosTexto);
		
		encostador.cameras = [camHUD];
		pontosCounter.cameras = [camHUD];
		pontosTexto.cameras = [camHUD];
		
		super.create();
	}

	override public function update(elapsed:Float)
	{
		super.update(elapsed);
		
		mouseCoiso.x = FlxG.mouse.x;
		mouseCoiso.y = FlxG.mouse.y;
		
		pontosTexto.text = '' + pontos; //pq o bag tinha bugado
			
		if (FlxG.mouse.justPressed && FlxG.overlap(mouseCoiso, sprite1))
		{
			if (versao == 1)
				FlxG.sound.play(Paths.sound('sopaClicker/Meow'));
			if (versao == 2)
				FlxG.sound.play(Paths.sound('sopaClicker/tom scream_128k'));
			pontos += 1;
			
			if (trolagem && pontos >= 5)
				pontos = 0;
		}

		if (versao == 2) {
			if (FlxG.mouse.justPressed && FlxG.overlap(mouseCoiso, encostador) && !encostadorTomAtivado && pontos >= 6)
			{
				encostadorTomAtivado = true;
				encostador.visible = false;
				tomEncostated();
			}
		}
		
		if (controls.BACK)
		{
			FlxG.mouse.visible = false;
			FlxG.sound.music.stop();
			FlxG.sound.play(Paths.sound('cancelMenu'));
			switchState(new MainMenuState());
		}
	}
	
	function tomEncostated()
	{
		if (encostadorTomAtivado) {
			pontos += 1;
			new FlxTimer().start(1, function(tmr:FlxTimer){
				tomEncostated();
			});
		}
	}
}
