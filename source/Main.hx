package;

import flixel.system.scaleModes.RatioScaleMode;
import flixel.FlxG;
import flixel.FlxGame;
import openfl.display.FPS;
import openfl.display.Sprite;

using StringTools;

class Main extends Sprite
{
	public static var fpsDisplay:FPS;
	
	public static var novid:Bool = false;
	public static var flippymode:Bool = false;
	public static var salsicha:Bool = false;
	
	public function new()
	{
		super();
		
		#if sys
		novid = Sys.args().contains("-novid");
		flippymode = Sys.args().contains("-flippymode");
		salsicha = Sys.args().contains("-salsicha");
		#end

		fpsDisplay = new FPS(10, 3, 0xFFFFFF);
		fpsDisplay.visible = true;
		
		var game:FlxGame = new FlxGame(0, 0, Startup, 144, 144, true);
		
		@:privateAccess
		game._customSoundTray = usefulshits.ScratchSoundTray;
		
		addChild(game);
		addChild(fpsDisplay);
		
		// On web builds, video tends to lag quite a bit, so this just helps it run a bit faster.
		#if web
		VideoHandler.MAX_FPS = 30;
		#end
		
		trace("-= Args =-");
		trace("novid: " + novid);
		trace("flippymode: " + flippymode);
		trace("salsicha: " + salsicha);
	}
}
