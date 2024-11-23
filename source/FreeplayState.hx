package;

import flash.text.TextField;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxSubState;
import flixel.addons.display.FlxGridOverlay;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.math.FlxMath;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import lime.utils.Assets;
import openfl.utils.Assets as OpenFlAssets;
import CoolUtil;
import usefulshits.ProjectSprite;

using StringTools;

class FreeplayState extends MusicBeatState
{
	var songs:Array<SongMetadata> = [];

	public static var startingSelection:Int = 0;

	var selector:FlxText;
	var projCounter:FlxText;
	var headerSelected:FlxSprite;

	public static var curSelected:Int = 0;
	public static var curSelectedVertical:Int = 1;
	static var curDifficulty:Int = 1;

	public static var curLimit:Int = 0;

	var missingShit:Bool = false;
	var playStateAnyways:Bool = false;
	
	var scoreText:FlxText;
	var lerpScore:Int = 0;
	var intendedScore:Int = 0;

	private var grpSongs:FlxTypedGroup<ProjectSprite>;
	private var curPlaying:Bool = false;

	public static final songsWithNoDiff:Array<String> = ["Hihi", "Tres-Bofetadas", "Dragons", "Do-Mal", "Street-Musician", "fnfolas", "Big-Bus", "so-um-cara"];
	
	override function create()
	{
		openfl.Lib.current.stage.frameRate = 144;

		curSelected = 0;
		
		if (curSelected == 0)
			curLimit = 0;

		if (CoolUtil.exists("assets/images/week1")) {
			addWeek(['Tutorial'], 1, ['gf-menu']);
			addWeek(['Bopeebo', 'Fresh', 'Dadbattle'], 1, ['dad']);
		}

		if (CoolUtil.exists("assets/images/week2"))
			addWeek(['Spookeez', 'South', 'Monster'], 2, ['spooky', 'spooky', "monster"]);

		if (CoolUtil.exists("assets/images/week3"))
			addWeek(['Pico', 'Philly', 'Blammed'], 3, ['pico']);

		if (CoolUtil.exists("assets/images/week4"))
			addWeek(['Satin-Panties', 'High', 'Milf'], 4, ['mom']);

		if (CoolUtil.exists("assets/images/week5"))
			addWeek(['Cocoa', 'Eggnog', 'Winter-Horrorland'], 5, ['parents', 'parents', 'monster']);

		if (CoolUtil.exists("assets/images/week6"))
			addWeek(['Senpai', 'Roses', 'Thorns'], 6, ['senpai', 'senpai-angry', 'spirit']);

		if (CoolUtil.exists("assets/images/week7"))
			addWeek(['Ugh', 'Guns', 'Stress'], 7, ['tankman']);

		// eu quero ver quem q vai ser o louco q vai deixar o mod absolutamente vazio sem Nada
		if (CoolUtil.exists("assets/images/especula"))
			addWeek(['Hihi', 'Tres-Bofetadas', 'Dragons'], 8, ['espe', 'espe', 'dave']);

		if (CoolUtil.exists("assets/images/scdm"))
			addWeek(['Do-Mal'], 9, ['scdm']);

		/* if (FlxG.save.data.ee2 && Startup.hasEe2)
			{
				addWeek(['Lil-Buddies'], 1, ['face-lil']);
			} 
		 */
		SaveManager.modSpecific();
		
		if (FlxG.save.data.yotsubaUnlock && Startup.hasYotsu && CoolUtil.exists("assets/images/yotsu"))
			addWeek(['Street-Musician'], 10, ['yotsuba']);

		if (FlxG.save.data.qenUnlock && Startup.hasQeN && CoolUtil.exists("assets/images/qen"))
			addWeek(['fnfolas', 'Big-Bus'], 11, ['qen', 'maujoa']);
		
		SaveManager.close();
		
		if (Main.salsicha && CoolUtil.exists("assets/images/salsicha"))
			addWeek(['so-um-cara'], 12, ['hawnt-salsicha']);
			
		#if EXPERIMENTAL_MODDING
		var freeplaySongtxt:String = CoolUtil.getText(Paths.text("freeplaySonglist"));
		var freeplaySonglist:Array<String> = freeplaySongtxt.split(';');
		var extraShitWeek:Array<String> = [];
		
		for (song in freeplaySonglist)
		{
				extraShitWeek.push(song);
		}
		trace(extraShitWeek);
		
		addWeek(extraShitWeek, 13, ['face']);
		#end
			
		// bagulhos de UI coisa xd!!
		var bg:FlxSprite = new FlxSprite().loadGraphic(Paths.image('menu/scratchBG'));
		add(bg);

		var longerMenuThing:FlxSprite = new FlxSprite(36, 233).loadGraphic(Paths.image('menu/freeplay/longerMenuThing'));
		add(longerMenuThing);

		projCounter = new FlxText(54, 241, 0, "", 26);
		projCounter.setFormat(Paths.font("arialbd"), 26, 0xFF333333, LEFT);
		add(projCounter);

		grpSongs = new FlxTypedGroup<ProjectSprite>();
		add(grpSongs);

		for (i in 0...songs.length)
		{
			var songProj:ProjectSprite = new ProjectSprite((70 * i) + 92, 304, 'menu/freeplay/songs/' + songs[i].songName.toLowerCase());
			songProj.isMenuItem = true;
			songProj.targetX = i;
			grpSongs.add(songProj);
		}

		scoreText = new FlxText(FlxG.width * 0.5, 14, 0, "", 24);
		// scoreText.autoSize = true;
		scoreText.setFormat(Paths.font("arial"), 24, FlxColor.WHITE, CENTER);
		// scoreText.alignment = RIGHT;

		var headerBG:FlxSprite = new FlxSprite(-19, -1).makeGraphic(1313, 59, 0xFF0F8BC0);
		headerBG.updateHitbox();
		add(headerBG);

		headerSelected = new FlxSprite(0, -1).makeGraphic(1280, 59, 0xFF0F668C);
		headerSelected.updateHitbox();
		add(headerSelected);

		add(scoreText);

		changeSelection(startingSelection);
		changeVerticalSelection();
		changeDiff();

		if (!FlxG.sound.music.playing && !Startup.songsCacheActive) {
			FlxG.sound.playMusic(Paths.music('coolMenu'), 1);
		}
		
		// FlxG.sound.playMusic(Paths.music('title'), 0);
		// FlxG.sound.music.fadeIn(2, 0, 0.8);
		selector = new FlxText();

		selector.size = 40;
		selector.text = ">";
		// add(selector);
		// JUST DOIN THIS SHIT FOR TESTING!!!
		/* 
			var md:String = Markdown.markdownToHtml(CoolUtil.getText('CHANGELOG.md'));
			var texFel:TextField = new TextField();
			texFel.width = FlxG.width;
			texFel.height = FlxG.height;
			// texFel.
			texFel.htmlText = md;
			FlxG.stage.addChild(texFel);
			// scoreText.textField.htmlText = md;
			trace(md);
		 */

		super.create();
	}

