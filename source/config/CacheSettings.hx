package config;

import transition.data.*;
import flixel.FlxState;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.util.FlxColor;
import flixel.text.FlxText;

using StringTools;

class CacheSettings extends MusicBeatState
{
	public static var noFunMode = false;

	var keyTextDisplay:FlxText;
	var warning:FlxText;

	public static var returnLoc:FlxState;
	public static var thing:Bool = false;

	var settings:Array<Bool>;
	var startingSettings:Array<Bool>;
	var names:Array<String> = ["MUSIC", "CHARACTERS", "GRAPHICS"];
	var onOff:Array<String> = ["off", "on"];

	var curSelected:Int = 0;

	var state:String = "select";

	override function create()
	{
		var bgColor:FlxColor = 0xFFFFFFFF;

		if (noFunMode)
		{
			bgColor = FlxColor.fromRGB(232, 232, 232);
		}

		var bg:FlxSprite = new FlxSprite(0).loadGraphic(Paths.image('menu/scratchBG'));
		bg.scrollFactor.x = 0;
		bg.scrollFactor.y = 0;
		bg.updateHitbox();
		bg.screenCenter();
		bg.antialiasing = true;

		bg.color = bgColor;
		add(bg);

		var moreMenuShittery:FlxSprite = new FlxSprite(256, 108).loadGraphic(Paths.image('menu/options/moreMenuStuff'));
		add(moreMenuShittery);

		var titleStuff:FlxText = new FlxText(moreMenuShittery.x + 14, moreMenuShittery.y + 9, 718, "Configurações de cache", 24);
		titleStuff.scrollFactor.set(0, 0);
		titleStuff.setFormat(Paths.font("arialbd"), 24, 0xFF333333, FlxTextAlign.LEFT);
		add(titleStuff);
		
		keyTextDisplay = new FlxText(moreMenuShittery.x + 24, 170, 718, "", 32);
		keyTextDisplay.scrollFactor.set(0, 0);
		keyTextDisplay.setFormat(Paths.font("arial"), 32, FlxColor.GRAY, FlxTextAlign.LEFT);
		add(keyTextDisplay);

		warning = new FlxText(moreMenuShittery.x + 24, 545, 718,
			"WARNING!\nEnabling this will load a large amount of graphics data to VRAM.\nIf you don't have a decent GPU it might be best to leave this disabled.",
			32);
		warning.scrollFactor.set(0, 0);
		warning.setFormat(Paths.font("arial"), 20, 0xFFCC3300, FlxTextAlign.CENTER);
		warning.screenCenter(X);
		warning.visible = false;
		add(warning);

		var backText = new FlxText(5, FlxG.height - 21, 0, "ESCAPE - back to menu", 16);
		backText.scrollFactor.set();
		backText.setFormat("Arial", 16, 0xFF343434, LEFT);
		add(backText);

		if (FlxG.save.data.musicPreload2 == null || FlxG.save.data.charPreload2 == null || FlxG.save.data.graphicsPreload2 == null)
		{
			FlxG.save.data.musicPreload2 = true;
			FlxG.save.data.charPreload2 = true;
			FlxG.save.data.graphicsPreload2 = false;
		}

		settings = [
			FlxG.save.data.musicPreload2,
			FlxG.save.data.charPreload2,
			FlxG.save.data.graphicsPreload2
		];
		startingSettings = [
			FlxG.save.data.musicPreload2,
			FlxG.save.data.charPreload2,
			FlxG.save.data.graphicsPreload2
		];

		textUpdate();

		customTransIn = new WeirdBounceIn(0.6);
		customTransOut = new WeirdBounceOut(0.6);

		super.create();
	}

	override function update(elapsed:Float)
	{
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

				if (controls.ACCEPT || controls.LEFT_P || controls.RIGHT_P)
				{
					FlxG.sound.play(Paths.sound('scrollMenu'));
					settings[curSelected] = !settings[curSelected];
				}
				else if (controls.BACK)
				{
					FlxG.sound.play(Paths.sound('cancelMenu'));
					quit();
				}

			case "exiting":

			default:
				state = "select";
		}

		if (FlxG.keys.justPressed.ANY)
			textUpdate();
	}

	function textUpdate()
	{
		keyTextDisplay.clearFormats();
		keyTextDisplay.text = "";

		for (i in 0...3)
		{
			var sectionStart = keyTextDisplay.text.length;
			keyTextDisplay.text += names[i] + ": " + (settings[i] ? onOff[1] : onOff[0]) + "\n";
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
		FlxG.save.data.musicPreload2 = settings[0];
		FlxG.save.data.charPreload2 = settings[1];
		FlxG.save.data.graphicsPreload2 = settings[2];

		FlxG.save.flush();

		// PlayerSettings.player1.controls.loadKeyBinds();
	}

	function quit()
	{
		state = "exiting";

		save();

		CacheReload.doMusic = true;
		CacheReload.doGraphics = true;

		if ((startingSettings[0] != settings[0] || startingSettings[1] != settings[1] || startingSettings[2] != settings[2]) && !noFunMode)
		{
			if (startingSettings[0] == settings[0])
			{
				CacheReload.doMusic = false;
			}
			if (startingSettings[1] == settings[1] && startingSettings[2] == settings[2])
			{
				CacheReload.doGraphics = false;
			}
			returnLoc = new CacheReload();
			// ConfigMenu.startSong = false;
		}
		else if (!noFunMode)
		{
			// ConfigMenu.startSong = false;
		}

		noFunMode = false;

		switchState(returnLoc);
	}

	function changeItem(_amount:Int = 0)
	{
		curSelected += _amount;

		if (curSelected > 2)
			curSelected = 0;
		if (curSelected < 0)
			curSelected = 2;

		warning.visible = curSelected == 2;
	}
}
