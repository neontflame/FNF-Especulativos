package;

import flixel.util.FlxColor;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.graphics.FlxGraphic;
import openfl.display.BitmapData;
import flixel.animation.FlxBaseAnimation;
import flixel.graphics.frames.FlxAtlasFrames;
import stages.elements.*;

using StringTools;

class Character extends FlxSprite
{
	// Global character properties.
	public static final LOOP_ANIM_ON_HOLD:Bool = true; // Determines whether hold notes will loop the sing animation. Default is true.
	public static final HOLD_LOOP_WAIT:Bool = false; // Determines whether hold notes will only loop the sing animation if 4 frames of animation have passed. Default is false.
	public static final USE_IDLE_END:Bool = true; // Determines whether you will go back to the start of the idle or the end of the idle when letting go of a note. Default is true for FPS Plus, false for base game.

	public var animOffsets:Map<String, Array<Dynamic>>;
	public var debugMode:Bool = false;

	public var isPlayer:Bool = false;
	public var curCharacter:String = 'bf';

	public var holdTimer:Float = 0;
	public var stepsUntilRelease:Float = 4;

	public var canAutoAnim:Bool = true;
	public var danceLockout:Bool = false;
	public var animSet:String = "";

	public var deathCharacter:String = "bf";
	public var iconName:String = "face";
	public var characterColor:Null<FlxColor> = null;

	public var charOffsetArray:Array<Float> = [0, 0];
	public var cameraOffsetArray:Array<Float> = [150, -100];

	var facesLeft:Bool = false;