	public function addSong(songName:String, weekNum:Int, songCharacter:String)
	{
		if (CoolUtil.exists("assets/data/" + songName) || OpenFlAssets.exists("assets/data/" + songName))
		{
			songs.push(new SongMetadata(songName, weekNum, songCharacter));
		}
	}

	public function addWeek(songs:Array<String>, weekNum:Int, ?songCharacters:Array<String>)
	{
		if (songCharacters == null)
			songCharacters = ['bf'];

		var num:Int = 0;
		for (song in songs)
		{
			addSong(song, weekNum, songCharacters[num]);

			if (songCharacters.length != 1)
				num++;
		}
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);

		lerpScore = Math.floor(FlxMath.lerp(lerpScore, intendedScore, 0.4));

		if (Math.abs(lerpScore - intendedScore) <= 10)
			lerpScore = intendedScore;

		if (songsWithNoDiff.contains(songs[curSelected].songName)) {
			scoreText.text = "Melhor pontuação: " + lerpScore;
		} else {
			scoreText.text = "Melhor pontuação: "
				+ lerpScore
				+ "   //   Dificuldade: "
				+ (curDifficulty == 0 ? 'Fácil' : curDifficulty == 2 ? 'Difícil' : 'Normal');
		}
		
		scoreText.screenCenter(X);

		if (headerSelected.width != scoreText.width + 32)
		{
			headerSelected.makeGraphic(Math.floor(scoreText.width + 32), 59, 0xFF0F668C);
			headerSelected.width = scoreText.width + 32;
		}

		headerSelected.screenCenter(X);

		if (projCounter.text == "")
			projCounter.text = "Músicas compartilhadas (" + songs.length + ")";

		var leftP = controls.LEFT_P;
		var rightP = controls.RIGHT_P;
		var accepted = controls.ACCEPT;

		if (controls.UP_P)
			changeVerticalSelection(-1);
		if (controls.DOWN_P)
			changeVerticalSelection(1);

		if (curSelectedVertical == 1)
		{
			headerSelected.visible = false;

			if (leftP)
			{
				changeSelection(-1);
				changeDiff(0);
			}
			if (rightP)
			{
				changeSelection(1);
				changeDiff(0);
			}
		}
		else
		{
			headerSelected.visible = true;

			if (leftP)
				changeDiff(-1);
			if (rightP)
				changeDiff(1);
		}

		if (controls.BACK)
		{
			if (FlxG.sound.music.playing && Startup.songsCacheActive) {
			FlxG.sound.music.stop();
			}
			FlxG.sound.play(Paths.sound('cancelMenu'));
			switchState(new MainMenuState());
		}

