package usefulshits;
// this file is for modchart things, this is to declutter playstate.hx
// Lua
import flixel.graphics.FlxGraphic;
import flixel.animation.FlxBaseAnimation;
import flixel.graphics.frames.FlxAtlasFrames;
#if EXPERIMENTAL_MODDING
import openfl.utils.Assets as OpenFlAssets;
#end
#if EXPERIMENTAL_LUA
import flixel.tweens.FlxEase;
// import openfl.filters.ShaderFilter;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import openfl.geom.Matrix;
import openfl.display.BitmapData;
import lime.app.Application;
import flixel.FlxSprite;
import llua.Convert;
import llua.Lua;
import llua.State;
import llua.LuaL;
import flixel.FlxBasic;
import flixel.FlxCamera;
import flixel.FlxG;
import config.*;

class ModchartState
{
	// public static var shaders:Array<LuaShader> = null;
	public static var lua:State = null;

	function callLua(func_name:String, args:Array<Dynamic>, ?type:String):Dynamic
	{
		var result:Any = null;

		Lua.getglobal(lua, func_name);

		for (arg in args)
		{
			Convert.toLua(lua, arg);
		}

		result = Lua.pcall(lua, args.length, 1, 0);
		var p = Lua.tostring(lua, result);
		var e = getLuaErrorMessage(lua);

		if (e != null)
		{
			if (p != null)
			{
				Application.current.window.alert("LUA ERROR:\n" + p + "\nhaxe things: " + e, "Kade Engine Modcharts");
				lua = null;
				PlayState.instance.switchState(new MainMenuState());
			}
			// trace('err: ' + e);
		}
		if (result == null)
		{
			return null;
		}
		else
		{
			return convert(result, type);
		}
	}

	static function toLua(l:State, val:Any):Bool
	{
		switch (Type.typeof(val))
		{
			case Type.ValueType.TNull:
				Lua.pushnil(l);
			case Type.ValueType.TBool:
				Lua.pushboolean(l, val);
			case Type.ValueType.TInt:
				Lua.pushinteger(l, cast(val, Int));
			case Type.ValueType.TFloat:
				Lua.pushnumber(l, val);
			case Type.ValueType.TClass(String):
				Lua.pushstring(l, cast(val, String));
			case Type.ValueType.TClass(Array):
				Convert.arrayToLua(l, val);
			case Type.ValueType.TObject:
				objectToLua(l, val);
			default:
				trace("haxe value not supported - " + val + " which is a type of " + Type.typeof(val));
				return false;
		}

		return true;
	}

	static function objectToLua(l:State, res:Any)
	{
		var FUCK = 0;
		for (n in Reflect.fields(res))
		{
			trace(Type.typeof(n).getName());
			FUCK++;
		}

		Lua.createtable(l, FUCK, 0); // TODONE: I did it

		for (n in Reflect.fields(res))
		{
			if (!Reflect.isObject(n))
				continue;
			Lua.pushstring(l, n);
			toLua(l, Reflect.field(res, n));
			Lua.settable(l, -3);
		}
	}

	function getType(l, type):Any
	{
		return switch Lua.type(l, type)
		{
			case t if (t == Lua.LUA_TNIL): null;
			case t if (t == Lua.LUA_TNUMBER): Lua.tonumber(l, type);
			case t if (t == Lua.LUA_TSTRING): (Lua.tostring(l, type) : String);
			case t if (t == Lua.LUA_TBOOLEAN): Lua.toboolean(l, type);
			case t: throw 'you don goofed up. lua type error ($t)';
		}
	}

	function getReturnValues(l)
	{
		var lua_v:Int;
		var v:Any = null;
		while ((lua_v = Lua.gettop(l)) != 0)
		{
			var type:String = getType(l, lua_v);
			v = convert(lua_v, type);
			Lua.pop(l, 1);
		}
		return v;
	}

	private function convert(v:Any, type:String):Dynamic
	{ // I didn't write this lol
		if (Std.is(v, String) && type != null)
		{
			var v:String = v;
			if (type.substr(0, 4) == 'array')
			{
				if (type.substr(4) == 'float')
				{
					var array:Array<String> = v.split(',');
					var array2:Array<Float> = new Array();

					for (vars in array)
					{
						array2.push(Std.parseFloat(vars));
					}

					return array2;
				}
				else if (type.substr(4) == 'int')
				{
					var array:Array<String> = v.split(',');
					var array2:Array<Int> = new Array();

					for (vars in array)
					{
						array2.push(Std.parseInt(vars));
					}

					return array2;
				}
				else
				{
					var array:Array<String> = v.split(',');
					return array;
				}
			}
			else if (type == 'float')
			{
				return Std.parseFloat(v);
			}
			else if (type == 'int')
			{
				return Std.parseInt(v);
			}
			else if (type == 'bool')
			{
				if (v == 'true')
				{
					return true;
				}
				else
				{
					return false;
				}
			}
			else
			{
				return v;
			}
		}
		else
		{
			return v;
		}
	}

