package;

#if sys
import sys.FileSystem;
#end
#if EXPERIMENTAL_LUA
import openfl.geom.Matrix;
import openfl.display.BitmapData;
import lime.app.Application;
#end
import config.*;
import title.*;
import transition.data.*;
import stages.*;
import stages.elements.*;
import flixel.math.FlxAngle;
import flixel.group.FlxGroup;
import lime.utils.Assets;
import flixel.math.FlxRect;
#if sys
import openfl.system.System;
#end
import openfl.ui.KeyLocation;
import flixel.input.keyboard.FlxKey;
import openfl.ui.Keyboard;
import openfl.events.KeyboardEvent;
// import polymod.fs.SysFileSystem;
import Section.SwagSection;
import Song.SwagSong;
import Song.SongEvents;
// import WiggleEffect.WiggleEffectType;
// import flixel.FlxBasic;
import flixel.FlxCamera;
import flixel.FlxG;
// import flixel.FlxGame;
import flixel.FlxBasic;
import flixel.FlxObject;
import flixel.FlxSprite;
// import flixel.FlxState;
import flixel.FlxSubState;
// import flixel.addons.display.FlxGridOverlay;
import flixel.addons.effects.FlxTrail;
// import flixel.addons.effects.FlxTrailArea;
// import flixel.addons.effects.chainable.FlxEffectSprite;
import flixel.addons.effects.chainable.FlxWaveEffect;
import flixel.addons.transition.FlxTransitionableState;
// import flixel.graphics.atlas.FlxAtlas;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.math.FlxMath;
import flixel.math.FlxPoint;
// import flixel.math.FlxRect;
import flixel.sound.FlxSound;
import flixel.text.FlxText;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.ui.FlxBar;
// import flixel.util.FlxCollision;
import flixel.util.FlxColor;
import flixel.util.FlxSort;
// import flixel.util.FlxStringUtil;
import flixel.util.FlxTimer;
import usefulshits.SwagStrum;

// import haxe.Json;
// import lime.utils.Assets;
// import openfl.display.BlendMode;
// import openfl.display.StageQuality;
// import openfl.filters.ShaderFilter;
using StringTools;

class PlayState extends MusicBeatState
{
	public static var instance:PlayState = null;

	public static var curStage:String = '';
	public static var curUiType:String = '';
	public static var SONG:SwagSong;
	public static var EVENTS:SongEvents;
	public static var loadEvents:Bool = true;
	public static var isStoryMode:Bool = false;
	public static var storyWeek:Int = 0;
	public static var storyPlaylist:Array<String> = [];
	public static var storyDifficulty:Int = 1;
	public static var fromChartEditor:Bool = false;

	public static var returnLocation:String = "main";
	public static var returnSong:Int = 0;

	private var canHit:Bool = false;
	// private var noMissCount:Int = 0;
	private var missTime:Float = 0;

	private var invuln:Bool = false;
	// private var invulnCount:Int = 0;
	private var invulnTime:Float = 0;

	private var releaseTimes:Array<Float> = [-1, -1, -1, -1];
	private final releaseBufferTime = (2 / 60);

	public static final stageSongs = ["tutorial", "bopeebo", "fresh", "dadbattle"]; // List isn't really used since stage is default, but whatever.
	public static final spookySongs = ["spookeez", "south", "monster"];
	public static final phillySongs = ["pico", "philly", "blammed"];
	public static final limoSongs = ["satin-panties", "high", "milf"];
	public static final mallSongs = ["cocoa", "eggnog"];
	public static final evilMallSongs = ["winter-horrorland"];
	public static final schoolSongs = ["senpai", "roses"];
	public static final schoolScared = ["roses"];
	public static final evilSchoolSongs = ["thorns"];
	public static final pixelSongs = ["senpai", "roses", "thorns"];
	public static final tankSongs = ["ugh", "guns", "stress"];

	public static final scratchSongs = ["hihi", "tres-bofetadas", "dragons", "do-mal"];
	public static final qenSongs = ["fnfolas"];
	
	// gimmicky shit
	public static final marcoballGimmickSongs = ["marcoball-gimmick-test"];

	private var marcoHealth:Float = 0;

	private var camFocus:String = "";
	private var camTween:FlxTween;
	private var camZoomTween:FlxTween;
	private var uiZoomTween:FlxTween;
	private var camFollow:FlxObject;
	private var autoCam:Bool = true;
	private var autoZoom:Bool = true;
	private var autoUi:Bool = true;

	private var bopSpeed:Int = 1;

	private var sectionHasOppNotes:Bool = false;
	private var sectionHasBFNotes:Bool = false;
	private var sectionHaveNotes:Array<Array<Bool>> = [];

	private var vocals:FlxSound;

	public var dad:Character;
	public var gf:Character;
	public var boyfriend:Character;

	// Wacky input stuff=========================
	// private var skipListener:Bool = false;
	private var upTime:Int = 0;
	private var downTime:Int = 0;
	private var leftTime:Int = 0;
	private var rightTime:Int = 0;

	private var upPress:Bool = false;
	private var downPress:Bool = false;
	private var leftPress:Bool = false;
	private var rightPress:Bool = false;

	private var upRelease:Bool = false;
	private var downRelease:Bool = false;
	private var leftRelease:Bool = false;
	private var rightRelease:Bool = false;

	private var upHold:Bool = false;
	private var downHold:Bool = false;
	private var leftHold:Bool = false;
	private var rightHold:Bool = false;

	// End of wacky input stuff===================
	private var autoplay:Bool = false;
	private var usedAutoplay:Bool = false;

	public var notes:FlxTypedGroup<Note>;

	private var unspawnNotes:Array<Note> = [];

	public var strumLine:FlxSprite;

	private var curSection:Int = 0;

	private static var prevCamFollow:FlxObject;

	public static var strumLineNotes:FlxTypedGroup<SwagStrum> = null;
	public static var playerStrums:FlxTypedGroup<SwagStrum> = null;
	public static var enemyStrums:FlxTypedGroup<SwagStrum> = null;
	
	private var camZooming:Bool = true;
	private var curSong:String = "";

	private var health:Float = 1;
	private var healthLerp:Float = 1;

	private var combo:Int = 0;
	private var misses:Int = 0;
	private var comboBreaks:Int = 0;
	private var accuracy:Float = 0.00;
	private var totalNotesHit:Float = 0;
	private var totalPlayed:Int = 0;
	private var sicks:Int = 0;
	private var goods:Int = 0;
	private var bads:Int = 0;
	private var shits:Int = 0;
	private var textRating:String = '?';

	private var healthBarBG:FlxSprite;
	private var healthBar:FlxBar;

	private var generatedMusic:Bool = false;
	private var startingSong:Bool = false;

	private var iconP1:HealthIcon;
	private var iconP2:HealthIcon;

	public var camHUD:FlxCamera;

	private var camGame:FlxCamera;
	private var camOverlay:FlxCamera;

	private var eventList:Array<Dynamic> = [];

	private var comboUI:ComboPopup;

	public static final minCombo:Int = 10;

	var dialogue:Array<String> = [':bf:strange code', ':dad:>:]'];

	var stage:Dynamic;

	var foregroundSprites:FlxTypedGroup<BGSprite>;

	var talking:Bool = true;
	var songScore:Int = 0;

	// UIs
	// default UI
	var scoreTxt:FlxText;
	// var kadeEngineWatermark:FlxText;
	var autoplayText:FlxText;
	var hudFont:String = "vcr";
	var hudSize:Int = 16;

	// scratch UI
	/* de agora em diante eu peço minhas 
		mais sinceras desculpas por qualquer 
		ocasiao de codigo bosta que rolar aqui 
						- neon
	 */
	var scoreScratchTxt:FlxText;
	var missesScratchTxt:FlxText;
	var ratingScratchTxt:FlxText;

	var scoreScratchBG:FlxSprite;
	var missesScratchBG:FlxSprite;
	var ratingScratchBG:FlxSprite;

	// end UIs
	public static var campaignScore:Int = 0;

	var defaultCamZoom:Float = 1.05;

	// how big to stretch the pixel art assets
	public static var daPixelZoom:Float = 6;

	public static var inCutscene:Bool = false;

	var dadBeats:Array<Int> = [0, 2];
	var bfBeats:Array<Int> = [1, 3];

	public static var sectionStart:Bool = false;
	public static var sectionStartPoint:Int = 0;
	public static var sectionStartTime:Float = 0;

	private var meta:SongMetaTags;

	private var executeModchart = false;

	#if EXPERIMENTAL_LUA
	//////// API SHIT
	public function addObject(object:FlxBasic)
	{
		add(object);
	}

	public function removeObject(object:FlxBasic)
	{
		remove(object);
	}