		if (accepted)
		{
				if (CoolUtil.chartExists(songs[curSelected].songName.toLowerCase(), curDifficulty))
				{
					// hell yeah lets song
					var poop:String = Highscore.formatSong(songs[curSelected].songName.toLowerCase(), curDifficulty);

					PlayState.SONG = Song.loadFromJson(poop, songs[curSelected].songName.toLowerCase());
					PlayState.isStoryMode = false;
					PlayState.storyDifficulty = curDifficulty;
					PlayState.loadEvents = true;
					startingSelection = curSelected;
					PlayState.returnLocation = "freeplay";
					PlayState.storyWeek = songs[curSelected].week;
					trace('CUR WEEK' + PlayState.storyWeek);

					if (CoolUtil.weekGfxWork(songs[curSelected].week)) {
						switchState(new PlayState());
						
						if (FlxG.sound.music != null)
						FlxG.sound.music.stop();
					} else {
						playStateAnyways = true;
						openAlert();
					}
				}
				else
				{
					// no song
					openAlert("vaiNoNormalFdp");
				}
			}
	}

	function changeDiff(change:Int = 0)
	{
		curDifficulty += change;

		if (curDifficulty < 0)
			curDifficulty = 2;
		if (curDifficulty > 2)
			curDifficulty = 0;
		
		if (songs[curSelected].songName == "Lil-Buddies")
		{
			curDifficulty = 2;
		}
		
		if (songsWithNoDiff.contains(songs[curSelected].songName))
		{
			curDifficulty = 1;
		}

		#if !switch
		intendedScore = Highscore.getScore(songs[curSelected].songName, curDifficulty);
		#end

		switch (curDifficulty)
		{
			case 0:
			//	diffText.text = "EASY";
			case 1:
			//	diffText.text = 'NORMAL';
			case 2:
				//	diffText.text = "HARD";
		}
	}

	function changeSelection(change:Int = 0)
	{
		FlxG.sound.play(Paths.sound('scrollMenu'), 0.4);

		curSelected += change;
		curLimit += change;

		if (curLimit > 4)
			curLimit = 4;
		if (curLimit < 0)
			curLimit = 0;

		if (curSelected < 0)
		{
			curSelected = songs.length - 1;
			curLimit = 4;
		}

		if (curSelected >= songs.length)
		{
			curSelected = 0;
			curLimit = 0;
		}

		// selector.y = (70 * curSelected) + 30;

		#if !switch
		intendedScore = Highscore.getScore(songs[curSelected].songName, curDifficulty);
		// lerpScore = 0;
		#end

		if (Startup.songsCacheActive) {
			FlxG.sound.playMusic(Paths.inst(songs[curSelected].songName), 0);
			FlxG.sound.music.fadeIn(1, 0, 0.8);
		}
		
		var bullShit:Int = 0;

		for (item in grpSongs.members)
		{
			item.targetX = bullShit - curSelected + curLimit;
			bullShit++;

			// mais codigo quase ilegivel mas tudo bem nos bolamos
			// nvm o codigo nao e mais ilegivel
			if (item.targetX >= 5 || item.targetX <= -1)
			{
				item.alpha = 0;
			}
			else
			{
				item.alpha = 0.6;
			}
			// item.setGraphicSize(Std.int(item.width * 0.8));

			if (item.targetX == 0 + curLimit)
			{
				item.alpha = 1;
				// item.setGraphicSize(Std.int(item.width));
			}
		}
	}

	function changeVerticalSelection(change:Int = 0)
	{
		FlxG.sound.play(Paths.sound('scrollMenu'), 0.4);

		curSelectedVertical += change;

		if (curSelectedVertical < 0)
		{
			curSelectedVertical = 1;
		}

		if (curSelectedVertical > 1)
		{
			curSelectedVertical = 0;
		}

		// uhhhhhhhhhhhhhhhh
		for (item in grpSongs.members)
		{
			if (item.targetX >= 5 || item.targetX <= -1)
			{
				item.alpha = 0;
			}
			else
			{
				item.alpha = 0.4 + (curSelectedVertical * 0.2);
			}
			// item.setGraphicSize(Std.int(item.width * 0.8));

			if (item.targetX == 0 + curLimit)
			{
				item.alpha = 0.9 + (curSelectedVertical * 0.1);
				// item.setGraphicSize(Std.int(item.width));
			}
		}
	}

	function openAlert(alert:String = 'missinShit')
	{
		// eu nao vou copiar esse codigo 500 vezes nao
		FlxG.sound.play(Paths.sound('cancelMenu'));

		if (!missingShit)
		{
			missingShit = true;
			openSubState(new AlertSubState(0, 0, alert));
		}
	}

	override function closeSubState()
	{
		missingShit = false;
		super.closeSubState();
		
		if (playStateAnyways) {
			switchState(new PlayState());
						
			if (FlxG.sound.music != null)
			FlxG.sound.music.stop();
		}
	}
}

class SongMetadata
{
	public var songName:String = "";
	public var week:Int = 0;
	public var songCharacter:String = "";

	public function new(song:String, week:Int, songCharacter:String)
	{
		this.songName = song;
		this.week = week;
		this.songCharacter = songCharacter;
	}
}
