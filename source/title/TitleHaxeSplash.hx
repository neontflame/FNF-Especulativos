package title;

import flixel.FlxG;
import flixel.FlxState;
import flixel.util.FlxColor;

using StringTools;

class TitleHaxeSplash extends FlxState
{
	var oldFPS:Int = VideoHandler.MAX_FPS;
	var video:VideoHandler;
	var titleState = new TitleIntroText();

	override public function create():Void
	{
		super.create();

		// FlxG.sound.cache(Paths.music("klaskiiLoop"));

		if (!Main.novid)
		{
			VideoHandler.MAX_FPS = 60;

			video = new VideoHandler();

			video.playMP4(Paths.video('flixelIntro'), function()
			{
				next();
				#if web
				VideoHandler.MAX_FPS = oldFPS;
				#end
			}, false, true);

			add(video);
		}
		else
		{
			next();
		}
	}

	override public function update(elapsed:Float)
	{
		super.update(elapsed);
	}

	function next():Void
	{
		FlxG.switchState(titleState);
	}
}