	private function stringToEase(?ease:String)
	{
		switch (ease) {
			case "backIn":
				return FlxEase.backIn;
			case "backInOut":			
				return FlxEase.backInOut;
			case "backOut":
				return FlxEase.backOut;
			case "bounceIn":
				return FlxEase.bounceIn;
			case "bounceInOut":
				return FlxEase.bounceInOut;
			case "bounceOut":
				return FlxEase.bounceOut;
			case "circIn":
				return FlxEase.circIn;
			case "circInOut":
				return FlxEase.circInOut;
			case "circOut":
				return FlxEase.circOut;
			case "cubeIn":
				return FlxEase.cubeIn;
			case "cubeInOut":
				return FlxEase.cubeInOut;
			case "cubeOut":
				return FlxEase.cubeOut;
			case "elasticIn":
				return FlxEase.elasticIn;
			case "elasticInOut":
				return FlxEase.elasticInOut;
			case "elasticOut":
				return FlxEase.elasticOut;
			case "expoIn":
				return FlxEase.expoIn;
			case "expoInOut":
				return FlxEase.expoInOut;
			case "expoOut":
				return FlxEase.expoOut;
			case "linear":
				return FlxEase.linear;
			case "quadIn":
				return FlxEase.quadIn;
			case "quadInOut":
				return FlxEase.quadInOut;
			case "quadOut":
				return FlxEase.quadOut;
			case "quartIn":
				return FlxEase.quartIn;
			case "quartInOut":
				return FlxEase.quartInOut;
			case "quartOut":
				return FlxEase.quartOut;
			case "quintIn":
				return FlxEase.quintIn;
			case "quintInOut":
				return FlxEase.quintInOut;
			case "quintOut":
				return FlxEase.quintOut;
			case "sineIn":
				return FlxEase.sineIn;
			case "sineInOut":
				return FlxEase.sineInOut;
			case "sineOut":
				return FlxEase.sineOut;
			case "smoothStepIn":
				return FlxEase.smoothStepIn;
			case "smoothStepInOut":
				return FlxEase.smoothStepInOut;
			case "smoothStepOut":
				return FlxEase.smoothStepOut;
			case "smootherStepIn":
				return FlxEase.smootherStepIn;
			case "smootherStepInOut":
				return FlxEase.smootherStepInOut;
			case "smootherStepOut":
				return FlxEase.smootherStepOut;
			default:
				return FlxEase.linear;
		}
	}
	
	function getLuaErrorMessage(l)
	{
		var v:String = Lua.tostring(l, -1);
		Lua.pop(l, 1);
		return v;
	}

	public function setVar(var_name:String, object:Dynamic)
	{
		// trace('setting variable ' + var_name + ' to ' + object);

		Lua.pushnumber(lua, object);
		Lua.setglobal(lua, var_name);
	}

	public function getVar(var_name:String, type:String):Dynamic
	{
		var result:Any = null;

		// trace('getting variable ' + var_name + ' with a type of ' + type);

		Lua.getglobal(lua, var_name);
		result = Convert.fromLua(lua, -1);
		Lua.pop(lua, 1);

		if (result == null)
		{
			return null;
		}
		else
		{
			var result = convert(result, type);
			// trace(var_name + ' result: ' + result);
			return result;
		}
	}

	function getActorByName(id:String):Dynamic
	{
		// pre defined names
		switch (id)
		{
			case 'boyfriend':
				return PlayState.instance.boyfriend;
			case 'girlfriend':
				return PlayState.instance.gf;
			case 'dad':
				return PlayState.instance.dad;
		}
		// lua objects or what ever
		if (luaSprites.get(id) == null)
		{
			if (Std.parseInt(id) == null) {
				@:privateAccess
				return Reflect.getProperty(PlayState.instance, id);
			}
			return PlayState.strumLineNotes.members[Std.parseInt(id)];
		}
		return luaSprites.get(id);
	}

	function getPropertyByName(id:String)
	{
		return Reflect.field(PlayState.instance, id);
	}

	public static var luaSprites:Map<String, FlxSprite> = [];