	//////// END API SHIT
	#end
	override public function create()
	{
		instance = this;
		FlxG.mouse.visible = false;
		PlayerSettings.gameControls();

		customTransIn = new ScreenWipeIn(1.2);
		customTransOut = new ScreenWipeOut(0.6);

		#if sys
		executeModchart = FileSystem.exists(Paths.lua(PlayState.SONG.song.toLowerCase() + "/modchart"));
		#end
		#if !cpp
		executeModchart = false; // FORCE disable for non cpp targets
		#end

		trace('Mod chart: ' + executeModchart + " - " + Paths.lua(PlayState.SONG.song.toLowerCase() + "/modchart"));

		if (loadEvents)
		{
			if (CoolUtil.exists("assets/data/" + SONG.song.toLowerCase() + "/events.json"))
			{
				trace("loaded events");
				trace(Paths.json(SONG.song.toLowerCase() + "/events"));
				EVENTS = Song.parseEventJSON(CoolUtil.getText(Paths.json(SONG.song.toLowerCase() + "/events")));
			}
			else
			{
				trace("No events found");
				EVENTS = {
					events: []
				};
			}
		}
		
		for (i in EVENTS.events)
		{
			eventList.push([i[1], i[3]]);
			
			/*
			if (i[1].startsWith("changeChar;"))
			{
				//just so the game doesnt lag with new chars - DIDNT WORK! idk why maybe im just dumb
				var coolCharacter:Character = new Character(-10000, -5000, tagShits[2]);
			}
			*/
		}
		
		if (!FlxG.save.data.charPreload2) {
			if (SONG.song.toLowerCase() ==  'dragons') {
				ImageCache.add(Paths.file('especula/dave', "images", "png"));
				ImageCache.add(Paths.file('especula/blu', "images", "png"));
				ImageCache.add(Paths.file('especula/hawnt', "images", "png"));
				ImageCache.add(Paths.file('especula/sketcher', "images", "png"));
				trace("DP (dude preloading)");
			}
		}
		
		eventList.sort(sortByEventStuff);

		inCutscene = false;

		FlxG.sound.cache(Paths.inst(SONG.song));
		FlxG.sound.cache(Paths.voices(SONG.song));

		if (Config.noFpsCap)
			openfl.Lib.current.stage.frameRate = 999;
		else
			openfl.Lib.current.stage.frameRate = 144;

		camTween = FlxTween.tween(this, {}, 0);
		camZoomTween = FlxTween.tween(this, {}, 0);
		uiZoomTween = FlxTween.tween(this, {}, 0);

		for (i in 0...SONG.notes.length)
		{
			var array = [false, false];

			array[0] = sectionContainsBfNotes(i);
			array[1] = sectionContainsOppNotes(i);

			sectionHaveNotes.push(array);
		}

		canHit = !(Config.ghostTapType > 0);
		// noMissCount = 0;
		// invulnCount = 0;

		// var gameCam:FlxCamera = FlxG.camera;
		camGame = new FlxCamera();
		camHUD = new FlxCamera();
		camHUD.bgColor.alpha = 0;
		camOverlay = new FlxCamera();
		camOverlay.bgColor.alpha = 0;

		FlxG.cameras.reset(camGame);
		FlxG.cameras.add(camOverlay, false);
		FlxG.cameras.add(camHUD, false);

		FlxG.cameras.setDefaultDrawTarget(camGame, true);

		persistentUpdate = true;
		persistentDraw = true;

		if (SONG == null)
			SONG = Song.loadFromJson('tutorial');

		Conductor.changeBPM(SONG.bpm);
		Conductor.mapBPMChanges(SONG);

		foregroundSprites = new FlxTypedGroup<BGSprite>();

		if (CoolUtil.exists(Paths.text(SONG.song.toLowerCase() + "/" + SONG.song.toLowerCase() + "Dialogue")))
		{
			try
			{
				dialogue = CoolUtil.coolTextFile(Paths.text(SONG.song.toLowerCase() + "/" + SONG.song.toLowerCase() + "Dialogue"));
			}
			catch (e)
			{
			}
		}

		// song-specific font
		if (qenSongs.contains(SONG.song.toLowerCase())) {
			hudFont = "calibrib";
			hudSize = 20;
		}
		
		if (SONG.song.toLowerCase() == "street-musician")
		{
			hudFont = "augie";
			hudSize = 18;
		}

		var gfCheck:String = 'gf';

		if (SONG.gf == null)
		{
			switch (storyWeek)
			{
				case 4:
					gfCheck = 'gf-car';
				case 5:
					gfCheck = 'gf-christmas';
				case 6:
					gfCheck = 'gf-pixel';
				case 7:
					if (SONG.song.toLowerCase() == "stress")
					{
						gfCheck = 'pico-speaker';
					}
					else
					{
						gfCheck = 'gf-tankmen';
					}
			}

			SONG.gf = gfCheck;
		}

		gfCheck = SONG.gf;

		gf = new Character(400, 130, gfCheck);
		gf.scrollFactor.set(0.95, 0.95);

		var dadChar = SONG.player2;

		dad = new Character(100, 100, dadChar);

		var bfChar = SONG.player1;

		// antes era 450 agora e 100, consistencia pessoal consistencia
		boyfriend = new Character(770, 100, bfChar, true);

		var stageCheck:String = 'Stage';
		if (SONG.stage == null)
		{
			if (spookySongs.contains(SONG.song.toLowerCase()))
			{
				stageCheck = 'Spooky';
			}
			else if (phillySongs.contains(SONG.song.toLowerCase()))
			{
				stageCheck = 'Philly';
			}
			else if (limoSongs.contains(SONG.song.toLowerCase()))
			{
				stageCheck = 'Limo';
			}
			else if (mallSongs.contains(SONG.song.toLowerCase()))
			{
				stageCheck = 'Mall';
			}
			else if (evilMallSongs.contains(SONG.song.toLowerCase()))
			{
				stageCheck = 'MallEvil';
			}
			else if (schoolSongs.contains(SONG.song.toLowerCase()))
			{
				stageCheck = 'School';
			}
			else if (evilSchoolSongs.contains(SONG.song.toLowerCase()))
			{
				stageCheck = 'SchoolEvil';
			}
			else if (tankSongs.contains(SONG.song.toLowerCase()))
			{
				stageCheck = 'Tank';
			}

			SONG.stage = stageCheck;
		}
		else
		{
			stageCheck = SONG.stage;
		}

		var stageClass = Type.resolveClass("stages." + stageCheck);
		if (stageClass == null)
		{
			stageClass = BasicStage;
		}

		stage = Type.createInstance(Type.resolveClass("stages." + stageCheck), []);

		curStage = stage.name;
		curUiType = stage.uiType;

		for (i in 0...stage.backgroundElements.length)
		{
			add(stage.backgroundElements[i]);
		}

		switch (SONG.song.toLowerCase())
		{
			case "tutorial":
				autoZoom = false;
				dadBeats = [0, 1, 2, 3];
			case "bopeebo":
				dadBeats = [0, 1, 2, 3];
				bfBeats = [0, 1, 2, 3];
			case "fresh":
				camZooming = false;
				dadBeats = [0, 1, 2, 3];
				bfBeats = [0, 1, 2, 3];
			case "spookeez":
				dadBeats = [0, 1, 2, 3];
			case "south":
				dadBeats = [0, 1, 2, 3];
			case "monster":
				dadBeats = [0, 1, 2, 3];
				bfBeats = [0, 1, 2, 3];
			case "cocoa":
				dadBeats = [0, 1, 2, 3];
				bfBeats = [0, 1, 2, 3];
			case "thorns":
				dadBeats = [0, 1, 2, 3];
		}

		var camPos:FlxPoint = new FlxPoint(dad.getGraphicMidpoint().x + (dad.cameraOffsetArray[0] - 150),
			dad.getGraphicMidpoint().y + (dad.cameraOffsetArray[1] + 100));

		dad.x += dad.charOffsetArray[0];
		dad.y += dad.charOffsetArray[1];

		boyfriend.x -= boyfriend.charOffsetArray[0];
		boyfriend.y += boyfriend.charOffsetArray[1];

		// and then there's these off cases
		switch (SONG.player2)
		{
			case 'gf':
				dad.setPosition(gf.x, gf.y);
				gf.visible = false;
				if (isStoryMode)
				{
					camPos.x += 600;
					camChangeZoom(1.3, (Conductor.stepCrochet * 4 / 1000), FlxEase.elasticInOut);
				}

			case "spooky":
				camPos.set(dad.getGraphicMidpoint().x + 300, dad.getGraphicMidpoint().y - 100);
			case "monster":
				camPos.set(dad.getGraphicMidpoint().x + 300, dad.getGraphicMidpoint().y - 100);
			case 'dad':
				camPos.x += 400;
			case 'pico':
				camPos.x += 600;
			case 'senpai':
				camPos.set(dad.getGraphicMidpoint().x + 300, dad.getGraphicMidpoint().y);
			case 'senpai-angry':
				camPos.set(dad.getGraphicMidpoint().x + 300, dad.getGraphicMidpoint().y);
			case 'spirit':
				camPos.set(dad.getGraphicMidpoint().x + 300, dad.getGraphicMidpoint().y);
		}

		autoCam = stage.cameraMovementEnabled;

		if (stage.cameraStartPosition != null)
		{
			camPos.set(stage.cameraStartPosition.x, stage.cameraStartPosition.y);
		}

		add(gf);

		for (i in 0...stage.middleElements.length)
		{
			add(stage.middleElements[i]);
		}

		add(dad);
		add(boyfriend);

		for (i in 0...stage.foregroundElements.length)
		{
			add(stage.foregroundElements[i]);
		}

		// add(foregroundSprites);

		if (!pixelSongs.contains(SONG.song.toLowerCase()))
		{
			if (qenSongs.contains(SONG.song.toLowerCase()))
			{
			comboUI = new ComboPopup(boyfriend.x - 250, boyfriend.y - 75, [Paths.image("ui/qenUI/ratings"), 403, 163, true],
				[Paths.image("ui/qenUI/numbers"), 100, 120, true], [Paths.image("ui/qenUI/comboBreak"), 348, 211, true]);
			NoteSplash.splashPath = "ui/qenUI/noteSplashes";
			} else {
			comboUI = new ComboPopup(boyfriend.x - 250, boyfriend.y - 75, [Paths.image("ui/ratings"), 403, 163, true],
				[Paths.image("ui/numbers"), 100, 120, true], [Paths.image("ui/comboBreak"), 348, 211, true]);
			NoteSplash.splashPath = "ui/noteSplashes";			
			}
		}
		else
		{
			comboUI = new ComboPopup(boyfriend.x - 250, boyfriend.y - 75, [Paths.image("week6/weeb/pixelUI/ratings-pixel"), 51, 20, false],
				[Paths.image("week6/weeb/pixelUI/numbers-pixel"), 11, 12, false], [Paths.image("week6/weeb/pixelUI/comboBreak-pixel"), 53, 32, false],
				[daPixelZoom * 0.7, daPixelZoom * 0.8, daPixelZoom * 0.7]);
			comboUI.numberPosition[0] -= 120;
			NoteSplash.splashPath = "week6/weeb/pixelUI/noteSplashes-pixel";
		}

		// Prevents the game from lagging at first note splash.
		var preloadSplash = new NoteSplash(-2000, -2000, 0);

		if (Config.comboType == 1)
		{
			comboUI.cameras = [camHUD];
			comboUI.setPosition(0, 0);
			comboUI.scrollFactor.set(0, 0);
			comboUI.setScales([comboUI.ratingScale * 0.8, comboUI.numberScale * 0.8, comboUI.breakScale * 0.8]);
			comboUI.accelScale = 0.2;
			comboUI.velocityScale = 0.2;

			/* if (!Config.downscroll)
				{
					comboUI.ratingPosition = [700, 510];
					comboUI.numberPosition = [320, 480];
					comboUI.breakPosition = [690, 465];
				}
				else
				{
					comboUI.ratingPosition = [700, 80];
					comboUI.numberPosition = [320, 100];
					comboUI.breakPosition = [690, 85];
			}*/

			comboUI.ratingPosition = [782, 266];
			comboUI.numberPosition = [873, 349];
			comboUI.breakPosition = [690, 85];

			if (Config.centeredNotes)
			{
				comboUI.ratingPosition[0] -= 322;
				comboUI.numberPosition[0] -= 322;
			}

			if (pixelSongs.contains(SONG.song.toLowerCase()))
			{
				comboUI.numberPosition[0] -= 120;
				comboUI.setPosition(160, 60);
			}
		}

		if (Config.comboType < 2)
		{
			add(comboUI);
		}

		var doof:DialogueBox = new DialogueBox(false, dialogue);
		// doof.x += 70;
		// doof.y = FlxG.height * 0.5;
		doof.scrollFactor.set();
		doof.finishThing = startCountdown;

		Conductor.songPosition = -5000;

		if (Config.downscroll)
		{
			strumLine = new FlxSprite(0, 570).makeGraphic(FlxG.width, 10);
		}
		else
		{
			strumLine = new FlxSprite(0, 30).makeGraphic(FlxG.width, 10);
		}
		strumLine.scrollFactor.set();

		strumLineNotes = new FlxTypedGroup<SwagStrum>();
		add(strumLineNotes);

		playerStrums = new FlxTypedGroup<SwagStrum>();
		enemyStrums = new FlxTypedGroup<SwagStrum>();

		// startCountdown();

		generateSong(SONG.song);

		// add(strumLine);

		camFollow = new FlxObject(0, 0, 1, 1);

		camFollow.setPosition(camPos.x, camPos.y);

		if (prevCamFollow != null)
		{
			camFollow = prevCamFollow;
			prevCamFollow = null;
		}

		add(camFollow);

		FlxG.camera.follow(camFollow, LOCKON);

		defaultCamZoom = stage.startingZoom;

		// FlxG.camera.setScrollBounds(0, FlxG.width, 0, FlxG.height);
		FlxG.camera.zoom = defaultCamZoom;

		FlxG.camera.focusOn(camFollow.getPosition());

		FlxG.worldBounds.set(0, 0, FlxG.width, FlxG.height);

		FlxG.fixedTimestep = false;

		if (CoolUtil.exists(Paths.text(SONG.song.toLowerCase() + "/meta")))
		{
			meta = new SongMetaTags(0, 144, SONG.song.toLowerCase());
			meta.cameras = [camHUD];
			add(meta);
		}

		healthBarBG = new FlxSprite(0, Config.downscroll ? FlxG.height * 0.1 : FlxG.height * 0.9).loadGraphic(
		(qenSongs.contains(SONG.song.toLowerCase()) ? Paths.image("ui/qenUI/healthBar") : Paths.image("ui/healthBar"))
		);
		
		healthBarBG.screenCenter(X);
		healthBarBG.scrollFactor.set();
		healthBarBG.antialiasing = true;
		add(healthBarBG);

		healthBar = new FlxBar(healthBarBG.x + 4, healthBarBG.y + 4, RIGHT_TO_LEFT, Std.int(healthBarBG.width - 8), Std.int(healthBarBG.height - 8), this,
			'healthLerp', 0, 2);
		healthBar.scrollFactor.set();
		healthBar.createFilledBar(dad.characterColor, boyfriend.characterColor);
		healthBar.antialiasing = true;
		// healthBar

		//////// CUSTOM UIs
		//// DEFAULT UI
		/*
			// Add Kade Engine watermark
			kadeEngineWatermark = new FlxText(4,healthBarBG.y + 50,0, curSong + " " + (storyDifficulty == 2 ? "Hard" : storyDifficulty == 1 ? "Normal" : "Easy") + " - FPS+ 4.1.0", 16);
			kadeEngineWatermark.setFormat(Paths.font("vcr"), 16, FlxColor.WHITE, RIGHT, FlxTextBorderStyle.OUTLINE,FlxColor.BLACK);
			kadeEngineWatermark.scrollFactor.set();
		 */

		scoreTxt = new FlxText(healthBarBG.x - 105, healthBarBG.y + 40, 800, "", hudSize);
		scoreTxt.setFormat(Paths.font(hudFont), hudSize, FlxColor.WHITE, FlxTextAlign.CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		scoreTxt.scrollFactor.set();

		// botplay text
		autoplayText = new FlxText(healthBarBG.x, healthBarBG.y - 50, 0, "AUTOPLAY", 32);
		autoplayText.setFormat(Paths.font(hudFont), 32, FlxColor.WHITE, CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		autoplayText.scrollFactor.set();
		autoplayText.visible = false;
		autoplayText.screenCenter(X);

		//// SCRATCH UI
		scoreScratchBG = new FlxSprite(400, healthBarBG.y + 35).loadGraphic(Paths.image("ui/scratchUI/scoreCount"));
		scoreScratchBG.scrollFactor.set();
		scoreScratchBG.antialiasing = true;

		ratingScratchBG = new FlxSprite(400, healthBarBG.y + 39).loadGraphic(Paths.image("ui/scratchUI/standaloneVariable"));
		ratingScratchBG.scrollFactor.set();
		ratingScratchBG.antialiasing = true;
		ratingScratchBG.screenCenter(X);

		missesScratchBG = new FlxSprite(721, healthBarBG.y + 35).loadGraphic(Paths.image("ui/scratchUI/missesCount"));
		missesScratchBG.scrollFactor.set();
		missesScratchBG.antialiasing = true;

		scoreScratchTxt = new FlxText(scoreScratchBG.x + 70, scoreScratchBG.y + 7, 79, "0000000", 20);
		scoreScratchTxt.setFormat(Paths.font("arialbd"), 20, FlxColor.WHITE, FlxTextAlign.CENTER);
		scoreScratchTxt.scrollFactor.set();
		scoreScratchTxt.antialiasing = true;

		ratingScratchTxt = new FlxText(ratingScratchBG.x, ratingScratchBG.y, 0, "teeeeeest", 26);
		ratingScratchTxt.setFormat(Paths.font("arialbd"), 26, FlxColor.WHITE, FlxTextAlign.CENTER);
		ratingScratchTxt.scrollFactor.set();
		ratingScratchTxt.screenCenter(X);
		ratingScratchTxt.antialiasing = true;

		missesScratchTxt = new FlxText(missesScratchBG.x + 88, missesScratchBG.y + 7, 79, "0000000", 20);
		missesScratchTxt.setFormat(Paths.font("arialbd"), 20, FlxColor.WHITE, FlxTextAlign.CENTER);
		missesScratchTxt.scrollFactor.set();
		missesScratchTxt.antialiasing = true;

		//////// END CUSTOM UIs

		iconP1 = new HealthIcon(boyfriend.iconName, true);
		iconP1.y = healthBar.y - (iconP1.height / 2);

		iconP2 = new HealthIcon(dad.iconName, false);
		iconP2.y = healthBar.y - (iconP2.height / 2);

		add(healthBar);
		add(iconP2);
		add(iconP1);

		if (!scratchSongs.contains(SONG.song.toLowerCase()))
		{
			add(scoreTxt);
			// add(kadeEngineWatermark);
		}
		add(autoplayText);

		if (scratchSongs.contains(SONG.song.toLowerCase()))
		{
			add(scoreScratchBG);
			add(ratingScratchBG);
			add(missesScratchBG);
			add(scoreScratchTxt);
			add(ratingScratchTxt);
			add(missesScratchTxt);
		}

		strumLineNotes.cameras = [camHUD];
		notes.cameras = [camHUD];

		healthBar.cameras = [camHUD];
		healthBarBG.cameras = [camHUD];
		iconP1.cameras = [camHUD];
		iconP2.cameras = [camHUD];

		if (!scratchSongs.contains(SONG.song.toLowerCase()))
		{
			scoreTxt.cameras = [camHUD];
			// kadeEngineWatermark.cameras = [camHUD];
		}

		autoplayText.cameras = [camHUD];

		if (scratchSongs.contains(SONG.song.toLowerCase()))
		{
			scoreScratchBG.cameras = [camHUD];
			ratingScratchBG.cameras = [camHUD];
			missesScratchBG.cameras = [camHUD];

			scoreScratchTxt.cameras = [camHUD];
			ratingScratchTxt.cameras = [camHUD];
			missesScratchTxt.cameras = [camHUD];
		}

		doof.cameras = [camHUD];

		healthBar.visible = false;
		healthBarBG.visible = false;
		iconP1.visible = false;
		iconP2.visible = false;

		if (!scratchSongs.contains(SONG.song.toLowerCase()))
		{
			scoreTxt.visible = false;
			// kadeEngineWatermark.visible = false;
		}

		if (scratchSongs.contains(SONG.song.toLowerCase()))
		{
			scoreScratchBG.visible = false;
			ratingScratchBG.visible = false;
			missesScratchBG.visible = false;
			scoreScratchTxt.visible = false;
			ratingScratchTxt.visible = false;
			missesScratchTxt.visible = false;
		}

		// if (SONG.song == 'South')
		// FlxG.camera.alpha = 0.7;
		// UI_camera.zoom = 1;

		// cameras = [FlxG.cameras.list[1]];

		startingSong = true;

		if (isStoryMode)
		{
			switch (curSong.toLowerCase())
			{
				case "winter-horrorland":
					var blackScreen:FlxSprite = new FlxSprite(0, 0).makeGraphic(Std.int(FlxG.width * 2), Std.int(FlxG.height * 2), FlxColor.BLACK);
					add(blackScreen);
					blackScreen.scrollFactor.set();
					camHUD.visible = false;

					new FlxTimer().start(0.1, function(tmr:FlxTimer)
					{
						remove(blackScreen);
						FlxG.sound.play(Paths.sound('Lights_Turn_On'));
						camFollow.y = -2050;
						camFollow.x += 200;
						FlxG.camera.focusOn(camFollow.getPosition());
						FlxG.camera.zoom = 1.5;

						new FlxTimer().start(0.8, function(tmr:FlxTimer)
						{
							camHUD.visible = true;
							remove(blackScreen);
							FlxTween.tween(FlxG.camera, {zoom: defaultCamZoom}, 2.5, {
								ease: FlxEase.quadInOut,
								onComplete: function(twn:FlxTween)
								{
									startCountdown();
								}
							});
						});
					});
				case 'senpai':
					schoolIntro(doof);
				case 'roses':
					FlxG.sound.play(Paths.sound('ANGRY'));
					schoolIntro(doof);
				case 'thorns':
					schoolIntro(doof);

				case "ugh":
					videoCutscene(Paths.video("week7/ughCutsceneFade"), function()
					{
						camMove(camFollow.x, camFollow.y + 100, 0, null);
						FlxG.camera.zoom = defaultCamZoom * 1.2;
						if (PlayState.SONG.notes[0].mustHitSection)
						{
							camFocusBF();
						}
						else
						{
							camFocusOpponent();
						}
						FlxTween.tween(FlxG.camera, {zoom: defaultCamZoom}, ((Conductor.crochet / 1000) * 5) - 0.1, {ease: FlxEase.quadOut});
					});

				case "guns":
					videoCutscene(Paths.video("week7/gunsCutsceneFade"), function()
					{
						camMove(camFollow.x, camFollow.y + 100, 0, null);
						FlxG.camera.zoom = defaultCamZoom * 1.2;
						if (PlayState.SONG.notes[0].mustHitSection)
						{
							camFocusBF();
						}
						else
						{
							camFocusOpponent();
						}
						FlxTween.tween(FlxG.camera, {zoom: defaultCamZoom}, ((Conductor.crochet / 1000) * 5) - 0.1, {ease: FlxEase.quadOut});
					});

				case "stress":
					videoCutscene(Paths.video("week7/stressCutsceneFade"), function()
					{
						camMove(camFollow.x, camFollow.y + 100, 0, null);
						FlxG.camera.zoom = defaultCamZoom * 1.2;
						if (PlayState.SONG.notes[0].mustHitSection)
						{
							camFocusBF();
						}
						else
						{
							camFocusOpponent();
						}
						FlxTween.tween(FlxG.camera, {zoom: defaultCamZoom}, ((Conductor.crochet / 1000) * 5) - 0.1, {ease: FlxEase.quadOut});
					});

				case "hihi":
					scratchStart();

				default:
					startCountdown();
			}
		}
		else
		{
			switch (curSong.toLowerCase())
			{
				case "lil-buddies":
					if (fromChartEditor)
					{
						lilBuddiesStart();
					}
					else
					{
						startCountdown();
					}
				/*case "ugh":
						videoCutscene(Paths.video("week7/ughCutsceneFade"), function(){
							camMove(camFollow.x, camFollow.y + 100, 0, null);
							FlxG.camera.zoom = defaultCamZoom * 1.2;
							if(PlayState.SONG.notes[0].mustHitSection){ camFocusBF(); }
							else{ camFocusOpponent(); }
							FlxTween.tween(FlxG.camera, {zoom: defaultCamZoom}, ((Conductor.crochet / 1000) * 5) - 0.1, {ease: FlxEase.quadOut});
						});
						
					case "guns":
						videoCutscene(Paths.video("week7/gunsCutsceneFade"), function(){
							camMove(camFollow.x, camFollow.y + 100, 0, null);
							FlxG.camera.zoom = defaultCamZoom * 1.2;
							if(PlayState.SONG.notes[0].mustHitSection){ camFocusBF(); }
							else{ camFocusOpponent(); }
							FlxTween.tween(FlxG.camera, {zoom: defaultCamZoom}, ((Conductor.crochet / 1000) * 5) - 0.1, {ease: FlxEase.quadOut});
						});

					case "stress":
						videoCutscene(Paths.video("week7/stressCutsceneFade"), function(){
							camMove(camFollow.x, camFollow.y + 100, 0, null);
							FlxG.camera.zoom = defaultCamZoom * 1.2;
							if(PlayState.SONG.notes[0].mustHitSection){ camFocusBF(); }
							else{ camFocusOpponent(); }
							FlxTween.tween(FlxG.camera, {zoom: defaultCamZoom}, ((Conductor.crochet / 1000) * 5) - 0.1, {ease: FlxEase.quadOut});
				});*/

				default:
					startCountdown();
			}
		}

		var bgDim = new FlxSprite(1280 / -2, 720 / -2).makeGraphic(1280 * 2, 720 * 2, FlxColor.BLACK);
		bgDim.cameras = [camOverlay];
		bgDim.alpha = Config.bgDim / 10;
		add(bgDim);

		fromChartEditor = false;

		if (marcoballGimmickSongs.contains(SONG.song.toLowerCase()))
		{
			health = 2;
		}

		super.create();
	}

	function updateAccuracy(?wife3:Bool = false)
	{
		var wifeThree:String = '?';
		var moreRatingText:String = '?';

		totalPlayed += 1;
		accuracy = totalNotesHit / totalPlayed * 100;
		if (accuracy >= 100)
		{
			accuracy = 100;
		}

		if (wife3)
		{
			// start text rating shit
			if (accuracy < 60)
				wifeThree = "D";
			if (accuracy >= 60)
				wifeThree = "C";
			if (accuracy >= 70)
				wifeThree = "B";
			if (accuracy >= 80)
				wifeThree = "A";
			if (accuracy >= 85)
				wifeThree = "A.";
			if (accuracy >= 90)
				wifeThree = "A:";
			if (accuracy >= 93)
				wifeThree = "AA";
			if (accuracy >= 96.50)
				wifeThree = "AA.";
			if (accuracy >= 99)
				wifeThree = "AA:";
			if (accuracy >= 99.70)
				wifeThree = "AAA";
			if (accuracy >= 99.80)
				wifeThree = "AAA.";
			if (accuracy >= 99.90)
				wifeThree = "AAA:";
			if (accuracy >= 99.955)
				wifeThree = "AAAA";
			if (accuracy >= 99.970)
				wifeThree = "AAAA.";
			if (accuracy >= 99.980)
				wifeThree = "AAAA:";
			if (accuracy >= 99.9935)
				wifeThree = "AAAAA";
		}

		if (sicks > 0)
			moreRatingText = "SFC";
		if (goods > 0)
			moreRatingText = "GFC";
		if (bads > 0 || shits > 0)
			moreRatingText = "FC";

		if (comboBreaks > 0)
		{
			if (comboBreaks > 9)
			{
				moreRatingText = "Clear";
			}
			else
			{
				moreRatingText = "SDCB";
			}
		}

		if (wife3)
			textRating = '(' + moreRatingText + ')' + ' ' + wifeThree;
		else
			textRating = '' + moreRatingText;
		// end text rating shit
	}

	function schoolIntro(?dialogueBox:DialogueBox):Void
	{
		var black:FlxSprite = new FlxSprite(-100, -100).makeGraphic(FlxG.width * 2, FlxG.height * 2, FlxColor.BLACK);
		black.scrollFactor.set();
		add(black);

		var red:FlxSprite = new FlxSprite(-100, -100).makeGraphic(FlxG.width * 2, FlxG.height * 2, 0xFFff1b31);
		red.scrollFactor.set();

		var senpaiEvil:FlxSprite = new FlxSprite();
		senpaiEvil.frames = Paths.getSparrowAtlas('week6/weeb/senpaiCrazy');
		senpaiEvil.animation.addByPrefix('idle', 'Senpai Pre Explosion', 24, false);
		senpaiEvil.setGraphicSize(Std.int(senpaiEvil.width * 5.5));
		senpaiEvil.updateHitbox();
		senpaiEvil.screenCenter();
		// senpaiEvil.x -= 120;
		senpaiEvil.y -= 115;

		if (SONG.song.toLowerCase() == 'roses' || SONG.song.toLowerCase() == 'thorns')
		{
			remove(black);

			if (SONG.song.toLowerCase() == 'thorns')
			{
				add(red);
			}
		}

		new FlxTimer().start(0.3, function(tmr:FlxTimer)
		{
			black.alpha -= 0.15;

			if (black.alpha > 0)
			{
				tmr.reset(0.3);
			}
			else
			{
				if (dialogueBox != null)
				{
					inCutscene = true;

					if (SONG.song.toLowerCase() == 'thorns')
					{
						add(senpaiEvil);
						senpaiEvil.alpha = 0;
						new FlxTimer().start(0.3, function(swagTimer:FlxTimer)
						{
							senpaiEvil.alpha += 0.15;
							if (senpaiEvil.alpha < 1)
							{
								swagTimer.reset();
							}
							else
							{
								senpaiEvil.animation.play('idle');
								FlxG.sound.play(Paths.sound('Senpai_Dies'), 1, false, null, true, function()
								{
									remove(senpaiEvil);
									remove(red);
									FlxG.camera.fade(FlxColor.WHITE, 0.01, true, function()
									{
										add(dialogueBox);
									}, true);
								});
								new FlxTimer().start(3.2, function(deadTime:FlxTimer)
								{
									FlxG.camera.fade(FlxColor.WHITE, 1.6, false);
								});
							}
						});
					}
					else
					{
						add(dialogueBox);
					}
				}
				else
					startCountdown();

				remove(black);
			}
		});
	}

	function videoCutscene(path:String, ?endFunc:Void->Void, ?startFunc:Void->Void)
	{
		inCutscene = true;

		var blackShit:FlxSprite = new FlxSprite(-200, -200).makeGraphic(FlxG.width * 3, FlxG.height * 3, FlxColor.BLACK);
		blackShit.screenCenter(XY);
		blackShit.scrollFactor.set();
		add(blackShit);

		var video = new VideoHandler();
		video.scrollFactor.set();
		video.antialiasing = true;

		FlxG.camera.zoom = 1;

		video.playMP4(path, function()
		{
			FlxTween.tween(blackShit, {alpha: 0}, 0.4, {
				ease: FlxEase.quadInOut,
				onComplete: function(t)
				{
					remove(blackShit);
				}
			});

			remove(video);

			FlxG.camera.zoom = defaultCamZoom;

			if (endFunc != null)
			{
				endFunc();
			}

			startCountdown();
		}, false, true);

		add(video);

		if (startFunc != null)
		{
			startFunc();
		}
	}

	function scratchStart(?cutsceneThing:String):Void
	{
		FlxG.mouse.visible = true;
		
		var startProj:FlxSprite = new FlxSprite(0, 0).loadGraphic(Paths.image('ui/scratchUI/startProj'));
		startProj.scrollFactor.set();
		add(startProj);
		startProj.cameras = [camHUD];

		new FlxTimer().start(0.001, function(tmr:FlxTimer)
		{
			var mousePressed = FlxG.mouse.justPressed;

			if (!mousePressed)
				tmr.reset(0.001);

			if (mousePressed)
			{
				FlxG.mouse.visible = false;
				remove(startProj);

				if (cutsceneThing != null)
				{
					videoCutscene(Paths.video(cutsceneThing));
				}
				else
					startCountdown();
			}
		});
	}

	function lilBuddiesStart():Void
	{
		inCutscene = false;

		healthBar.visible = true;
		healthBarBG.visible = true;
		iconP1.visible = true;
		iconP2.visible = true;
		scoreTxt.visible = true;
		// kadeEngineWatermark.visible = true;

		healthBar.alpha = 0;
		healthBarBG.alpha = 0;
		iconP1.alpha = 0;
		iconP2.alpha = 0;
		scoreTxt.alpha = 0;

		generateStaticArrows(0, true);
		generateStaticArrows(1, true);

		for (x in strumLineNotes.members)
		{
			x.alpha = 0;
		}

		talking = false;
		startedCountdown = true;
		Conductor.songPosition = 0;
		// Conductor.songPosition -= Conductor.crochet * 5;

		customTransIn = new BasicTransition();

		autoZoom = false;
		defaultCamZoom = 2.8;
		var hudElementsFadeInTime = 0.2;

		camChangeZoom(defaultCamZoom, Conductor.crochet / 1000 * 16, FlxEase.quadInOut, function(t)
		{
			autoZoom = true;
			FlxTween.tween(healthBar, {alpha: 1}, hudElementsFadeInTime);
			FlxTween.tween(healthBarBG, {alpha: 1}, hudElementsFadeInTime);
			FlxTween.tween(iconP1, {alpha: 1}, hudElementsFadeInTime);
			FlxTween.tween(iconP2, {alpha: 1}, hudElementsFadeInTime);
			FlxTween.tween(scoreTxt, {alpha: 1}, hudElementsFadeInTime);
			for (x in strumLineNotes.members)
			{
				FlxTween.tween(x, {alpha: 1}, hudElementsFadeInTime);
			}
		});
		camMove(155, 600, Conductor.crochet / 1000 * 16, FlxEase.quadOut, "center");

		/*if(stage.name == "chart"){
			stage.blackBGFade();
		}*/

		beatHit();
	}

	var startTimer:FlxTimer;

	public static var luaModchart:ModchartState = null;

	function startCountdown():Void
	{
		inCutscene = false;

		healthBar.visible = true;
		healthBarBG.visible = true;
		iconP1.visible = true;
		iconP2.visible = true;

		if (!scratchSongs.contains(SONG.song.toLowerCase()))
		{
			scoreTxt.visible = true;
			// kadeEngineWatermark.visible = true;
		}

		if (scratchSongs.contains(SONG.song.toLowerCase()))
		{
			scoreScratchBG.visible = true;
			ratingScratchBG.visible = true;
			missesScratchBG.visible = true;

			scoreScratchTxt.visible = true;
			ratingScratchTxt.visible = true;
			missesScratchTxt.visible = true;
		}

		generateStaticArrows(0);
		generateStaticArrows(1);

		#if EXPERIMENTAL_LUA
		//////// MORE LUA SHIT
		// gerson me ve 5 indurgencia q hoje eu vo peca brabo
		if (executeModchart)
		{
			luaModchart = ModchartState.createModchartState();
			luaModchart.executeState('start', [PlayState.SONG.song]);
		}
		//////// END MORE LUA SHIT
		#end

		talking = false;
		startedCountdown = true;
		Conductor.songPosition = 0;
		Conductor.songPosition -= Conductor.crochet * 5;

		var swagCounter:Int = 0;

		var introAssets:Map<String, Array<String>> = new Map<String, Array<String>>();
		if (qenSongs.contains(SONG.song.toLowerCase()))
			introAssets.set('default', ['ui/qenUI/ready', "ui/qenUI/set", "ui/qenUI/go", ""]);
		else
			introAssets.set('default', ['ui/ready', "ui/set", "ui/go", ""]);
		introAssets.set('pixel', [
			"week6/weeb/pixelUI/ready-pixel",
			"week6/weeb/pixelUI/set-pixel",
			"week6/weeb/pixelUI/date-pixel",
			"-pixel"
		]);

		var introAlts:Array<String> = introAssets.get(stage.uiType);
		var altSuffix = introAlts[3];

		startTimer = new FlxTimer().start(Conductor.crochet / 1000, function(tmr:FlxTimer)
		{
			if (swagCounter != 4)
			{
				gf.dance();
			}

			if (dadBeats.contains((swagCounter % 4)))
				if (swagCounter != 4)
				{
					dad.dance();
				}

			if (bfBeats.contains((swagCounter % 4)))
				if (swagCounter != 4)
				{
					boyfriend.dance();
				}

			switch (swagCounter)

			{
				case 0:
					FlxG.sound.play(Paths.sound('intro3' + altSuffix), 0.6);
					if (meta != null)
					{
						meta.start();
					}
				case 1:
					var ready:FlxSprite = new FlxSprite().loadGraphic(Paths.image(introAlts[0]));
					ready.scrollFactor.set();
					ready.antialiasing = !(stage.uiType == "pixel");

					if (stage.uiType == "pixel")
						ready.setGraphicSize(Std.int(ready.width * daPixelZoom * 0.8));
					else
						ready.setGraphicSize(Std.int(ready.width * 0.5));

					ready.updateHitbox();

					ready.screenCenter();
					ready.y -= 120;
					ready.cameras = [camHUD];
					add(ready);
					FlxTween.tween(ready, {y: ready.y += 100, alpha: 0}, Conductor.crochet / 1000, {
						ease: FlxEase.cubeInOut,
						onComplete: function(twn:FlxTween)
						{
							ready.destroy();
						}
					});
					FlxG.sound.play(Paths.sound('intro2' + altSuffix), 0.6);
				case 2:
					var set:FlxSprite = new FlxSprite().loadGraphic(Paths.image(introAlts[1]));
					set.scrollFactor.set();
					set.antialiasing = !(stage.uiType == "pixel");

					if (stage.uiType == "pixel")
						set.setGraphicSize(Std.int(set.width * daPixelZoom * 0.8));
					else
						set.setGraphicSize(Std.int(set.width * 0.5));

					set.updateHitbox();

					set.screenCenter();
					set.y -= 120;
					set.cameras = [camHUD];
					add(set);
					FlxTween.tween(set, {y: set.y += 100, alpha: 0}, Conductor.crochet / 1000, {
						ease: FlxEase.cubeInOut,
						onComplete: function(twn:FlxTween)
						{
							set.destroy();
						}
					});
					FlxG.sound.play(Paths.sound('intro1' + altSuffix), 0.6);
				case 3:
					var go:FlxSprite = new FlxSprite().loadGraphic(Paths.image(introAlts[2]));
					go.scrollFactor.set();
					go.antialiasing = !(stage.uiType == "pixel");

					if (stage.uiType == "pixel")
						go.setGraphicSize(Std.int(go.width * daPixelZoom * 0.8));
					else
						go.setGraphicSize(Std.int(go.width * 0.8));

					go.updateHitbox();

					go.screenCenter();
					go.y -= 120;
					go.cameras = [camHUD];
					add(go);
					FlxTween.tween(go, {y: go.y += 100, alpha: 0}, Conductor.crochet / 1000, {
						ease: FlxEase.cubeInOut,
						onComplete: function(twn:FlxTween)
						{
							go.destroy();
						}
					});
					FlxG.sound.play(Paths.sound('introGo' + altSuffix), 0.6);
				case 4:
					beatHit();
			}

			swagCounter += 1;
			// generateSong('fresh');
		}, 5);
	}

	var previousFrameTime:Int = 0;
	var lastReportedPlayheadPosition:Int = 0;
	var songTime:Float = 0;

	var songStarted = false;

	function startSong():Void
	{
		startingSong = false;

		songStarted = true;
		previousFrameTime = FlxG.game.ticks;
		lastReportedPlayheadPosition = 0;

		if (!paused)
		{
			FlxG.sound.playMusic(Paths.inst(SONG.song), 1, false);
		}

		FlxG.sound.music.onComplete = endSong;
		vocals.play();

		if (sectionStart)
		{
			FlxG.sound.music.time = sectionStartTime;
			Conductor.songPosition = sectionStartTime;
			vocals.time = sectionStartTime;
		}

		/*
			new FlxTimer().start(0.5, function(tmr:FlxTimer)
			{
				if(!paused)
				resyncVocals();
			});
		 */
	}

	private function generateSong(dataPath:String):Void
	{
		// FlxG.log.add(ChartParser.parse());

		var songData = SONG;
		Conductor.changeBPM(songData.bpm);

		curSong = songData.song;

		if (SONG.needsVoices)
		{
			vocals = new FlxSound().loadEmbedded(Paths.voices(curSong));
		}
		else
			vocals = new FlxSound();

		FlxG.sound.list.add(vocals);

		notes = new FlxTypedGroup<Note>();
		add(notes);

		var noteData:Array<SwagSection>;

		var scrollSpeedForMaths:Float = 1;

		if (Config.scrollSpeedOverride > 0)
			scrollSpeedForMaths = Config.scrollSpeedOverride;
		else
			scrollSpeedForMaths = FlxMath.roundDecimal(PlayState.SONG.speed, 2);

		// NEW SHIT
		noteData = songData.notes;

		var playerCounter:Int = 0;

		var daBeats:Int = 0; // Not exactly representative of 'daBeats' lol, just how much it has looped
		// for (section in noteData)
		for (section in noteData)
		{
			if (sectionStart && daBeats < sectionStartPoint)
			{
				daBeats++;
				continue;
			}

			var coolSection:Int = Std.int(section.lengthInSteps / 4);

			for (songNotes in section.sectionNotes)
			{
				var daStrumTime:Float = songNotes[0];
				var daNoteData:Int = Std.int(songNotes[1] % 4);
				var daNoteType:String = songNotes[3];

				var gottaHitNote:Bool = section.mustHitSection;

				if (songNotes[1] > 3)
				{
					gottaHitNote = !section.mustHitSection;
				}

				var oldNote:Note;
				if (unspawnNotes.length > 0)
					oldNote = unspawnNotes[Std.int(unspawnNotes.length - 1)];
				else
					oldNote = null;

				var swagNote:Note = new Note(daStrumTime, daNoteData, daNoteType, false, oldNote);

				swagNote.sustainLength = songNotes[2];

				// if (scrollSpeedForMaths < 1.5)
				//	swagNote.sustainLength -= 90;

				swagNote.scrollFactor.set(0, 0);

				var susLength:Float = swagNote.sustainLength;

				susLength = susLength / Conductor.stepCrochet;
				unspawnNotes.push(swagNote);

				for (susNote in 0...Math.round(susLength))
				{
					oldNote = unspawnNotes[Std.int(unspawnNotes.length - 1)];

					var sustainNote:Note = new Note(daStrumTime + (Conductor.stepCrochet * susNote) + Conductor.stepCrochet, daNoteData, daNoteType, false,
						oldNote, true);
					sustainNote.scrollFactor.set();
					unspawnNotes.push(sustainNote);

					sustainNote.mustPress = gottaHitNote;

					if (sustainNote.mustPress)
					{
						sustainNote.x += FlxG.width / 2; // general offset
					}
				}

				swagNote.mustPress = gottaHitNote;

				if (swagNote.mustPress)
				{
					swagNote.x += FlxG.width / 2; // general offset
				}
				else
				{
				}
			}
			daBeats++;
		}

		// trace(unspawnNotes.length);
		// playerCounter += 1;

		unspawnNotes.sort(sortByShit);

		generatedMusic = true;
	}

	function sortByShit(Obj1:Note, Obj2:Note):Int
	{
		return FlxSort.byValues(FlxSort.ASCENDING, Obj1.strumTime, Obj2.strumTime);
	}

	function sortByEventStuff(Obj1:Array<Dynamic>, Obj2:Array<Dynamic>):Int
	{
		return FlxSort.byValues(FlxSort.ASCENDING, Obj1[0], Obj2[0]);
	}

	private function generateStaticArrows(player:Int, ?instant:Bool = false):Void
	{
		for (i in 0...4)
		{
			// FlxG.log.add(i);
			var babyArrow:SwagStrum = new SwagStrum(50, strumLine.y);

			switch (stage.uiType)
			{
				case "pixel":
					babyArrow.loadGraphic(Paths.image('week6/weeb/pixelUI/arrows-pixels'), true, 19, 19);
					babyArrow.animation.add('green', [6]);
					babyArrow.animation.add('red', [7]);
					babyArrow.animation.add('blue', [5]);
					babyArrow.animation.add('purplel', [4]);

					babyArrow.setGraphicSize(Std.int(babyArrow.width * daPixelZoom));
					babyArrow.updateHitbox();
					babyArrow.antialiasing = false;

					switch (Math.abs(i))
					{
						case 2:
							babyArrow.x += Note.swagWidth * 2;
							babyArrow.animation.add('static', [2]);
							babyArrow.animation.add('pressed', [26, 10], 12, false);
							babyArrow.animation.add('confirm', [30, 14, 18], 24, false);
						case 3:
							babyArrow.x += Note.swagWidth * 3;
							babyArrow.animation.add('static', [3]);
							babyArrow.animation.add('pressed', [27, 11], 12, false);
							babyArrow.animation.add('confirm', [31, 15, 19], 24, false);
						case 1:
							babyArrow.x += Note.swagWidth * 1;
							babyArrow.animation.add('static', [1]);
							babyArrow.animation.add('pressed', [25, 9], 12, false);
							babyArrow.animation.add('confirm', [29, 13, 17], 24, false);
						case 0:
							babyArrow.x += Note.swagWidth * 0;
							babyArrow.animation.add('static', [0]);
							babyArrow.animation.add('pressed', [24, 8], 12, false);
							babyArrow.animation.add('confirm', [28, 12, 16], 24, false);
					}

				default:
					if (qenSongs.contains(SONG.song.toLowerCase()))
						babyArrow.frames = Paths.getSparrowAtlas('ui/qenUI/NOTE_assets');
					else
						babyArrow.frames = Paths.getSparrowAtlas('ui/NOTE_assets');
					babyArrow.animation.addByPrefix('green', 'arrowUP');
					babyArrow.animation.addByPrefix('blue', 'arrowDOWN');
					babyArrow.animation.addByPrefix('purple', 'arrowLEFT');
					babyArrow.animation.addByPrefix('red', 'arrowRIGHT');

					babyArrow.antialiasing = true;
					babyArrow.setGraphicSize(Std.int(babyArrow.width * 0.7));

					switch (Math.abs(i))
					{
						case 2:
							babyArrow.x += Note.swagWidth * 2;
							babyArrow.animation.addByPrefix('static', 'arrowUP');
							babyArrow.animation.addByPrefix('pressed', 'up press', 24, false);
							babyArrow.animation.addByPrefix('confirm', 'up confirm', 24, false);
						case 3:
							babyArrow.x += Note.swagWidth * 3;
							babyArrow.animation.addByPrefix('static', 'arrowRIGHT');
							babyArrow.animation.addByPrefix('pressed', 'right press', 24, false);
							babyArrow.animation.addByPrefix('confirm', 'right confirm', 24, false);
						case 1:
							babyArrow.x += Note.swagWidth * 1;
							babyArrow.animation.addByPrefix('static', 'arrowDOWN');
							babyArrow.animation.addByPrefix('pressed', 'down press', 24, false);
							babyArrow.animation.addByPrefix('confirm', 'down confirm', 24, false);
						case 0:
							babyArrow.x += Note.swagWidth * 0;
							babyArrow.animation.addByPrefix('static', 'arrowLEFT');
							babyArrow.animation.addByPrefix('pressed', 'left press', 24, false);
							babyArrow.animation.addByPrefix('confirm', 'left confirm', 24, false);
					}
			}

			babyArrow.updateHitbox();
			babyArrow.scrollFactor.set();

			if (!instant)
			{
				babyArrow.y -= 10;
				babyArrow.alpha = 0;
				FlxTween.tween(babyArrow, {y: babyArrow.y + 10, alpha: 1}, 1, {ease: FlxEase.circOut, startDelay: 0.5 + (0.2 * i)});
			}

			babyArrow.ID = i;

			babyArrow.x += 50;

			if (player == 1)
			{
				playerStrums.add(babyArrow);
				babyArrow.animation.finishCallback = function(name:String)
				{
					if (autoplay)
					{
						if (name == "confirm")
						{
							babyArrow.animation.play('static', true);
							babyArrow.centerOffsets();
						}
					}
				}

				if (!Config.centeredNotes)
				{
					babyArrow.x += ((FlxG.width / 2));
				}
				else
				{
					babyArrow.x += ((FlxG.width / 4));
				}
			}
			else
			{
				enemyStrums.add(babyArrow);
				babyArrow.animation.finishCallback = function(name:String)
				{
					if (name == "confirm")
					{
						babyArrow.animation.play('static', true);
						babyArrow.centerOffsets();
					}
				}

				if (Config.centeredNotes)
				{
					babyArrow.x -= 1280;
				}
			}

			babyArrow.animation.play('static');

			strumLineNotes.add(babyArrow);
		}
	}

	override function openSubState(SubState:FlxSubState)
	{
		if (paused)
		{
			if (FlxG.sound.music != null)
			{
				FlxG.sound.music.pause();
				vocals.pause();
			}

			if (startTimer != null && !startTimer.finished)
				startTimer.active = false;
		}

		super.openSubState(SubState);
	}

	override function closeSubState()
	{
		PlayerSettings.gameControls();

		if (paused)
		{
			if (FlxG.sound.music != null && !startingSong)
			{
				resyncVocals();
			}

			if (startTimer != null && !startTimer.finished)
				startTimer.active = true;
			paused = false;
		}

		setBoyfriendInvuln(1 / 60);

		super.closeSubState();
	}

	function resyncVocals():Void
	{
		vocals.pause();
		FlxG.sound.music.play();
		Conductor.songPosition = FlxG.sound.music.time;
		if (Conductor.songPosition <= vocals.length)
		{
			vocals.time = Conductor.songPosition;
			vocals.play();
		}

		trace("resyncing vocals");
	}

	private var paused:Bool = false;
	var startedCountdown:Bool = false;
	var canPause:Bool = true;

	function truncateFloat(number:Float, precision:Int):Float
	{
		var num = number;
		num = num * Math.pow(10, precision);
		num = Math.round(num) / Math.pow(10, precision);
		return num;
	}

	override public function update(elapsed:Float)
	{
		#if EXPERIMENTAL_LUA
		//////// YET EVEN MORE LUA SHIT
		if (executeModchart && luaModchart != null && songStarted)
		{
			luaModchart.setVar('songPos', Conductor.songPosition);
			luaModchart.setVar('hudZoom', camHUD.zoom);
			luaModchart.setVar('cameraZoom', FlxG.camera.zoom);
			luaModchart.executeState('update', [elapsed]);

			/*for (i in 0...strumLineNotes.length) {
				var member = strumLineNotes.members[i];
				member.x = getVar("strum" + i + "X", "float");
				member.y = getVar("strum" + i + "Y", "float");
				member.angle = getVar("strum" + i + "Angle", "float");
			}*/

			FlxG.camera.angle = luaModchart.getVar('cameraAngle', 'float');
			camHUD.angle = luaModchart.getVar('camHudAngle', 'float');

			if (luaModchart.getVar("showOnlyStrums", 'bool'))
			{
				healthBarBG.visible = false;
				healthBar.visible = false;
				iconP1.visible = false;
				iconP2.visible = false;

				// normal hud
				if (!scratchSongs.contains(SONG.song.toLowerCase()))
				{
					scoreTxt.visible = false;
				}

				// scratch hud
				if (scratchSongs.contains(SONG.song.toLowerCase()))
				{
					scoreScratchBG.visible = false;
					ratingScratchBG.visible = false;
					missesScratchBG.visible = false;
					scoreScratchTxt.visible = false;
					ratingScratchTxt.visible = false;
					missesScratchTxt.visible = false;
				}
			}
			else
			{
				healthBarBG.visible = true;
				healthBar.visible = true;
				iconP1.visible = true;
				iconP2.visible = true;
				// normal hud
				if (!scratchSongs.contains(SONG.song.toLowerCase()))
				{
					scoreTxt.visible = !autoplay;
				}

				// scratch hud
				if (scratchSongs.contains(SONG.song.toLowerCase()))
				{
					scoreScratchBG.visible = !autoplay;
					ratingScratchBG.visible = !autoplay;
					missesScratchBG.visible = !autoplay;
					scoreScratchTxt.visible = !autoplay;
					ratingScratchTxt.visible = !autoplay;
					missesScratchTxt.visible = !autoplay;
				}
			}

			var p1 = luaModchart.getVar("strumLine1Visible", 'bool');
			var p2 = luaModchart.getVar("strumLine2Visible", 'bool');

			for (i in 0...4)
			{
				if (i <= enemyStrums.length)
					enemyStrums.members[i].visible = p1;
				if (i <= playerStrums.length)
					playerStrums.members[i].visible = p2;
			}
		}
		//////// CEASE LUA SHIT YET AGAIN
		#end

		if (invulnTime > 0)
		{
			invulnTime -= elapsed;
			// trace(invulnTime);
			if (invulnTime <= 0)
			{
				invuln = false;
			}
		}

		if (missTime > 0)
		{
			missTime -= elapsed;
			// trace(missTime);
			if (missTime <= 0)
			{
				canHit = false;
			}
		}

		keyCheck();

		for (i in 0...releaseTimes.length)
		{
			if (releaseTimes[i] != -1)
			{
				releaseTimes[i] += elapsed;
				// trace(i + ": " + releaseTimes[i]);
			}
		}

		if (!inCutscene)
		{
			if (!autoplay)
			{
				keyShit();
			}
			else
			{
				keyShitAuto();
			}
		}

		if (FlxG.keys.pressed.SHIFT && FlxG.keys.justPressed.TAB && !isStoryMode)
		{
			autoplay = !autoplay;
			usedAutoplay = true;

			scoreTxt.visible = !autoplay;

			scoreScratchBG.visible = !autoplay;
			ratingScratchBG.visible = !autoplay;
			missesScratchBG.visible = !autoplay;
			scoreScratchTxt.visible = !autoplay;
			ratingScratchTxt.visible = !autoplay;
			missesScratchTxt.visible = !autoplay;

			autoplayText.visible = autoplay;
		}

		/* if (FlxG.keys.justPressed.NINE)
			{
				if (iconP1.animation.curAnim.name == 'bf-old')
					iconP1.animation.play(boyfriend.iconName);
				else
					iconP1.animation.play('bf-old');
		}*/

		if (!startingSong)
		{
			for (i in eventList)
			{
				if (i[0] > Conductor.songPosition)
				{
					break;
				}
				else
				{
					executeEvent(i[1]);
					eventList.remove(i);
				}
			}
		}

		stage.update(elapsed);

		super.update(elapsed);

		scoreScratchTxt.text = Std.string(songScore);

		switch (Config.accuracy)
		{
			case "none":
				scoreTxt.text = "Score: " + songScore + " [" + textRating + "]";
				ratingScratchTxt.text = textRating;
				if (Config.showComboBreaks)
				{
					missesScratchTxt.text = Std.string(comboBreaks);
				}
				else
				{
					missesScratchTxt.text = Std.string(misses);
				}
			default:
				if (curBeat % 4 < 2)
				{
					ratingScratchTxt.text = truncateFloat(accuracy, 2) + "%";
				}
				else
				{
					ratingScratchTxt.text = textRating;
				}

				if (Config.showComboBreaks)
				{
					scoreTxt.text = "Score: " + songScore + " | Combo Breaks: " + comboBreaks + " | Accuracy: " + truncateFloat(accuracy, 2) + "% ["
						+ textRating + "]";
					missesScratchTxt.text = Std.string(comboBreaks);
				}
				else
				{
					scoreTxt.text = "Score: " + songScore + " | Misses: " + misses + " | Accuracy: " + truncateFloat(accuracy, 2) + "% [" + textRating + "]";
					missesScratchTxt.text = Std.string(misses);
				}
		}

		if (ratingScratchTxt.width > 119)
		{
			ratingScratchTxt.scale.x = 119 / ratingScratchTxt.width;
			ratingScratchTxt.x = 579 - ((ratingScratchTxt.width - 119) / 2);
		}
		else
		{
			ratingScratchTxt.scale.x = 1;
			ratingScratchTxt.screenCenter(X);
		}

		if (controls.PAUSE && startedCountdown && canPause)
		{
			persistentUpdate = false;
			persistentDraw = true;
			paused = true;

			PlayerSettings.menuControls();

			openSubState(new PauseSubState(boyfriend.getScreenPosition().x, boyfriend.getScreenPosition().y));
		}

		if (FlxG.keys.justPressed.SEVEN)
		{
			PlayerSettings.menuControls();
			switchState(new ChartingState());

			#if EXPERIMENTAL_LUA
			if (luaModchart != null)
			{
				luaModchart.die();
				luaModchart = null;
			}
			#end
			sectionStart = false;
		}

		var iconOffset:Int = 26;

		iconP1.x = healthBar.x + (healthBar.width * (FlxMath.remapToRange(healthBar.percent, 0, 100, 100, 0) * 0.01) - iconOffset);
		iconP2.x = healthBar.x + (healthBar.width * (FlxMath.remapToRange(healthBar.percent, 0, 100, 100, 0) * 0.01)) - (iconP2.width - iconOffset);

		if (health > 2)
		{
			health = 2;
		}

		if (healthLerp != health)
		{
			healthLerp = CoolUtil.fpsAdjsutedLerp(healthLerp, health, 0.7);
		}
		if (inRange(healthLerp, 2, 0.001))
		{
			healthLerp = 2;
		}
		// trace(healthLerp);

		// Health Icons
		if (healthBar.percent < 20)
		{
			iconP1.animation.curAnim.curFrame = 1;
			iconP2.animation.curAnim.curFrame = 2;
		}
		else if (healthBar.percent > 80)
		{
			iconP1.animation.curAnim.curFrame = 2;
			iconP2.animation.curAnim.curFrame = 1;
		}
		else
		{
			iconP1.animation.curAnim.curFrame = 0;
			iconP2.animation.curAnim.curFrame = 0;
		}

		// marco bosta
		var marcoBar:Bool = true;

		if (marcoballGimmickSongs.contains(SONG.song.toLowerCase()))
		{
			if (marcoHealth > 0)
			{
				healthBar.createFilledBar(dad.characterColor, 0xFFFFFF00);
				marcoHealth -= 0.05;
				health -= 0.00125;
			}
			else
			{
				if (marcoBar)
				{
					healthBar.createFilledBar(dad.characterColor, boyfriend.characterColor);
					marcoBar = false;
				}
			}
			healthBar.percent = (healthLerp * 50);
		}
		/* if (FlxG.keys.justPressed.NINE)
			switchState(new Charting()); */

		if (FlxG.keys.justPressed.EIGHT)
		{
			PlayerSettings.menuControls();
			sectionStart = false;

			if (FlxG.keys.pressed.SHIFT)
			{
				switchState(new AnimationDebug(boyfriend.curCharacter));
			}
			else if (FlxG.keys.pressed.CONTROL)
			{
				switchState(new AnimationDebug(gf.curCharacter));
			}
			else
			{
				switchState(new AnimationDebug(dad.curCharacter));
			}
		}

		if (startingSong)
		{
			if (startedCountdown)
			{
				Conductor.songPosition += FlxG.elapsed * 1000;
				if (Conductor.songPosition >= 0)
					startSong();
			}
		}
		else
		{
			// Conductor.songPosition = FlxG.sound.music.time;
			Conductor.songPosition += FlxG.elapsed * 1000;

			if (!paused)
			{
				songTime += FlxG.game.ticks - previousFrameTime;
				previousFrameTime = FlxG.game.ticks;

				// Interpolation type beat
				if (Conductor.lastSongPos != Conductor.songPosition)
				{
					songTime = (songTime + Conductor.songPosition) / 2;
					Conductor.lastSongPos = Conductor.songPosition;
					// Conductor.songPosition += FlxG.elapsed * 1000;
					// trace('MISSED FRAME');
				}
			}

			// Conductor.lastSongPos = FlxG.sound.music.time;
		}

		if (generatedMusic && PlayState.SONG.notes[Std.int(curStep / 16)] != null)
		{
			if (curBeat % 4 == 0)
			{
				// trace(PlayState.SONG.notes[Std.int(curStep / 16)].mustHitSection);
			}

			if (camFocus != "dad" && !PlayState.SONG.notes[Std.int(curStep / 16)].mustHitSection && autoCam)
			{
				camFocusOpponent();
			}

			if (camFocus != "bf" && PlayState.SONG.notes[Std.int(curStep / 16)].mustHitSection && autoCam)
			{
				camFocusBF();
			}
		}

		// FlxG.watch.addQuick("totalBeats: ", totalBeats);

		// RESET = Quick Game Over Screen
		if (controls.RESET && !startingSong)
		{
			health = 0;
			// trace("RESET = True");
		}

		// CHEAT = brandon's a pussy
		if (controls.CHEAT)
		{
			health += 1;
			// trace("User is cheating!");
		}

		if (health <= 0)
		{
			// boyfriend.stunned = true;

			persistentUpdate = false;
			persistentDraw = false;
			paused = true;

			vocals.stop();
			FlxG.sound.music.stop();

			PlayerSettings.menuControls();

			openSubState(new GameOverSubstate(boyfriend.getScreenPosition().x, boyfriend.getScreenPosition().y, camFollow.getScreenPosition().x,
				camFollow.getScreenPosition().y, boyfriend.deathCharacter));
			sectionStart = false;
		}

		if (unspawnNotes[0] != null)
		{
			if (unspawnNotes[0].strumTime - Conductor.songPosition < 3000)
			{
				var dunceNote:Note = unspawnNotes[0];
				notes.add(dunceNote);

				var index:Int = unspawnNotes.indexOf(dunceNote);
				unspawnNotes.splice(index, 1);

				sortNotes();
			}
		}

		if (generatedMusic)
		{
			updateNote();
			opponentNoteCheck();
		}

		#if debug
		if (FlxG.keys.justPressed.ONE)
			endSong();
		#end

		leftPress = false;
		leftRelease = false;
		downPress = false;
		downRelease = false;
		upPress = false;
		upRelease = false;
		rightPress = false;
		rightRelease = false;

		for (i in 0...releaseTimes.length)
		{
			if (releaseTimes[i] >= releaseBufferTime)
			{
				releaseTimes[i] = -1;
				// trace(i + ": reset");
			}
		}
	}

	function updateNote()
	{
		notes.forEachAlive(function(daNote:Note)
		{
			var targetY:Float;
			var targetX:Float;
			var targetAngle:Float;
			var targetModAngle:Float;
			var targetAlpha:Float;

			var scrollSpeed:Float;

			var hypotheticalY:Float;

			if (daNote.mustPress)
			{
				targetY = playerStrums.members[Math.floor(Math.abs(daNote.noteData))].y;
				targetX = playerStrums.members[Math.floor(Math.abs(daNote.noteData))].x;
				targetAngle = playerStrums.members[Math.floor(Math.abs(daNote.noteData))].angle;
				targetModAngle = playerStrums.members[Math.floor(Math.abs(daNote.noteData))].modAngle;
				targetAlpha = playerStrums.members[Math.floor(Math.abs(daNote.noteData))].alpha;
			}
			else
			{
				targetY = enemyStrums.members[Math.floor(Math.abs(daNote.noteData))].y;
				targetX = enemyStrums.members[Math.floor(Math.abs(daNote.noteData))].x;
				targetAngle = enemyStrums.members[Math.floor(Math.abs(daNote.noteData))].angle;
				targetModAngle = enemyStrums.members[Math.floor(Math.abs(daNote.noteData))].modAngle;
				targetAlpha = enemyStrums.members[Math.floor(Math.abs(daNote.noteData))].alpha;
			}

			if (Config.scrollSpeedOverride > 0)
			{
				scrollSpeed = Config.scrollSpeedOverride;
			}
			else
			{
				scrollSpeed = FlxMath.roundDecimal(PlayState.SONG.speed, 2);
			}

			var sinShit:Float = Math.sin((targetModAngle) * FlxAngle.TO_RAD);
			var cosShit:Float = Math.cos((targetModAngle) * FlxAngle.TO_RAD);

			if (Config.downscroll)
			{
				hypotheticalY = ((Conductor.songPosition - daNote.strumTime) * (0.45 * scrollSpeed));
				daNote.y = targetY + (hypotheticalY * cosShit);

				if (daNote.isSustainNote)
				{
					daNote.y -= daNote.height;
					daNote.y += 125;

					if ((!daNote.mustPress || daNote.wasGoodHit || daNote.prevNote.wasGoodHit && !daNote.canBeHit)
						&& (strumLine.y + hypotheticalY) - daNote.offset.y * daNote.scale.y + daNote.height >= (strumLine.y + Note.swagWidth / 2))
					{
						// Clip to strumline
						var swagRect = new FlxRect(0, 0, daNote.frameWidth * 2, daNote.frameHeight * 2);
						swagRect.height = (targetY + Note.swagWidth / 2 - daNote.y) / daNote.scale.y;
						swagRect.y = daNote.frameHeight - swagRect.height;
	
						daNote.clipRect = swagRect;
					}

					daNote.x -= (daNote.height * sinShit);
					daNote.x += (125 * sinShit);					
					daNote.y += (daNote.height * sinShit);
					daNote.y -= (125 * sinShit);
				}
			}
			else
			{
				hypotheticalY = ((Conductor.songPosition - daNote.strumTime) * (0.45 * scrollSpeed));
				daNote.y = targetY - (hypotheticalY * cosShit);

				if (daNote.isSustainNote)
				{
					if ((!daNote.mustPress || daNote.wasGoodHit || daNote.prevNote.wasGoodHit && !daNote.canBeHit)
						&& (strumLine.y - hypotheticalY) + daNote.offset.y * daNote.scale.y <= (strumLine.y + Note.swagWidth / 2))
					{
						// Clip to strumline
						var swagRect = new FlxRect(0, 0, daNote.width / daNote.scale.x, daNote.height / daNote.scale.y);
						swagRect.y = (targetY + Note.swagWidth / 2 - daNote.y) / daNote.scale.y;
						swagRect.height -= swagRect.y;

						daNote.clipRect = swagRect;
					}
				}
			}

			if (!daNote.isSustainNote)
				daNote.angle = targetAngle;

			if (daNote.isSustainNote)
				daNote.angle = 0 - targetModAngle;

			if (!daNote.modifiedByLua)
			{
				if (!daNote.tooLate && targetAlpha != 1)
				{
					if (daNote.isSustainNote)
						daNote.alpha = targetAlpha * 0.6;
					else
						daNote.alpha = targetAlpha;
				}

				daNote.x = targetX + daNote.xOffset;
				daNote.x += hypotheticalY * sinShit;
			}

			// MOVE NOTE TRANSPARENCY CODE BECAUSE REASONS
			if (daNote.tooLate)
			{
				if (daNote.alpha > 0.3)
				{
					switch (daNote.type)
					{
						case "":
							vocals.volume = 0;
							noteMiss(daNote.noteData, daNote.type, 0.055, false, true);
						case "BULLET":
							vocals.volume = 0;
							marcoHealth = 10;
							noteMiss(daNote.noteData, daNote.type, 0.35, false, true);
					}

					daNote.alpha = 0.3;
				}
			}

			if ((Config.downscroll ? (daNote.y > targetY + ((daNote.height + 50) * cosShit)) : (daNote.y < targetY - ((daNote.height - 50) * cosShit))
				|| ((daNote.x < targetX - ((daNote.height - 50) * sinShit)))))
			{
				if (daNote.tooLate || daNote.wasGoodHit)
				{
					daNote.active = false;
					daNote.visible = false;
					daNote.destroy();
				}
			}
		});
	}

	function opponentNoteCheck()
	{
		notes.forEachAlive(function(daNote:Note)
		{
			if (!daNote.mustPress && daNote.canBeHit && !daNote.wasGoodHit)
			{
				daNote.wasGoodHit = true;

				var altAnim:String = "";

				if (SONG.notes[Math.floor(curStep / 16)] != null)
				{
					if (SONG.notes[Math.floor(curStep / 16)].altAnim)
						altAnim = '-alt';
				}

				// trace("DA ALT THO?: " + SONG.notes[Math.floor(curStep / 16)].altAnim);

				if (dad.canAutoAnim
					&& (Character.LOOP_ANIM_ON_HOLD ? (daNote.isSustainNote ? (Character.HOLD_LOOP_WAIT ? (!dad.animation.name.contains("sing")
						|| (dad.animation.curAnim.curFrame >= 3 || dad.animation.curAnim.finished)) : true) : true) : !daNote.isSustainNote))
				{
					switch (Math.abs(daNote.noteData))
					{
						case 2:
							dad.playAnim('singUP' + altAnim, true);
						case 3:
							dad.playAnim('singRIGHT' + altAnim, true);
						case 1:
							dad.playAnim('singDOWN' + altAnim, true);
						case 0:
							dad.playAnim('singLEFT' + altAnim, true);
					}
				}

				#if EXPERIMENTAL_LUA
				if (luaModchart != null)
					luaModchart.executeState('playerTwoSing', [Math.abs(daNote.noteData), Conductor.songPosition]);
				#end

				enemyStrums.forEach(function(spr:SwagStrum)
				{
					if (Math.abs(daNote.noteData) == spr.ID)
					{
						spr.animation.play('confirm', true);
						if (spr.animation.curAnim.name == 'confirm' && !(stage.uiType == "pixel"))
						{
							spr.centerOffsets();
							spr.offset.x -= 14;
							spr.offset.y -= 14;
						}
						else
							spr.centerOffsets();
					}
				});

				dad.holdTimer = 0;

				if (SONG.needsVoices)
					vocals.volume = 1;

				if (!daNote.isSustainNote)
				{
					daNote.destroy();
				}
			}
		});
	}

	public function endSong():Void
	{
		#if EXPERIMENTAL_LUA
		if (luaModchart != null)
		{
			luaModchart.die();
			luaModchart = null;
		}
		#end

		canPause = false;
		FlxG.sound.music.volume = 0;
		vocals.volume = 0;
		if (SONG.validScore && !usedAutoplay)
		{
			#if !switch
			Highscore.saveScore(SONG.song, songScore, storyDifficulty);
			#end
		}

		if (isStoryMode)
		{
			campaignScore += songScore;

			storyPlaylist.remove(storyPlaylist[0]);

			if (storyPlaylist.length <= 0)
			{
				FlxG.sound.playMusic(Paths.music("coolMenu"), 1);

				PlayerSettings.menuControls();

				#if EXPERIMENTAL_LUA
				if (luaModchart != null)
				{
					luaModchart.die();
					luaModchart = null;
				}
				#end

				switchState(new StoryMenuState());
				sectionStart = false;

				// if ()
				StoryMenuState.weekUnlocked[Std.int(Math.min(storyWeek + 1, StoryMenuState.weekUnlocked.length - 1))] = true;

				if (SONG.validScore)
				{
					Highscore.saveWeekScore(storyWeek, campaignScore, storyDifficulty);
				}

				FlxG.save.data.weekUnlocked = StoryMenuState.weekUnlocked;
				FlxG.save.flush();
			}
			else
			{
				var difficulty:String = "";

				if (storyDifficulty == 0)
					difficulty = '-easy';

				if (storyDifficulty == 2)
					difficulty = '-hard';

				// trace('LOADING NEXT SONG');
				// trace(PlayState.storyPlaylist[0].toLowerCase() + difficulty);

				if (SONG.song.toLowerCase() == 'eggnog')
				{
					var blackShit:FlxSprite = new FlxSprite(-FlxG.width * FlxG.camera.zoom,
						-FlxG.height * FlxG.camera.zoom).makeGraphic(FlxG.width * 3, FlxG.height * 3, FlxColor.BLACK);
					blackShit.scrollFactor.set();
					add(blackShit);
					camHUD.visible = false;

					FlxG.sound.play(Paths.sound('Lights_Shut_off'));
				}

				if (SONG.song.toLowerCase() == 'senpai')
				{
					transIn = null;
					transOut = null;
					prevCamFollow = camFollow;
				}

				PlayState.SONG = Song.loadFromJson(PlayState.storyPlaylist[0].toLowerCase() + difficulty, PlayState.storyPlaylist[0]);
				FlxG.sound.music.stop();

				switchState(new PlayState());

				transIn = FlxTransitionableState.defaultTransIn;
				transOut = FlxTransitionableState.defaultTransOut;
			}
		}
		else
		{
			PlayerSettings.menuControls();
			sectionStart = false;

			switchState(new FreeplayState());
		}
	}

	var endingSong:Bool = false;

	private function popUpScore(note:Note):Void
	{
		var strumtime = note.strumTime;

		var noteDiff:Float = Math.abs(strumtime - Conductor.songPosition);
		var score:Int = Conductor.timingScores[0];
		var daRating:String = "sick";

		if (noteDiff > Conductor.timings[2])
		{
			daRating = 'shit';
			if (Config.accuracy == "complex")
			{
				totalNotesHit += Conductor.timingAccuracies[3];
			}
			else
			{
				totalNotesHit += Conductor.timingAccuracies[0];
			}
			score = Conductor.timingScores[3];
			shits += 1;

			if (Config.noteSplashType == 2)
			{
				createNoteSplash(note.noteData);
			}
		}
		else if (noteDiff > Conductor.timings[1])
		{
			daRating = 'bad';
			score = Conductor.timingScores[2];
			bads += 1;

			if (Config.accuracy == "complex")
			{
				totalNotesHit += Conductor.timingAccuracies[2];
			}
			else
			{
				totalNotesHit += Conductor.timingAccuracies[0];
			}

			if (Config.noteSplashType == 2)
			{
				createNoteSplash(note.noteData);
			}
		}
		else if (noteDiff > Conductor.timings[0])
		{
			daRating = 'good';
			if (Config.accuracy == "complex")
			{
				totalNotesHit += Conductor.timingAccuracies[1];
			}
			else
			{
				totalNotesHit += Conductor.timingAccuracies[0];
			}
			score = Conductor.timingScores[1];
			goods += 1;

			if (Config.noteSplashType == 2)
			{
				createNoteSplash(note.noteData);
			}
		}
		if (daRating == 'sick')
		{
			totalNotesHit += Conductor.timingAccuracies[0];
			sicks += 1;

			if (Config.noteSplashType > 0)
			{
				createNoteSplash(note.noteData);
			}
		}

		// trace('hit ' + daRating);

		songScore += score;

		comboUI.ratingPopup(daRating, noteDiff);

		// if (combo >= minCombo)
		comboUI.comboPopup(combo);
	}

	private function createNoteSplash(note:Int)
	{
		var bigSplashy = new NoteSplash(playerStrums.members[note].x, playerStrums.members[note].y, note);
		bigSplashy.cameras = [camHUD];
		add(bigSplashy);
	}

	private function keyCheck():Void
	{
		upTime = controls.UP ? upTime + 1 : 0;
		downTime = controls.DOWN ? downTime + 1 : 0;
		leftTime = controls.LEFT ? leftTime + 1 : 0;
		rightTime = controls.RIGHT ? rightTime + 1 : 0;

		upPress = upTime == 1;
		downPress = downTime == 1;
		leftPress = leftTime == 1;
		rightPress = rightTime == 1;

		upRelease = upHold && upTime == 0;
		downRelease = downHold && downTime == 0;
		leftRelease = leftHold && leftTime == 0;
		rightRelease = rightHold && rightTime == 0;

		upHold = upTime > 0;
		downHold = downTime > 0;
		leftHold = leftTime > 0;
		rightHold = rightTime > 0;

		if (leftRelease)
		{
			releaseTimes[0] = 0;
		}
		else if (leftPress)
		{
			releaseTimes[0] = -1;
		}

		if (downRelease)
		{
			releaseTimes[1] = 0;
		}
		else if (downPress)
		{
			releaseTimes[1] = -1;
		}

		if (upRelease)
		{
			releaseTimes[2] = 0;
		}
		else if (upPress)
		{
			releaseTimes[2] = -1;
		}

		if (rightRelease)
		{
			releaseTimes[3] = 0;
		}
		else if (rightPress)
		{
			releaseTimes[3] = -1;
		}

		/*THE FUNNY 4AM CODE! [bro what was i doin????]
			trace((leftHold?(leftPress?"^":"|"):(leftRelease?"^":" "))+(downHold?(downPress?"^":"|"):(downRelease?"^":" "))+(upHold?(upPress?"^":"|"):(upRelease?"^":" "))+(rightHold?(rightPress?"^":"|"):(rightRelease?"^":" ")));
			I should probably remove this from the code because it literally serves no purpose, but I'm gonna keep it in because I think it's funny.
			It just sorta prints 4 lines in the console that look like the arrows being pressed. Looks something like this:
			====
			^  | 
			| ^|
			| |^
			^ |
			==== */
	}

	private function keyShit():Void
	{
		var controlArray:Array<Bool> = [leftPress, downPress, upPress, rightPress];
		var controlArrayHold:Array<Bool> = [leftHold, downHold, upHold, rightHold];

		if ((upPress || rightPress || downPress || leftPress) && generatedMusic)
		{
			boyfriend.holdTimer = 0;

			var possibleNotes:Array<Note> = [];

			var ignoreList:Array<Int> = [];

			notes.forEachAlive(function(daNote:Note)
			{
				if (daNote.canBeHit && daNote.mustPress && !daNote.tooLate)
				{
					// the sorting probably doesn't need to be in here? who cares lol
					possibleNotes.push(daNote);
					possibleNotes.sort((a, b) -> Std.int(a.strumTime - b.strumTime));

					for (i in daNote.noteData...(daNote.noteData + daNote.noteWidth))
					{
						ignoreList.push(i);
					}

					if (Config.ghostTapType == 1)
					{
						setCanMiss();
					}
				}
			});

			var directionsAccounted = [false, false, false, false];

			if (possibleNotes.length > 0)
			{
				for (note in possibleNotes)
				{
					if (note.noteWidth == 1)
					{
						if (controlArray[note.noteData] && !directionsAccounted[note.noteData])
						{
							goodNoteHit(note);
							directionsAccounted[note.noteData] = true;
						}
					}

					// shit code ughhhhhhh
					if (note.noteWidth == 2)
					{
						var firstInputValid1st = controlArrayHold[note.noteData] && !directionsAccounted[note.noteData];
						var secondInputValid1st = controlArrayHold[note.noteData + 1] && !directionsAccounted[note.noteData + 1];
						var firstInputValid2nd = controlArray[note.noteData] && !directionsAccounted[note.noteData];
						var secondInputValid2nd = controlArray[note.noteData + 1] && !directionsAccounted[note.noteData + 1];

						if (firstInputValid1st || secondInputValid1st)
						{
							if (secondInputValid1st)
							{
								if (firstInputValid2nd)
								{
									goodNoteHit(note);
									directionsAccounted[note.noteData] = true;
									directionsAccounted[note.noteData + 1] = true;
								}
							}

							if (firstInputValid1st)
							{
								if (secondInputValid2nd)
								{
									goodNoteHit(note);
									directionsAccounted[note.noteData] = true;
									directionsAccounted[note.noteData + 1] = true;
								}
							}
						}
					}
				}
				for (i in 0...4)
				{
					if (!ignoreList.contains(i) && controlArray[i])
					{
						badNoteCheck(i);
					}
				}
			}
			else
			{
				badNoteCheck();
			}
		}

		notes.forEachAlive(function(daNote:Note)
		{
			if ((upHold || rightHold || downHold || leftHold) && generatedMusic)
			{
				if (daNote.canBeHit && daNote.mustPress && daNote.isSustainNote)
				{
					boyfriend.holdTimer = 0;

					switch (daNote.noteData)
					{
						// NOTES YOU ARE HOLDING
						case 2:
							if (upHold)
								goodNoteHit(daNote);
						case 3:
							if (rightHold)
								goodNoteHit(daNote);
						case 1:
							if (downHold)
								goodNoteHit(daNote);
						case 0:
							if (leftHold)
								goodNoteHit(daNote);
					}
				}
			}

			// Guitar Hero Type Held Notes
			if (daNote.isSustainNote && daNote.mustPress)
			{
				// This is for all subsequent released notes.
				if (daNote.prevNote.tooLate && !daNote.prevNote.wasGoodHit)
				{
					daNote.tooLate = true;
					daNote.destroy();
					updateAccuracy();
					noteMiss(daNote.noteData, daNote.type, 0.0425, false, true, false, false);
				}

				// This is for the first released note.
				if (daNote.prevNote.wasGoodHit && !daNote.wasGoodHit)
				{
					var doTheMiss:Bool = false;

					doTheMiss = releaseTimes[daNote.noteData] >= releaseBufferTime;

					/* switch(daNote.noteData){
						case 0:
							doTheMiss = leftRelease;
						case 1:
							doTheMiss = downRelease;
						case 2:
							doTheMiss = upRelease;
						case 3:
							doTheMiss = rightRelease;
					}*/

					if (doTheMiss)
					{
						noteMiss(daNote.noteData, daNote.type, 0.055, true, true, false, true);
						vocals.volume = 0;
						daNote.tooLate = true;
						daNote.destroy();
						boyfriend.holdTimer = 0;
						updateAccuracy();

						var recursiveNote = daNote;
						while (recursiveNote.prevNote != null && recursiveNote.prevNote.exists && recursiveNote.prevNote.isSustainNote)
						{
							recursiveNote.prevNote.visible = false;
							recursiveNote = recursiveNote.prevNote;
						}
					}
				}
			}
		});

		if (boyfriend.holdTimer > Conductor.stepCrochet * boyfriend.stepsUntilRelease * 0.001
			&& !upHold
			&& !downHold
			&& !rightHold
			&& !leftHold)
		{
			if (boyfriend.animation.curAnim.name.startsWith('sing'))
			{
				if (Character.USE_IDLE_END)
				{
					boyfriend.idleEnd();
				}
				else
				{
					boyfriend.dance();
					boyfriend.danceLockout = true;
				}
			}
		}

		playerStrums.forEach(function(spr:SwagStrum)
		{
			switch (spr.ID)
			{
				case 2:
					if (upPress && spr.animation.curAnim.name != 'confirm')
						spr.animation.play('pressed');
					if (!upHold)
						spr.animation.play('static');
				case 3:
					if (rightPress && spr.animation.curAnim.name != 'confirm')
						spr.animation.play('pressed');
					if (!rightHold)
						spr.animation.play('static');
				case 1:
					if (downPress && spr.animation.curAnim.name != 'confirm')
						spr.animation.play('pressed');
					if (!downHold)
						spr.animation.play('static');
				case 0:
					if (leftPress && spr.animation.curAnim.name != 'confirm')
						spr.animation.play('pressed');
					if (!leftHold)
						spr.animation.play('static');
			}

			switch (spr.animation.curAnim.name)
			{
				case "confirm":
					// spr.alpha = 1;
					spr.centerOffsets();

					if (!(stage.uiType == "pixel"))
					{
						spr.offset.x -= 14;
						spr.offset.y -= 14;
					}

				/*case "static":
					spr.alpha = 0.5; //Might mess around with strum transparency in the future or something.
					spr.centerOffsets(); */

				default:
					// spr.alpha = 1;
					spr.centerOffsets();
			}
		});
	}

	private function keyShitAuto():Void
	{
		var hitNotes:Array<Note> = [];

		notes.forEachAlive(function(daNote:Note)
		{
			if (daNote.mustPress
				&& daNote.strumTime < Conductor.songPosition + Conductor.timings[2] * (!daNote.isSustainNote ? 0.125 : (daNote.prevNote.wasGoodHit ? 1 : 0)))
			{
				if (daNote.type != "JOLA")
				{
					hitNotes.push(daNote);
				}
			}
		});

		if (boyfriend.holdTimer > Conductor.stepCrochet * boyfriend.stepsUntilRelease * 0.001
			&& !upHold
			&& !downHold
			&& !rightHold
			&& !leftHold)
		{
			if (boyfriend.animation.curAnim.name.startsWith('sing'))
			{
				if (Character.USE_IDLE_END)
				{
					boyfriend.idleEnd();
				}
				else
				{
					boyfriend.dance();
					boyfriend.danceLockout = true;
				}
			}
		}

		for (x in hitNotes)
		{
			boyfriend.holdTimer = 0;

			goodNoteHit(x);

			playerStrums.forEach(function(spr:SwagStrum)
			{
				if (Math.abs(x.noteData) == spr.ID)
				{
					spr.animation.play('confirm', true);
					if (spr.animation.curAnim.name == 'confirm' && !(stage.uiType == "pixel"))
					{
						spr.centerOffsets();
						spr.offset.x -= 14;
						spr.offset.y -= 14;
					}
					else
						spr.centerOffsets();
				}
			});
		}
	}

	function noteMiss(direction:Int = 1, ?type:String = "", ?healthLoss:Float = 0.04, ?playAudio:Bool = true, ?skipInvCheck:Bool = false,
			?countMiss:Bool = true, ?dropCombo:Bool = true, ?invulnTime:Int = 5, ?scoreAdjust:Int = 100):Void
	{
		if (!startingSong && (!invuln || skipInvCheck))
		{
			health -= healthLoss * Config.healthDrainMultiplier;

			if (dropCombo)
			{
				if (combo > minCombo)
				{
					gf.playAnim('sad');
					comboUI.breakPopup();
				}
				combo = 0;
				comboBreaks++;
			}

			if (countMiss)
			{
				misses++;
			}

			songScore -= scoreAdjust;

			if (playAudio)
			{
				FlxG.sound.play(Paths.sound('missnote' + FlxG.random.int(1, 3)), FlxG.random.float(0.1, 0.2));
			}

			setBoyfriendInvuln(invulnTime / 60);

			if (boyfriend.canAutoAnim)
			{
				if (type == "BULLET")
				{
					boyfriend.playAnim('damage', true);
				}
				else
				{
					switch (direction)
					{
						case 2:
							boyfriend.playAnim('singUPmiss', true);
						case 3:
							boyfriend.playAnim('singRIGHTmiss', true);
						case 1:
							boyfriend.playAnim('singDOWNmiss', true);
						case 0:
							boyfriend.playAnim('singLEFTmiss', true);
					}
				}

				#if EXPERIMENTAL_LUA
				if (luaModchart != null)
					luaModchart.executeState('playerOneMiss', [direction, Conductor.songPosition]);
				#end
			}

			updateAccuracy();
		}

		if (Main.flippymode)
		{#if sys System.exit(0); #end
		}
	}

	inline function noteMissWrongPress(direction:Int = 1, ?healthLoss:Float = 0.0475):Void
	{
		noteMiss(direction, "", healthLoss, true, false, false, false, 4, 25);
	}

	function badNoteCheck(direction:Int = -1)
	{
		if (Config.ghostTapType > 0 && !canHit)
		{
		}
		else
		{
			if (leftPress && (direction == -1 || direction == 0))
				noteMissWrongPress(0);
			if (upPress && (direction == -1 || direction == 2))
				noteMissWrongPress(2);
			if (rightPress && (direction == -1 || direction == 3))
				noteMissWrongPress(3);
			if (downPress && (direction == -1 || direction == 1))
				noteMissWrongPress(1);
		}
	}

	function setBoyfriendInvuln(time:Float = 5 / 60)
	{
		if (time > invulnTime)
		{
			invulnTime = time;
			invuln = true;
		}
	}

	function setCanMiss(time:Float = 10 / 60)
	{
		if (time > missTime)
		{
			missTime = time;
			canHit = true;
		}
	}

	/*function setBoyfriendStunned(time:Float = 5 / 60){

		boyfriend.stunned = true;

		new FlxTimer().start(time, function(tmr:FlxTimer)
		{
			boyfriend.stunned = false;
		});

	}*/
	function goodNoteHit(note:Note):Void
	{
		// Guitar Hero Styled Hold Notes
		// This is to make sure that if hold notes are hit out of order they are destroyed. Should not be possible though.
		if (note.isSustainNote && !note.prevNote.wasGoodHit)
		{
			noteMiss(note.noteData, note.type, 0.055, true, true, false);
			vocals.volume = 0;
			note.prevNote.tooLate = true;
			note.prevNote.destroy();
			boyfriend.holdTimer = 0;
			updateAccuracy();
		}
		else if (!note.wasGoodHit)
		{
			if (!note.isSustainNote)
			{
				popUpScore(note);
				combo += 1;
			}
			else
			{
				totalNotesHit += 1;
			}

			switch (note.type)
			{
				case "JOLA":
					health -= 0.03 * Config.healthMultiplier;

				default:
					if (!marcoballGimmickSongs.contains(SONG.song.toLowerCase()))
					{
						if (!note.isSustainNote)
						{
							health += 0.015 * Config.healthMultiplier;
						}
						else
						{
							health += 0.0075 * Config.healthMultiplier;
						}
						health += 0.015 * Config.healthMultiplier;
					}
			}

			if (boyfriend.canAutoAnim
				&& (Character.LOOP_ANIM_ON_HOLD ? (note.isSustainNote ? (Character.HOLD_LOOP_WAIT ? (!boyfriend.animation.name.contains("sing")
					|| (boyfriend.animation.curAnim.curFrame >= 3
						|| boyfriend.animation.curAnim.finished)) : true) : true) : !note.isSustainNote))
			{
				if (note.type == "BULLET")
				{
					boyfriend.playAnim('dodge', true);
				}
				else
				{
					switch (note.noteData)
					{
						case 2:
							boyfriend.playAnim('singUP', true);
						case 3:
							boyfriend.playAnim('singRIGHT', true);
						case 1:
							boyfriend.playAnim('singDOWN', true);
						case 0:
							boyfriend.playAnim('singLEFT', true);
					}
				}
			}

			#if EXPERIMENTAL_LUA
			if (luaModchart != null)
				luaModchart.executeState('playerOneSing', [note.noteData, Conductor.songPosition]);
			#end

			if (!note.isSustainNote)
			{
				setBoyfriendInvuln(2.5 / 60);
			}

			playerStrums.forEach(function(spr:SwagStrum)
			{
				for (i in 0...note.noteWidth)
				{
					if (Math.abs(note.noteData + i) == spr.ID)
					{
						spr.animation.play('confirm', true);
						spr.centerOffsets();
					}
				}
			});

			note.wasGoodHit = true;
			vocals.volume = 1;

			if (!note.isSustainNote)
			{
				note.destroy();
			}

			updateAccuracy();
		}
	}

	override function stepHit()
	{
		if (Math.abs(FlxG.sound.music.time - (Conductor.songPosition)) > 20
			|| (SONG.needsVoices && Math.abs(vocals.time - (Conductor.songPosition)) > 20))
		{
			resyncVocals();
		}

		#if EXPERIMENTAL_LUA
		if (executeModchart && luaModchart != null)
		{
			luaModchart.setVar('curStep', curStep);
			luaModchart.executeState('stepHit', [curStep]);
		}
		#end

		/*if (dad.curCharacter == 'spooky' && totalSteps % 4 == 2)
			{
				// dad.dance();
		}*/

		stage.step(curStep);

		super.stepHit();
	}

	override function beatHit()
	{
		// wiggleShit.update(Conductor.crochet);
		super.beatHit();

		#if EXPERIMENTAL_LUA
		if (executeModchart && luaModchart != null)
		{
			luaModchart.setVar('curBeat', curBeat);
			luaModchart.executeState('beatHit', [curBeat]);
		}
		#end

		if (curBeat % 4 == 0)
		{
			var sec = Math.floor(curBeat / 4);
			if (sec >= sectionHaveNotes.length)
			{
				sec = -1;
			}

			sectionHasBFNotes = sec >= 0 ? sectionHaveNotes[sec][0] : false;
			sectionHasOppNotes = sec >= 0 ? sectionHaveNotes[sec][1] : false;
		}

		// sortNotes();

		if (SONG.notes[Math.floor(curStep / 16)] != null)
		{
			if (SONG.notes[Math.floor(curStep / 16)].changeBPM)
			{
				#if EXPERIMENTAL_LUA
				if (executeModchart && luaModchart != null)
				{
					luaModchart.setVar("bpm", SONG.notes[Math.floor(curStep / 16)].bpm);
				}
				#end
				
				Conductor.changeBPM(SONG.notes[Math.floor(curStep / 16)].bpm);
				FlxG.log.add('CHANGED BPM!');
			}
			// else
			//	Conductor.changeBPM(SONG.bpm);

			// Dad doesnt interupt his own notes
			if (!sectionHasOppNotes)
			{
				if (dadBeats.contains(curBeat % 4) && dad.canAutoAnim && dad.holdTimer == 0)
				{
					dad.dance();
				}
			}
		}
		else
		{
			if (dadBeats.contains(curBeat % 4))
				dad.dance();
		}
		// FlxG.log.add('change bpm' + SONG.notes[Std.int(curStep / 16)].changeBPM);

		if (curBeat % (4 * bopSpeed) == 0 && camZooming)
		{
			//	uiBop();
		}

		if (curBeat % bopSpeed == 0)
		{
			iconP1.iconScale = iconP1.defaultIconScale * 1.25;
			iconP2.iconScale = iconP2.defaultIconScale * 1.25;

			iconP1.tweenToDefaultScale(0.2, FlxEase.quintOut);
			iconP2.tweenToDefaultScale(0.2, FlxEase.quintOut);

			gf.dance();
		}

		if (bfBeats.contains(curBeat % 4) && boyfriend.canAutoAnim && !boyfriend.animation.curAnim.name.startsWith('sing'))
		{
			boyfriend.dance();
		}

		switch (curSong.toLowerCase())
		{
			case "bopeebo":
				if (curBeat % 8 == 7 && curSong == 'Bopeebo')
				{
					boyfriend.playAnim('hey', true);
				}

			case "fresh":
				switch (curBeat)
				{
					case 16:
						camZooming = true;
						bopSpeed = 2;
						dadBeats = [0, 2];
						bfBeats = [1, 3];
					case 48:
						bopSpeed = 1;
						dadBeats = [0, 1, 2, 3];
						bfBeats = [0, 1, 2, 3];
					case 80:
						bopSpeed = 2;
						dadBeats = [0, 2];
						bfBeats = [1, 3];
					case 112:
						bopSpeed = 1;
						dadBeats = [0, 1, 2, 3];
						bfBeats = [0, 1, 2, 3];
				}

			case "milf":
				if (curSong.toLowerCase() == 'milf' && curBeat >= 168 && curBeat <= 200 && camZooming && FlxG.camera.zoom < 1.35)
				{
					uiBop(0.015, 0.03);
				}

				if (curSong.toLowerCase() == 'milf' && curBeat == 168)
				{
					dadBeats = [0, 1, 2, 3];
					bfBeats = [0, 1, 2, 3];
				}

				if (curSong.toLowerCase() == 'milf' && curBeat == 200)
				{
					dadBeats = [0, 2];
					bfBeats = [1, 3];
				}
		}

		stage.beat(curBeat);
	}

	public function executeEvent(tag:String):Void
	{
		// playanim
		if (tag.startsWith("playAnim;"))
		{
			var tagSplit = tag.split(";");
			trace(tagSplit);

			switch (tagSplit[1])
			{
				case "dad":
					dad.playAnim(tagSplit[2]);

				case "gf":
					gf.playAnim(tagSplit[2]);

				default:
					boyfriend.playAnim(tagSplit[2]);
			}
		}
		// change char!!
		else if (tag.startsWith("changeChar;"))
		{
			var tagSplit = tag.split(";");
			trace(tagSplit);

			switch (tagSplit[1])
			{
				case "dad":
					var oldDadXPos:Float = dad.x - dad.charOffsetArray[0];
					var oldDadYPos:Float = dad.y - dad.charOffsetArray[1];
					dad.destroy();
					dad = new Character(oldDadXPos, oldDadYPos, tagSplit[2]);
					add(dad);

					dad.x += dad.charOffsetArray[0];
					dad.y += dad.charOffsetArray[1];

					iconP2.setIconCharacter(dad.iconName);

				default:
					var oldBFXPos:Float = boyfriend.x - boyfriend.charOffsetArray[0];
					var oldBFYPos:Float = boyfriend.y - boyfriend.charOffsetArray[1];
					boyfriend.destroy();
					boyfriend = new Character(oldBFXPos, oldBFYPos, tagSplit[2], true);
					add(boyfriend);

					boyfriend.x += boyfriend.charOffsetArray[0];
					boyfriend.y += boyfriend.charOffsetArray[1];

					iconP1.setIconCharacter(boyfriend.iconName);
			}
		}
		else
		{
			switch (tag)
			{
				case "dadAnimLockToggle":
					dad.canAutoAnim = !dad.canAutoAnim;

				case "bfAnimLockToggle":
					boyfriend.canAutoAnim = !boyfriend.canAutoAnim;

				case "gfAnimLockToggle":
					gf.canAutoAnim = !gf.canAutoAnim;

				default:
					trace(tag);
			}
		}
		return;
	}

	var curLight:Int = 0;

	function sectionContainsBfNotes(section:Int):Bool
	{
		var notes = SONG.notes[section].sectionNotes;
		var mustHit = SONG.notes[section].mustHitSection;

		for (x in notes)
		{
			if (mustHit)
			{
				if (x[1] < 4)
				{
					return true;
				}
			}
			else
			{
				if (x[1] > 3)
				{
					return true;
				}
			}
		}

		return false;
	}

	function sectionContainsOppNotes(section:Int):Bool
	{
		var notes = SONG.notes[section].sectionNotes;
		var mustHit = SONG.notes[section].mustHitSection;

		for (x in notes)
		{
			if (mustHit)
			{
				if (x[1] > 3)
				{
					return true;
				}
			}
			else
			{
				if (x[1] < 4)
				{
					return true;
				}
			}
		}

		return false;
	}

	function camFocusOpponent()
	{
		var followX = dad.getMidpoint().x + dad.cameraOffsetArray[0]
		#if EXPERIMENTAL_LUA + (luaModchart != null ? luaModchart.getVar("followXOffset", "float") : 0) #end;
		var followY = dad.getMidpoint().y + dad.cameraOffsetArray[1]
		#if EXPERIMENTAL_LUA + (luaModchart != null ? luaModchart.getVar("followYOffset", "float") : 0) #end;

		#if EXPERIMENTAL_LUA
		if (luaModchart != null)
			luaModchart.executeState('playerTwoTurn', []);
		#end
		// camFollow.setPosition(lucky.getMidpoint().x - 120, lucky.getMidpoint().y + 210);

		/* switch (dad.curCharacter)
			{
				case "spooky":
					followY = dad.getMidpoint().y - 30;
				case "pico":
					followX += 280;
				case "mom" | "mom-car":
					followY = dad.getMidpoint().y;
				case 'senpai':
					followY = dad.getMidpoint().y - 430;
					followX = dad.getMidpoint().x - 100;
				case 'senpai-angry':
					followY = dad.getMidpoint().y - 430;
					followX = dad.getMidpoint().x - 100;
				case 'spirit':
					followY = dad.getMidpoint().y;
		}*/
		/*if (dad.curCharacter == 'mom')
				vocals.volume = 1; 

			if (SONG.song.toLowerCase() == 'tutorial')
			{
				camChangeZoom(1.3, (Conductor.stepCrochet * 4 / 1000), FlxEase.elasticInOut);
		}*/

		camMove(followX, followY, 1.9, FlxEase.quintOut, "dad");
	}

	function camFocusBF()
	{
		var followX = boyfriend.getMidpoint().x - 100
		#if EXPERIMENTAL_LUA + (luaModchart != null ? luaModchart.getVar("followXOffset", "float") : 0) #end;
		var followY = boyfriend.getMidpoint().y - 100
		#if EXPERIMENTAL_LUA + (luaModchart != null ? luaModchart.getVar("followYOffset", "float") : 0) #end;

		#if EXPERIMENTAL_LUA
		if (luaModchart != null)
			luaModchart.executeState('playerOneTurn', []);
		#end

		if (SONG.player1 == 'bf-qen')
		{
			followX = boyfriend.getMidpoint().x - 400
			#if EXPERIMENTAL_LUA + (luaModchart != null ? luaModchart.getVar("followXOffset", "float") : 0) #end;
		}

		switch (stage.name)
		{
			case 'coisasbar':
				followX = boyfriend.getMidpoint().x - 325;
			case 'spooky':
				followY = boyfriend.getMidpoint().y - 125;
			case 'limo':
				followX = boyfriend.getMidpoint().x - 300;
			case 'mall':
				followY = boyfriend.getMidpoint().y - 200;
			case 'school':
				followX = boyfriend.getMidpoint().x - 200;
				followY = boyfriend.getMidpoint().y - 225;
			case 'schoolEvil':
				followX = boyfriend.getMidpoint().x - 200;
				followY = boyfriend.getMidpoint().y - 225;
		}

		if (SONG.song.toLowerCase() == 'tutorial')
		{
			camChangeZoom(1, (Conductor.stepCrochet * 4 / 1000), FlxEase.elasticInOut);
		}

		camMove(followX, followY, 1.9, FlxEase.quintOut, "bf");
	}

	function camMove(_x:Float, _y:Float, _time:Float, _ease:Null<flixel.tweens.EaseFunction>, ?_focus:String = "", ?_onComplete:Null<TweenCallback> = null):Void
	{
		if (_onComplete == null)
		{
			_onComplete = function(tween:FlxTween)
			{
			};
		}

		if (_time > 0)
		{
			camTween.cancel();
			camTween = FlxTween.tween(camFollow, {x: _x, y: _y}, _time, {ease: _ease, onComplete: _onComplete});
		}
		else
		{
			camTween.cancel();
			camFollow.setPosition(_x, _y);
		}

		camFocus = _focus;
	}

	function camChangeZoom(_zoom:Float, _time:Float, _ease:Null<flixel.tweens.EaseFunction>, ?_onComplete:Null<TweenCallback> = null):Void
	{
		if (_onComplete == null)
		{
			_onComplete = function(tween:FlxTween)
			{
			};
		}

		if (_time > 0)
		{
			camZoomTween.cancel();
			camZoomTween = FlxTween.tween(FlxG.camera, {zoom: _zoom}, _time, {ease: _ease, onComplete: _onComplete});
		}
		else
		{
			camZoomTween.cancel();
			FlxG.camera.zoom = _zoom;
		}
	}

	function uiChangeZoom(_zoom:Float, _time:Float, _ease:Null<flixel.tweens.EaseFunction>, ?_onComplete:Null<TweenCallback> = null):Void
	{
		if (_onComplete == null)
		{
			_onComplete = function(tween:FlxTween)
			{
			};
		}

		if (_time > 0)
		{
			uiZoomTween.cancel();
			uiZoomTween = FlxTween.tween(camHUD, {zoom: _zoom}, _time, {ease: _ease, onComplete: _onComplete});
		}
		else
		{
			uiZoomTween.cancel();
			camHUD.zoom = _zoom;
		}
	}

	function uiBop(?_camZoom:Float = 0.01, ?_uiZoom:Float = 0.02)
	{
		if (autoZoom)
		{
			camZoomTween.cancel();
			FlxG.camera.zoom = defaultCamZoom + _camZoom;
			camChangeZoom(defaultCamZoom, 0.6, FlxEase.quintOut);
		}

		if (autoUi)
		{
			uiZoomTween.cancel();
			camHUD.zoom = 1 + _uiZoom;
			uiChangeZoom(1, 0.6, FlxEase.quintOut);
		}
	}

	override public function onFocus()
	{
		super.onFocus();
		new FlxTimer().start(0.3, function(t)
		{
			if (Config.noFpsCap && !paused)
			{
				openfl.Lib.current.stage.frameRate = 999;
			}
			else
			{
				openfl.Lib.current.stage.frameRate = 144;
			}
		});
	}

	function inRange(a:Float, b:Float, tolerance:Float)
	{
		return (a <= b + tolerance && a >= b - tolerance);
	}

	function sortNotes()
	{
		if (generatedMusic)
		{
			notes.sort(noteSortThing, FlxSort.DESCENDING);
		}
	}

	public static inline function noteSortThing(Order:Int, Obj1:Note, Obj2:Note):Int
	{
		return FlxSort.byValues(Order, Obj1.strumTime, Obj2.strumTime);
	}
}