	public function new(x:Float, y:Float, ?character:String = "bf", ?_isPlayer:Bool = false, ?_enableDebug:Bool = false)
	{
		debugMode = _enableDebug;
		animOffsets = new Map<String, Array<Dynamic>>();

		super(x, y);

		curCharacter = character;
		isPlayer = _isPlayer;

		var tex:FlxAtlasFrames;
		antialiasing = true;

		switch (curCharacter)
		{
			case 'gf':
				// GIRLFRIEND CODE
				frames = Paths.getSparrowAtlas("GF_assets");
				animation.addByPrefix('cheer', 'GF Cheer', 24, false);
				animation.addByPrefix('singLEFT', 'GF left note', 24, false);
				animation.addByPrefix('singRIGHT', 'GF Right Note', 24, false);
				animation.addByPrefix('singUP', 'GF Up Note', 24, false);
				animation.addByPrefix('singDOWN', 'GF Down Note', 24, false);
				animation.addByIndices('sad', 'gf sad', [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12], "", 24, false);
				animation.addByIndices('danceLeft', 'GF Dancing Beat', [30, 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14], "", 24, false);
				animation.addByIndices('danceRight', 'GF Dancing Beat', [15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29], "", 24, false);
				animation.addByIndices('hairBlow', "GF Dancing Beat Hair blowing", [0, 1, 2, 3], "", 24);
				animation.addByIndices('hairFall', "GF Dancing Beat Hair Landing", [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11], "", 24, false);
				animation.addByPrefix('scared', 'GF FEAR', 24);

				addOffset('cheer');
				addOffset('sad', -2, -21);
				addOffset('danceLeft', 0, -9);
				addOffset('danceRight', 0, -9);

				addOffset("singUP", 0, 4);
				addOffset("singRIGHT", 0, -20);
				addOffset("singLEFT", 0, -19);
				addOffset("singDOWN", 0, -20);
				addOffset('hairBlow', 45, -8);
				addOffset('hairFall', 0, -9);

				addOffset('scared', -2, -17);

				playAnim('danceRight');

				iconName = "gf";

			case 'gf-qen':
				// GIRLFRIEND CODE
				frames = Paths.getSparrowAtlas("qen/gf");
				animation.addByPrefix('cheer', 'GF Cheer', 24, false);
				animation.addByIndices('sad', 'gf sad', [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12], "", 24, false);
				animation.addByIndices('danceLeft', 'GF Dancing Beat', [30, 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14], "", 24, false);
				animation.addByIndices('danceRight', 'GF Dancing Beat', [15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29], "", 24, false);

				addOffset('cheer');
				addOffset('sad', -2, -21);
				addOffset('danceLeft', 0, -9);
				addOffset('danceRight', 0, -9);

				playAnim('danceRight');

				iconName = "gf";

			case 'gf-bar':
				// GIRLFRIEND (bar) CODE
				frames = Paths.getSparrowAtlas("especula/girlfriendBar");
				animation.addByPrefix('cheer', 'GF Cheer', 24, false);
				animation.addByIndices('sad', 'gf sad', [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12], "", 24, false);
				animation.addByIndices('danceLeft', 'GF Dancing Beat', [30, 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14], "", 24, false);
				animation.addByIndices('danceRight', 'GF Dancing Beat', [15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29], "", 24, false);

				addOffset('cheer', -74, 0);
				addOffset('sad', -76, -22);
				addOffset('danceLeft', 0, -9);
				addOffset('danceRight', 0, -9);

				playAnim('danceRight');

				iconName = "gf";

			case 'gf-christmas':
				frames = Paths.getSparrowAtlas("week5/gfChristmas");
				animation.addByPrefix('cheer', 'GF Cheer', 24, false);
				animation.addByPrefix('singLEFT', 'GF left note', 24, false);
				animation.addByPrefix('singRIGHT', 'GF Right Note', 24, false);
				animation.addByPrefix('singUP', 'GF Up Note', 24, false);
				animation.addByPrefix('singDOWN', 'GF Down Note', 24, false);
				animation.addByIndices('sad', 'gf sad', [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12], "", 24, false);
				animation.addByIndices('danceLeft', 'GF Dancing Beat', [30, 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14], "", 24, false);
				animation.addByIndices('danceRight', 'GF Dancing Beat', [15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29], "", 24, false);
				animation.addByIndices('hairBlow', "GF Dancing Beat Hair blowing", [0, 1, 2, 3], "", 24);
				animation.addByIndices('hairFall', "GF Dancing Beat Hair Landing", [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11], "", 24, false);
				animation.addByPrefix('scared', 'GF FEAR', 24);

				addOffset('cheer');
				addOffset('sad', 0, -21);
				addOffset('danceLeft', 0, -9);
				addOffset('danceRight', 0, -9);

				addOffset("singUP", 0, 4);
				addOffset("singRIGHT", 0, -20);
				addOffset("singLEFT", 0, -19);
				addOffset("singDOWN", 0, -20);
				addOffset('hairBlow', 45, -8);
				addOffset('hairFall', 0, -9);

				addOffset('scared', -2, -17);

				playAnim('danceRight');

				iconName = "gf";

			case 'gf-car':
				frames = Paths.getSparrowAtlas("week4/gfCar");
				animation.addByIndices('singUP', 'GF Dancing Beat Hair blowing CAR', [0], "", 24, false);
				animation.addByIndices('danceLeft', 'GF Dancing Beat Hair blowing CAR', [30, 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14], "", 24, false);
				animation.addByIndices('danceRight', 'GF Dancing Beat Hair blowing CAR', [15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29], "", 24,
					false);

				addOffset('danceLeft', 0);
				addOffset('danceRight', 0);

				playAnim('danceRight');

				iconName = "gf";

			case 'gf-pixel':
				frames = Paths.getSparrowAtlas("week6/gfPixel");
				animation.addByIndices('singUP', 'GF IDLE', [2], "", 24, false);
				animation.addByIndices('danceLeft', 'GF IDLE', [30, 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14], "", 24, false);
				animation.addByIndices('danceRight', 'GF IDLE', [15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29], "", 24, false);

				addOffset('danceLeft', 0);
				addOffset('danceRight', 0);

				playAnim('danceRight');

				setGraphicSize(Std.int(width * PlayState.daPixelZoom));
				updateHitbox();
				antialiasing = false;

				iconName = "gf";

			case 'gf-tankmen':
				frames = Paths.getSparrowAtlas('week7/gfTankmen');
				animation.addByIndices('sad', 'GF Crying at Gunpoint', [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12], "", 24, true);
				animation.addByIndices('danceLeft', 'GF Dancing at Gunpoint', [30, 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14], "", 24, false);
				animation.addByIndices('danceRight', 'GF Dancing at Gunpoint', [15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29], "", 24, false);

				addOffset('sad', -2, -21);
				addOffset('danceLeft', 0, -9);
				addOffset('danceRight', 0, -9);

				playAnim('danceRight');

				iconName = "gf";

			case 'bf-holding-gf':
				frames = Paths.getSparrowAtlas('week7/bfAndGF');
				animation.addByPrefix('idle', 'BF idle dance', 24, false);
				animation.addByPrefix('singDOWN', 'BF NOTE DOWN0', 24, false);
				animation.addByPrefix('singLEFT', 'BF NOTE LEFT0', 24, false);
				animation.addByPrefix('singRIGHT', 'BF NOTE RIGHT0', 24, false);
				animation.addByPrefix('singUP', 'BF NOTE UP0', 24, false);

				animation.addByPrefix('singDOWNmiss', 'BF NOTE DOWN MISS', 24, false);
				animation.addByPrefix('singLEFTmiss', 'BF NOTE LEFT MISS', 24, false);
				animation.addByPrefix('singRIGHTmiss', 'BF NOTE RIGHT MISS', 24, false);
				animation.addByPrefix('singUPmiss', 'BF NOTE UP MISS', 24, false);
				animation.addByPrefix('bfCatch', 'BF catches GF', 24, false);

				addOffset("idle", 0, 0);
				addOffset("singUP", -29, 10);
				addOffset("singRIGHT", -41, 23);
				addOffset("singLEFT", 12, 7);
				addOffset("singDOWN", -10, -10);
				addOffset("singUPmiss", -29, 10);
				addOffset("singRIGHTmiss", -41, 23);
				addOffset("singLEFTmiss", 12, 7);
				addOffset("singDOWNmiss", -10, -10);
				addOffset("bfCatch", 0, 0);

				playAnim('idle');

				facesLeft = true;

				deathCharacter = "bf-holding-gf-dead";
				iconName = "bf";
				charOffsetArray = [0, 350];

			case 'bf-holding-gf-dead':
				frames = Paths.getSparrowAtlas('week7/bfHoldingGF-DEAD');
				animation.addByPrefix('firstDeath', "BF Dies with GF", 24, false);
				animation.addByPrefix('deathLoop', "BF Dead with GF Loop", 24, true);
				animation.addByPrefix('deathConfirm', "RETRY confirm holding gf", 24, false);
				animation.play('firstDeath');

				addOffset('firstDeath', 37, 14);
				addOffset('deathLoop', 37, -3);
				addOffset('deathConfirm', 37, 28);
				playAnim('firstDeath');

				facesLeft = true;

				iconName = "bf";
				charOffsetArray = [0, 350];

			case 'bf-especula-dead':
				frames = Paths.getSparrowAtlas('especula/bfMorrendo');
				animation.addByPrefix('firstDeath', "morreu", 24, false);
				animation.addByPrefix('deathLoop', "morteRetry", 24, true);
				animation.addByPrefix('deathConfirm', "morteOk", 24, false);
				animation.play('firstDeath');

				addOffset('firstDeath', 827, 70);
				addOffset('deathLoop', -181, -171);
				addOffset('deathConfirm', -178, -132);
				playAnim('firstDeath');

				facesLeft = true;

				iconName = "bf";
				charOffsetArray = [0, 350];

			case 'dad':
				// DAD ANIMATION LOADING CODE
				frames = Paths.getSparrowAtlas("week1/DADDY_DEAREST");
				animation.addByPrefix('idle', 'Dad idle dance', 24, false);
				animation.addByPrefix('singUP', 'Dad Sing Note UP', 24, false);
				animation.addByPrefix('singRIGHT', 'Dad Sing Note RIGHT', 24, false);
				animation.addByPrefix('singDOWN', 'Dad Sing Note DOWN', 24, false);
				animation.addByPrefix('singLEFT', 'Dad Sing Note LEFT', 24, false);

				addOffset('idle');
				addOffset("singUP", -9, 50);
				addOffset("singRIGHT", -4, 26);
				addOffset("singLEFT", -11, 10);
				addOffset("singDOWN", 2, -32);

				playAnim('idle');

				stepsUntilRelease = 6.1;
				iconName = "dad";
				
				////// VS ESPE CHARS
				//// WEEK ESPE
			case 'espe':
				// omg espe from especulativos do cramunhao!!!
				frames = Paths.getSparrowAtlas("especula/espe");
				animation.addByPrefix('idle', 'espe idle', 24, false);
				animation.addByPrefix('singUP', 'espe up', 24, false);
				animation.addByPrefix('singRIGHT', 'espe right', 24, false);
				animation.addByPrefix('singDOWN', 'espe down', 24, false);
				animation.addByPrefix('singLEFT', 'espe left', 24, false);
				animation.addByPrefix('o3o', 'espe o3o', 24, false);

				addOffset('idle');
				addOffset("singUP", 0, 78);
				addOffset("singRIGHT", -66, -11);
				addOffset("singLEFT", 88, -15);
				addOffset("singDOWN", 11, -70);
				addOffset("o3o", 3, 0);

				playAnim('idle');

				iconName = "espe";
				charOffsetArray = [0, 110];
				cameraOffsetArray = [250, 25];
				
			case 'dave':
				// o dude primordial
				frames = Paths.getSparrowAtlas("especula/dave");
				animation.addByPrefix('idle', 'dave idle', 24, false);
				animation.addByPrefix('singUP', 'dave up', 24, false);
				animation.addByPrefix('singRIGHT', 'dave right', 24, false);
				animation.addByPrefix('singDOWN', 'dave down', 24, false);
				animation.addByPrefix('singLEFT', 'dave left', 24, false);

				addOffset('idle');
				addOffset("singUP", 3, 28);
				addOffset("singRIGHT", -22, -10);
				addOffset("singLEFT", 66, -2);
				addOffset("singDOWN", -12, -16);

				playAnim('idle');

				iconName = "dave";
				charOffsetArray = [194, 163];
				
			case 'blu':
				// o dude flamejante azul (nao usado mais lmfao)
				frames = Paths.getSparrowAtlas("especula/blu");
				animation.addByPrefix('idle', 'blu idle', 24, false);
				animation.addByPrefix('singUP', 'blu up', 24, false);
				animation.addByPrefix('singRIGHT', 'blu right', 24, false);
				animation.addByPrefix('singDOWN', 'blu down', 24, false);
				animation.addByPrefix('singLEFT', 'blu left', 24, false);

				addOffset('idle');
				addOffset("singUP", 12, 113);
				addOffset("singRIGHT", 60, 1);
				addOffset("singLEFT", 121, -4);
				addOffset("singDOWN", 91, -27);

				playAnim('idle');

				iconName = "blu";
				charOffsetArray = [150, 337];
				
			case 'hektor':
				// o dude Grande e Azul
				frames = Paths.getSparrowAtlas("especula/hektor");
				animation.addByPrefix('idle', 'hektor idle', 24, false);
				animation.addByPrefix('singLEFT', 'hektor left', 24, false);
				animation.addByPrefix('singDOWN', 'hektor down', 24, false);
				animation.addByPrefix('singUP', 'hektor up', 24, false);
				animation.addByPrefix('singRIGHT', 'hektor right', 24, false);
				
				addOffset('idle', 0, 0);
				addOffset('singLEFT', 77, 4);
				addOffset('singDOWN', 24, -33);
				addOffset('singUP', 39, 103);
				addOffset('singRIGHT', -27, -15);
				
				playAnim('idle');
				
				iconName = "hektor";
				charOffsetArray = [0, 80];
				
			case 'sketcher':
				// o dude Redux
				frames = Paths.getSparrowAtlas("especula/sketcher");
				animation.addByPrefix('idle', 'sketcher idle', 24, false);
				animation.addByPrefix('singUP', 'sketcher up', 24, false);
				animation.addByPrefix('singRIGHT', 'sketcher right', 24, false);
				animation.addByPrefix('singDOWN', 'sketcher down', 24, false);
				animation.addByPrefix('singLEFT', 'sketcher left', 24, false);

				addOffset('idle');
				addOffset("singUP", -42, 27);
				addOffset("singRIGHT", -74, -17);
				addOffset("singLEFT", 5, -13);
				addOffset("singDOWN", -33, -38);

				playAnim('idle');

				iconName = "sketcher";
				charOffsetArray = [109, 140];
				
			case 'hawnt':
				// o dude Guitarrero
				frames = Paths.getSparrowAtlas("especula/hawnt");
				animation.addByPrefix('idle', 'hawnt idle', 24, false);
				animation.addByPrefix('singUP', 'hawnt up', 24, false);
				animation.addByPrefix('singRIGHT', 'hawnt right', 24, false);
				animation.addByPrefix('singDOWN', 'hawnt down', 24, false);
				animation.addByPrefix('singLEFT', 'hawnt left', 24, false);

				addOffset('idle');
				addOffset("singUP", 65, -39);
				addOffset("singRIGHT", 10, -128);
				addOffset("singLEFT", 126, -137);
				addOffset("singDOWN", 28, -195);

				playAnim('idle');

				iconName = "hawnt";
				charOffsetArray = [186, 183];
				cameraOffsetArray = [150, 25];
				
			case 'scdm':
				// tambem conhecido como esc na gringa
				frames = Paths.getSparrowAtlas("scdm/scdm");
				animation.addByPrefix('idle', 'scdm idle', 24, false);
				animation.addByPrefix('singUP', 'scdm up', 24, false);
				animation.addByPrefix('singRIGHT', 'scdm right', 24, false);
				animation.addByPrefix('singDOWN', 'scdm down', 24, false);
				animation.addByPrefix('singLEFT', 'scdm left', 24, false);

				addOffset('idle');
				addOffset("singUP", -42, 96);
				addOffset("singRIGHT", -16, -2);
				addOffset("singLEFT", 27, 3);
				addOffset("singDOWN", 36, -33);

				playAnim('idle');

				iconName = "scdm";
				charOffsetArray = [0, 308];

			case 'yotsuba':
				// enfim a mais recente mascote do especulativos
				frames = Paths.getSparrowAtlas("yotsu/yotuba");
				animation.addByPrefix('idle', 'yotsu idle', 24, false);
				animation.addByPrefix('singLEFT', 'yotsu left', 24, false);
				animation.addByPrefix('singDOWN', 'yotsu down', 24, false);
				animation.addByPrefix('singUP', 'yotsu up', 24, false);
				animation.addByPrefix('singRIGHT', 'yotsu right', 24, false);
				animation.addByPrefix('hey', 'yotsu hey', 24, false);
				animation.addByPrefix('grabStick', 'yotsu grab stick', 24, false);
				
				addOffset('idle');
				addOffset('singLEFT', 58, -8);
				addOffset('singDOWN', -30, -61);
				addOffset('singUP', -22, 38);
				addOffset('singRIGHT', -32, -28);
				addOffset('hey', -36, 4);
				addOffset('grabStick', 66, 3);
				
				playAnim('idle');

				iconName = "yotsuba";
				charOffsetArray = [0, 315];
				cameraOffsetArray = [150, -60];

			case 'yotsuba-stick':
				// yotsuba so q dessa vez com uma vara
				frames = Paths.getSparrowAtlas("yotsu/yotuba");
				animation.addByPrefix('idle', 'yotsu stick idle', 24, false);
				animation.addByPrefix('singLEFT', 'yotsu stick left', 24, false);
				animation.addByPrefix('singDOWN', 'yotsu stick down', 24, false);
				animation.addByPrefix('singUP', 'yotsu stick up', 24, false);
				animation.addByPrefix('singRIGHT', 'yotsu stick right', 24, false);

				animation.addByPrefix('singLEFT-alt', 'yotsu stick a', 24, false);
				animation.addByPrefix('singUP-alt', 'yotsu stick b', 24, false);
				animation.addByPrefix('singRIGHT-alt', 'yotsu stick c', 24, false);
				
				addOffset('idle', 83, 2);
				addOffset('singLEFT', 191, -8);
				addOffset('singDOWN', 52, -61);
				addOffset('singUP', 2, 38);
				addOffset('singRIGHT', -38, -27);

				addOffset('singLEFT-alt', 126, 64);
				addOffset('singUP-alt', 39, 150);
				addOffset('singRIGHT-alt', -49, 61);
				
				playAnim('idle');

				iconName = "yotsuba";
				charOffsetArray = [0, 315];
				cameraOffsetArray = [150, -60];
				
			case 'narigao':
				// nariz man
				frames = Paths.getSparrowAtlas("qen/narigao");
				animation.addByPrefix('idle', 'narigao idle', 24, false);
				animation.addByPrefix('singUP', 'narigao up', 24, false);
				animation.addByPrefix('singRIGHT', 'narigao right', 24, false);
				animation.addByPrefix('singDOWN', 'narigao down', 24, false);
				animation.addByPrefix('singLEFT', 'narigao left', 24, false);
				animation.addByPrefix('wtf', 'narigao wtf', 24, false);
				
				addOffset('idle');
				addOffset("singDOWN", 23, -102);
				addOffset("singRIGHT", -41, -38);
				addOffset("singUP", -60, 196);
				addOffset("singLEFT", 379, 5);
				addOffset('wtf', 1, 5);
				
				playAnim('idle');

				iconName = "narigao";
				charOffsetArray = [-24, 290];
				
			case 'maujoa':
				// mauj man
				frames = Paths.getSparrowAtlas("qen/maujoa");
				animation.addByPrefix('idle', 'maujoa idle', 24, true);
				animation.addByPrefix('singUP', 'maujoa up', 24, false);
				animation.addByPrefix('singRIGHT', 'maujoa right', 24, false);
				animation.addByPrefix('singDOWN', 'maujoa down', 24, false);
				animation.addByPrefix('singLEFT', 'maujoa left', 24, false);
				
				addOffset('idle');
				addOffset("singDOWN", 10, -80);
				addOffset("singRIGHT", -210, 80);
				addOffset("singUP", -140, 200);
				addOffset("singLEFT", 105, -20);
				
				playAnim('idle');

				iconName = "maujoa";
				charOffsetArray = [-24, 297];
						
			case 'velhote':
				// o velho
				frames = Paths.getSparrowAtlas("weekOld/velhote");
				
				// eu so fiz isso pra experimentar btw
				loadAnims('weekOld/velhoteAnims');
				loadOffsetFile('weekOld/velhoteOffsets');
				
				playAnim('idle');

				iconName = "velhote";
				charOffsetArray = [0, 349];
				
			// hawnts salsicha
			case 'hawnt-salsicha':
				// ele e so um cara
				frames = Paths.getSparrowAtlas("salsicha/hawntSalsicha");
				
				animation.addByPrefix('idle', 'hawnt salsicha idle', 24, false);
				animation.addByPrefix('singUP', 'hawnt salsicha up', 24, false);
				animation.addByPrefix('singRIGHT', 'hawnt salsicha right', 24, false);
				animation.addByPrefix('singDOWN', 'hawnt salsicha down', 24, false);
				animation.addByPrefix('singLEFT', 'hawnt salsicha left', 24, false);
				animation.addByPrefix('cobrindo', 'hawnt salsicha cobrindo', 24, false);
				
				addOffset('idle');
				addOffset("singDOWN");
				addOffset("singRIGHT");
				addOffset("singUP");
				addOffset("singLEFT");
				addOffset('cobrindo', 0, 55);
				
				playAnim('idle');

				iconName = "hawnt-salsicha";
				charOffsetArray = [0, 405];
			case 'hawnt-salsicha-ketchup':
				// ele e so um cara
				frames = Paths.getSparrowAtlas("salsicha/hawntSalsicha");
				
				animation.addByPrefix('idle', 'hawnt ketchup idle', 24, false);
				animation.addByPrefix('singUP', 'hawnt ketchup up', 24, false);
				animation.addByPrefix('singRIGHT', 'hawnt ketchup right', 24, false);
				animation.addByPrefix('singDOWN', 'hawnt ketchup down', 24, false);
				animation.addByPrefix('singLEFT', 'hawnt ketchup left', 24, false);
				animation.addByPrefix('cobrindo', 'hawnt salsicha cobrindo', 24, false);
				
				addOffset('idle');
				addOffset("singDOWN");
				addOffset("singRIGHT");
				addOffset("singUP");
				addOffset("singLEFT");
				addOffset('cobrindo', 0, 55);
				
				playAnim('idle');

				iconName = "hawnt-salsicha";
				charOffsetArray = [0, 405];
			////// BASE GAME CHARS
			case 'spooky':
				frames = Paths.getSparrowAtlas("week2/spooky_kids_assets");
				animation.addByPrefix('singUP', 'spooky UP NOTE', 24, false);
				animation.addByPrefix('singDOWN', 'spooky DOWN note', 24, false);
				animation.addByPrefix('singLEFT', 'note sing left', 24, false);
				animation.addByPrefix('singRIGHT', 'spooky sing right', 24, false);
				animation.addByIndices('danceLeft', 'spooky dance idle', [0, 2, 6], "", 12, false);
				animation.addByIndices('danceRight', 'spooky dance idle', [8, 10, 12, 14], "", 12, false);

				addOffset('danceLeft');
				addOffset('danceRight');

				addOffset("singUP", -18, 25);
				addOffset("singRIGHT", -130, -14);
				addOffset("singLEFT", 124, -13);
				addOffset("singDOWN", -46, -144);

				playAnim('danceRight');

				iconName = "spooky";
				charOffsetArray = [0, 200];
				cameraOffsetArray = [150, -30];

			case 'mom':
				frames = Paths.getSparrowAtlas("week4/Mom_Assets");
				animation.addByPrefix('idle', "Mom Idle", 24, false);
				animation.addByPrefix('singUP', "Mom Up Pose", 24, false);
				animation.addByPrefix('singDOWN', "MOM DOWN POSE", 24, false);
				animation.addByPrefix('singLEFT', 'Mom Left Pose', 24, false);
				// ANIMATION IS CALLED MOM LEFT POSE BUT ITS FOR THE RIGHT
				// CUZ DAVE IS DUMB!
				animation.addByPrefix('singRIGHT', 'Mom Pose Left', 24, false);

				addOffset('idle');
				addOffset("singUP", -1, 81);
				addOffset("singRIGHT", 21, -54);
				addOffset("singLEFT", 250, -23);
				addOffset("singDOWN", 20, -157);

				playAnim('idle');

				iconName = "mom";
				cameraOffsetArray = [150, 0];

			case 'mom-car':
				frames = Paths.getSparrowAtlas("week4/momCar");
				animation.addByPrefix('idle', "Mom Idle", 24, false);
				animation.addByPrefix('singUP', "Mom Up Pose", 24, false);
				animation.addByPrefix('singDOWN', "MOM DOWN POSE", 24, false);
				animation.addByPrefix('singLEFT', 'Mom Left Pose', 24, false);
				// ANIMATION IS CALLED MOM LEFT POSE BUT ITS FOR THE RIGHT
				// CUZ DAVE IS DUMB!
				animation.addByPrefix('singRIGHT', 'Mom Pose Left', 24, false);

				addOffset('idle');
				addOffset("singUP", -1, 81);
				addOffset("singRIGHT", 21, -54);
				addOffset("singLEFT", 250, -23);
				addOffset("singDOWN", 20, -157);

				playAnim('idle');

				iconName = "mom";

			case 'monster':
				frames = Paths.getSparrowAtlas("week2/Monster_Assets");
				animation.addByPrefix('idle', 'monster idle', 24, false);
				animation.addByPrefix('singUP', 'monster up note', 24, false);
				animation.addByPrefix('singDOWN', 'monster down', 24, false);
				animation.addByPrefix('singLEFT', 'Monster left note', 24, false);
				animation.addByPrefix('singRIGHT', 'Monster Right note', 24, false);

				addOffset('idle');
				addOffset("singUP", -23, 87);
				addOffset("singRIGHT", -51, 15);
				addOffset("singLEFT", -31, 4);
				addOffset("singDOWN", -63, -86);
				playAnim('idle');

				iconName = "monster";
				charOffsetArray = [0, 100];

			case 'monster-christmas':
				frames = Paths.getSparrowAtlas("week5/monsterChristmas");
				animation.addByPrefix('idle', 'monster idle', 24, false);
				animation.addByPrefix('singUP', 'monster up note', 24, false);
				animation.addByPrefix('singDOWN', 'monster down', 24, false);
				animation.addByPrefix('singLEFT', 'Monster left note', 24, false);
				animation.addByPrefix('singRIGHT', 'Monster Right note', 24, false);

				addOffset('idle');
				addOffset("singUP", -21, 53);
				addOffset("singRIGHT", -51, 10);
				addOffset("singLEFT", -30, 7);
				addOffset("singDOWN", -52, -91);
				playAnim('idle');

				iconName = "monster";
				charOffsetArray = [0, 130];

			case 'pico':
				frames = Paths.getSparrowAtlas("week3/Pico_FNF_assetss");
				animation.addByPrefix('idle', "Pico Idle Dance", 24, false);
				animation.addByPrefix('singUP', 'pico Up note0', 24, false);
				animation.addByPrefix('singDOWN', 'Pico Down Note0', 24, false);
				animation.addByPrefix('singLEFT', 'Pico NOTE LEFT0', 24, false);
				animation.addByPrefix('singRIGHT', 'Pico Note Right0', 24, false);
				animation.addByPrefix('singRIGHTmiss', 'Pico Note Right Miss', 24, false);
				animation.addByPrefix('singLEFTmiss', 'Pico NOTE LEFT miss', 24, false);
				animation.addByPrefix('singUPmiss', 'pico Up note miss', 24, false);
				animation.addByPrefix('singDOWNmiss', 'Pico Down Note MISS', 24, false);

				/*addOffset('idle');
					addOffset("singUP", -43, 29);
					addOffset("singRIGHT", -85, -11);
					addOffset("singLEFT", 54, 2);
					addOffset("singDOWN", 198, -76);
					addOffset("singUPmiss", -29, 67);
					addOffset("singRIGHTmiss", -70, 28);
					addOffset("singLEFTmiss", 62, 50);
					addOffset("singDOWNmiss", 200, -34); */

				addOffset("singRIGHTmiss", -40, 49);
				addOffset("singDOWN", 92, -77);
				addOffset("singLEFTmiss", 82, 27);
				addOffset("singUP", 20, 29);
				addOffset("idle", 0, 0);
				addOffset("singDOWNmiss", 86, -37);
				addOffset("singRIGHT", -46, 1);
				addOffset("singLEFT", 86, -11);
				addOffset("singUPmiss", 26, 67);

				playAnim('idle');

				facesLeft = true;

				iconName = "pico";
				charOffsetArray = [-280, 300];
				cameraOffsetArray = [430, -100];
			
			//// all my friends boyed...
			case 'bf':
				frames = Paths.getSparrowAtlas("BOYFRIEND");
				animation.addByPrefix('idle', 'BF idle dance', 24, false);
				animation.addByPrefix('singUP', 'BF NOTE UP0', 24, false);
				animation.addByPrefix('singLEFT', 'BF NOTE LEFT0', 24, false);
				animation.addByPrefix('singRIGHT', 'BF NOTE RIGHT0', 24, false);
				animation.addByPrefix('singDOWN', 'BF NOTE DOWN0', 24, false);
				animation.addByPrefix('singUPmiss', 'BF NOTE UP MISS', 24, false);
				animation.addByPrefix('singLEFTmiss', 'BF NOTE LEFT MISS', 24, false);
				animation.addByPrefix('singRIGHTmiss', 'BF NOTE RIGHT MISS', 24, false);
				animation.addByPrefix('singDOWNmiss', 'BF NOTE DOWN MISS', 24, false);
				animation.addByPrefix('hey', 'BF HEY', 24, false);

				animation.addByPrefix('dodge', 'boyfriend dodge', 24, false);
				animation.addByPrefix('damage', 'BF hit', 24, false);
				// animation.addByPrefix('attack', 'boyfriend attack', 24, false);

				animation.addByPrefix('firstDeath', "BF dies", 24, false);
				animation.addByPrefix('deathLoop', "BF Dead Loop", 24, true);
				animation.addByPrefix('deathConfirm', "BF Dead confirm", 24, false);

				animation.addByPrefix('scared', 'BF idle shaking', 24);

				addOffset('idle', 0);
				addOffset("singUP", -29, 27);
				addOffset("singRIGHT", -38, -7);
				addOffset("singLEFT", 12, -6);
				addOffset("singDOWN", -10, -50);
				addOffset("singUPmiss", -29, 27);
				addOffset("singRIGHTmiss", -30, 21);
				addOffset("singLEFTmiss", 12, 24);
				addOffset("singDOWNmiss", -11, -19);
				addOffset("hey", 7, 4);

				addOffset('dodge', -1, -10);
				addOffset('damage', 18, 20);

				addOffset('firstDeath', 37, 11);
				addOffset('deathLoop', 37, 5);
				addOffset('deathConfirm', 37, 69);

				addOffset('scared', -4);

				playAnim('idle');

				facesLeft = true;

				iconName = "bf";
				charOffsetArray = [0, 350];

			case 'bf-christmas':
				frames = Paths.getSparrowAtlas("week5/bfChristmas");
				animation.addByPrefix('idle', 'BF idle dance', 24, false);
				animation.addByPrefix('singUP', 'BF NOTE UP0', 24, false);
				animation.addByPrefix('singLEFT', 'BF NOTE LEFT0', 24, false);
				animation.addByPrefix('singRIGHT', 'BF NOTE RIGHT0', 24, false);
				animation.addByPrefix('singDOWN', 'BF NOTE DOWN0', 24, false);
				animation.addByPrefix('singUPmiss', 'BF NOTE UP MISS', 24, false);
				animation.addByPrefix('singLEFTmiss', 'BF NOTE LEFT MISS', 24, false);
				animation.addByPrefix('singRIGHTmiss', 'BF NOTE RIGHT MISS', 24, false);
				animation.addByPrefix('singDOWNmiss', 'BF NOTE DOWN MISS', 24, false);
				animation.addByPrefix('hey', 'BF HEY', 24, false);

				addOffset('idle', -5);
				addOffset("singUP", -29, 27);
				addOffset("singRIGHT", -38, -7);
				addOffset("singLEFT", 12, -6);
				addOffset("singDOWN", -10, -50);
				addOffset("singUPmiss", -29, 27);
				addOffset("singRIGHTmiss", -30, 21);
				addOffset("singLEFTmiss", 12, 24);
				addOffset("singDOWNmiss", -11, -19);
				addOffset("hey", 7, 4);

				playAnim('idle');

				facesLeft = true;

				iconName = "bf";
				charOffsetArray = [0, 350];

			case 'bf-car':
				frames = Paths.getSparrowAtlas("week4/bfCar");
				animation.addByPrefix('idle', 'BF idle dance', 24, false);
				animation.addByPrefix('singUP', 'BF NOTE UP0', 24, false);
				animation.addByPrefix('singLEFT', 'BF NOTE LEFT0', 24, false);
				animation.addByPrefix('singRIGHT', 'BF NOTE RIGHT0', 24, false);
				animation.addByPrefix('singDOWN', 'BF NOTE DOWN0', 24, false);
				animation.addByPrefix('singUPmiss', 'BF NOTE UP MISS', 24, false);
				animation.addByPrefix('singLEFTmiss', 'BF NOTE LEFT MISS', 24, false);
				animation.addByPrefix('singRIGHTmiss', 'BF NOTE RIGHT MISS', 24, false);
				animation.addByPrefix('singDOWNmiss', 'BF NOTE DOWN MISS', 24, false);

				addOffset('idle', -5);
				addOffset("singUP", -29, 27);
				addOffset("singRIGHT", -38, -7);
				addOffset("singLEFT", 12, -6);
				addOffset("singDOWN", -10, -50);
				addOffset("singUPmiss", -29, 27);
				addOffset("singRIGHTmiss", -30, 21);
				addOffset("singLEFTmiss", 12, 24);
				addOffset("singDOWNmiss", -11, -19);
				playAnim('idle');

				facesLeft = true;

				iconName = "bf";
				charOffsetArray = [0, 350];

			case 'bf-pixel':
				frames = Paths.getSparrowAtlas("week6/bfPixel");
				animation.addByPrefix('idle', 'BF IDLE', 24, false);
				animation.addByPrefix('singUP', 'BF UP NOTE', 24, false);
				animation.addByPrefix('singLEFT', 'BF LEFT NOTE', 24, false);
				animation.addByPrefix('singRIGHT', 'BF RIGHT NOTE', 24, false);
				animation.addByPrefix('singDOWN', 'BF DOWN NOTE', 24, false);
				animation.addByPrefix('singUPmiss', 'BF UP MISS', 24, false);
				animation.addByPrefix('singLEFTmiss', 'BF LEFT MISS', 24, false);
				animation.addByPrefix('singRIGHTmiss', 'BF RIGHT MISS', 24, false);
				animation.addByPrefix('singDOWNmiss', 'BF DOWN MISS', 24, false);

				addOffset('idle');
				addOffset("singUP", -6);
				addOffset("singRIGHT");
				addOffset("singLEFT", -12);
				addOffset("singDOWN");
				addOffset("singUPmiss", -6);
				addOffset("singRIGHTmiss");
				addOffset("singLEFTmiss", -12);
				addOffset("singDOWNmiss");

				setGraphicSize(Std.int(width * 6));
				updateHitbox();

				playAnim('idle');

				width -= 100;
				height -= 100;

				antialiasing = false;

				deathCharacter = "bf-pixel-dead";
				iconName = "bf-pixel";

				facesLeft = true;
				charOffsetArray = [0, 350];

			case 'bf-pixel-dead':
				frames = Paths.getSparrowAtlas("week6/bfPixelsDEAD");
				animation.addByPrefix('singUP', "BF Dies pixel", 24, false);
				animation.addByPrefix('firstDeath', "BF Dies pixel", 24, false);
				animation.addByPrefix('deathLoop', "Retry Loop", 24, true);
				animation.addByPrefix('deathConfirm', "RETRY CONFIRM", 24, false);
				animation.play('firstDeath');

				addOffset('firstDeath');
				addOffset('deathLoop', -36);
				addOffset('deathConfirm', -36);
				playAnim('firstDeath');
				// pixel bullshit
				setGraphicSize(Std.int(width * 6));
				updateHitbox();
				antialiasing = false;
				facesLeft = true;

				iconName = "bf-pixel";
				charOffsetArray = [0, 350];

			case 'bf-lil':
				loadGraphic(Paths.image("chartEditor/lilBf"), true, 300, 256);

				animation.add("idle", [0, 1], 12, true);

				animation.add("singLEFT", [3, 4, 5], 12, false);
				animation.add("singDOWN", [6, 7, 8], 12, false);
				animation.add("singUP", [9, 10, 11], 12, false);
				animation.add("singRIGHT", [12, 13, 14], 12, false);

				animation.add("singLEFTmiss", [3, 15, 15, 16, 16], 24, false);
				animation.add("singDOWNmiss", [6, 18, 18, 19, 19], 24, false);
				animation.add("singUPmiss", [9, 21, 21, 22, 22], 24, false);
				animation.add("singRIGHTmiss", [12, 24, 24, 25, 25], 24, false);

				animation.add("hey", [17, 20, 23], 12, false);

				addOffset('idle');
				addOffset("singUP");
				addOffset("singRIGHT");
				addOffset("singLEFT");
				addOffset("singDOWN");
				addOffset("singUPmiss");
				addOffset("singRIGHTmiss");
				addOffset("singLEFTmiss");
				addOffset("singDOWNmiss");
				addOffset("hey");

				playAnim('idle');

				facesLeft = true;
				antialiasing = false;

				iconName = "bf-lil";
				charOffsetArray = [0, 0];

			case 'bf-qen':
				frames = Paths.getSparrowAtlas("qen/bf");
				animation.addByPrefix('idle', 'BF idle dance', 24, false);
				animation.addByPrefix('singUP', 'BF NOTE UP0', 24, false);
				animation.addByPrefix('singLEFT', 'BF NOTE LEFT0', 24, false);
				animation.addByPrefix('singRIGHT', 'BF NOTE RIGHT0', 24, false);
				animation.addByPrefix('singDOWN', 'BF NOTE DOWN0', 24, false);
				animation.addByPrefix('singUPmiss', 'BF NOTE UP MISS', 24, false);
				animation.addByPrefix('singLEFTmiss', 'BF NOTE LEFT MISS', 24, false);
				animation.addByPrefix('singRIGHTmiss', 'BF NOTE RIGHT MISS', 24, false);
				animation.addByPrefix('singDOWNmiss', 'BF NOTE DOWN MISS', 24, false);
				animation.addByPrefix('hey', 'BF HEY', 24, false);
				// animation.addByPrefix('attack', 'boyfriend attack', 24, false);

				animation.addByPrefix('firstDeath', "BF dies", 24, false);
				animation.addByPrefix('deathLoop', "BF Dead Loop", 24, true);
				animation.addByPrefix('deathConfirm', "BF Dead confirm", 24, false);

				addOffset('idle', -5);

				addOffset("singUP", -29, 38);
				addOffset("singRIGHT", -18, -12);
				addOffset("singLEFT", 42, 1);
				addOffset("singDOWN", 20, -70);
				addOffset("hey", -10, 3);

				addOffset("singUPmiss", -26, 181);
				addOffset("singRIGHTmiss", 10, -19);
				addOffset("singLEFTmiss", 125, 1);
				addOffset("singDOWNmiss", 179, -59);

				addOffset('firstDeath', 320, 101);
				addOffset('deathLoop', 321, -238);
				addOffset('deathConfirm', 321, -238);

				playAnim('idle');

				facesLeft = true;

				deathCharacter = "bf-qen";
				iconName = "bf-qen";
				charOffsetArray = [0, 350];

			case 'senpai':
				frames = Paths.getSparrowAtlas("week6/senpai");
				animation.addByPrefix('idle', 'Senpai Idle', 24, false);
				animation.addByPrefix('singUP', 'SENPAI UP NOTE', 24, false);
				animation.addByPrefix('singLEFT', 'SENPAI LEFT NOTE', 24, false);
				animation.addByPrefix('singRIGHT', 'SENPAI RIGHT NOTE', 24, false);
				animation.addByPrefix('singDOWN', 'SENPAI DOWN NOTE', 24, false);

				addOffset('idle');
				addOffset("singUP", 12, 36);
				addOffset("singRIGHT", 6);
				addOffset("singLEFT", 30);
				addOffset("singDOWN", 12);

				playAnim('idle');

				setGraphicSize(Std.int(width * 6));
				updateHitbox();

				antialiasing = false;

				iconName = "senpai";
				charOffsetArray = [150, 360];
				cameraOffsetArray = [-100, -430];

			case 'senpai-angry':
				frames = Paths.getSparrowAtlas("week6/senpai");
				animation.addByPrefix('idle', 'Angry Senpai Idle', 24, false);
				animation.addByPrefix('singUP', 'Angry Senpai UP NOTE', 24, false);
				animation.addByPrefix('singLEFT', 'Angry Senpai LEFT NOTE', 24, false);
				animation.addByPrefix('singRIGHT', 'Angry Senpai RIGHT NOTE', 24, false);
				animation.addByPrefix('singDOWN', 'Angry Senpai DOWN NOTE', 24, false);

				addOffset('idle');
				addOffset("singUP", 6, 36);
				addOffset("singRIGHT");
				addOffset("singLEFT", 24, 6);
				addOffset("singDOWN", 6, 6);
				playAnim('idle');

				setGraphicSize(Std.int(width * 6));
				updateHitbox();

				antialiasing = false;

				iconName = "senpai-angry";
				charOffsetArray = [150, 360];
				cameraOffsetArray = [-100, -430];

			case 'spirit':
				frames = Paths.getPackerAtlas("week6/spirit");
				animation.addByPrefix('idle', "idle spirit_", 24, false);
				animation.addByPrefix('singUP', "up_", 24, false);
				animation.addByPrefix('singRIGHT', "right_", 24, false);
				animation.addByPrefix('singLEFT', "left_", 24, false);
				animation.addByPrefix('singDOWN', "spirit down_", 24, false);

				addOffset('idle', -220, -280);
				addOffset('singUP', -220, -238);
				addOffset("singRIGHT", -220, -280);
				addOffset("singLEFT", -202, -280);
				addOffset("singDOWN", 170, 110);

				setGraphicSize(Std.int(width * 6));
				updateHitbox();

				playAnim('idle');

				antialiasing = false;

				iconName = "spirit";
				charOffsetArray = [-150, 100];
				cameraOffsetArray = [150, 0];

			case 'parents-christmas':
				frames = Paths.getSparrowAtlas("week5/mom_dad_christmas_assets");
				animation.addByPrefix('idle', 'Parent Christmas Idle', 24, false);
				animation.addByPrefix('singUP', 'Parent Up Note Dad', 24, false);
				animation.addByPrefix('singDOWN', 'Parent Down Note Dad', 24, false);
				animation.addByPrefix('singLEFT', 'Parent Left Note Dad', 24, false);
				animation.addByPrefix('singRIGHT', 'Parent Right Note Dad', 24, false);

				animation.addByPrefix('singUP-alt', 'Parent Up Note Mom', 24, false);

				animation.addByPrefix('singDOWN-alt', 'Parent Down Note Mom', 24, false);
				animation.addByPrefix('singLEFT-alt', 'Parent Left Note Mom', 24, false);
				animation.addByPrefix('singRIGHT-alt', 'Parent Right Note Mom', 24, false);

				addOffset('idle');
				addOffset("singUP", -47, 24);
				addOffset("singRIGHT", -1, -23);
				addOffset("singLEFT", -30, 16);
				addOffset("singDOWN", -31, -29);
				addOffset("singUP-alt", -47, 24);
				addOffset("singRIGHT-alt", -1, -24);
				addOffset("singLEFT-alt", -30, 15);
				addOffset("singDOWN-alt", -30, -27);

				playAnim('idle');

				iconName = "parents";
				charOffsetArray = [-500, 0];

			case "tankman":
				frames = Paths.getSparrowAtlas("week7/tankmanCaptain");

				animation.addByPrefix('idle', "Tankman Idle Dance", 24, false);
				animation.addByPrefix('singUP', 'Tankman UP note ', 24, false);
				animation.addByPrefix('singDOWN', 'Tankman DOWN note ', 24, false);
				animation.addByPrefix('singRIGHT', 'Tankman Right Note ', 24, false);
				animation.addByPrefix('singLEFT', 'Tankman Note Left ', 24, false);

				animation.addByPrefix('prettyGood', 'PRETTY GOOD', 24, false);
				animation.addByPrefix('ugh', 'TANKMAN UGH', 24, false);

				/*addOffset("idle", 0, 0);
					addOffset("singDOWN", 78, -106);
					addOffset("singRIGHT", -18, -30);
					addOffset("singUP", 51, 51);
					addOffset("singLEFT", 85, -11);
					addOffset("ugh", -14, -8);
					addOffset("prettyGood", 0, 15); */

				addOffset("idle", 0, 0);
				addOffset("singLEFT", 91, -25);
				addOffset("singDOWN", 68, -106);
				addOffset("ugh", -14, -8);
				addOffset("singRIGHT", -23, -11);
				addOffset("singUP", 27, 58);
				addOffset("prettyGood", 101, 15);

				facesLeft = true;
				playAnim('idle');

				iconName = "tankman";
				charOffsetArray = [-40, 165];

			case 'pico-speaker':
				frames = Paths.getSparrowAtlas('week7/picoSpeaker');

				animation.addByPrefix('shoot1', "Pico shoot 1", 24, false);
				animation.addByPrefix('shoot2', "Pico shoot 2", 24, false);
				animation.addByPrefix('shoot3', "Pico shoot 3", 24, false);
				animation.addByPrefix('shoot4', "Pico shoot 4", 24, false);

				// here for now, will be replaced later for less copypaste
				addOffset("shoot3", 413, -64);
				addOffset("shoot1", 0, 0);
				addOffset("shoot4", 440, -19);
				addOffset("shoot2", 0, -128);

				playAnim('shoot1');

				iconName = "pico";

			case 'guy-lil':
				loadGraphic(Paths.image("chartEditor/lilOpp"), true, 300, 256);

				animation.add("idle", [0, 1], 12, true);

				animation.add("singLEFT", [3, 4, 5], 12, false);
				animation.add("singDOWN", [6, 7, 8], 12, false);
				animation.add("singUP", [9, 10, 11], 12, false);
				animation.add("singRIGHT", [12, 13, 14], 12, false);

				addOffset('idle');
				addOffset("singUP");
				addOffset("singRIGHT");
				addOffset("singLEFT");
				addOffset("singDOWN");

				playAnim('idle');

				antialiasing = false;

				iconName = "face-lil";
			default:
				// eu fiz isso pra experimentar btw
				loadCharInfo('generic/' + curCharacter);
				loadAnims('generic/' + curCharacter + 'Anims');
				loadOffsetFile('generic/' + curCharacter + 'Offsets');
				
				playAnim('idle');
		}

		dance();

		if (((facesLeft && !isPlayer) || (!facesLeft && isPlayer)) && !debugMode)
		{
			flipX = true;

			// var animArray
			var oldRight = animation.getByName("singRIGHT").frames;
			var oldRightOffset = animOffsets.get("singRIGHT");
			animation.getByName("singRIGHT").frames = animation.getByName("singLEFT").frames;
			animOffsets.set("singRIGHT", animOffsets.get("singLEFT"));
			animation.getByName('singLEFT').frames = oldRight;
			animOffsets.set("singLEFT", oldRightOffset);

			// IF THEY HAVE MISS ANIMATIONS??
			if (animation.getByName('singRIGHTmiss') != null)
			{
				var oldMiss = animation.getByName("singRIGHTmiss").frames;
				var oldMissOffset = animOffsets.get("singRIGHTmiss");
				animation.getByName("singRIGHTmiss").frames = animation.getByName("singLEFTmiss").frames;
				animOffsets.set("singRIGHTmiss", animOffsets.get("singLEFTmiss"));
				animation.getByName('singLEFTmiss').frames = oldMiss;
				animOffsets.set("singLEFTmiss", oldMissOffset);
			}
		}

		animation.finishCallback = animationEnd;

		if (characterColor == null)
		{
			characterColor = (isPlayer) ? 0xFF66FF33 : 0xFFFF0000;
		}
	}

