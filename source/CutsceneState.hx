package;

import flixel.FlxG;
import flixel.FlxState;
import flixel.util.FlxColor;

using StringTools;

class CutsceneState extends FlxState
{
	public static var instance:CutsceneState = null;
	var oldFPS:Int = VideoHandler.MAX_FPS;
	var video:VideoHandler;
	public static var vid:String = "weekEspe/badending";
	
	override public function create():Void
	{
		instance = this;
		
		super.create();

		// FlxG.sound.cache(Paths.music("klaskiiLoop"));

		if (!Main.novid)
		{
			VideoHandler.MAX_FPS = 60;

			video = new VideoHandler();

			video.playMP4(Paths.video(vid), function()
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
		FlxG.sound.music.stop();
		FlxG.sound.music.volume = 100;
		FlxG.sound.playMusic(Paths.music("coolMenu"), 1);
		FlxG.switchState(new StoryMenuState());
	}
}
