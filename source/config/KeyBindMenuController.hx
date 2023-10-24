package config;

import transition.data.*;
import flixel.input.gamepad.FlxGamepad;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import flixel.text.FlxText;

using StringTools;

class KeyBindMenuController extends MusicBeatState
{
	var keyTextDisplay:FlxText;
	var keyWarning:FlxText;
	var warningTween:FlxTween;
	var keyText:Array<String> = ["LEFT", "DOWN", "UP", "RIGHT"];
	var defaultKeys:Array<String> = ["X", "A", "Y", "B"];
	var allowedKeys:Array<Int> = [];
	var curSelected:Int = 0;

	var keys:Array<String> = [
		FlxG.save.data.leftBindController,
		FlxG.save.data.downBindController,
		FlxG.save.data.upBindController,
		FlxG.save.data.rightBindController
	];

	var tempKey:String = "";
	var blacklist:Array<String> = ["START", "BACK"];

	var state:String = "select";

	override function create()
	{
		for (i in 0...42)
		{
			allowedKeys[i] = i;
		}

		for (i in 19...30)
		{
			allowedKeys.remove(i);
		}

		persistentUpdate = persistentDraw = true;

		var bg:FlxSprite = new FlxSprite(0).loadGraphic(Paths.image('menu/scratchBG'));
		bg.scrollFactor.x = 0;
		bg.scrollFactor.y = 0;
		bg.updateHitbox();
		bg.screenCenter();
		bg.antialiasing = true;
		add(bg);

		var moreMenuShittery:FlxSprite = new FlxSprite(256, 108).loadGraphic(Paths.image('menu/options/moreMenuStuff'));
		add(moreMenuShittery);

		var titleStuff:FlxText = new FlxText(moreMenuShittery.x + 14, moreMenuShittery.y + 9, 718, "Configurações de controle (gamepad)", 24);
		titleStuff.scrollFactor.set(0, 0);
		titleStuff.setFormat(Paths.font("arialbd"), 24, 0xFF333333, FlxTextAlign.LEFT);
		add(titleStuff);
		
		keyTextDisplay = new FlxText(moreMenuShittery.x + 24, 170, 718, "", 32);
		keyTextDisplay.scrollFactor.set(0, 0);
		keyTextDisplay.setFormat(Paths.font("arial"), 32, FlxColor.GRAY, FlxTextAlign.LEFT);
		add(keyTextDisplay);

		keyWarning = new FlxText(moreMenuShittery.x + 24, 545, 718,
			"WARNING: BIND NOT SET, TRY ANOTHER KEY",
			32);
		keyWarning.scrollFactor.set(0, 0);
		keyWarning.setFormat(Paths.font("arial"), 20, 0xFFCC3300, FlxTextAlign.CENTER);
		keyWarning.screenCenter(X);
		keyWarning.alpha = 0;
		add(keyWarning);
		
		var backText = new FlxText(5, FlxG.height - 37, 0, "ESCAPE - back to menu\nBACKSPACE - reset to defaults\n", 16);
		backText.scrollFactor.set();
		backText.setFormat("Arial", 16, 0xFF343434, LEFT);
		add(backText);

		warningTween = FlxTween.tween(keyWarning, {alpha: 0}, 0);

		textUpdate();

		customTransIn = new WeirdBounceIn(0.6);
		customTransOut = new WeirdBounceOut(0.6);

		super.create();
	}

	override function update(elapsed:Float)
	{
		var controller:FlxGamepad = FlxG.gamepads.lastActive;

		var pressedAny = false;

		for (x in allowedKeys)
		{
			pressedAny = pressedAny || FlxG.gamepads.anyJustPressed(x);
		}

		switch (state)
		{
			case "select":
				if (controls.UP_P)
				{
					FlxG.sound.play(Paths.sound('scrollMenu'));
					changeItem(-1);
				}

				if (controls.DOWN_P)
				{
					FlxG.sound.play(Paths.sound('scrollMenu'));
					changeItem(1);
				}

				if (controls.ACCEPT)
				{
					FlxG.sound.play(Paths.sound('scrollMenu'));
					state = "input";
				}
				else if (controls.PAUSE)
				{
					FlxG.sound.play(Paths.sound('cancelMenu'));
					quit();
				}
				else if (controls.RESET)
				{
					FlxG.sound.play(Paths.sound('cancelMenu'));
					reset();
				}

			case "input":
				tempKey = keys[curSelected];
				keys[curSelected] = "?";
				textUpdate();
				state = "waiting";

			case "waiting":
				if (controls.PAUSE)
				{
					keys[curSelected] = tempKey;
					state = "select";
					FlxG.sound.play(Paths.sound('cancelMenu'));
				}
				else if (controls.RESET)
				{
					addKey(defaultKeys[curSelected]);
					save();
					state = "select";
				}
				else if (pressedAny)
				{
					addKey(controller.firstJustPressedID());
					save();
					state = "select";
				}

			case "exiting":

			default:
				state = "select";
		}

		if (FlxG.gamepads.anyJustPressed(ANY))
			textUpdate();

		super.update(elapsed);
	}