	override function update(elapsed:Float)
	{
		if (!debugMode)
		{
			if (!isPlayer)
			{
				if (animation.curAnim.name.startsWith('sing'))
				{
					holdTimer += elapsed;
				}

				if (holdTimer >= Conductor.stepCrochet * stepsUntilRelease * 0.001 && canAutoAnim)
				{
					if (USE_IDLE_END)
					{
						idleEnd();
					}
					else
					{
						dance();
						danceLockout = true;
					}
					holdTimer = 0;
				}
			}
			else
			{
				if (animation.curAnim.name.startsWith('sing'))
				{
					holdTimer += elapsed;
				}
				else
				{
					holdTimer = 0;
				}

				if (animation.curAnim.name.endsWith('miss') && animation.curAnim.finished && canAutoAnim)
				{
					if (USE_IDLE_END)
					{
						idleEnd();
					}
					else
					{
						dance();
						danceLockout = true;
					}
				}
			}

			switch (curCharacter)
			{
				case 'gf':
					if (animation.curAnim.name == 'hairFall' && animation.curAnim.finished)
						playAnim('danceRight');

				case "pico-speaker":
					// for pico??
					if (TankmenBG.animationNotes.length > 0)
					{
						if (Conductor.songPosition > TankmenBG.animationNotes[0][0])
						{
							// trace('played shoot anim' + TankmenBG.animationNotes[0][1]);

							var shootAnim:Int = 1;

							if (TankmenBG.animationNotes[0][1] >= 2)
								shootAnim = 3;

							shootAnim += FlxG.random.int(0, 1);

							playAnim('shoot' + shootAnim, true);
							TankmenBG.animationNotes.shift();
						}
					}
			}
		}

		super.update(elapsed);
		changeOffsets();
	}

