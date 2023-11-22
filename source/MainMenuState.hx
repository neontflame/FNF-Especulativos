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
	var menuDesc:FlxSprite;
	var menuAwesomes:FlxSprite;

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

		// start menu art and desc
		// menu description
		menuDesc = new FlxSprite(59, 131);
		menuDesc.frames = Paths.getSparrowAtlas('menu/menuDescs');

		for (i in 0...optionShit.length)
		{
			menuDesc.animation.addByPrefix(optionShit[i], "desc " + optionShit[i], 24);
		}
		menuDesc.animation.addByPrefix('secrets', "desc secrets", 24);

		menuDesc.animation.play(optionShit[0]);
		add(menuDesc);
		menuDesc.scrollFactor.set();
		menuDesc.antialiasing = true;

		// menu art
		menuAwesomes = new FlxSprite(699, 131);
		menuAwesomes.frames = Paths.getSparrowAtlas('menu/menuAwesomes');

		for (i in 0...optionShit.length)
		{
			menuAwesomes.animation.addByPrefix(optionShit[i], "menu " + optionShit[i], 24);
		}
		menuAwesomes.animation.addByPrefix('secrets', "menu secrets", 24);

		menuAwesomes.animation.play(optionShit[0]);
		add(menuAwesomes);
		menuAwesomes.scrollFactor.set();
		menuAwesomes.antialiasing = true;

		// end menu art and desc

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

		versionText = new FlxText(5, FlxG.height - 21, 0, "Vs. Espe / FPS Plus: v4.1.0-YF", 16);
		versionText.scrollFactor.set();
		versionText.setFormat("Arial", 16, 0xFF343434, LEFT);
		add(versionText);

		keyWarning = new FlxText(5, FlxG.height - 21 + 16, 0,
			"Se os controles não estiverem funcionando, tente pressionar CTRL + BACKSPACE para redefini-los.", 16);
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
				menuDesc.animation.play('secrets');
				menuAwesomes.animation.play('secrets');

				tabDisplay.visible = true;

				if (FlxG.keys.justPressed.ANY)
				{
					if (FlxG.keys.getIsDown()[0].ID.toString() != "TAB")
					{
						var numberShits:Array<String> = ["ZERO", "ONE", "TWO", "THREE", "FOUR", "FIVE", "SIX", "SEVEN", "EIGHT", "NINE"];
						var numpadShits:Array<String> = [
							"NUMPADZERO", "NUMPADONE", "NUMPADTWO", "NUMPADTHREE", "NUMPADFOUR", "NUMPADFIVE", "NUMPADSIX", "NUMPADSEVEN", "NUMPADEIGHT",
							"NUMPADNINE"
						];

						// mtos parenteses
						if (numpadShits.contains(FlxG.keys.getIsDown()[0].ID.toString()))
						{
							tabKeys.push(Std.string(numpadShits.indexOf(FlxG.keys.getIsDown()[0].ID.toString())));
						}
						else if (numberShits.contains(FlxG.keys.getIsDown()[0].ID.toString()))
						{
							tabKeys.push(Std.string(numberShits.indexOf(FlxG.keys.getIsDown()[0].ID.toString())));
						}
						else
						{
							if (FlxG.keys.getIsDown()[0].ID.toString() == "BACKSPACE")
								tabKeys.pop();
							else
								tabKeys.push(FlxG.keys.getIsDown()[0].ID.toString());
						}

						tabDisplay.text = Std.string(tabKeys);
					}
				}
			}
			else
			{
				menuDesc.animation.play(optionShit[curSelected]);
				menuAwesomes.animation.play(optionShit[curSelected]);

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
								// case 'options':
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
				
			case "FINALBUILD":
				trace('PARA de tentar OLHAR leaks do FNF: The Full Ass Game');
				openAlert('deskinned');
				selectedSomethin = false;
				
			case "ENJOYEVERYTHING":
				// pra quem tiver lendo esse comentario leia yotsuba&!
				// assinado, neon
				trace('leia yotsubato');
				openAlert('yotsubaAlert');
				selectedSomethin = false;
				
			case "JOLITAAS":
				// queixones e narigoles
				trace('fnfolas e real');
				openAlert('qenAlert');
				selectedSomethin = false;
				
			case "595313131313131":
				// lmfao
				trace('ufs referencia detected');
				openAlert('ultUnlock');
				selectedSomethin = false;
				
			// SOPA CLICKERS
			// sopa clicker 1
			case "SOPACLICKER":
				trace('soup time');
				SopaClickerState.versao = 1;
				SopaClickerState.trolagem = false;
				switchState(new SopaClickerState());
				selectedSomethin = true;
			
			// sopa clicker 2 (fake)
			case "SOPACLICKER2":
				trace('soup time 2 fake');
				SopaClickerState.versao = 2;
				SopaClickerState.trolagem = true;
				switchState(new SopaClickerState());
				selectedSomethin = true;
				
			// sopa clicker 2 dlc tom
			case "SOPACLICKER2DLCTOM":
				trace('soup time 2 real');
				SopaClickerState.versao = 2;
				SopaClickerState.trolagem = false;
				switchState(new SopaClickerState());
				selectedSomethin = true;
			default:
				trace('cade');
				selectedSomethin = false;
		}
	}

	function openAlert(alert:String = 'oiblu')
	{
		if (!alertOpened)
		{
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
