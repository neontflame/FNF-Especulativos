package;

#if sys
import sys.FileSystem;
#end
import flixel.tweens.FlxTween;
import flixel.ui.FlxBar;
import openfl.media.Sound;
import title.*;
import config.*;
import transition.data.*;

import flixel.FlxState;
import flixelExtensions.FlxUIStateExt;
import lime.utils.Assets;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;
import flixel.text.FlxText;
import openfl.system.System;
//import openfl.utils.Future;
//import flixel.addons.util.FlxAsyncLoop;

using StringTools;

class Startup extends FlxState
{

    var nextState:FlxState = new TitleHaxeSplash();

    var loadingBar:FlxBar;
    var loadingText:FlxText;

    var currentLoaded:Int = 0;
    var loadTotal:Int = 1;
	var lmfaoTrolled:Bool = false;

	public static var songsCacheActive:Bool = false;
		
    var songsCached:Bool;
    public static final songs:Array<String> =   ["Tutorial", 
                                "Bopeebo", "Fresh", "Dadbattle", 
                                "Spookeez", "South", "Monster",
                                "Pico", "Philly", "Blammed", 
                                "Satin-Panties", "High", "Milf", 
                                "Cocoa", "Eggnog", "Winter-Horrorland", 
                                "Senpai", "Roses", "Thorns",
                                "Ugh", "Guns", "Stress",
								"Hihi", "Tres-Bofetadas",
								"Do-Mal",
                                "Lil-Buddies",
                                "klaskiiLoop", "especulaintro", "coolMenu"]; //Start of the non-gameplay songs.
                                
    //List of character graphics and some other stuff.
    //Just in case it want to do something with it later.
    var charactersCached:Bool;
    var startCachingCharacters:Bool = false;
    var charI:Int = 0;
	
    public static final characters:Array<String> =   ["BOYFRIEND", "week4/bfCar", "week5/bfChristmas", "week6/bfPixel", "week6/bfPixelsDEAD", "week7/bfAndGF", "week7/bfHoldingGF-DEAD", "qen/bf", 
                                    "GF_assets", "week4/gfCar", "week5/gfChristmas", "week6/gfPixel", "week7/gfTankmen", "especula/girlfriendBar",
                                    "week1/DADDY_DEAREST", 
                                    "week2/spooky_kids_assets", "week2/Monster_Assets",
                                    "week3/Pico_FNF_assetss", "week7/picoSpeaker",
                                    "week4/Mom_Assets", "week4/momCar",
                                    "week5/mom_dad_christmas_assets", "week5/monsterChristmas",
                                    "week6/senpai", "week6/spirit",
                                    "week7/tankmanCaptain",
									"especula/espe",
									"scdm/scdm",
									"yotsu/yotuba",
									"qen/narigao"
									];

    var graphicsCached:Bool;
    var startCachingGraphics:Bool = false;
    var gfxI:Int = 0;
    public static final graphics:Array<String> =    [
									"alphabet", "ui/NOTE_assets", "ui/noteSplashes",
									"titleEnter", "fpsPlus/title/espeDj", "fpsPlus/title/logoBump",
									"menu/headerStuffs", "menu/footer", "menu/scratchBG", "menu/fnfScratch", "menu/freeplay/longerMenuThing", // menu shits end here
                                    "week1/stageback", "week1/stagefront", "week1/stagecurtains",
                                    "week2/halloween_bg",
                                    "week3/philly/sky", "week3/philly/city", "week3/philly/behindTrain", "week3/philly/train", "week3/philly/street", "week3/philly/win0", "week3/philly/win1", "week3/philly/win2", "week3/philly/win3", "week3/philly/win4",
                                    "week4/limo/bgLimo", "week4/limo/fastCarLol", "week4/limo/limoDancer", "week4/limo/limoDrive", "week4/limo/limoSunset",
                                    "week5/christmas/bgWalls", "week5/christmas/upperBop", "week5/christmas/bgEscalator", "week5/christmas/christmasTree", "week5/christmas/bottomBop", "week5/christmas/fgSnow", "week5/christmas/santa",
                                    "week5/christmas/evilBG", "week5/christmas/evilTree", "week5/christmas/evilSnow",
                                    "week6/weeb/weebSky", "week6/weeb/weebSchool", "week6/weeb/weebStreet", "week6/weeb/weebTreesBack", "week6/weeb/weebTrees", "week6/weeb/petals", "week6/weeb/bgFreaks",
                                    "week6/weeb/animatedEvilSchool", "week6/weeb/senpaiCrazy",
                                    "week7/stage/tank0", "week7/stage/tank1", "week7/stage/tank2", "week7/stage/tank3", "week7/stage/tank4", "week7/stage/tank5", "week7/stage/tankmanKilled1", 
                                    "week7/stage/smokeLeft", "week7/stage/smokeRight", "week7/stage/tankBuildings", "week7/stage/tankClouds", "week7/stage/tankGround", "week7/stage/tankMountains", "week7/stage/tankRolling", "week7/stage/tankRuins", "week7/stage/tankSky", "week7/stage/tankWatchtower",
									"especula/stage/adegaFunny", "especula/stage/barMesa", "especula/stage/bgTijolos", "especula/stage/cadeiras", "especula/stage/chao", "especula/stage/coisas", "especula/stage/escarradeira", "especula/stage/sushiCaidoTodoFodido",
									"scdm/stage/ceuBrabo", "scdm/stage/fundoBrabo", "scdm/stage/ruaBraba"
									];