	private var danced:Bool = false;

	/**
	 * FOR GF DANCING SHIT
	 */
	public function dance(?ignoreDebug:Bool = false)
	{
		if (!debugMode || ignoreDebug)
		{
			if (danceLockout)
			{
				danceLockout = false;
				return;
			}

			switch (curCharacter)
			{
				case 'gf' | 'gf-bar' | 'gf-qen' | 'gf-car' | 'gf-christmas' | 'gf-pixel' | "gf-tankmen":
					if (!animation.curAnim.name.startsWith('hair'))
					{
						danced = !danced;

						if (danced)
							playAnim('danceRight', true);
						else
							playAnim('danceLeft', true);
					}

				case 'spooky':
					danced = !danced;

					if (danced)
						playAnim('danceRight', true);
					else
						playAnim('danceLeft', true);

				case "pico-speaker":
					playAnim('shoot1');

				default:
					playAnim('idle', true);
			}
		}
	}

	public function idleEnd(?ignoreDebug:Bool = false)
	{
		if (!debugMode || ignoreDebug)
		{
			switch (curCharacter)
			{
				case 'gf' | 'gf-bar' | 'gf-car' | 'gf-christmas' | 'gf-pixel' | "spooky" | "gf-tankmen":
					playAnim('danceRight', true, false, animation.getByName('danceRight').numFrames - 1);
				case "pico-speaker":
					playAnim(animation.curAnim.name, true, false, animation.getByName(animation.curAnim.name).numFrames - 1);
				default:
					playAnim('idle', true, false, animation.getByName('idle').numFrames - 1);
			}
		}
	}

