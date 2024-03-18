package;

import lime.utils.Assets;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.FlxSprite;
import flixel.graphics.FlxGraphic;
import openfl.display.BitmapData;

class HealthIcon extends FlxSprite
{
	public var sprTracker:FlxSprite;
	public var id:Int;

	public var defaultIconScale:Float = 1;
	public var iconScale:Float = 1;
	public var iconSize:Float;
	public var isPlayer:Bool = false;
	public var character:String = "face";

	private var tween:FlxTween;

	private static final pixelIcons:Array<String> = ["bf-pixel", "senpai", "senpai-angry", "spirit", "bf-lil", "guy-lil"];
	
	public function new(_character:String = 'face', _isPlayer:Bool = false, ?_id:Int = -1)
	{
		super();

		isPlayer = _isPlayer;

		if (CoolUtil.exists(Paths.file("ui/healthIcons/" + _character, "images", "png")))
		{
			character = _character;
		}
		else
		{
			trace("No icon exists at ui/healthIcons/" + _character + ".png, defaulting to face.");
		}

		setIconCharacter(character);

		iconSize = width;

		id = _id;

		scrollFactor.set();

		tween = FlxTween.tween(this, {}, 0);
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);
		setGraphicSize(Std.int(iconSize * iconScale));
		updateHitbox();

		if (sprTracker != null)
		{
			setPosition(sprTracker.x + sprTracker.width + 10, sprTracker.y - 30);
		}
	}

	public function tweenToDefaultScale(_time:Float, _ease:Null<flixel.tweens.EaseFunction>)
	{
		tween.cancel();
		tween = FlxTween.tween(this, {iconScale: this.defaultIconScale}, _time, {ease: _ease});
	}

	public function setIconCharacter(character:String)
	{
		var iconPx:Int = 150;
		
		switch (character) {
			case "hektor":
				iconPx = 166;
			default:
				iconPx = 150;
		}
		
		loadGraphic(Paths.image('ui/healthIcons/' + character), true, iconPx, iconPx);
		animation.add("icon", [0, 1, 2], 0, false, isPlayer);
		animation.play("icon");

		antialiasing = !pixelIcons.contains(character);
	}
}
