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

class MainMenuState extends MusicBeatState {
	var curSelected:Int = 0;

	var menuItems:FlxTypedGroup<FlxSprite>;

	var optionShit:Array<String> = ['story mode', 'freeplay', 'search bar', 'options'];
	var optionPosX:Array<Float> = [273, 459, 617, 930];

	var alertOpened:Bool = false;

	var versionText:FlxText;
	var keyWarning:FlxText;
	var tabDisplay:FlxText;
	var menuDesc:FlxSprite;
	var menuAwesomes:FlxSprite;

	var selectedSomethin:Bool = false;
	var tabString:String = '';
	
	override function create() {
		openfl.Lib.current.stage.frameRate = 144;

		if (!FlxG.sound.music.playing) {
			FlxG.sound.playMusic(Paths.music('coolMenu'), 1);
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

		for (i in 0...optionShit.length) {
			menuDesc.animation.addByPrefix(optionShit[i], 'desc ' + optionShit[i], 24);
		}
		menuDesc.animation.addByPrefix('search bar', 'desc secrets', 24);

		menuDesc.animation.play(optionShit[0]);
		add(menuDesc);
		menuDesc.scrollFactor.set();
		menuDesc.antialiasing = true;

		// menu art
		menuAwesomes = new FlxSprite(699, 131);
		menuAwesomes.frames = Paths.getSparrowAtlas('menu/menuAwesomes');

		for (i in 0...optionShit.length) {
			menuAwesomes.animation.addByPrefix(optionShit[i], 'menu ' + optionShit[i], 24);
		}
		menuAwesomes.animation.addByPrefix('search bar', 'menu secrets', 24);

		menuAwesomes.animation.play(optionShit[0]);
		add(menuAwesomes);
		menuAwesomes.scrollFactor.set();
		menuAwesomes.antialiasing = true;

		// end menu art and desc

		var tex = Paths.getSparrowAtlas('menu/headerStuffs');

		for (i in 0...optionShit.length) {
			var menuItem:FlxSprite = new FlxSprite(optionPosX[i], -1);
			menuItem.frames = tex;

			menuItem.animation.addByPrefix('idle', optionShit[i] + ' white', 24);
			menuItem.animation.addByPrefix('selected', optionShit[i] + ' selected', 24);
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

		versionText = new FlxText(5, FlxG.height - 21, 0, 'Vs. Espe / FPS Plus: v4.1.0-YF', 16);
		versionText.scrollFactor.set();
		versionText.setFormat('Arial', 16, 0xFF343434, LEFT);
		add(versionText);

		keyWarning = new FlxText(5, FlxG.height - 21 + 16, 0,
			'Se os controles não estiverem funcionando, tente pressionar CTRL + BACKSPACE para redefini-los.', 16);
		keyWarning.scrollFactor.set();
		keyWarning.setFormat('Arial', 16, 0xFF343434, LEFT);
		keyWarning.alpha = 0;
		add(keyWarning);

		tabDisplay = new FlxText(671, 15, 0, tabString, 20);
		tabDisplay.scrollFactor.set();
		tabDisplay.visible = false;
		tabDisplay.setFormat('Arial', 20, 0xFF000000, LEFT);
		add(tabDisplay);

		FlxTween.tween(versionText, {y: versionText.y - 16}, 0.75, {ease: FlxEase.quintOut, startDelay: 10});
		FlxTween.tween(keyWarning, {alpha: 1, y: keyWarning.y - 16}, 0.75, {ease: FlxEase.quintOut, startDelay: 10});

		// NG.core.calls.event.logEvent('swag').send();
		changeItem();

		// Offset Stuff
		Config.reload();

		super.create();
	}
	
	override function update(elapsed:Float) {
		if (FlxG.sound.music.volume < 0.8) {
			FlxG.sound.music.volume += 0.5 * FlxG.elapsed;
		}
		
		if (!selectedSomethin && !alertOpened) {
			// BARRA DE PESQUISA
			if (optionShit[curSelected] == 'search bar') {
				tabDisplay.visible = true;

				if (FlxG.keys.justPressed.ANY) {
					var directions:Array<String> = ['LEFT', 'DOWN', 'UP', 'RIGHT', 'ENTER'];
					var numberShits:Array<String> = ['ZERO', 'ONE', 'TWO', 'THREE', 'FOUR', 'FIVE', 'SIX', 'SEVEN', 'EIGHT', 'NINE'];
					var numpadShits:Array<String> = [
						'NUMPADZERO', 'NUMPADONE', 'NUMPADTWO', 'NUMPADTHREE', 'NUMPADFOUR', 'NUMPADFIVE', 'NUMPADSIX', 'NUMPADSEVEN', 'NUMPADEIGHT',
						'NUMPADNINE'
					];

					// mtos parenteses
					if (!directions.contains(FlxG.keys.getIsDown()[0].ID.toString())) {
						if (numpadShits.contains(FlxG.keys.getIsDown()[0].ID.toString()))
							tabString += Std.string(numpadShits.indexOf(FlxG.keys.getIsDown()[0].ID.toString()));
						else if (numberShits.contains(FlxG.keys.getIsDown()[0].ID.toString()))
							tabString += Std.string(numberShits.indexOf(FlxG.keys.getIsDown()[0].ID.toString()));
						else {
							if (FlxG.keys.getIsDown()[0].ID.toString() == 'BACKSPACE')
								tabString = tabString.substring(0, tabString.length - 1);
							else
								tabString += FlxG.keys.getIsDown()[0].ID.toString();
						}
					}
					tabDisplay.text = tabString;
				}
			} else {
				tabDisplay.visible = false;
			}

			// e la vamos nos com as tecnicas
			if (optionShit[curSelected] == 'search bar') {
				if (FlxG.keys.justPressed.LEFT) {
					FlxG.sound.play(Paths.sound('scrollMenu'));
					changeItem(-1);
				}

				if (FlxG.keys.justPressed.RIGHT) {
					FlxG.sound.play(Paths.sound('scrollMenu'));
					changeItem(1);
				}
				if (FlxG.keys.justPressed.ESCAPE) {
					FlxG.sound.music.stop();
					switchState(new TitleScreen());
				}
			} else {
				if (controls.LEFT_P) {
					FlxG.sound.play(Paths.sound('scrollMenu'));
					changeItem(-1);
				}

				if (controls.RIGHT_P) {
					FlxG.sound.play(Paths.sound('scrollMenu'));
					changeItem(1);
				}	
				if (controls.BACK) {
					FlxG.sound.music.stop();
					switchState(new TitleScreen());
				}
			}
			
			if (FlxG.keys.justPressed.BACKSPACE && FlxG.keys.pressed.CONTROL) {
				KeyBinds.resetBinds();
				switchState(new MainMenuState());
			}

			menuDesc.animation.play(optionShit[curSelected]);
			menuAwesomes.animation.play(optionShit[curSelected]);

			if (controls.ACCEPT) {
				FlxG.sound.play(Paths.sound('confirmMenu'));

				var daChoice:String = optionShit[curSelected];

				switch (daChoice) {
					case 'freeplay':
						FlxG.sound.music.stop();
				}

				menuItems.forEach(function(spr:FlxSprite) {
					if (curSelected != spr.ID) {
						/* insira algo melhor aqui dps
							FlxTween.tween(spr, {alpha: 0}, 0.4, {
								ease: FlxEase.quadOut,
								onComplete: function(twn:FlxTween)
								{
									spr.kill();
								}
							});
						 */
					} else {
						spr.visible = true;
						switch (daChoice) {
							case 'story mode':
								selectedSomethin = true;
								switchState(new StoryMenuState());
								trace('Story Menu Selected');
							case 'freeplay':
								selectedSomethin = true;
								FreeplayState.startingSelection = 0;
								switchState(new FreeplayState());
								trace('Freeplay Menu Selected');
							case 'options':
								selectedSomethin = true;
								switchState(new ConfigMenu());
								trace('options time');
							case 'search bar':
								trace(tabString);
								secretFindOut(tabString);
								tabString = '';
								tabDisplay.text = tabString;
						}
					}
				});
			}
		}

		super.update(elapsed);
	}

	function secretFindOut(_combo:String) {
		switch (_combo) {
			case 'BLU':
				trace('epico deu certo');
				openAlert();
				selectedSomethin = false;

			case 'FINALBUILD':
				trace('PARA de tentar OLHAR leaks do FNF: The Full Ass Game');
				openAlert('deskinned');
				selectedSomethin = false;

			case 'ENJOYEVERYTHING':
				// pra quem tiver lendo esse comentario leia yotsuba&!
				// assinado, neon
				trace('leia yotsubato');
				openAlert('yotsubaAlert');
				selectedSomethin = false;

			case 'JOLITAAS':
				// queixones e narigoles
				trace('fnfolas e real');
				openAlert('qenAlert');
				selectedSomethin = false;

			case '595313131313131':
				// lmfao
				trace('ufs referencia detected');
				openAlert('ultUnlock');
				selectedSomethin = false;

			// SOPA CLICKERS
			// sopa clicker 1
			case 'SOPACLICKER':
				trace('soup time');
				SopaClickerState.versao = 1;
				SopaClickerState.trolagem = false;
				switchState(new SopaClickerState());
				selectedSomethin = true;

			// sopa clicker 2 (fake)
			case 'SOPACLICKER2':
				trace('soup time 2 fake');
				SopaClickerState.versao = 2;
				SopaClickerState.trolagem = true;
				switchState(new SopaClickerState());
				selectedSomethin = true;

			// sopa clicker 2 dlc tom
			case 'SOPACLICKER2DLCTOM':
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

	function openAlert(alert:String = 'oiblu') {
		if (!alertOpened) {
			alertOpened = true;
			openSubState(new AlertSubState(0, 0, alert));
		}
	}

	override function closeSubState() {
		alertOpened = false;
		super.closeSubState();
	}

	function changeItem(huh:Int = 0) {
		curSelected += huh;

		if (curSelected >= menuItems.length)
			curSelected = 0;
		if (curSelected < 0)
			curSelected = menuItems.length - 1;

		menuItems.forEach(function(spr:FlxSprite) {
			spr.animation.play('idle');

			if (spr.ID == curSelected) {
				spr.animation.play('selected');
			}

			spr.updateHitbox();
		});
	}
}