	function changeDadCharacter(id:String)
	{
		PlayState.instance.executeEvent("changeChar;dad;" + id);
	}

	function changeBoyfriendCharacter(id:String)
	{
		PlayState.instance.executeEvent("changeChar;boyfriend;" + id);
	}

	function makeAnimatedLuaSprite(spritePath:String, names:Array<String>, prefixes:Array<String>, startAnim:String, id:String, drawBehind:Bool, customPath:String = null)
	{
		#if sys
		// TODO: Make this use OpenFlAssets.
		var data:BitmapData = BitmapData.fromFile(Sys.getCwd() + (customPath != null ? customPath : "assets/data/" + PlayState.SONG.song.toLowerCase()) + '/' + spritePath + ".png");
			
		var sprite:FlxSprite = new FlxSprite(0, 0);

		sprite.frames = FlxAtlasFrames.fromSparrow(FlxGraphic.fromBitmapData(data), 
		(customPath != null ? customPath : "assets/data/" + PlayState.SONG.song.toLowerCase()) + '/' + spritePath + ".xml");

		trace(sprite.frames.frames.length);

		for (p in 0...names.length)
		{
			var i = names[p];
			var ii = prefixes[p];
			sprite.animation.addByPrefix(i, ii, 24, false);
		}

		luaSprites.set(id, sprite);

		if (drawBehind)
		{
			PlayState.instance.removeObject(PlayState.instance.gfGroup);
			PlayState.instance.removeObject(PlayState.instance.bfGroup);
			PlayState.instance.removeObject(PlayState.instance.dadGroup);

			if (Config.comboType == 0)
				@:privateAccess
				PlayState.instance.removeObject(PlayState.instance.comboUI);
		}
			
		PlayState.instance.addObject(sprite);
			
		if (drawBehind)
		{
			PlayState.instance.addObject(PlayState.instance.gfGroup);
			PlayState.instance.addObject(PlayState.instance.bfGroup);
			PlayState.instance.addObject(PlayState.instance.dadGroup);

			if (Config.comboType == 0)
				@:privateAccess
				PlayState.instance.addObject(PlayState.instance.comboUI);
		}

		sprite.animation.play(startAnim);
		return id;
		#end
	}

	function makeLuaSprite(spritePath:String, toBeCalled:String, drawBehind:Bool, customPath:String = null)
	{
		#if sys
		var data:BitmapData = BitmapData.fromFile(Sys.getCwd() + (customPath != null ? customPath : "assets/data/" + PlayState.SONG.song.toLowerCase()) + '/' + spritePath + ".png");
			
		var sprite:FlxSprite = new FlxSprite(0, 0);
		var imgWidth:Float = FlxG.width / data.width;
		var imgHeight:Float = FlxG.height / data.height;
		var scale:Float = imgWidth <= imgHeight ? imgWidth : imgHeight;

		// Cap the scale at x1
		if (scale > 1)
			scale = 1;

		sprite.makeGraphic(Std.int(data.width * scale), Std.int(data.width * scale), FlxColor.TRANSPARENT);

		var data2:BitmapData = sprite.pixels.clone();
		var matrix:Matrix = new Matrix();
		matrix.identity();
		matrix.scale(scale, scale);
		data2.fillRect(data2.rect, FlxColor.TRANSPARENT);
		data2.draw(data, matrix, null, null, null, true);
		sprite.pixels = data2;

		luaSprites.set(toBeCalled, sprite);
		// and I quote:
		// shitty layering but it works!
		{
			if (drawBehind)
			{
				PlayState.instance.removeObject(PlayState.instance.gfGroup);
				PlayState.instance.removeObject(PlayState.instance.bfGroup);
				PlayState.instance.removeObject(PlayState.instance.dadGroup);

				if (Config.comboType == 0)
					@:privateAccess
					PlayState.instance.removeObject(PlayState.instance.comboUI);
			}
			
			PlayState.instance.addObject(sprite);
			
			if (drawBehind)
			{
				PlayState.instance.addObject(PlayState.instance.gfGroup);
				PlayState.instance.addObject(PlayState.instance.bfGroup);
				PlayState.instance.addObject(PlayState.instance.dadGroup);

				if (Config.comboType == 0)
					@:privateAccess
					PlayState.instance.addObject(PlayState.instance.comboUI);
			}
		}
		#end
		return toBeCalled;
	}

