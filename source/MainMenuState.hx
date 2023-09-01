package;

import config.*;
import title.TitleScreen;
import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.effects.FlxFlicker;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import lime.utils.Assets;
import flixel.text.FlxText;

using StringTools;

class MainMenuState extends MusicBeatState
{
	var curSelected:Int = 0;

	var menuItems:FlxTypedGroup<FlxSprite>;

	var optionShit:Array<String> = ['story mode', 'freeplay', "options"];
	var optionPosX:Array<Float> = [273, 459, 930];

	var alertOpened:Bool = false;

	var versionText:FlxText;
	var keyWarning:FlxText;
	var tabDisplay:FlxText;
	
	override function create()
	{
		openfl.Lib.current.stage.frameRate = 144;

		if (!FlxG.sound.music.playing)
		{
			FlxG.sound.playMusic(Paths.music("coolMenu"), 1);
		}

		persistentUpdate = persistentDraw = true;

		var bg:FlxSprite = new FlxSprite(0).loadGraphic(Paths.image('menu/scratchBG'));
		bg.scrollFactor.x = 0;
		bg.scrollFactor.y = 0;
		bg.updateHitbox();
		bg.screenCenter();
		bg.antialiasing = true;
		add(bg);

		var headerBG:FlxSprite = new FlxSprite(-19, -1).makeGraphic(1313, 59, 0xFF0F8BC0);
		headerBG.updateHitbox();
		add(headerBG);

		menuItems = new FlxTypedGroup<FlxSprite>();
		add(menuItems);

		var tex = Paths.getSparrowAtlas('menu/headerStuffs');

		for (i in 0...optionShit.length)
		{
			var menuItem:FlxSprite = new FlxSprite(optionPosX[i], -1);
			menuItem.frames = tex;

			menuItem.animation.addByPrefix('idle', optionShit[i] + " white", 24);
			menuItem.animation.addByPrefix('selected', optionShit[i] + " selected", 24);
			menuItem.animation.play('idle');
			menuItem.ID = i;
			menuItems.add(menuItem);
			menuItem.scrollFactor.set();
			menuItem.antialiasing = true;
		}

		var fnfScratchLogo:FlxSprite = new FlxSprite(141, 0).loadGraphic(Paths.image('menu/fnfScratch'));
		fnfScratchLogo.updateHitbox();
		add(fnfScratchLogo);

		var footer:FlxSprite = new FlxSprite(-35, 492).loadGraphic(Paths.image('menu/footer'));
		footer.updateHitbox();
		add(footer);

		versionText = new FlxText(5, FlxG.height - 21, 0, "Vs. Espe indev / FPS Plus: v4.1.0", 16);
		versionText.scrollFactor.set();
		versionText.setFormat("Arial", 16, 0xFF343434, LEFT);
		add(versionText);

		keyWarning = new FlxText(5, FlxG.height - 21 + 16, 0, "Se os controles não estiverem funcionando, tente pressionar CTRL + BACKSPACE para redefini-los.", 16);
		keyWarning.scrollFactor.set();
		keyWarning.setFormat("Arial", 16, 0xFF343434, LEFT);
		keyWarning.alpha = 0;
		add(keyWarning);

		tabDisplay = new FlxText(5, FlxG.height - 53, 0, Std.string(tabKeys), 16);
		tabDisplay.scrollFactor.set();
		tabDisplay.visible = false;
		tabDisplay.setFormat("Arial", 16, 0xFF343434, LEFT);
		add(tabDisplay);

		FlxTween.tween(versionText, {y: versionText.y - 16}, 0.75, {ease: FlxEase.quintOut, startDelay: 10});
		FlxTween.tween(keyWarning, {alpha: 1, y: keyWarning.y - 16}, 0.75, {ease: FlxEase.quintOut, startDelay: 10});

		// NG.core.calls.event.logEvent('swag').send();

		changeItem();

		// Offset Stuff
		Config.reload();

		super.create();
	}

	var selectedSomethin:Bool = false;
	var tabKeys:Array<String> = [];