	public function playAnim(AnimName:String, Force:Bool = false, Reversed:Bool = false, Frame:Int = 0):Void
	{
		if (animSet != "")
		{
			if (animation.exists(AnimName + "-" + animSet))
			{
				AnimName = AnimName + "-" + animSet;
			}
			else
			{
				trace(AnimName + "-" + animSet + " not found. Reverting to " + AnimName);
			}
		}

		animation.play(AnimName, Force, Reversed, Frame);
		changeOffsets();

		if (curCharacter == 'gf')
		{
			if (AnimName == 'singLEFT')
			{
				danced = true;
			}
			else if (AnimName == 'singRIGHT')
			{
				danced = false;
			}

			if (AnimName == 'singUP' || AnimName == 'singDOWN')
			{
				danced = !danced;
			}
		}
	}

	function changeOffsets()
	{
		if (animOffsets.exists(animation.curAnim.name))
		{
			var animOffset = animOffsets.get(animation.curAnim.name);

			var xOffsetAdjust:Float = animOffset[0];
			if (flipX == true)
			{
				xOffsetAdjust *= -1;
				xOffsetAdjust += frameWidth;
				xOffsetAdjust -= width;
			}

			var yOffsetAdjust:Float = animOffset[1];
			/*if(flipY == true){
				yOffsetAdjust *= -1;
				yOffsetAdjust += frameHeight;
				yOffsetAdjust -= height;
			}*/

			offset.set(xOffsetAdjust, yOffsetAdjust);
		}
		else
		{
			offset.set(0, 0);
		}
	}

