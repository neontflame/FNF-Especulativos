package title;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.addons.display.FlxGridOverlay;
import flixel.addons.transition.FlxTransitionSprite.GraphicTransTileDiamond;
import flixel.addons.transition.FlxTransitionableState;
import flixel.addons.transition.TransitionData;
import flixel.graphics.FlxGraphic;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.group.FlxGroup;
import flixel.input.gamepad.FlxGamepad;
import flixel.math.FlxPoint;
import flixel.math.FlxRect;
import flixel.math.FlxRandom;
import flixel.sound.FlxSound;
import flixel.system.ui.FlxSoundTray;
import flixel.text.FlxText;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;
import io.newgrounds.NG;
import lime.app.Application;
import openfl.Assets;

using StringTools;

class TitleIntroText extends MusicBeatState
{
	var blackScreen:FlxSprite;
	var credGroup:FlxGroup;
	var textGroup:FlxGroup;
	var ngSpr:FlxSprite;

	var curWacky:Array<String> = [];
	
	var wackyImage:FlxSprite;

	override public function create():Void
	{
		useDefaultTransIn = false;
		useDefaultTransOut = false;

		curWacky = FlxG.random.getObject(getIntroTextShit());

		credGroup = new FlxGroup();
		add(credGroup);
		textGroup = new FlxGroup();

		// blackScreen = new FlxSprite().makeGraphic(FlxG.width, FlxG.height, FlxColor.BLACK);
		// credGroup.add(blackScreen);

		ngSpr = new FlxSprite(0, FlxG.height * 0.52).loadGraphic(Paths.image('wipinhosLogo/wipinhos000' + FlxG.random.int(1,4)));
		add(ngSpr);
		ngSpr.visible = false;
		ngSpr.setGraphicSize(Std.int(ngSpr.width * 0.8));
		ngSpr.updateHitbox();
		ngSpr.screenCenter(X);
		ngSpr.antialiasing = true;

		Conductor.changeBPM(130);
		FlxG.sound.playMusic(Paths.music('especulaintro'), 0.8);
		TitleScreen.titleMusic = "especulaintro";
	}

	function getIntroTextShit():Array<Array<String>>
	{
		var fullText:String = CoolUtil.getText(Paths.text("introText"));

		var firstArray:Array<String> = fullText.split('\n');
		var swagGoodArray:Array<Array<String>> = [];

		for (i in firstArray)
		{
			swagGoodArray.push(i.split('--'));
		}

		return swagGoodArray;
	}

	var transitioning:Bool = false;

	override function update(elapsed:Float)
	{
		Conductor.songPosition = FlxG.sound.music.time;
		// FlxG.watch.addQuick('amp', FlxG.sound.music.amplitude);

		if (FlxG.keys.justPressed.F)
		{
			FlxG.fullscreen = !FlxG.fullscreen;
		}

		var pressedEnter:Bool = FlxG.keys.justPressed.ENTER;

		var gamepad:FlxGamepad = FlxG.gamepads.lastActive;

		if (gamepad != null)
		{
			if (gamepad.justPressed.START)
				pressedEnter = true;

			#if switch
			if (gamepad.justPressed.B)
				pressedEnter = true;
			#end
		}

		if (pressedEnter)
		{
			skipIntro();
		}

		super.update(elapsed);
	}

	function createCoolText(textArray:Array<String>)
	{
		for (i in 0...textArray.length)
		{
			var money:Alphabet = new Alphabet(0, 0, textArray[i], true, false);
			money.screenCenter(X);
			money.y += (i * 60) + 200;
			credGroup.add(money);
			textGroup.add(money);
		}
	}

	function addMoreText(text:String)
	{
		var coolText:Alphabet = new Alphabet(0, 0, text, true, false);
		coolText.screenCenter(X);
		coolText.y += (textGroup.length * 60) + 200;
		credGroup.add(coolText);
		textGroup.add(coolText);
	}

	function deleteCoolText()
	{
		while (textGroup.members.length > 0)
		{
			credGroup.remove(textGroup.members[0], true);
			textGroup.remove(textGroup.members[0], true);
		}
	}

	override function beatHit()
	{
		super.beatHit();

		switch (curBeat)
		{
			case 1:
				createCoolText(['um salve em especial']);
			case 4:
				addMoreText('pro especulativos');
			case 7:
				deleteCoolText();
			case 8:
				addMoreText('feito inteiramente');
			case 10:
				addMoreText('com uma dose de fe');
			case 12:
				addMoreText('e feedback no');
				ngSpr.visible = true;
			case 15:
				deleteCoolText();
				ngSpr.visible = false;
			case 16:
				createCoolText([curWacky[0]]);
			case 20:
				addMoreText(curWacky[1]);
			case 23:
				deleteCoolText();
			case 24:
				addMoreText('Friday');
			case 26:
				addMoreText('Night');
			case 28:
				addMoreText('Funkin');
			case 30:
				addMoreText('Vs Espe');
			case 32:
				skipIntro();
		}
	}

	function skipIntro():Void
	{
		switchState(new TitleScreen());
	}
}