    var cacheStart:Bool = false;

    public static var thing = false;

    public static var hasEe2:Bool;

    public static var hasYotsu:Bool;
    public static var hasQeN:Bool;
	
	public static function reloadMods()
	{
		#if EXPERIMENTAL_MODDING
		var modListTxt:String = CoolUtil.getText('mods/modList.txt');
		var modList:Array<String> = modListTxt.split(';');
		
		// yo shoutouts to funkin multikey
		polymod.Polymod.init({
			modRoot:"mods",
			dirs: modList,
			framework: OPENFL,
			errorCallback: function(error:polymod.Polymod.PolymodError){ 
			trace(error.message); 
			}
		});
		#else
		trace('que mane modding o que');
		#end
	} 
	
	override function create()
	{
        FlxG.mouse.visible = false;
        FlxG.sound.muteKeys = null;

        // FlxG.save.bind('data');
		Highscore.load();
		SaveManager.global();
		KeyBinds.keyCheck();
		PlayerSettings.init();

        PlayerSettings.player1.controls.loadKeyBinds();
		Config.configCheck();
		Config.reload();

        Main.fpsDisplay.visible = Config.showFPS;

        /*Switched to a new custom transition system.
        var diamond:FlxGraphic = FlxGraphic.fromClass(GraphicTransTileDiamond);
        diamond.persist = true;
        diamond.destroyOnNoUse = false;
        
        FlxTransitionableState.defaultTransIn = new TransitionData(FADE, FlxColor.BLACK, 1, new FlxPoint(0, -1), 
            {asset: diamond, width: 32, height: 32},  new FlxRect(-200, -200, FlxG.width * 1.4, FlxG.height * 1.4));
        FlxTransitionableState.defaultTransOut = new TransitionData(FADE, FlxColor.BLACK, 0.7, new FlxPoint(0, 1),
            {asset: diamond, width: 32, height: 32}, new FlxRect(-200, -200, FlxG.width * 1.4, FlxG.height * 1.4));
        */

        FlxUIStateExt.defaultTransIn = ScreenWipeIn;
        FlxUIStateExt.defaultTransInArgs = [1.2];
        FlxUIStateExt.defaultTransOut = ScreenWipeOut;
        FlxUIStateExt.defaultTransOutArgs = [0.6];

        if (FlxG.save.data.weekUnlocked != null)
		{
			// FIX LATER!!!
			// WEEK UNLOCK PROGRESSION!!
			// StoryMenuState.weekUnlocked = FlxG.save.data.weekUnlocked;

			if (StoryMenuState.weekUnlocked.length < 4)
				StoryMenuState.weekUnlocked.insert(0, true);

			// QUICK PATCH OOPS!
			if (!StoryMenuState.weekUnlocked[0])
				StoryMenuState.weekUnlocked[0] = true;
		}

        if( FlxG.save.data.musicPreload2 == null ||
            FlxG.save.data.charPreload2 == null ||
            FlxG.save.data.graphicsPreload2 == null)
        {
            openPreloadSettings();
        }
        else{
            songsCached = !FlxG.save.data.musicPreload2;
            charactersCached = !FlxG.save.data.charPreload2;
            graphicsCached = !FlxG.save.data.graphicsPreload2;
        }

        hasEe2 = CoolUtil.exists(Paths.inst("Lil-Buddies"));
		
        hasYotsu = CoolUtil.exists(Paths.inst("Street-Musician"));
        hasQeN = CoolUtil.exists(Paths.inst("fnfolas"));
		
		if (FlxG.random.int(0, 85) == 85) 
			lmfaoTrolled = true;
			
		reloadMods();

		songsCacheActive = FlxG.save.data.musicPreload2;
		
		super.create();
		
		var bg:FlxSprite = new FlxSprite();
		bg.makeGraphic(FlxG.width, FlxG.height, 0xFF959595);
		add(bg);

		var scratchThing = new FlxSprite(330 - 10, 221 - 10);
		scratchThing.loadGraphic(Paths.image('fpsPlus/loading/modCarregando'));
		add(scratchThing);

        loadTotal = (!songsCached ? songs.length : 1) + (!charactersCached ? characters.length : 1) + (!graphicsCached ? graphics.length : 1);

        if(loadTotal > 0){
            loadingBar = new FlxBar(0, 280, LEFT_TO_RIGHT, 475, 54, this, 'currentLoaded', 0, loadTotal);
            loadingBar.createImageBar(Paths.image('fpsPlus/loading/loadCoisaVazio'), Paths.image('fpsPlus/loading/loadCoisaCheio'));
            loadingBar.screenCenter(X);
            loadingBar.visible = false;
            add(loadingBar);
        }

        loadingText = new FlxText(5, 420, 0, "", 24);
        loadingText.setFormat(Paths.font("arial"), 24, 0xFF343434, CENTER);
		loadingText.screenCenter(X);
        add(loadingText);

        #if web
        FlxG.sound.play(Paths.sound("tick"), 0);   
        #end

        new FlxTimer().start(1.1, function(tmr:FlxTimer)
        {
            // FlxG.sound.play(Paths.sound("splashSound"));   
        });

    }