	public function addOffset(name:String, x:Float = 0, y:Float = 0)
	{
		animOffsets[name] = [x, y];
	}

	// e agora uns bagulho q eu adicionei enquanto eu esperava o sket fazer as cutscene pq eu nao tinha nada melhor pra fazer
	// personagens softcoded
	// ta na hora de botar polymod nessa merda
	// FOI
	private function loadCharInfo(infoPath:String)
	{
		var daFile:Array<String> = CoolUtil.coolTextFile("assets/images/" + infoPath + ".txt");

		for (i in daFile)
		{	
			var splitWords:Array<String> = i.split(";");
			// spritesheet path, icon name, char offset [X, Y], camera offset [X, Y], antialiasing, deathchar, does it face left
			
			// frames = FlxAtlasFrames.fromSparrow(data, xmlCool);
			frames = Paths.getSparrowAtlas(splitWords[0]);
			iconName = splitWords[1];
			charOffsetArray = [Std.parseInt(splitWords[2]), Std.parseInt(splitWords[3])];
			cameraOffsetArray = [Std.parseInt(splitWords[4]), Std.parseInt(splitWords[5])];
			antialiasing = (splitWords[6] == 'true' ? true : false);
			deathCharacter = splitWords[7];
			facesLeft = (splitWords[8] == 'true' ? true : false);
		}
	}
	
