package;

#if sys
import sys.io.File;
import sys.FileSystem;
#end
import flixel.math.FlxMath;
import flixel.FlxG;
import lime.utils.Assets;

using StringTools;

class CoolUtil
{
	public static function coolTextFile(path:String):Array<String>
	{
		var daList:Array<String> = getText(path).trim().split('\n');

		for (i in 0...daList.length)
		{
			daList[i] = daList[i].trim();
		}

		return daList;
	}

	public static function numberArray(max:Int, ?min = 0):Array<Int>
	{
		var dumbArray:Array<Int> = [];
		for (i in min...max)
		{
			dumbArray.push(i);
		}
		return dumbArray;
	}

	/**
		Lerps camera, but accounts for framerate shit?
		Right now it's simply for use to change the followLerp variable of a camera during update
		TODO LATER MAYBE:
			Actually make and modify the scroll and lerp shit in it's own function
			instead of solely relying on changing the lerp on the fly
	 */
	public static inline function fpsAdjust(value:Float, ?referenceFps:Float = 60):Float
	{
		return value * (FlxG.elapsed / (1 / referenceFps));
	}

	/*
	 * just lerp that does camLerpShit for u so u dont have to do it every time
	 */
	public static inline function fpsAdjsutedLerp(a:Float, b:Float, ratio:Float):Float
	{
		return FlxMath.lerp(a, b, fpsAdjust(ratio));
	}

	/*
	 * Uses FileSystem.exists for desktop and Assets.exists for non-desktop builds.
	 * This is because Assets.exists just checks the manifest and can't find files that weren't compiled with the game.
	 * This also means that if you delete a file, it will return true because it's still in the manifest.
	 * FileSystem only works on certain build types though (namely, not web).
	 */
	public static function exists(path:String):Bool
	{
		#if desktop
		return FileSystem.exists(path);
		#else
		return Assets.exists(path);
		#end
	}
	
	// Same as above but for getting text from a file.
	public static function getText(path:String):String
	{
		#if desktop
		return File.getContent(path);
		#else
		return Assets.getText(path);
		#end
	}
	
	public static function chartExists(songName:String, curDifficulty:Int):Bool
	{
		var difString:String = '';
		var real:Bool = false;
		
		switch (curDifficulty) {
			case 0:
				difString = "-easy";
			case 2:
				difString = "-hard";
		}

		real = exists('assets/data/' + songName + '/' + songName + difString + '.json');
		trace('assets/data/' + songName + '/' + songName + difString + '.json is a ' + real);
		return real;
	}
	
	public static function weekGfxWork(weekNum:Int):Bool
	{
		// isso aqui e uma gambiarra IMENSA vamo la

		var weekCheck:Array<String>;
		var everyoneIsHere:Bool = true;

		switch (weekNum)
		{
			case 1:
				weekCheck = [
					"week1/DADDY_DEAREST",
					"week1/stageback", "week1/stagefront", "week1/stagecurtains"
				];

			case 2:
				weekCheck = [
				"week2/spooky_kids_assets", "week2/Monster_Assets", 
				"week2/halloween_bg"
				];
			case 3:
				weekCheck = [
					"week3/Pico_FNF_assetss", 
					"week3/philly/sky", "week3/philly/city", "week3/philly/behindTrain", "week3/philly/train",
					"week3/philly/street", 
					"week3/philly/win0", "week3/philly/win1", "week3/philly/win2", "week3/philly/win3", "week3/philly/win4"
				];
			case 4:
				weekCheck = [
					"week4/gfCar", "week4/bfCar", "week4/momCar",
					"week4/limo/bgLimo",
					"week4/limo/fastCarLol",
					"week4/limo/limoDancer",
					"week4/limo/limoDrive",
					"week4/limo/limoSunset"
				];
			case 5:
				weekCheck = [
					"week5/gfChristmas", "week5/bfChristmas", "week5/mom_dad_christmas_assets", "week5/monsterChristmas",
					"week5/christmas/bgWalls",
					"week5/christmas/upperBop",
					"week5/christmas/bgEscalator",
					"week5/christmas/christmasTree",
					"week5/christmas/bottomBop",
					"week5/christmas/fgSnow",
					"week5/christmas/santa",
					"week5/christmas/evilBG",
					"week5/christmas/evilTree",
					"week5/christmas/evilSnow"
				];
			case 6:
				weekCheck = [
					"week6/gfPixel", "week6/bfPixel", "week6/bfPixelsDEAD", "week6/senpai", "week6/spirit",
					"week6/weeb/weebSky",
					"week6/weeb/weebSchool",
					"week6/weeb/weebStreet",
					"week6/weeb/weebTreesBack",
					"week6/weeb/weebTrees",
					"week6/weeb/petals",
					"week6/weeb/bgFreaks",
					"week6/weeb/animatedEvilSchool",
					"week6/weeb/senpaiCrazy"
				];
			case 7:
				weekCheck = [
					"week7/gfTankmen", "week7/bfAndGF", "week7/bfHoldingGF-DEAD", "week7/picoSpeaker", "week7/tankmanCaptain", 
					"week7/stage/tank0", "week7/stage/tank1", "week7/stage/tank2", "week7/stage/tank3", "week7/stage/tank4", "week7/stage/tank5", "week7/stage/tankmanKilled1",
					"week7/stage/smokeLeft", "week7/stage/smokeRight", "week7/stage/tankBuildings", "week7/stage/tankClouds", "week7/stage/tankGround",
					"week7/stage/tankMountains", "week7/stage/tankRolling", "week7/stage/tankRuins", "week7/stage/tankSky", "week7/stage/tankWatchtower"
				];
				
			case 8: // ESPE
				weekCheck = [
					"especula/espe"
				];
			case 9: // SCDM
				weekCheck = [
					"scdm/scdm",
					"scdm/stage/ceuBrabo",
					"scdm/stage/fundoBrabo",
					"scdm/stage/ruaBraba"
				];
			default:
				weekCheck = ["week1/stageback", "week1/stagefront", "week1/stagecurtains"];
		}

		for (asset in weekCheck)
		{
			// codigo bosta. bolamos regardless
			if (exists('assets/images/' + asset + '.xml'))
			{
				if (exists('assets/images/' + asset + '.png'))
				{
					trace('Swag. assets/images/' + asset + ' is Real');
				}
			}
			else
			{
				if (exists('assets/images/' + asset + '.png'))
				{
					trace('Swag. assets/images/' + asset + ' is Real');
				}
				else
				{
					trace('Whoopsie! Missin Shit! Most Specifically assets/images/' + asset);
					everyoneIsHere = false;
				}
			}
		}

		return everyoneIsHere;
		trace(everyoneIsHere);
	}

	public static function weekExists(weekNum:Int):Bool
	{
		// isso aqui e uma gambiarra um pouco menor mas ainda assim bolamos
		var weekCheck:String = "week1";
		
		switch (weekNum)
		{
			case 0: 
				weekCheck = "week1";
			case 8: // ESPE
				weekCheck = "especula";
			case 9: // SCDM
				weekCheck = "scdm";
			default:
				weekCheck = "week" + weekNum;
		}

		return exists('assets/images/' + weekCheck + '/');
	}
}
