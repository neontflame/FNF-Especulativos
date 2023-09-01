package;

import title.*;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.group.FlxGroup;
import flixel.math.FlxMath;
import flixel.text.FlxText;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;
import lime.net.curl.CURLCode;
import usefulshits.ProjectSprite;

using StringTools;

class StoryMenuState extends MusicBeatState
{
	var scoreText:FlxText;

	public static var weekData:Array<Dynamic>;

	var curDifficulty:Int = 1;

	public static var weekUnlocked:Array<Bool> = [
		true, true, true, true, true, true, true, true, true, true, true, true, true, true
	];

	public static var weekCharacters:Array<Dynamic>;

	public static var weekNames:Array<String>;

	var txtWeekTitle:FlxText;

	var curWeek:Int = 0;

	var txtTracklist:FlxText;

	var grpWeekText:FlxTypedGroup<MenuItem>;
	var grpProjectShits:FlxTypedGroup<ProjectSprite>;
	var grpLocks:FlxTypedGroup<FlxSprite>;

	var ui_tex:FlxAtlasFrames;

	var sprDifficulty:FlxSprite;

	override function create()
	{
		openfl.Lib.current.stage.frameRate = 144;

		weekData = [
			['tutorial'],
			['bopeebo', 'fresh', 'dadbattle'],
			['spookeez', 'south', 'monster'],
			['pico', 'philly', "blammed"],
			['satin-panties', "high", "milf"],
			['cocoa', 'eggnog', 'winter-horrorland'],
			['senpai', 'roses', 'thorns'],
			['ugh', 'guns', 'stress']
		];

		weekCharacters = [
			['dad', 'bf', 'gf'],
			['dad', 'bf', 'gf'],
			['spooky', 'bf', 'gf'],
			['pico', 'bf', 'gf'],
			['mom', 'bf', 'gf'],
			['parents-christmas', 'bf', 'gf'],
			['senpai', 'bf', 'gf'],
			['tankman', 'bf', 'gf']
		];

		weekNames = CoolUtil.coolTextFile(Paths.text("weekNames"));

		if (FlxG.sound.music == null)
		{
			FlxG.sound.playMusic(Paths.music("coolMenu"), 1);
		}

		persistentUpdate = persistentDraw = true;

		scoreText = new FlxText(994, 165, 0, "SCORE: 49324858", 12);
		scoreText.setFormat(Paths.font("arialbd"), 12, 0xFF333333);

		txtWeekTitle = new FlxText(424, 115, 0, "", 28);
		txtWeekTitle.setFormat(Paths.font("arialbd"), 28, 0xFF333333);

		var rankText:FlxText = new FlxText(0, 10);
		rankText.text = 'RANK: GREAT';
		rankText.setFormat(Paths.font("vcr"), 32);
		rankText.size = scoreText.size;
		rankText.screenCenter(X);

		ui_tex = Paths.getSparrowAtlas('menu/story/campaign_menu_UI_assets');
		var bgForStory:FlxSprite = new FlxSprite(126, 215).loadGraphic(Paths.image("menu/story/bgStory"));
		var storyMenuThing:FlxSprite = new FlxSprite(409, 108).loadGraphic(Paths.image("menu/story/storyMenuThing"));
		
		add(bgForStory);
		add(storyMenuThing);
		
		grpWeekText = new FlxTypedGroup<MenuItem>();
		add(grpWeekText);

		grpProjectShits = new FlxTypedGroup<ProjectSprite>();
		add(grpProjectShits);
		
		grpLocks = new FlxTypedGroup<FlxSprite>();
		add(grpLocks);

		trace("Line 114");

		for (i in 0...weekData.length)
		{
			var weekThing:MenuItem = new MenuItem(143, 228, i);
			weekThing.y += (188 * i);
			weekThing.targetY = i;
			grpWeekText.add(weekThing);

			weekThing.antialiasing = true;
			// weekThing.updateHitbox();

			// Needs an offset thingie
			if (!weekUnlocked[i])
			{
				var lock:FlxSprite = new FlxSprite(weekThing.x - 32);
				lock.frames = ui_tex;
				lock.animation.addByPrefix('lock', 'lock');
				lock.animation.play('lock');
				lock.ID = i;
				lock.antialiasing = true;
				grpLocks.add(lock);
			}
		}

		trace("Line 140");

		trace("Line 173");

		sprDifficulty = new FlxSprite(959, 123);
		sprDifficulty.frames = Paths.getSparrowAtlas('menu/story/diffs');
		sprDifficulty.animation.addByPrefix('easy', 'facil');
		sprDifficulty.animation.addByPrefix('normal', 'normal');
		sprDifficulty.animation.addByPrefix('hard', 'dificil');
		sprDifficulty.animation.play('easy');
		changeDifficulty();

		add(sprDifficulty);

		trace("Line 199");

		txtTracklist = new FlxText(FlxG.width * 0.05, storyMenuThing.x + storyMenuThing.height + 100, 0, "Tracks", 32);
		txtTracklist.alignment = CENTER;
		txtTracklist.font = rankText.font;
		txtTracklist.color = 0xFFe55777;
		add(txtTracklist);
		// add(rankText);
		add(scoreText);
		add(txtWeekTitle);

		updateText();

		trace("Line 215");
		
		changeWeek();
		super.create();
	}