	private function loadOffsetFile(offsetPath:String)
	{
		var daFile:Array<String> = CoolUtil.coolTextFile("assets/images/" + offsetPath + ".txt");

		for (i in daFile)
		{
			var splitWords:Array<String> = i.split(";");
			addOffset(splitWords[0], Std.parseInt(splitWords[1]), Std.parseInt(splitWords[2]));
			
			if (splitWords[0] == 'idle' || splitWords[0] == 'danceRight')
				playAnim(splitWords[0]);
		}
	}

	private function loadAnims(animsPath:String)
	{
		var daFile:Array<String> = CoolUtil.coolTextFile("assets/images/" + animsPath + ".txt");

		for (i in daFile)
		{
			var splitWords:Array<String> = i.split(";");
			// anim name, prefix, fps, does it loop
			animation.addByPrefix(splitWords[0], splitWords[1], Std.parseInt(splitWords[2]), (splitWords[3] == 'true' ? true : false));
		}
	}
	// cabo os personagem softcoded xd
	
	function animationEnd(name:String)
	{
		danceLockout = false;

		switch (curCharacter)
		{
			case "dad" | "mom" | "mom-car" | "bf-car":
				playAnim(name, true, false, animation.getByName(name).numFrames - 4);

			case "bf" | "bf-christmas" | "bf-pixel" | "bf-holding-gf" | "bf-qen" | "pico":
				if (name.contains("miss"))
				{
					playAnim(name, true, false, animation.getByName(name).numFrames - 4);
				}

			case "bf-lil" | "guy-lil":
				if (name.contains("miss"))
				{
					playAnim(name, true, false, animation.getByName(name).numFrames - 4);
				}
				else
				{
					playAnim(name, true, false, animation.getByName(name).numFrames - 2);
				}

			case "monster-christmas" | "monster":
				switch (name)
				{
					case "idle":
						playAnim(name, false, false, 10);
					case "singUP":
						playAnim(name, false, false, 8);
					case "singDOWN":
						playAnim(name, false, false, 7);
					case "singLEFT":
						playAnim(name, false, false, 5);
					case "singRIGHT":
						playAnim(name, false, false, 6);
				}

			case "pico-speaker":
				playAnim(animation.curAnim.name, false, false, animation.curAnim.numFrames - 3);
		}
	}
}