    override function update(elapsed) 
    {
        loadingText.text = currentLoaded + " of " + loadTotal + " assets loaded";
		loadingText.screenCenter(X);
		
		new FlxTimer().start(2.3, function(tmr:FlxTimer)
		{
		
        if(!cacheStart){
            
            #if web
            new FlxTimer().start(1.5, function(tmr:FlxTimer)
            {
                songsCached = true;
                charactersCached = true;
                graphicsCached = true;
            });
            #else
            if(!songsCached || !charactersCached || !graphicsCached){
                preload(); 
            }
            #end
            
            cacheStart = true;
        }
		});
		
        if(songsCached && charactersCached && graphicsCached){
            
            //System.gc();
			
            /* new FlxTimer().start(0.3, function(tmr:FlxTimer){
                loadingText.text = "Done!";
				loadingText.screenCenter(X);
                
				/* if(loadingBar != null){
                    FlxTween.tween(loadingBar, {alpha: 0}, 0.3);
                }
            }); */
			
			new FlxTimer().start(0.5, function(tmr:FlxTimer)
			{
				#if sys System.gc(); #end
				if (!lmfaoTrolled) {
					FlxG.switchState(nextState); 
				}
			});
        }

        if(!cacheStart && FlxG.keys.justPressed.ANY){
            openPreloadSettings();
        }

        if(startCachingCharacters){
            if(charI >= characters.length){
                loadingText.text = "Characters cached...";
                startCachingCharacters = false;
                charactersCached = true;
            }
            else{
                if(CoolUtil.exists(Paths.file(characters[charI], "images", "png"))){
                    ImageCache.add(Paths.file(characters[charI], "images", "png"));
					trace("Character: " + characters[charI] + " added.");
                }
                else{
                    trace("Character: File at " + characters[charI] + " not found, skipping cache.");
                }
                charI++;
                currentLoaded++;
            }
        }

        if(startCachingGraphics){
            if(gfxI >= graphics.length){
                startCachingGraphics = false;
                graphicsCached = true;
            }
            else{
                if(CoolUtil.exists(Paths.file(graphics[gfxI], "images", "png"))){
                    ImageCache.add(Paths.file(graphics[gfxI], "images", "png"));
					trace("Graphics: " + graphics[gfxI] + " added.");
                }
                else{
                    trace("Graphics: File at " + graphics[gfxI] + " not found, skipping cache.");
                }
                gfxI++;
                currentLoaded++;
            }
        }
        
        super.update(elapsed);

    }

    function preload(){

        loadingText.text = currentLoaded + " of " + loadTotal + " assets loaded";
        loadingText.screenCenter(X);
		
        if(loadingBar != null){
            loadingBar.visible = true;
        }
        
        if(!songsCached){ 
            #if sys sys.thread.Thread.create(() -> { #end
                preloadMusic();
            #if sys }); #end
        }
        

        /*if(!charactersCached){
            var i = 0;
            var charLoadLoop = new FlxAsyncLoop(characters.length, function(){
                ImageCache.add(Paths.file(characters[i], "images", "png"));
                i++;
            }, 1);
        }

        for(x in characters){
            
            //trace("Chached " + x);
        }
        loadingText.text = "Characters cached...";
        charactersCached = true;*/

        if(!charactersCached){
            startCachingCharacters = true;
        }

        if(!graphicsCached){
            startCachingGraphics = true;
        }

    }

    function preloadMusic(){
        for(x in songs){
            if(CoolUtil.exists(Paths.inst(x))){
                FlxG.sound.cache(Paths.inst(x));
            }
            else{
                FlxG.sound.cache(Paths.music(x));
            }
            currentLoaded++;
        }
        // loadingText.text = "Songs cached";
		loadingText.text = currentLoaded + " of " + loadTotal + " assets loaded";
		loadingText.screenCenter(X);
        songsCached = true;
    }

    function preloadCharacters(){
        for(x in characters){
            ImageCache.add(Paths.file(x, "images", "png"));
            //trace("Chached " + x);
        }
		loadingText.text = currentLoaded + " of " + loadTotal + " assets loaded";
		loadingText.screenCenter(X);
        charactersCached = true;
    }

    function preloadGraphics(){
        for(x in graphics){
            ImageCache.add(Paths.file(x, "images", "png"));
            //trace("Chached " + x);
        }
		loadingText.text = currentLoaded + " of " + loadTotal + " assets loaded";
		loadingText.screenCenter(X);
        graphicsCached = true;
    }

    function openPreloadSettings(){
        #if desktop
        CacheSettings.noFunMode = true;
        FlxG.switchState(new CacheSettings());
        CacheSettings.returnLoc = new Startup();
        #end
    }

}