	function textUpdate()
	{
		keyTextDisplay.clearFormats();
		keyTextDisplay.text = "";

		for (i in 0...4)
		{
			var keyDisplay = keys[i];

			switch (keyDisplay)
			{
				case "A":
					keyDisplay = "A (CROSS)";
				case "B":
					keyDisplay = "B (CIRCLE)";
				case "X":
					keyDisplay = "X (SQUARE)";
				case "Y":
					keyDisplay = "Y (TRIANGLE)";
				default:
					keyDisplay = keyDisplay.replace("STICK_DIGITAL", "STICK").replace("_", " ");
			}

			var sectionStart = keyTextDisplay.text.length;
			keyTextDisplay.text += keyText[i] + ": " + ((keys[i] != keyText[i]) ? (keys[i] + " + ") : "") + keyText[i] + " ARROW\n";
			var sectionEnd = keyTextDisplay.text.length - 1;

			if (i == curSelected)
			{
				keyTextDisplay.addFormat(new FlxTextFormat(0xFF046792), sectionStart, sectionEnd);
			}
		}

		// keyTextDisplay.screenCenter();
	}

	function save()
	{
		FlxG.save.data.upBindController = keys[2];
		FlxG.save.data.downBindController = keys[1];
		FlxG.save.data.leftBindController = keys[0];
		FlxG.save.data.rightBindController = keys[3];

		FlxG.save.flush();
	}

	function reset()
	{
		for (i in 0...4)
		{
			keys[i] = defaultKeys[i];
		}
		quit();
	}

	function quit()
	{
		state = "exiting";

		save();

		// ConfigMenu.startSong = false;
		switchState(new ConfigMenu());
	}

	function addKey(r:String)
	{
		trace(r);

		if (r == null)
		{
			if (FlxG.gamepads.anyPressed(LEFT_TRIGGER))
			{
				r = "LEFT_TRIGGER";
			}
			else if (FlxG.gamepads.anyPressed(RIGHT_TRIGGER))
			{
				r = "RIGHT_TRIGGER";
			}
			else
			{
				r = "START";
			}
		}

		var shouldReturn:Bool = true;

		var notAllowed:Array<String> = [];

		for (x in keys)
		{
			if (x != tempKey)
			{
				notAllowed.push(x);
			}
		}

		for (x in blacklist)
		{
			notAllowed.push(x);
		}

		if (curSelected != 4)
		{
			for (x in keyText)
			{
				if (x != keyText[curSelected])
				{
					notAllowed.push(x);
				}
			}
		}
		else
		{
			for (x in keyText)
			{
				notAllowed.push(x);
			}
		}

		trace(notAllowed);

		for (x in notAllowed)
		{
			if (x == r)
			{
				shouldReturn = false;
			}
		}

		if (shouldReturn)
		{
			keys[curSelected] = r;
			FlxG.sound.play(Paths.sound('scrollMenu'));
		}
		else if (!shouldReturn && keys.contains(r))
		{
			keys[keys.indexOf(r)] = tempKey;
			keys[curSelected] = r;
			FlxG.sound.play(Paths.sound('scrollMenu'));
		}
		else
		{
			keys[curSelected] = tempKey;
			FlxG.sound.play(Paths.sound('cancelMenu'));
			keyWarning.alpha = 1;
			warningTween.cancel();
			warningTween = FlxTween.tween(keyWarning, {alpha: 0}, 0.5, {ease: FlxEase.circOut, startDelay: 2});
		}

		if (controls.DOWN_P || controls.UP_P)
			changeItem(0);
	}

	function changeItem(_amount:Int = 0)
	{
		curSelected += _amount;

		if (curSelected > 3)
			curSelected = 0;
		if (curSelected < 0)
			curSelected = 3;
	}
}
