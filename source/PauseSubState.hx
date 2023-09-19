package;

#if EXPERIMENTAL_LUA
import llua.Lua;
#end
import flixel.tweens.FlxTween;
import config.*;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.text.FlxText;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.sound.FlxSound;
import flixel.util.FlxColor;
import flixel.tweens.FlxEase;

class PauseSubState extends MusicBeatSubstate
{
	var grpMenuShit:FlxTypedGroup<Alphabet>;

	var menuItems:Array<String> = ['Resume', 'Restart Song', "Options", 'Exit to menu'];
	var curSelected:Int = 0;

	var pauseMusic:FlxSound;

	public function new(x:Float, y:Float)
	{
		super();

		openfl.Lib.current.stage.frameRate = 144;

		FlxTween.globalManager.active = false;
		
		var diffsArray:Array<String> = ["EASY", "NORMAL", "HARD"];
		
		if (PlayState.storyPlaylist.length > 1 && PlayState.isStoryMode)
		{
			menuItems.insert(2, "Skip Song");
		}

		if (!PlayState.isStoryMode)
		{
			menuItems.insert(2, "Chart Editor");
		}

		if (!PlayState.isStoryMode && PlayState.sectionStart)
		{
			menuItems.insert(1, "Restart Section");
		}

		var pauseSongName = "especulapause";
		var artist = "Dex Dousky";

		switch (PlayState.SONG.song.toLowerCase())
		{
			case "ugh" | "guns" | "stress":
				pauseSongName = "distorto";
				artist = "Kawai Sprite";
		}

		pauseMusic = new FlxSound().loadEmbedded(Paths.music(pauseSongName), true, true);

		pauseMusic.volume = 0;
		pauseMusic.play(false, FlxG.random.int(0, Std.int(pauseMusic.length / 2)));

		FlxG.sound.list.add(pauseMusic);

		var bg:FlxSprite = new FlxSprite().makeGraphic(FlxG.width, FlxG.height, FlxColor.BLACK);
		bg.alpha = 0.6;
		bg.scrollFactor.set();
		add(bg);

		// song info definers
		var levelInfo:FlxText = new FlxText(20, 15, 0, '', 32);
		levelInfo.text += PlayState.SONG.song;
		levelInfo.scrollFactor.set();
		levelInfo.setFormat(Paths.font("vcr"), 32);
		levelInfo.updateHitbox();
		add(levelInfo);

		var levelDifficulty:FlxText = new FlxText(20, 15 + 32, 0, '', 24);
		levelDifficulty.text += diffsArray[PlayState.storyDifficulty];
		levelDifficulty.scrollFactor.set();
		levelDifficulty.setFormat(Paths.font("vcr"), 24);
		levelDifficulty.updateHitbox();
		add(levelDifficulty);

		levelInfo.x = FlxG.width - (levelInfo.width + 20);
		levelDifficulty.x = FlxG.width - (levelDifficulty.width + 20);
		
		// end song info definers
		
		var musicCredit:FlxText = new FlxText(54, 12, 0, "Música do menu de pausa feita por " + artist, 18);
		musicCredit.setFormat(Paths.font("vcr"), 18, FlxColor.WHITE, CENTER);
		musicCredit.scrollFactor.set();
		musicCredit.screenCenter(X);
		add(musicCredit);
		
		grpMenuShit = new FlxTypedGroup<Alphabet>();
		add(grpMenuShit);

		for (i in 0...menuItems.length)
		{
			var songText:Alphabet = new Alphabet(0, (70 * i) + 30, menuItems[i], true, false);
			songText.isMenuItem = true;
			songText.targetY = i;
			grpMenuShit.add(songText);
		}

		changeSelection();

		cameras = [FlxG.cameras.list[FlxG.cameras.list.length - 1]];
	}

	override function update(elapsed:Float)
	{
		if (pauseMusic.volume < 0.8)
			pauseMusic.volume += 0.05 * elapsed;

		super.update(elapsed);

		var upP = controls.UP_P;
		var downP = controls.DOWN_P;
		var accepted = controls.ACCEPT;

		if (upP)
		{
			changeSelection(-1);
		}
		if (downP)
		{
			changeSelection(1);
		}

		if (accepted)
		{
			FlxTween.globalManager.active = true;

			var daSelected:String = menuItems[curSelected];

			switch (daSelected)
			{
				case "Resume":
					unpause();

				case "Restart Song":
					FlxTween.globalManager.clear();
					PlayState.instance.switchState(new PlayState());
					PlayState.sectionStart = false;

				case "Restart Section":
					FlxTween.globalManager.clear();
					PlayState.instance.switchState(new PlayState());

				case "Chart Editor":
					PlayerSettings.menuControls();
					FlxTween.globalManager.clear();
					PlayState.instance.switchState(new ChartingState());

				case "Skip Song":
					FlxTween.globalManager.clear();
					PlayState.instance.endSong();

				case "Options":
					FlxTween.globalManager.clear();
					PlayState.instance.switchState(new ConfigMenu());
					ConfigMenu.exitTo = PlayState;

				case "Exit to menu":
					FlxTween.globalManager.clear();

					PlayState.sectionStart = false;

					#if EXPERIMENTAL_LUA
					if (PlayState.lua != null)
					{
						Lua.close(PlayState.lua);
						PlayState.lua = null;
					}
					#end
					switch (PlayState.returnLocation)
					{
						case "freeplay":
							PlayState.instance.switchState(new FreeplayState());
						case "story":
							PlayState.instance.switchState(new StoryMenuState());
						default:
							PlayState.instance.switchState(new MainMenuState());
					}
			}
		}
	}

	function unpause()
	{
		if (Config.noFpsCap)
			openfl.Lib.current.stage.frameRate = 999;
		close();
	}

	override function destroy()
	{
		pauseMusic.destroy();

		super.destroy();
	}

	function changeSelection(change:Int = 0):Void
	{
		curSelected += change;

		if (curSelected < 0)
			curSelected = menuItems.length - 1;
		if (curSelected >= menuItems.length)
			curSelected = 0;

		var bullShit:Int = 0;

		for (item in grpMenuShit.members)
		{
			item.targetY = bullShit - curSelected;
			bullShit++;

			item.alpha = 0.6;
			// item.setGraphicSize(Std.int(item.width * 0.8));

			if (item.targetY == 0)
			{
				item.alpha = 1;
				// item.setGraphicSize(Std.int(item.width));
			}
		}
	}
}
