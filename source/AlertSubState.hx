package;

import flixel.tweens.FlxTween;
import config.*;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.sound.FlxSound;
import flixel.util.FlxColor;

class AlertSubState extends MusicBeatSubstate
{
	var timeLeftToCool:Float = 2;

	public function new(x:Float, y:Float, alert:String)
	{
		super();

		openfl.Lib.current.stage.frameRate = 144;

		FlxTween.globalManager.active = false;

		var bg:FlxSprite = new FlxSprite().makeGraphic(FlxG.width, FlxG.height, 0xFF666666);
		bg.alpha = 0.6;
		bg.scrollFactor.set();
		add(bg);

		var alertWindow:FlxSprite = new FlxSprite(382, 192).loadGraphic(Paths.image('menu/alerts/' + alert));
		alertWindow.updateHitbox();
		add(alertWindow);
	}

	override function update(elapsed:Float)
	{
		if (timeLeftToCool > 0)
			timeLeftToCool = timeLeftToCool - 0.1;

		super.update(elapsed);

		var accepted = controls.ACCEPT;

		if (accepted && timeLeftToCool < 0.1)
		{
			FlxTween.globalManager.active = true;

			unpause();
		}
	}

	function unpause()
	{
		if (Config.noFpsCap)
			openfl.Lib.current.stage.frameRate = 999;
		close();
	}

	override function destroy()
	{
		super.destroy();
	}
}
