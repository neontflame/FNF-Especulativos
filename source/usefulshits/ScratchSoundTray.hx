package usefulshits;

import flixel.FlxG;

import openfl.Assets;
import flixel.system.FlxAssets;

import flixel.util.FlxColor;

import openfl.Lib;
import openfl.display.Bitmap;
import openfl.display.BitmapData;
import openfl.text.TextField;
import openfl.text.TextFormat;
import openfl.text.TextFormatAlign;

import flixel.system.FlxAssets;
import flixel.system.ui.FlxSoundTray;

class ScratchSoundTray extends FlxSoundTray
{
	/**The sound used when increasing the volume.**/
	public var volumeUp:String = "assets/sounds/saltar";

	/**The sound used when decreasing the volume.**/
	public var volumeDown:String = 'assets/sounds/saltar';
	
	var scratchVolume:Bitmap;
	var ball:Bitmap;
	var volText:TextField;
	
	public function new()
	{
		super();
		removeChildren();
		
		createTheThing();
		
		visible = false;
	}

	function createTheThing()
	{
		scratchVolume = new Bitmap(Assets.getBitmapData("assets/images/ui/scratchUI/volumePopout.png"));
		addChild(scratchVolume);
		// scratchVolume.x = (Lib.current.stage.stageWidth - scratchVolume.width) / 2;
		// scratchVolume.y = 100;
		
		// text
		volText = new TextField();
		volText.width = 65;
		volText.height = 27;
		volText.multiline = false;
		volText.wordWrap = true;
		volText.selectable = false;
		
		var dtf:TextFormat = new TextFormat(Paths.font("arialbd"), 20, 0xffffff);
		dtf.align = TextFormatAlign.CENTER;
		volText.defaultTextFormat = dtf;
	
		addChild(volText);
		
		volText.text = "100";
		volText.x = scratchVolume.x + 84;
		volText.y = scratchVolume.y + 6;
		
		ball = new Bitmap(Assets.getBitmapData("assets/images/ui/scratchUI/volumeBola.png"));
		addChild(ball);
		
		ball.x = scratchVolume.x + 9;
		ball.y = scratchVolume.y + 38;
		
		scaleX = 1.0;
		scaleY = 1.0;
		
	}
	/**
	 * This function updates the soundtray object.
	 */
	override public function update(MS:Float):Void
	{
		// Animate sound tray thing
		if (_timer > 0)
		{
			scaleX = 1.0;
			scaleY = 1.0;
			
			visible = true;
			_timer -= (MS / 1000);
		}
		else
		{
			visible = false;
			active = false;

			#if FLX_SAVE
			// Save sound preferences
			if (FlxG.save.isBound)
			{
				FlxG.save.data.mute = FlxG.sound.muted;
				FlxG.save.data.volume = FlxG.sound.volume;
				FlxG.save.flush();
			}
			#end
		}
	}

	/**
	 * Makes the little volume tray slide out.
	 *
	 * @param	up Whether the volume is increasing.
	 */
	override public function show(up:Bool = false):Void
	{
		if (!silent)
		{
			var sound = FlxAssets.getSound(up ? volumeUp : volumeDown);
			if (sound != null)
				FlxG.sound.load(sound).play();
		}
		
		_timer = 1;
		y = 0;
		
		visible = true;
		active = true;
		
		var globalVolume:Int = Math.round(FlxG.sound.volume * 10);

		if (FlxG.sound.muted)
		{
			globalVolume = 0;
		}
		
		ball.x = scratchVolume.x + 9 + (12.5 * globalVolume);
		volText.text = '' + Math.round(FlxG.sound.volume * 100);
	}
}