	override function update(elapsed:Float)
	{
		// scoreText.setFormat('VCR OSD Mono', 32);
		lerpScore = Math.floor(FlxMath.lerp(lerpScore, intendedScore, 0.5));

		scoreText.text = "( Pontuação: " + lerpScore + " )";

		txtWeekTitle.text = weekNames[curWeek];

		// FlxG.watch.addQuick('font', scoreText.font);

		grpLocks.forEach(function(lock:FlxSprite)
		{
			lock.y = grpWeekText.members[lock.ID].y;
		});

		if (!movedBack)
		{
			if (!selectedWeek)
			{
				if (controls.UP_P)
				{
					changeWeek(-1);
				}

				if (controls.DOWN_P)
				{
					changeWeek(1);
				}

				if (controls.RIGHT_P)
					changeDifficulty(1);
				if (controls.LEFT_P)
					changeDifficulty(-1);
			}

			if (controls.ACCEPT)
			{
				selectWeek();
			}
		}

		if (controls.BACK && !movedBack && !selectedWeek)
		{
			FlxG.sound.play(Paths.sound('cancelMenu'));
			movedBack = true;
			switchState(new MainMenuState());
		}

		super.update(elapsed);
	}

	var movedBack:Bool = false;
	var selectedWeek:Bool = false;
	var stopspamming:Bool = false;

	function selectWeek()
	{
		if (weekUnlocked[curWeek])
		{
			if (stopspamming == false)
			{
				FlxG.sound.play(Paths.sound('confirmMenu'));

				// grpWeekText.members[curWeek].startFlashing();
				stopspamming = true;
			}

			PlayState.storyPlaylist = weekData[curWeek];
			PlayState.isStoryMode = true;
			selectedWeek = true;

			var diffic = "";

			switch (curDifficulty)
			{
				case 0:
					diffic = '-easy';
				case 2:
					diffic = '-hard';
			}

			PlayState.storyDifficulty = curDifficulty;

			PlayState.SONG = Song.loadFromJson(PlayState.storyPlaylist[0].toLowerCase() + diffic, PlayState.storyPlaylist[0].toLowerCase());
			PlayState.storyWeek = curWeek;
			PlayState.returnLocation = "main";
			PlayState.campaignScore = 0;
			new FlxTimer().start(1, function(tmr:FlxTimer)
			{
				if (FlxG.sound.music != null)
					FlxG.sound.music.stop();
				PlayState.loadEvents = true;
				switchState(new PlayState());
			});
		}
	}

	function changeDifficulty(change:Int = 0):Void
	{
		curDifficulty += change;

		if (curDifficulty < 0)
			curDifficulty = 2;
		if (curDifficulty > 2)
			curDifficulty = 0;

		sprDifficulty.offset.x = 0;

		switch (curDifficulty)
		{
			case 0:
				sprDifficulty.animation.play('easy');
			case 1:
				sprDifficulty.animation.play('normal');
			case 2:
				sprDifficulty.animation.play('hard');
		}

		intendedScore = Highscore.getWeekScore(curWeek, curDifficulty);

		#if !switch
		intendedScore = Highscore.getWeekScore(curWeek, curDifficulty);
		#end
	}

	var lerpScore:Int = 0;
	var intendedScore:Int = 0;

	function changeWeek(change:Int = 0):Void
	{
		curWeek += change;

		if (curWeek >= weekData.length)
			curWeek = 0;
		if (curWeek < 0)
			curWeek = weekData.length - 1;

		sprDifficulty.frames = Paths.getSparrowAtlas('menu/story/diffs');
		sprDifficulty.animation.addByPrefix('easy', 'facil');
		sprDifficulty.animation.addByPrefix('normal', 'normal');
		sprDifficulty.animation.addByPrefix('hard', 'dificil');
		changeDifficulty();

		var bullShit:Int = 0;

		for (item in grpWeekText.members)
		{
			item.targetY = bullShit - curWeek;
			if (item.targetY == Std.int(0) && weekUnlocked[curWeek])
				item.visible = true;
			else
				item.visible = false;
			bullShit++;
		}

		FlxG.sound.play(Paths.sound('scrollMenu'));

		updateText();
	}

	function updateText()
	{

		txtTracklist.text = "Tracks\n";

		var stringThing:Array<String> = weekData[curWeek];
		grpProjectShits.clear();
		
		for (i in stringThing)
		{
			txtTracklist.text += "\n" + i;
			
			var bosta:ProjectSprite = new ProjectSprite(438 + (216 * stringThing.indexOf(i)), 204, "menu/freeplay/songs/" + i);
			grpProjectShits.add(bosta);
		}

		txtTracklist.text += "\n";

		txtTracklist.text = txtTracklist.text.toUpperCase();

		txtTracklist.screenCenter(X);
		txtTracklist.x -= FlxG.width * 0.35;

		#if !switch
		intendedScore = Highscore.getWeekScore(curWeek, curDifficulty);
		#end
	}
}