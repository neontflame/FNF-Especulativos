package title;

import flixel.addons.display.FlxBackdrop;
import flixel.FlxCamera;
import openfl.system.System;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
// import flixel.addons.display.FlxGridOverlay;
// import flixel.addons.transition.FlxTransitionSprite.GraphicTransTileDiamond;
// import flixel.addons.transition.FlxTransitionableState;
// import flixel.addons.transition.TransitionData;
import flixel.graphics.FlxGraphic;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.group.FlxGroup;
import flixel.input.gamepad.FlxGamepad;
// import flixel.math.FlxPoint;
// import flixel.math.FlxRect;
import flixel.sound.FlxSound;
import flixel.system.ui.FlxSoundTray;
import flixel.text.FlxText;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;
// import io.newgrounds.NG;
import lime.app.Application;
import openfl.Assets;

// import polymod.Polymod;
using StringTools;

class TitleScreen extends MusicBeatState
{
	public static var titleMusic:String = "especulaintro";

	var camBackground:FlxCamera;
	var camMain:FlxCamera;

	final bgScrollSpeed = 20;

	override public function create():Void
	{
		// Polymod.init({modRoot: "mods", dirs: ['introMod']});

		// DEBUG BULLSHIT

		useDefaultTransIn = false;

		camBackground = new FlxCamera();
		camBackground.width *= 2;
		camBackground.x -= 640;
		camBackground.angle = -6.26;

		camMain = new FlxCamera();
		camMain.bgColor.alpha = 0;
		camMain.bgColor.alpha = 0;

		FlxG.cameras.reset();
		FlxG.cameras.add(camBackground, false);
		FlxG.cameras.add(camMain, true);
		FlxG.cameras.setDefaultDrawTarget(camMain, true);

		logoBl = new FlxSprite(27, 32);
		logoBl.frames = Paths.getSparrowAtlas("fpsPlus/title/logoBump");
		logoBl.antialiasing = true;
		logoBl.animation.addByPrefix('bump', 'logo bumpin', 24);
		logoBl.animation.play('bump');

		gfDance = new FlxSprite(563, 271);
		gfDance.frames = Paths.getSparrowAtlas("fpsPlus/title/espeDj");
		gfDance.animation.addByPrefix('dance', "espe dj", 24);
		gfDance.animation.play("dance", true, false, 14);
		gfDance.antialiasing = true;

		titleText = new FlxSprite(59, FlxG.height * 0.8);
		titleText.scale.set(0.6, 0.6);
		titleText.frames = Paths.getSparrowAtlas("titleEnter");
		titleText.animation.addByPrefix('idle', "Press Enter to Begin", 24);
		titleText.animation.addByPrefix('press', "ENTER PRESSED", 24);
		titleText.antialiasing = true;
		titleText.animation.play('idle');
		titleText.updateHitbox();
		/*titleText.angle = camBackground.angle;
			titleText.x += 120;
			titleText.y -= 24; */

		add(gfDance);

		add(logoBl);
		add(titleText);

		if (FlxG.sound.music == null)
		{
			FlxG.sound.playMusic(Paths.music(titleMusic), 1);
		}
		else
		{
			if (!FlxG.sound.music.playing)
			{
				FlxG.sound.playMusic(Paths.music(titleMusic), 1);
				switch (titleMusic)
				{
					case "especulaintro":
						Conductor.changeBPM(130);
					case "klaskiiLoop":
						Conductor.changeBPM(158);
					case "freakyMenu":
						Conductor.changeBPM(102);
				}
			}
		}

		FlxG.sound.music.onComplete = function()
		{
			lastStep = 0;
		}

		camMain.flash(FlxColor.WHITE, 1);

		super.create();
	}

	var logoBl:FlxSprite;
	var gfDance:FlxSprite;
	var titleText:FlxSprite;

	var transitioning:Bool = false;

	override function update(elapsed:Float)
	{
		Conductor.songPosition = FlxG.sound.music.time;
		// FlxG.watch.addQuick('amp', FlxG.sound.music.amplitude);

		if (FlxG.keys.justPressed.F)
		{
			FlxG.fullscreen = !FlxG.fullscreen;
		}

		var pressedEnter:Bool = controls.ACCEPT || controls.PAUSE;

		if (!transitioning && controls.BACK)
		{
			#if sys System.exit(0); #end
		}

		if (pressedEnter && !transitioning)
		{
			FlxG.sound.music.stop();
			titleText.animation.play('press');

			camMain.flash(FlxColor.WHITE, 1);
			FlxG.sound.play(Paths.sound('confirmMenu'), 0.7);

			transitioning = true;
			// FlxG.sound.music.stop();

			new FlxTimer().start(2, function(tmr:FlxTimer)
			{
				// Check if version is outdated
				switchState(new MainMenuState());
			});
		}

		super.update(elapsed);
	}

	override function beatHit()
	{
		super.beatHit();

		logoBl.animation.play('bump', true);

		// i want the option
		gfDance.animation.play('dance', true);

		FlxG.log.add(curBeat);
	}
}
