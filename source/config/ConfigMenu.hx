package config;

import flixel.group.FlxSpriteGroup;
import flixel.group.FlxGroup.FlxTypedGroup;
import transition.data.*;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import flixel.text.FlxText;

using StringTools;

class ConfigMenu extends UIStateExt
{
	public static var exitTo:Class<Dynamic>;
	public static var startInSubMenu:Int = -1;

	var curSelected:Int = 0;
	var curSelectedSub:Int = 0;

	var state:String = "topLevelMenu";
	var titles:Array<FlxSprite> = [];

	var bg:FlxSprite;

	var subMenuGroup:FlxSpriteGroup = new FlxSpriteGroup();

	final options:Array<String> = ["video", "input", "misc"];
	final optionPostions:Array<Float> = [1 / 5, 1 / 2, 4 / 5];

	final menuTweenTime:Float = 0.6;
	final menuAlphaTweenTime:Float = 0.4;

	var configText:FlxText;
	var descText:FlxText;

	var configOptions:Array<Array<ConfigOption>> = [];

	final genericOnOff:Array<String> = ["on", "off"];

	static var offsetValue:Float;
	static var accuracyType:String;
	static var accuracyTypeInt:Int;

	final accuracyTypes:Array<String> = ["none", "simple", "complex"];

	static var healthValue:Int;
	static var healthDrainValue:Int;
	static var comboValue:Int;

	final comboTypes:Array<String> = ["world", "hud", "off"];

	static var downValue:Bool;
	static var glowValue:Bool;
	static var randomTapValue:Int;

	final randomTapTypes:Array<String> = ["never", "not singing", "always"];

	static var noCapValue:Bool;
	static var scheme:Int;
	static var dimValue:Int;
	static var noteSplashValue:Int;

	final noteSplashTypes:Array<String> = ["off", "sick only", "always"];

	static var centeredValue:Bool;
	static var scrollSpeedValue:Int;
	static var showComboBreaksValue:Bool;
	static var showFPSValue:Bool;

	override function create()
	{
		openfl.Lib.current.stage.frameRate = 144;

		if (exitTo == null)
		{
			exitTo = MainMenuState;
		}

		if (!FlxG.sound.music.playing)
		{
			FlxG.sound.playMusic(Paths.music("coolMenu"), 1);
		}

		bg = new FlxSprite(0).loadGraphic(Paths.image('menu/scratchBG'));
		bg.scrollFactor.x = 0;
		bg.scrollFactor.y = 0;
		bg.updateHitbox();
		bg.screenCenter();
		bg.antialiasing = true;

		add(bg);
		
		var textTexture = Paths.getSparrowAtlas("menu/options/scratchOptsSidebar");

		for (i in 0...options.length)
		{
			var text = new FlxSprite();
			text.frames = textTexture;
			text.animation.addByPrefix('active', options[i] + ' selected', 24);
			text.animation.addByPrefix('inactive', options[i] + ' idle', 24);
			text.animation.play("inactive");
			text.antialiasing = true;
			text.x = 126;
			text.y = 215 + (50 * i);
			titles.push(text);
			add(text);
		}

		var yetAnotherMenuThing:FlxSprite = new FlxSprite(409, 108).loadGraphic(Paths.image('menu/options/yetAnotherMenuThing'));
		add(yetAnotherMenuThing);
		
		add(subMenuGroup);
		
		configText = new FlxText(433, 170, 718, "", 60);
		configText.scrollFactor.set(0, 0);
		configText.setFormat(Paths.font("arial"), 32, FlxColor.GRAY, FlxTextAlign.LEFT);
		subMenuGroup.add(configText);

		descText = new FlxText(433, 545, 718, "", 16);
		descText.scrollFactor.set(0, 0);
		descText.setFormat(Paths.font("arial"), 16, FlxColor.GRAY, FlxTextAlign.CENTER);
		subMenuGroup.add(descText);

		setupOptions();
		if (startInSubMenu > -1)
		{
			instantBringTextToTop(startInSubMenu);
		}
		changeSelected(0);

		customTransIn = new WeirdBounceIn(0.6);
		customTransOut = new WeirdBounceOut(0.6);

		super.create();
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);