	public function camZoomThing(toZoom:Float, time:Float, ease:Null<flixel.tweens.EaseFunction>, onComplete:String) {
		PlayState.instance.camGameModified = true;
			
		PlayState.instance.camZoomTween.cancel();
		PlayState.instance.camChangeZoom(toZoom, time, ease, function(flxTween:FlxTween)
			{
				if (onComplete != '' && onComplete != null)
				{
					callLua(onComplete, ["camera"]);
				}
			});
	}
	
	public function hudZoomThing(toZoom:Float, time:Float, ease:Null<flixel.tweens.EaseFunction>, onComplete:String) {
		PlayState.instance.camHUDModified = true;
			
		PlayState.instance.uiZoomTween.cancel();
		PlayState.instance.uiChangeZoom(toZoom, time, ease, function(flxTween:FlxTween)
			{
				if (onComplete != '' && onComplete != null)
				{
					callLua(onComplete, ["camera"]);
				}
			});
	}
	
	public function die()
	{
		Lua.close(lua);
		lua = null;
	}

	// LUA SHIT

	function new()
	{
		trace('opening a lua state (because we are cool :))');
		lua = LuaL.newstate();
		LuaL.openlibs(lua);
		trace("Lua version: " + Lua.version());
		trace("LuaJIT version: " + Lua.versionJIT());
		Lua.init_callbacks(lua);

		// shaders = new Array<LuaShader>();

		var result = LuaL.dofile(lua, Paths.lua(PlayState.SONG.song.toLowerCase() + "/modchart")); // execute le file

		if (result != 0)
		{
			Application.current.window.alert("LUA COMPILE ERROR:\n" + Lua.tostring(lua, result), "Kade Engine Modcharts");
			lua = null;
			PlayState.instance.switchState(new MainMenuState());
		}

		// get some fukin globals up in here bois

		setVar("difficulty", PlayState.storyDifficulty);
		setVar("bpm", Conductor.bpm);
		setVar("scrollspeed", Config.scrollSpeedOverride > 0 ? Config.scrollSpeedOverride : PlayState.SONG.speed);
		setVar("fpsCap", (Config.noFpsCap ? 999 : 144));
		
		setVar("downscroll", Config.downscroll);
		setVar("centeredNotes", Config.centeredNotes);

		setVar("curStep", 0);
		setVar("curBeat", 0);
		setVar("crochet", Conductor.stepCrochet);
		setVar("safeZoneOffset", Conductor.safeZoneOffset);

		setVar("hudZoom", PlayState.instance.camHUD.zoom);
		setVar("cameraZoom", FlxG.camera.zoom);

		setVar("cameraAngle", FlxG.camera.angle);
		setVar("camHudAngle", PlayState.instance.camHUD.angle);

		setVar("followXOffset", 0);
		setVar("followYOffset", 0);

		setVar("showOnlyStrums", false);
		setVar("strumLine1Visible", true);
		setVar("strumLine2Visible", true);

		setVar("screenWidth", FlxG.width);
		setVar("screenHeight", FlxG.height);
		setVar("windowWidth", FlxG.width);
		setVar("windowHeight", FlxG.height);
		setVar("hudWidth", PlayState.instance.camHUD.width);
		setVar("hudHeight", PlayState.instance.camHUD.height);

		setVar("mustHit", false);

		setVar("strumLineY", PlayState.instance.strumLine.y);
		setVar("health", 1);
		
		// callbacks

		Lua_helper.add_callback(lua, "executeEvent", function(tag:String)
		{
			PlayState.instance.executeEvent(tag);
		});

		// sprites

		Lua_helper.add_callback(lua, "makeSprite", makeLuaSprite);
		Lua_helper.add_callback(lua, "changeDadCharacter", changeDadCharacter);
		Lua_helper.add_callback(lua, "changeBoyfriendCharacter", changeBoyfriendCharacter);
		Lua_helper.add_callback(lua, "getProperty", getPropertyByName);
		// this one is still in development
		Lua_helper.add_callback(lua, "makeAnimatedSprite", makeAnimatedLuaSprite);

		Lua_helper.add_callback(lua, "destroySprite", function(id:String)
		{
			var sprite = luaSprites.get(id);
			if (sprite == null)
				return false;
			PlayState.instance.removeObject(sprite);
			return true;
		});
		
		// health 
		
		Lua_helper.add_callback(lua, "setHealth", function(heal:Float)
		{
			@:privateAccess
			PlayState.instance.health = heal;
		});

		Lua_helper.add_callback(lua, "addHealth", function(heal:Float)
		{
			@:privateAccess
			PlayState.instance.health += heal;
		});
		
		// the fucking
		
		Lua_helper.add_callback(lua, "returnAssetsPath", function()
		{
			return OpenFlAssets.getPath("assets/");
		});
		
		// hud/camera

		Lua_helper.add_callback(lua, "setHudAngle", function(x:Float)
		{
			PlayState.instance.camHUD.angle = x;
		});
		
		Lua_helper.add_callback(lua, "setHudPosition", function(x:Int, y:Int)
		{
			PlayState.instance.camHUD.x = x;
			PlayState.instance.camHUD.y = y;
		});

		Lua_helper.add_callback(lua, "getHudX", function()
		{
			return PlayState.instance.camHUD.x;
		});

		Lua_helper.add_callback(lua, "getHudY", function()
		{
			return PlayState.instance.camHUD.y;
		});

		Lua_helper.add_callback(lua, "setCamPosition", function(x:Int, y:Int)
		{
			FlxG.camera.x = x;
			FlxG.camera.y = y;
		});

		Lua_helper.add_callback(lua, "getCameraX", function()
		{
			return FlxG.camera.x;
		});

		Lua_helper.add_callback(lua, "getCameraY", function()
		{
			return FlxG.camera.y;
		});

		Lua_helper.add_callback(lua, "setCamZoom", function(zoomAmount:Float)
		{
			PlayState.instance.camZoomTween.cancel();
			FlxG.camera.zoom = zoomAmount;
			PlayState.instance.camGameModified = true;
		});

		Lua_helper.add_callback(lua, "setHudZoom", function(zoomAmount:Float)
		{
			PlayState.instance.uiZoomTween.cancel();
			PlayState.instance.camHUD.zoom = zoomAmount;
			PlayState.instance.camHUDModified = true;
		});

		Lua_helper.add_callback(lua, "resetCamZoom", function(zoomAmount:Float)
		{
			FlxG.camera.zoom = PlayState.instance.defaultCamZoom;
			PlayState.instance.camGameModified = false;
		});

		Lua_helper.add_callback(lua, "resetHudZoom", function(zoomAmount:Float)
		{
			PlayState.instance.camHUD.zoom = zoomAmount;
			PlayState.instance.camHUDModified = false;
		});
		
		// strumline

		Lua_helper.add_callback(lua, "setStrumlineY", function(y:Float)
		{
			PlayState.instance.strumLine.y = y;
		});

		// actors

		Lua_helper.add_callback(lua, "getRenderedNotes", function()
		{
			return PlayState.instance.notes.members.length;
		});

		Lua_helper.add_callback(lua, "getRenderedNoteX", function(id:Int)
		{
			return PlayState.instance.notes.members[id].x;
		});

		Lua_helper.add_callback(lua, "getRenderedNoteY", function(id:Int)
		{
			return PlayState.instance.notes.members[id].y;
		});

		Lua_helper.add_callback(lua, "getRenderedNoteType", function(id:Int)
		{
			return PlayState.instance.notes.members[id].noteData;
		});

		Lua_helper.add_callback(lua, "isSustain", function(id:Int)
		{
			return PlayState.instance.notes.members[id].isSustainNote;
		});

		Lua_helper.add_callback(lua, "isParentSustain", function(id:Int)
		{
			return PlayState.instance.notes.members[id].prevNote.isSustainNote;
		});

		Lua_helper.add_callback(lua, "getRenderedNoteParentX", function(id:Int)
		{
			return PlayState.instance.notes.members[id].prevNote.x;
		});

		Lua_helper.add_callback(lua, "getRenderedNoteParentY", function(id:Int)
		{
			return PlayState.instance.notes.members[id].prevNote.y;
		});

		Lua_helper.add_callback(lua, "getRenderedNoteHit", function(id:Int)
		{
			return PlayState.instance.notes.members[id].mustPress;
		});

		Lua_helper.add_callback(lua, "getRenderedNoteCalcX", function(id:Int)
		{
			if (PlayState.instance.notes.members[id].mustPress)
				return PlayState.playerStrums.members[Math.floor(Math.abs(PlayState.instance.notes.members[id].noteData))].x;
			return PlayState.strumLineNotes.members[Math.floor(Math.abs(PlayState.instance.notes.members[id].noteData))].x;
		});

		Lua_helper.add_callback(lua, "anyNotes", function()
		{
			return PlayState.instance.notes.members.length != 0;
		});

		Lua_helper.add_callback(lua, "getRenderedNoteStrumtime", function(id:Int)
		{
			return PlayState.instance.notes.members[id].strumTime;
		});

		Lua_helper.add_callback(lua, "getRenderedNoteScaleX", function(id:Int)
		{
			return PlayState.instance.notes.members[id].scale.x;
		});

		Lua_helper.add_callback(lua, "resetRenderedNotePos", function(x:Float, y:Float, id:Int)
		{
			if (PlayState.instance.notes.members[id] == null)
				throw('error! you cannot reset a rendered notes position when it doesnt exist! ID: ' + id);
			else
				PlayState.instance.notes.members[id].modifiedByLua = false;
		});
		
		Lua_helper.add_callback(lua, "setRenderedNotePos", function(x:Float, y:Float, id:Int)
		{
			if (PlayState.instance.notes.members[id] == null)
				throw('error! you cannot set a rendered notes position when it doesnt exist! ID: ' + id);
			else
			{
				PlayState.instance.notes.members[id].modifiedByLua = true;
				PlayState.instance.notes.members[id].x = x;
				PlayState.instance.notes.members[id].y = y;
			}
		});

		Lua_helper.add_callback(lua, "setRenderedNoteX", function(x:Float, id:Int)
		{
			if (PlayState.instance.notes.members[id] != null)
			{
				PlayState.instance.notes.members[id].modifiedByLua = true;
				PlayState.instance.notes.members[id].x = x;
			}
		});

		Lua_helper.add_callback(lua, "setRenderedNoteY", function(y:Float, id:Int)
		{
			if (PlayState.instance.notes.members[id] != null)
			{
				PlayState.instance.notes.members[id].modifiedByLua = true;
				PlayState.instance.notes.members[id].y = y;
			}
		});

		Lua_helper.add_callback(lua, "setRenderedNoteAlpha", function(alpha:Float, id:Int)
		{
			PlayState.instance.notes.members[id].modifiedByLua = true;
			PlayState.instance.notes.members[id].alpha = alpha;
		});

		Lua_helper.add_callback(lua, "setRenderedNoteScale", function(scale:Float, id:Int)
		{
			PlayState.instance.notes.members[id].modifiedByLua = true;
			PlayState.instance.notes.members[id].setGraphicSize(Std.int(PlayState.instance.notes.members[id].width * scale));
		});

		Lua_helper.add_callback(lua, "setRenderedNoteScale", function(scaleX:Int, scaleY:Int, id:Int)
		{
			PlayState.instance.notes.members[id].modifiedByLua = true;
			PlayState.instance.notes.members[id].setGraphicSize(scaleX, scaleY);
		});

		Lua_helper.add_callback(lua, "getRenderedNoteWidth", function(id:Int)
		{
			return PlayState.instance.notes.members[id].width;
		});

		Lua_helper.add_callback(lua, "setRenderedNoteAngle", function(angle:Float, id:Int)
		{
			PlayState.instance.notes.members[id].modifiedByLua = true;
			PlayState.instance.notes.members[id].angle = angle;
		});

		Lua_helper.add_callback(lua, "setActorX", function(x:Int, id:String)
		{
			getActorByName(id).x = x;
		});

		Lua_helper.add_callback(lua, "setActorAccelerationX", function(x:Int, id:String)
		{
			getActorByName(id).acceleration.x = x;
		});

		Lua_helper.add_callback(lua, "setActorDragX", function(x:Int, id:String)
		{
			getActorByName(id).drag.x = x;
		});

		Lua_helper.add_callback(lua, "setActorVelocityX", function(x:Int, id:String)
		{
			getActorByName(id).velocity.x = x;
		});

		Lua_helper.add_callback(lua, "playActorAnimation", function(id:String, anim:String, force:Bool = false, reverse:Bool = false, frame:Int = 0)
		{
			if (Std.isOfType(getActorByName(id), usefulshits.SwagStrum) || Std.isOfType(getActorByName(id), Character)) {
				getActorByName(id).playAnim(anim, force, reverse, frame);
			} else {		
				getActorByName(id).animation.play(anim, force, reverse, frame);
			}
		});

		Lua_helper.add_callback(lua, "setActorAlpha", function(alpha:Float, id:String)
		{
			getActorByName(id).alpha = alpha;
		});

		Lua_helper.add_callback(lua, "setActorY", function(y:Int, id:String)
		{
			getActorByName(id).y = y;
		});

		Lua_helper.add_callback(lua, "setActorAccelerationY", function(y:Int, id:String)
		{
			getActorByName(id).acceleration.y = y;
		});

		Lua_helper.add_callback(lua, "setActorDragY", function(y:Int, id:String)
		{
			getActorByName(id).drag.y = y;
		});

		Lua_helper.add_callback(lua, "setActorVelocityY", function(y:Int, id:String)
		{
			getActorByName(id).velocity.y = y;
		});

		Lua_helper.add_callback(lua, "setActorAngle", function(angle:Int, id:String)
		{
			getActorByName(id).angle = angle;
		});

		Lua_helper.add_callback(lua, "setActorScale", function(scale:Float, id:String)
		{
			getActorByName(id).setGraphicSize(Std.int(getActorByName(id).width * scale));
		});

		Lua_helper.add_callback(lua, "setActorScaleXY", function(scaleX:Float, scaleY:Float, id:String)
		{
			getActorByName(id).setGraphicSize(Std.int(getActorByName(id).width * scaleX), Std.int(getActorByName(id).height * scaleY));
		});

		Lua_helper.add_callback(lua, "setActorFlipX", function(flip:Bool, id:String)
		{
			getActorByName(id).flipX = flip;
		});

		Lua_helper.add_callback(lua, "setActorFlipY", function(flip:Bool, id:String)
		{
			getActorByName(id).flipY = flip;
		});

		Lua_helper.add_callback(lua,"setActorScroll", function(xscroll:Float,yscroll:Float,id:String) {
			getActorByName(id).scrollFactor.set(xscroll, yscroll);
		});
		
		Lua_helper.add_callback(lua, "setLaneScrollspeed", function(speed:Float, id:String)
		{
			getActorByName(id).modSpeed = speed;
		});
	
		Lua_helper.add_callback(lua, "getActorWidth", function(id:String)
		{
			return getActorByName(id).width;
		});

		Lua_helper.add_callback(lua, "getActorHeight", function(id:String)
		{
			return getActorByName(id).height;
		});

		Lua_helper.add_callback(lua, "getActorAlpha", function(id:String)
		{
			return getActorByName(id).alpha;
		});

		Lua_helper.add_callback(lua, "getActorAngle", function(id:String)
		{
			return getActorByName(id).angle;
		});

		Lua_helper.add_callback(lua, "getActorX", function(id:String)
		{
			return getActorByName(id).x;
		});

		Lua_helper.add_callback(lua, "getActorY", function(id:String)
		{
			return getActorByName(id).y;
		});

		Lua_helper.add_callback(lua, "setStrumAngle", function(angle:Float, id:String)
		{
			getActorByName(id).modAngle = angle;
		});

		// window shiz
		
		Lua_helper.add_callback(lua, "setWindowPos", function(x:Int, y:Int)
		{
			Application.current.window.x = x;
			Application.current.window.y = y;
		});

		Lua_helper.add_callback(lua, "getWindowX", function()
		{
			return Application.current.window.x;
		});

		Lua_helper.add_callback(lua, "getWindowY", function()
		{
			return Application.current.window.y;
		});

		Lua_helper.add_callback(lua, "resizeWindow", function(Width:Int, Height:Int)
		{
			Application.current.window.resize(Width, Height);
		});

		Lua_helper.add_callback(lua, "getScreenWidth", function()
		{
			return Application.current.window.display.currentMode.width;
		});

		Lua_helper.add_callback(lua, "getScreenHeight", function()
		{
			return Application.current.window.display.currentMode.height;
		});

		Lua_helper.add_callback(lua, "getWindowWidth", function()
		{
			return Application.current.window.width;
		});

		Lua_helper.add_callback(lua, "getWindowHeight", function()
		{
			return Application.current.window.height;
		});

		// tweens

		Lua_helper.add_callback(lua, "tweenCameraPos", function(toX:Int, toY:Int, time:Float, ease:String, onComplete:String)
		{
			FlxTween.tween(FlxG.camera, {x: toX, y: toY}, time, {
				ease: stringToEase(ease),
				onComplete: function(flxTween:FlxTween)
				{
					if (onComplete != '' && onComplete != null)
					{
						callLua(onComplete, ["camera"]);
					}
				}
			});
		});

		Lua_helper.add_callback(lua, "tweenCameraAngle", function(toAngle:Float, time:Float, ease:String, onComplete:String)
		{
			FlxTween.tween(FlxG.camera, {angle: toAngle}, time, {
				ease: stringToEase(ease),
				onComplete: function(flxTween:FlxTween)
				{
					if (onComplete != '' && onComplete != null)
					{
						callLua(onComplete, ["camera"]);
					}
				}
			});
		});

		Lua_helper.add_callback(lua, "tweenCameraZoom", function(toZoom:Float, time:Float, ease:String, onComplete:String)
		{
			camZoomThing(toZoom, time, stringToEase(ease), onComplete);
		});

		Lua_helper.add_callback(lua, "tweenHudPos", function(toX:Int, toY:Int, time:Float, ease:String, onComplete:String)
		{
			FlxTween.tween(PlayState.instance.camHUD, {x: toX, y: toY}, time, {
				ease: stringToEase(ease),
				onComplete: function(flxTween:FlxTween)
				{
					if (onComplete != '' && onComplete != null)
					{
						callLua(onComplete, ["camera"]);
					}
				}
			});
		});

		Lua_helper.add_callback(lua, "tweenHudAngle", function(toAngle:Float, time:Float, ease:String, onComplete:String)
		{
			FlxTween.tween(PlayState.instance.camHUD, {angle: toAngle}, time, {
				ease: stringToEase(ease),
				onComplete: function(flxTween:FlxTween)
				{
					if (onComplete != '' && onComplete != null)
					{
						callLua(onComplete, ["camera"]);
					}
				}
			});
		});

		Lua_helper.add_callback(lua, "tweenHudZoom", function(toZoom:Float, time:Float, ease:String, onComplete:String)
		{
			hudZoomThing(toZoom, time, stringToEase(ease), onComplete);
		});

		Lua_helper.add_callback(lua, "tweenPos", function(id:String, toX:Int, toY:Int, time:Float, ease:String, onComplete:String)
		{
			FlxTween.tween(getActorByName(id), {x: toX, y: toY}, time, {
				ease: stringToEase(ease),
				onComplete: function(flxTween:FlxTween)
				{
					if (onComplete != '' && onComplete != null)
					{
						callLua(onComplete, [id]);
					}
				}
			});
		});

		Lua_helper.add_callback(lua, "tweenAngle", function(id:String, toAngle:Int, time:Float, ease:String, onComplete:String)
		{
			FlxTween.tween(getActorByName(id), {angle: toAngle}, time, {
				ease: stringToEase(ease),
				onComplete: function(flxTween:FlxTween)
				{
					if (onComplete != '' && onComplete != null)
					{
						callLua(onComplete, [id]);
					}
				}
			});
		});

		Lua_helper.add_callback(lua, "tweenFade", function(id:String, toAlpha:Float, time:Float, ease:String, onComplete:String)
		{
			FlxTween.tween(getActorByName(id), {alpha: toAlpha}, time, {
				ease: stringToEase(ease),
				onComplete: function(flxTween:FlxTween)
				{
					if (onComplete != '' && onComplete != null)
					{
						callLua(onComplete, [id]);
					}
				}
			});
		});

		// forgot and accidentally commit to master branch
		// shader

		/*Lua_helper.add_callback(lua,"createShader", function(frag:String,vert:String) {
				var shader:LuaShader = new LuaShader(frag,vert);

				trace(shader.glFragmentSource);

				shaders.push(shader);
				// if theres 1 shader we want to say theres 0 since 0 index and length returns a 1 index.
				return shaders.length == 1 ? 0 : shaders.length;
			});


			Lua_helper.add_callback(lua,"setFilterHud", function(shaderIndex:Int) {
				PlayState.instance.camHUD.setFilters([new ShaderFilter(shaders[shaderIndex])]);
			});

			Lua_helper.add_callback(lua,"setFilterCam", function(shaderIndex:Int) {
				FlxG.camera.setFilters([new ShaderFilter(shaders[shaderIndex])]);
		});*/

		// default strums

		for (i in 0...PlayState.strumLineNotes.length)
		{
			var member = PlayState.strumLineNotes.members[i];
			trace(PlayState.strumLineNotes.members[i].x
				+ " "
				+ PlayState.strumLineNotes.members[i].y + " " + PlayState.strumLineNotes.members[i].angle + " | strum" + i);
			// setVar("strum" + i + "X", Math.floor(member.x));
			setVar("defaultStrum" + i + "X", Math.floor(member.x));
			// setVar("strum" + i + "Y", Math.floor(member.y));
			setVar("defaultStrum" + i + "Y", Math.floor(member.y));
			// setVar("strum" + i + "Angle", Math.floor(member.angle));
			setVar("defaultStrum" + i + "Angle", Math.floor(member.angle));
			trace("Adding strum" + i);
		}
		
		trace("working dir is " + Sys.getCwd());
	}

	public function executeState(name, args:Array<Dynamic>)
	{
		return Lua.tostring(lua, callLua(name, args));
	}

	public static function createModchartState():ModchartState
	{
		return new ModchartState();
	}
}
#end