	override function update(elapsed:Float)
	{
		if (FlxG.sound.music.volume < 0.8)
		{
			FlxG.sound.music.volume += 0.5 * FlxG.elapsed;
		}

		if (!selectedSomethin && !alertOpened)
		{
			if (FlxG.keys.pressed.TAB)
			{
				tabDisplay.visible = true;
				
				if (FlxG.keys.justPressed.ANY)
				{
					if (FlxG.keys.getIsDown()[0].ID.toString() != "TAB")
					{
						tabKeys.push(FlxG.keys.getIsDown()[0].ID.toString());
						tabDisplay.text = Std.string(tabKeys);
					}
				}
			}
			else
			{	
				tabDisplay.visible = false;
				
				if (controls.LEFT_P)
				{
					FlxG.sound.play(Paths.sound('scrollMenu'));
					changeItem(-1);
				}

				if (controls.RIGHT_P)
				{
					FlxG.sound.play(Paths.sound('scrollMenu'));
					changeItem(1);
				}

				if (FlxG.keys.justPressed.BACKSPACE && FlxG.keys.pressed.CONTROL)
				{
					KeyBinds.resetBinds();
					switchState(new MainMenuState());
				}

				if (controls.BACK)
				{
					FlxG.sound.music.stop();
					switchState(new TitleScreen());
				}
			}

			if (controls.ACCEPT)
			{
				if (optionShit[curSelected] == 'donate')
				{
					#if linux
					Sys.command('/usr/bin/xdg-open', ["https://ninja-muffin24.itch.io/funkin", "&"]);
					#else
					FlxG.openURL('https://ninja-muffin24.itch.io/funkin');
					#end
				}
				else
				{
					selectedSomethin = true;
					FlxG.sound.play(Paths.sound('confirmMenu'));

					if (!FlxG.keys.pressed.TAB)
					{
						var daChoice:String = optionShit[curSelected];

						switch (daChoice)
						{
							case 'freeplay':
								FlxG.sound.music.stop();
							//case 'options':
							//	FlxG.sound.music.stop();
						}

						// FlxFlicker.flicker(magenta, 1.1, 0.15, false);

						menuItems.forEach(function(spr:FlxSprite)
						{
							if (curSelected != spr.ID)
							{
								/* insira algo melhor aqui dps
									FlxTween.tween(spr, {alpha: 0}, 0.4, {
										ease: FlxEase.quadOut,
										onComplete: function(twn:FlxTween)
										{
											spr.kill();
										}
									});
								 */
							}
							else
							{
								spr.visible = true;

								switch (daChoice)
								{
									case 'story mode':
										switchState(new StoryMenuState());
										trace("Story Menu Selected");
									case 'freeplay':
										FreeplayState.startingSelection = 0;
										switchState(new FreeplayState());
										trace("Freeplay Menu Selected");
									case 'options':
										switchState(new ConfigMenu());
										trace("options time");
								}
							}
						});
					}
					else
					{
						secretFindOut(tabKeys);
						tabKeys = [];
						tabDisplay.text = Std.string(tabKeys);
						tabDisplay.visible = false;
					}
				}
			}
		}

		super.update(elapsed);
	}

	function secretFindOut(_combo:Array<String>):Void
	{
		var combo:String = "";

		for (x in _combo)
		{
			combo += x;
		}

		switch (combo)
		{
			case "BLU":
				trace('epico deu certo');
				openAlert();
				selectedSomethin = false;
			case "ENJOYEVERYTHING":
				// pra quem tiver lendo esse comentario leia yotsuba&! 
				// assinado, neon
				trace('yotsu');
				openAlert('yotsubaAlert');
				selectedSomethin = false;
			case "JOLITAAS":
				// pra quem tiver lendo esse comentario leia yotsuba&! 
				// assinado, neon
				trace('fnfolas e real');
				openAlert('qenAlert');
				selectedSomethin = false;
			default:
				trace('cade');
				selectedSomethin = false;		
		}
	}

	function openAlert(alert:String = 'oiblu') {
		if (!alertOpened) {
			alertOpened = true;
			openSubState(new AlertSubState(0, 0, alert));
		}
	}
	
	override function closeSubState()
	{
		alertOpened = false;
		super.closeSubState();
	}
	
	function changeItem(huh:Int = 0)
	{
		curSelected += huh;

		if (curSelected >= menuItems.length)
			curSelected = 0;
		if (curSelected < 0)
			curSelected = menuItems.length - 1;

		menuItems.forEach(function(spr:FlxSprite)
		{
			spr.animation.play('idle');

			if (spr.ID == curSelected)
			{
				spr.animation.play('selected');
			}

			spr.updateHitbox();
		});
	}
}
