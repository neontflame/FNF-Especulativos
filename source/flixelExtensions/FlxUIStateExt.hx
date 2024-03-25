package flixelExtensions;

import transition.*;
import transition.data.*;
#if sys
import cpp.vm.Gc;
import openfl.system.System;
#end

#if EXPERIMENTAL_MODDING
import polymod.Polymod;
#end

import flixel.FlxG;
import flixel.FlxState;
import flixel.addons.ui.FlxUIState;
import flixel.sound.FlxSound;

class FlxUIStateExt extends FlxUIState
{
	private var useDefaultTransIn:Bool = true;
	private var useDefaultTransOut:Bool = true;

	public static var defaultTransIn:Class<Dynamic>;
	public static var defaultTransInArgs:Array<Dynamic>;
	public static var defaultTransOut:Class<Dynamic>;
	public static var defaultTransOutArgs:Array<Dynamic>;

	private var customTransIn:BasicTransition = null;
	private var customTransOut:BasicTransition = null;

	private var controls(get, never):Controls;

	inline function get_controls():Controls
		return PlayerSettings.player1.controls;

	override function create()
	{	
		var someShits:Bool = !(Std.string(Type.getClass(FlxG.state)) == 'PlayState' || Std.string(Type.getClass(FlxG.state)) == 'ChartingState');
		CoolUtil.clearCache(someShits,
							someShits, 
							(!Startup.songsCacheActive ? someShits : false), 
							true);
		
		#if EXPERIMENTAL_MODDING
		// Polymod.clearCache();
		#end
		
		if (!Startup.songsCacheActive) {
			FlxG.sound.list.forEachDead(function(sound:FlxSound) {
				FlxG.sound.list.remove(sound, true);
				sound.stop();
				sound.kill();
				sound.destroy();
			});
		}
		
		if (customTransIn != null)
		{
			CustomTransition.transition(customTransIn, null);
		}
		else if (useDefaultTransIn)
			CustomTransition.transition(Type.createInstance(defaultTransIn, defaultTransInArgs), null);
		super.create();
	}

	public function switchState(_state:FlxState)
	{
		if (customTransOut != null)
		{
			CustomTransition.transition(customTransOut, _state);
		}
		else if (useDefaultTransOut)
		{
			CustomTransition.transition(Type.createInstance(defaultTransOut, defaultTransOutArgs), _state);
			return;
		}
		else
		{
			// #if sys System.gc(); #end
			FlxG.switchState(_state);
			return;
		}
	}
}