		switch (state)
		{
			case "topLevelMenu":
				if (controls.UP_P)
				{
					FlxG.sound.play(Paths.sound('scrollMenu'));
					changeSelected(-1);
				}
				else if (controls.DOWN_P)
				{
					FlxG.sound.play(Paths.sound('scrollMenu'));
					changeSelected(1);
				}

				if (controls.BACK)
				{
					exit();
				}
				else if (controls.ACCEPT)
				{
					FlxG.sound.play(Paths.sound('confirmMenu'));
					bringTextToTop(curSelected);
					curSelectedSub = 0;
					textUpdate();
				}

			case "subMenu":
				if (controls.BACK)
				{
					FlxG.sound.play(Paths.sound('cancelMenu'));
					backToCategories();
				}

				if (controls.UP_P)
				{
					FlxG.sound.play(Paths.sound('scrollMenu'));
					changeSubSelected(-1);
				}
				else if (controls.DOWN_P)
				{
					FlxG.sound.play(Paths.sound('scrollMenu'));
					changeSubSelected(1);
				}

				if (configOptions[curSelected][curSelectedSub].optionUpdate != null)
				{
					configOptions[curSelected][curSelectedSub].optionUpdate();
				}

				if (controls.UP_P || controls.DOWN_P || controls.LEFT_P || controls.RIGHT_P || controls.ACCEPT)
				{
					textUpdate();
				}
		}
	}

	function exit()
	{
		writeToConfig();
		FlxG.sound.play(Paths.sound('cancelMenu'));
		switchState(Type.createInstance(exitTo, []));
		exitTo = null;
	}

	function bringTextToTop(x:Int)
	{
		state = "subMenu";
		FlxTween.cancelTweensOf(subMenuGroup);
		FlxTween.tween(subMenuGroup, {alpha: 1}, menuAlphaTweenTime, {ease: FlxEase.quintOut});
	}

	function instantBringTextToTop(x:Int)
	{
		state = "subMenu";
		curSelected = x;
		startInSubMenu = -1;
		titles[x].alpha = 1;
		subMenuGroup.alpha = 1;
		textUpdate();
	}

	function backToCategories()
	{
		state = "topLevelMenu";
		FlxTween.cancelTweensOf(subMenuGroup);
		FlxTween.tween(subMenuGroup, {alpha: 0}, menuAlphaTweenTime, {ease: FlxEase.quintOut});
	}

	function changeSelected(change:Int)
	{
		curSelected += change;

		if (curSelected < 0)
		{
			curSelected = options.length - 1;
		}
		else if (curSelected >= options.length)
		{
			curSelected = 0;
		}

		for (i in 0...options.length)
		{
			if (i == curSelected)
			{
				titles[i].animation.play("active");
			}
			else
			{
				titles[i].animation.play("inactive");
			}
		}
	}

	function changeSubSelected(change:Int)
	{
		curSelectedSub += change;

		if (curSelectedSub < 0)
		{
			curSelectedSub = configOptions[curSelected].length - 1;
		}
		else if (curSelectedSub >= configOptions[curSelected].length)
		{
			curSelectedSub = 0;
		}
	}

	function textUpdate()
	{
		configText.clearFormats();
		configText.text = "";

		for (i in 0...configOptions[curSelected].length)
		{
			var sectionStart = configText.text.length;
			configText.text += configOptions[curSelected][i].name + configOptions[curSelected][i].setting + "\n";
			var sectionEnd = configText.text.length - 1;

			if (i == curSelectedSub)
			{
				configText.addFormat(new FlxTextFormat(0xFF046792), sectionStart, sectionEnd);
			}
		}

		// configText.y += 30;
		configText.text += "\n";

		descText.text = configOptions[curSelected][curSelectedSub].description;

		// tabDisplay.text = Std.string(tabKeys);
	}

	function setupOptions()
	{
		offsetValue = Config.offset;
		accuracyType = Config.accuracy;
		accuracyTypeInt = accuracyTypes.indexOf(Config.accuracy);
		healthValue = Std.int(Config.healthMultiplier * 10);
		healthDrainValue = Std.int(Config.healthDrainMultiplier * 10);
		comboValue = Config.comboType;
		downValue = Config.downscroll;
		glowValue = Config.noteGlow;
		randomTapValue = Config.ghostTapType;
		noCapValue = Config.noFpsCap;
		scheme = Config.controllerScheme;
		dimValue = Config.bgDim;
		noteSplashValue = Config.noteSplashType;
		centeredValue = Config.centeredNotes;
		scrollSpeedValue = Std.int(Config.scrollSpeedOverride * 10);
		showComboBreaksValue = Config.showComboBreaks;
		showFPSValue = Config.showFPS;

		// VIDEO

		var fpsCap = new ConfigOption("Uncapped framerate", #if desktop ": " + genericOnOff[noCapValue ? 0 : 1]#else ": disabled" #end,
			#if desktop "Uncaps the framerate during gameplay." #else "Disabled on Web builds." #end);
		fpsCap.optionUpdate = function()
		{
			#if desktop
			if (controls.RIGHT_P || controls.LEFT_P || controls.ACCEPT)
			{
				FlxG.sound.play(Paths.sound('scrollMenu'));
				noCapValue = !noCapValue;
			}
			fpsCap.setting = ": " + genericOnOff[noCapValue ? 0 : 1];
			#end
		};

		var bgDim = new ConfigOption("Background dim", ": " + (dimValue * 10) + "%",
			"Adjusts how dark the background is.\nIt is recommended that you use the HUD combo display with a high background dim.");
		bgDim.optionUpdate = function()
		{
			if (controls.RIGHT_P)
			{
				FlxG.sound.play(Paths.sound('scrollMenu'));
				dimValue += 1;
			}

			if (controls.LEFT_P)
			{
				FlxG.sound.play(Paths.sound('scrollMenu'));
				dimValue -= 1;
			}

			if (dimValue > 10)
				dimValue = 0;
			if (dimValue < 0)
				dimValue = 10;

			bgDim.setting = ": " + (dimValue * 10) + "%";
		}

		var noteSplash = new ConfigOption("Note splash", ": " + noteSplashTypes[noteSplashValue],
			"Adjusts how dark the background is.\nIt is recommended that you use the HUD combo display with a high background dim.");
		noteSplash.extraData[0] = "Note splashes are disabled.";
		noteSplash.extraData[1] = "Note splashes are created when you get a sick rating.";
		noteSplash.extraData[2] = "Note splashes are created every time you hit a note. \nWhy?";
		noteSplash.optionUpdate = function()
		{
			if (controls.RIGHT_P)
			{
				FlxG.sound.play(Paths.sound('scrollMenu'));
				noteSplashValue += 1;
			}

			if (controls.LEFT_P)
			{
				FlxG.sound.play(Paths.sound('scrollMenu'));
				noteSplashValue -= 1;
			}

			if (noteSplashValue >= noteSplashTypes.length)
				noteSplashValue = 0;
			if (noteSplashValue < 0)
				noteSplashValue = noteSplashTypes.length - 1;

			noteSplash.setting = ": " + noteSplashTypes[noteSplashValue];
			noteSplash.description = noteSplash.extraData[noteSplashValue];
		}

		var noteGlow = new ConfigOption("Note glow", ": " + genericOnOff[glowValue ? 0 : 1], "Makes note arrows glow if they are able to be hit.");
		noteGlow.optionUpdate = function()
		{
			if (controls.RIGHT_P || controls.LEFT_P || controls.ACCEPT)
			{
				FlxG.sound.play(Paths.sound('scrollMenu'));
				glowValue = !glowValue;
			}
			noteGlow.setting = ": " + genericOnOff[glowValue ? 0 : 1];
		}

		// INPUT

		var noteOffset = new ConfigOption("Note offset", ": " + offsetValue,
			"Adjust note timings.\nPress \"ENTER\" to start the offset calibration." +
			(FlxG.save.data.ee1 ? "\nHold \"SHIFT\" to force the pixel calibration.\nHold \"CTRL\" to force the normal calibration." : ""));
		noteOffset.extraData[0] = 0;
		noteOffset.optionUpdate = function()
		{
			if (controls.RIGHT_P)
			{
				FlxG.sound.play(Paths.sound('scrollMenu'));
				offsetValue += 1;
			}

			if (controls.LEFT_P)
			{
				FlxG.sound.play(Paths.sound('scrollMenu'));
				offsetValue -= 1;
			}

			if (controls.RIGHT)
			{
				noteOffset.extraData[0]++;

				if (noteOffset.extraData[0] > 64)
				{
					offsetValue += 1;
					textUpdate();
				}
			}

			if (controls.LEFT)
			{
				noteOffset.extraData[0]++;

				if (noteOffset.extraData[0] > 64)
				{
					offsetValue -= 1;
					textUpdate();
				}
			}

			if (!controls.RIGHT && !controls.LEFT)
			{
				noteOffset.extraData[0] = 0;
				textUpdate();
			}

			if (FlxG.keys.justPressed.ENTER)
			{
				state = "transitioning";
				startInSubMenu = curSelected;
				FlxG.sound.music.fadeOut(0.3);
				writeToConfig();
				AutoOffsetState.forceEasterEgg = FlxG.keys.pressed.SHIFT ? 1 : (FlxG.keys.pressed.CONTROL ? -1 : 0);
				switchState(new AutoOffsetState());
			}

			noteOffset.setting = ": " + offsetValue;
		};

		var downscroll = new ConfigOption("Downscroll", ": " + genericOnOff[downValue ? 0 : 1], "Makes notes approach from the top instead the bottom.");
		downscroll.optionUpdate = function()
		{
			if (controls.RIGHT_P || controls.LEFT_P || controls.ACCEPT)
			{
				FlxG.sound.play(Paths.sound('scrollMenu'));
				downValue = !downValue;
			}
			downscroll.setting = ": " + genericOnOff[downValue ? 0 : 1];
		}

		var centeredNotes = new ConfigOption("Centered strumline", ": " + genericOnOff[centeredValue ? 0 : 1],
			"Makes the strum line centered instead of to the side.");
		centeredNotes.optionUpdate = function()
		{
			if (controls.RIGHT_P || controls.LEFT_P || controls.ACCEPT)
			{
				FlxG.sound.play(Paths.sound('scrollMenu'));
				centeredValue = !centeredValue;
			}
			centeredNotes.setting = ": " + genericOnOff[centeredValue ? 0 : 1];
		}

		var ghostTap = new ConfigOption("Allow ghost tapping", ": " + randomTapTypes[randomTapValue], "");
		ghostTap.extraData[0] = "Any key press that isn't for a valid note will cause you to miss.";
		ghostTap.extraData[1] = "You can only miss while you need to sing.";
		ghostTap.extraData[2] = "You cannot miss unless you do not hit a note.";
		ghostTap.optionUpdate = function()
		{
			if (controls.RIGHT_P)
			{
				FlxG.sound.play(Paths.sound('scrollMenu'));
				randomTapValue += 1;
			}

			if (controls.LEFT_P)
			{
				FlxG.sound.play(Paths.sound('scrollMenu'));
				randomTapValue -= 1;
			}

			if (randomTapValue > 2)
				randomTapValue = 0;
			if (randomTapValue < 0)
				randomTapValue = 2;

			ghostTap.setting = ": " + randomTapTypes[randomTapValue];
			ghostTap.description = "" + ghostTap.extraData[randomTapValue];
		}

		var keyBinds = new ConfigOption("[Edit keybinds]", "", "Press ENTER to change key binds.");
		keyBinds.optionUpdate = function()
		{
			if (controls.ACCEPT)
			{
				FlxG.sound.play(Paths.sound('scrollMenu'));
				state = "transitioning";
				startInSubMenu = curSelected;
				writeToConfig();
				switchState(new KeyBindMenu());
			}
		}

		var controllerBinds = new ConfigOption("Controller scheme", "", "");
		controllerBinds.extraData[0] = "Default";
		controllerBinds.extraData[1] = "Alt 1";
		controllerBinds.extraData[2] = "Alt 2";
		controllerBinds.extraData[3] = "[Custom]";
		controllerBinds.extraData[4] = "LEFT: DPAD LEFT / X (SQUARE) / LEFT TRIGGER\nDOWN: DPAD DOWN / X (CROSS) / LEFT BUMPER\nUP: DPAD UP / Y (TRIANGLE) / RIGHT BUMPER\nRIGHT: DPAD RIGHT / B (CIRCLE) / RIGHT TRIGGER";
		controllerBinds.extraData[5] = "LEFT: DPAD LEFT / DPAD DOWN / LEFT TRIGGER\nDOWN: DPAD UP / DPAD RIGHT / LEFT BUMPER\nUP: X (SQUARE) / Y (TRIANGLE) / RIGHT BUMPER\nRIGHT: A (CROSS) / B (CIRCLE) / RIGHT TRIGGER";
		controllerBinds.extraData[6] = "LEFT: ALL DPAD DIRECTIONS\nDOWN: LEFT BUMPER / LEFT TRIGGER\nUP: RIGHT BUMPER / RIGHT TRIGGER\nRIGHT: ALL FACE BUTTONS";
		controllerBinds.extraData[7] = "Press A (CROSS) to change controller binds.";
		controllerBinds.setting = ": " + controllerBinds.extraData[scheme];
		controllerBinds.optionUpdate = function()
		{
			if (controls.RIGHT_P)
			{
				FlxG.sound.play(Paths.sound('scrollMenu'));
				scheme += 1;
			}

			if (controls.LEFT_P)
			{
				FlxG.sound.play(Paths.sound('scrollMenu'));
				scheme -= 1;
			}

			if (scheme >= 4)
				scheme = 0;
			if (scheme < 0)
				scheme = 4 - 1;

			if (controls.ACCEPT && scheme == 4 - 1)
			{
				FlxG.sound.play(Paths.sound('scrollMenu'));
				state = "transitioning";
				startInSubMenu = curSelected;
				writeToConfig();
				switchState(new KeyBindMenuController());
			}

			controllerBinds.setting = ": " + controllerBinds.extraData[scheme];
			controllerBinds.description = controllerBinds.extraData[scheme + 4];
		}

		var showFPS = new ConfigOption("Show FPS", ": " + genericOnOff[showFPSValue ? 0 : 1], "Show or hide the game's framerate.");
		showFPS.optionUpdate = function()
		{
			if (controls.RIGHT_P || controls.LEFT_P || controls.ACCEPT)
			{
				FlxG.sound.play(Paths.sound('scrollMenu'));
				showFPSValue = !showFPSValue;
				Main.fpsDisplay.visible = showFPSValue;
			}
			showFPS.setting = ": " + genericOnOff[showFPSValue ? 0 : 1];
		}

		// MISC

		var accuracyDisplay = new ConfigOption("Accuracy display", ": " + accuracyType,
			"What type of accuracy calculation you want to use. \nSimple is just notes hit / total notes. \nComplex also factors in how early or late a note was.");
		accuracyDisplay.optionUpdate = function()
		{
			if (controls.RIGHT_P)
			{
				FlxG.sound.play(Paths.sound('scrollMenu'));
				accuracyTypeInt += 1;
			}

			if (controls.LEFT_P)
			{
				FlxG.sound.play(Paths.sound('scrollMenu'));
				accuracyTypeInt -= 1;
			}

			if (accuracyTypeInt > 2)
				accuracyTypeInt = 0;
			if (accuracyTypeInt < 0)
				accuracyTypeInt = 2;

			accuracyType = accuracyTypes[accuracyTypeInt];

			accuracyDisplay.setting = ": " + accuracyType;
		};

		var comboDisplay = new ConfigOption("Combo display", ": " + comboTypes[comboValue], "");
		comboDisplay.extraData[0] = "Ratings and combo count are a part of the world and move around with the camera.";
		comboDisplay.extraData[1] = "Ratings and combo count are a part of the hud and stay in a static position.";
		comboDisplay.extraData[2] = "Ratings and combo count are hidden.";
		comboDisplay.optionUpdate = function()
		{
			if (controls.RIGHT_P)
			{
				FlxG.sound.play(Paths.sound('scrollMenu'));
				comboValue += 1;
			}

			if (controls.LEFT_P)
			{
				FlxG.sound.play(Paths.sound('scrollMenu'));
				comboValue -= 1;
			}

			if (comboValue >= comboTypes.length)
				comboValue = 0;
			if (comboValue < 0)
				comboValue = comboTypes.length - 1;

			comboDisplay.setting = ": " + comboTypes[comboValue];
			comboDisplay.description = comboDisplay.extraData[comboValue];
		};

		var hpGain = new ConfigOption("HP gain multiplier", ": " + healthValue / 10.0, "Modifies how much Health you gain when hitting a note.");
		hpGain.extraData[0] = 0;
		hpGain.optionUpdate = function()
		{
			if (controls.RIGHT_P)
			{
				FlxG.sound.play(Paths.sound('scrollMenu'));
				healthValue += 1;
			}

			if (controls.LEFT_P)
			{
				FlxG.sound.play(Paths.sound('scrollMenu'));
				healthValue -= 1;
			}

			if (healthValue > 100)
				healthValue = 0;
			if (healthValue < 0)
				healthValue = 100;

			if (controls.RIGHT)
			{
				hpGain.extraData[0]++;

				if (hpGain.extraData[0] > 64 && hpGain.extraData[0] % 10 == 0)
				{
					healthValue += 1;
					textUpdate();
				}
			}

			if (controls.LEFT)
			{
				hpGain.extraData[0]++;

				if (hpGain.extraData[0] > 64 && hpGain.extraData[0] % 10 == 0)
				{
					healthValue -= 1;
					textUpdate();
				}
			}

			if (!controls.RIGHT && !controls.LEFT)
			{
				hpGain.extraData[0] = 0;
				textUpdate();
			}

			hpGain.setting = ": " + healthValue / 10.0;
		};

		var hpDrain = new ConfigOption("HP loss multiplier", ": " + healthDrainValue / 10.0, "Modifies how much Health you lose when missing a note.");
		hpDrain.extraData[0] = 0;
		hpDrain.optionUpdate = function()
		{
			if (controls.RIGHT_P)
			{
				FlxG.sound.play(Paths.sound('scrollMenu'));
				healthDrainValue += 1;
			}

			if (controls.LEFT_P)
			{
				FlxG.sound.play(Paths.sound('scrollMenu'));
				healthDrainValue -= 1;
			}

			if (healthDrainValue > 100)
				healthDrainValue = 0;
			if (healthDrainValue < 0)
				healthDrainValue = 100;

			if (controls.RIGHT)
			{
				hpGain.extraData[0]++;

				if (hpGain.extraData[0] > 64 && hpGain.extraData[0] % 10 == 0)
				{
					healthDrainValue += 1;
					textUpdate();
				}
			}

			if (controls.LEFT)
			{
				hpGain.extraData[0]++;

				if (hpGain.extraData[0] > 64 && hpGain.extraData[0] % 10 == 0)
				{
					healthDrainValue -= 1;
					textUpdate();
				}
			}

			if (!controls.RIGHT && !controls.LEFT)
			{
				hpGain.extraData[0] = 0;
				textUpdate();
			}

			hpDrain.setting = ": " + healthDrainValue / 10.0;
		};

		var cacheSettings = new ConfigOption("[Cache settings]", "", "Press ENTER to change what assets the game keeps cached.");
		cacheSettings.optionUpdate = function()
		{
			if (controls.ACCEPT)
			{
				#if desktop
				FlxG.sound.play(Paths.sound('scrollMenu'));
				state = "transitioning";
				startInSubMenu = curSelected;
				writeToConfig();
				switchState(new CacheSettings());
				CacheSettings.returnLoc = new ConfigMenu();
				#end
			}
		}

		var scrollSpeed = new ConfigOption("Static scroll speed", ": " + (scrollSpeedValue > 0 ? "" + (scrollSpeedValue / 10.0) : "[DISABLED]"), "");
		scrollSpeed.extraData[0] = 0;
		scrollSpeed.extraData[1] = "Press ENTER to enable.\nSets the song scroll speed to the set value instead of the song's default.";
		scrollSpeed.extraData[2] = "Press ENTER to disable.\nSets the song scroll speed to the set value instead of the song's default.";
		scrollSpeed.optionUpdate = function()
		{
			if (scrollSpeedValue != -10)
			{
				if (controls.RIGHT_P)
				{
					FlxG.sound.play(Paths.sound('scrollMenu'));
					scrollSpeedValue += 1;
				}

				if (controls.LEFT_P)
				{
					FlxG.sound.play(Paths.sound('scrollMenu'));
					scrollSpeedValue -= 1;
				}

				if (scrollSpeedValue > 50)
					scrollSpeedValue = 10;
				if (scrollSpeedValue < 10)
					scrollSpeedValue = 50;

				if (controls.RIGHT)
				{
					scrollSpeed.extraData[0]++;

					if (scrollSpeed.extraData[0] > 64 && scrollSpeed.extraData[0] % 10 == 0)
					{
						scrollSpeedValue += 1;
						textUpdate();
					}
				}

				if (controls.LEFT)
				{
					scrollSpeed.extraData[0]++;

					if (scrollSpeed.extraData[0] > 64 && scrollSpeed.extraData[0] % 10 == 0)
					{
						scrollSpeedValue -= 1;
						textUpdate();
					}
				}

				if (!controls.RIGHT && !controls.LEFT)
				{
					scrollSpeed.extraData[0] = 0;
					textUpdate();
				}

				if (controls.ACCEPT)
				{
					FlxG.sound.play(Paths.sound('scrollMenu'));
					scrollSpeedValue = -10;
				}
			}
			else
			{
				if (controls.ACCEPT)
				{
					FlxG.sound.play(Paths.sound('scrollMenu'));
					scrollSpeedValue = 10;
				}
			}

			scrollSpeed.description = scrollSpeedValue > 0 ? scrollSpeed.extraData[2] : scrollSpeed.extraData[1];
			scrollSpeed.setting = ": " + (scrollSpeedValue > 0 ? "" + (scrollSpeedValue / 10.0) : "[DISABLED]");
		};

		var showComboBreaks = new ConfigOption("Show combo breaks", ": " + genericOnOff[showComboBreaksValue ? 0 : 1],
			"Show combo breaks instead of misses.\nMisses only happen when you actually miss a note.\nCombo breaks can happen in other instances like dropping hold notes.");
		showComboBreaks.optionUpdate = function()
		{
			if (controls.RIGHT_P || controls.LEFT_P || controls.ACCEPT)
			{
				FlxG.sound.play(Paths.sound('scrollMenu'));
				showComboBreaksValue = !showComboBreaksValue;
			}
			showComboBreaks.setting = ": " + genericOnOff[showComboBreaksValue ? 0 : 1];
		}

		configOptions = [
			[fpsCap, noteSplash, noteGlow, bgDim, showFPS],
			[noteOffset, downscroll, centeredNotes, ghostTap, controllerBinds, keyBinds],
			[
				accuracyDisplay,
				showComboBreaks,
				comboDisplay,
				scrollSpeed,
				hpGain,
				hpDrain,
				cacheSettings
			]
		];
	}

	function writeToConfig()
	{
		Config.write(offsetValue, accuracyType, healthValue / 10.0, healthDrainValue / 10.0, comboValue, downValue, glowValue, randomTapValue, noCapValue,
			scheme, dimValue, noteSplashValue, centeredValue, scrollSpeedValue / 10.0, showComboBreaksValue, showFPSValue);
	}
}

class ConfigOption
{
	public var name:String;
	public var setting:String;
	public var description:String;
	public var optionUpdate:Void->Void;
	public var extraData:Array<Dynamic> = [];

	public function new(_name:String, _setting:String, _description:String, ?initFunction:Void->Void)
	{
		name = _name;
		setting = _setting;
		description = _description;
		if (initFunction != null)
		{
			initFunction();
		}
	}
}
