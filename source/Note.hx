package;

import config.*;
import flixel.FlxSprite;

// import polymod.format.ParseRules.TargetSignatureElement;
using StringTools;

class Note extends FlxSprite
{
	public var strumTime:Float = 0;

	public var mustPress:Bool = false;
	public var noteData:Int = 0;
	public var canBeHit:Bool = false;
	public var tooLate:Bool = false;
	public var wasGoodHit:Bool = false;
	public var prevNote:Note;
	public var type:String = "";
	public var noteWidth:Int = 1;

	public var sustainLength:Float = 0;
	public var isSustainNote:Bool = false;

	public var noteScore:Float = 1;

	public var playedEditorClick:Bool = false;
	public var editorBFNote:Bool = false;
	public var absoluteNumber:Int;

	public var editor = false;

	public var xOffset:Float = 0;
	public var yOffset:Float = 0;

	public static var swagWidth:Float = 160 * 0.7;
	public static final PURP_NOTE:Int = 0;
	public static final GREEN_NOTE:Int = 2;
	public static final BLUE_NOTE:Int = 1;
	public static final RED_NOTE:Int = 3;

	public var modifiedByLua:Bool = false;

	public function new(_strumTime:Float, _noteData:Int, _type:String, ?_editor = false, ?_prevNote:Note, ?_sustainNote:Bool = false)
	{
		super();

		if (_type != null)
			type = _type;

		if (type == "BULLET")
			noteWidth = 2;

		if (_prevNote == null)
			_prevNote = this;

		prevNote = _prevNote;
		isSustainNote = _sustainNote;

		// MAKE SURE ITS DEFINITELY OFF SCREEN?
		y -= 2000;

		editor = _editor;

		if (!editor)
		{
			strumTime = _strumTime + Config.offset;
			if (strumTime < 0)
			{
				strumTime = 0;
			}
		}
		else
		{
			strumTime = _strumTime;
		}

		if (_noteData > 4 - noteWidth)
			noteData = 4 - noteWidth;
		else
			noteData = _noteData;

		var uiType:String = PlayState.curUiType;
		var isQen:Bool = PlayState.qenSongs.contains(PlayState.SONG.song.toLowerCase());
		
		switch (uiType)
		{
			case 'pixel':
				loadGraphic(Paths.image('week6/weeb/pixelUI/arrows-pixels'), true, 19, 19);

				animation.add('greenScroll', [6]);
				animation.add('redScroll', [7]);
				animation.add('blueScroll', [5]);
				animation.add('purpleScroll', [4]);

				animation.add('green glow', [22]);
				animation.add('red glow', [23]);
				animation.add('blue glow', [21]);
				animation.add('purple glow', [20]);

				if (isSustainNote)
				{
					loadGraphic(Paths.image('week6/weeb/pixelUI/arrowEnds'), true, 7, 6);

					animation.add('purpleholdend', [4]);
					animation.add('greenholdend', [6]);
					animation.add('redholdend', [7]);
					animation.add('blueholdend', [5]);

					animation.add('purplehold', [0]);
					animation.add('greenhold', [2]);
					animation.add('redhold', [3]);
					animation.add('bluehold', [1]);
				}

				setGraphicSize(Std.int(width * PlayState.daPixelZoom));
				updateHitbox();

			default:
				if (_type != null)
				{
					if (CoolUtil.exists('assets/images/ui/customNotes/' + type + '.png')
						|| CoolUtil.exists('assets/images/ui/customNotes/' + type + '.xml'))
					{
						frames = Paths.getSparrowAtlas('ui/customNotes/' + type);
						// trace ('heres your note');
					}
					else
					{
						frames = Paths.getSparrowAtlas('ui/' + (isQen ? 'qenUI/' : '' ) + 'NOTE_assets');
						/* trace('get defaulted lmao png is a ' 
							+ CoolUtil.exists('assets/images/ui/customNotes/' + type + '.png') 
							+ ' and the xml is a ' 
							+ CoolUtil.exists('assets/images/ui/customNotes/' + type + '.xml')
							); */
					}
				}
				else
				{
					frames = Paths.getSparrowAtlas('ui/' + (isQen ? 'qenUI/' : '' ) + 'NOTE_assets');
				}

				if (_type == 'BULLET')
				{
					animation.addByPrefix('greenScroll', 'bulletnote');
					animation.addByPrefix('redScroll', 'bulletnote');
					animation.addByPrefix('blueScroll', 'bulletnote');
					animation.addByPrefix('purpleScroll', 'bulletnote');

					animation.addByPrefix('purpleholdend', 'bullet end hold');
					animation.addByPrefix('greenholdend', 'bullet end hold');
					animation.addByPrefix('redholdend', 'bullet end hold');
					animation.addByPrefix('blueholdend', 'bullet end hold');

					animation.addByPrefix('purplehold', 'bullet hold piece');
					animation.addByPrefix('greenhold', 'bullet hold piece');
					animation.addByPrefix('redhold', 'bullet hold piece');
					animation.addByPrefix('bluehold', 'bullet hold piece');
				}
				else
				{
					animation.addByPrefix('greenScroll', 'green0');
					animation.addByPrefix('redScroll', 'red0');
					animation.addByPrefix('blueScroll', 'blue0');
					animation.addByPrefix('purpleScroll', 'purple0');

					animation.addByPrefix('purpleholdend', 'pruple end hold');
					animation.addByPrefix('greenholdend', 'green hold end');
					animation.addByPrefix('redholdend', 'red hold end');
					animation.addByPrefix('blueholdend', 'blue hold end');

					animation.addByPrefix('purplehold', 'purple hold piece');
					animation.addByPrefix('greenhold', 'green hold piece');
					animation.addByPrefix('redhold', 'red hold piece');
					animation.addByPrefix('bluehold', 'blue hold piece');
				}

				if (_type != null)
				{
					animation.addByPrefix('purple glow', 'Purple Active');
					animation.addByPrefix('green glow', 'Green Active');
					animation.addByPrefix('red glow', 'Red Active');
					animation.addByPrefix('blue glow', 'Blue Active');
				}

				setGraphicSize(Std.int(width * 0.7));
				updateHitbox();
				antialiasing = true;
		}

		switch (noteData)
		{
			case 0:
				animation.play('purpleScroll');
			case 1:
				animation.play('blueScroll');
			case 2:
				animation.play('greenScroll');
			case 3:
				animation.play('redScroll');
		}

		// trace(prevNote);

		if (isSustainNote && prevNote != null)
		{
			alpha = 0.6;

			xOffset += width / 2;

			flipY = Config.downscroll;

			switch (noteData)
			{
				case 2:
					animation.play('greenholdend');
				case 3:
					animation.play('redholdend');
				case 1:
					animation.play('blueholdend');
				case 0:
					animation.play('purpleholdend');
			}

			updateHitbox();

			xOffset -= width / 2;

			if (PlayState.curUiType == "pixel")
				xOffset += 36;

			if (prevNote.isSustainNote)
			{
				switch (prevNote.noteData)
				{
					case 2:
						prevNote.animation.play('greenhold');
					case 3:
						prevNote.animation.play('redhold');
					case 1:
						prevNote.animation.play('bluehold');
					case 0:
						prevNote.animation.play('purplehold');
				}

				var speed = PlayState.SONG.speed;

				if (Config.scrollSpeedOverride > 0)
				{
					speed = Config.scrollSpeedOverride;
				}

				prevNote.scale.y *= Conductor.stepCrochet / 100 * 1.485 * speed;
				if (PlayState.curUiType == "pixel")
				{
					prevNote.scale.y *= 0.833 * (1.5 / 1.485); // Kinda weird, just roll with it.
				}
				prevNote.updateHitbox();
			}
		}

		if (type == "transparent")
		{
			alpha = 0.35;
		}
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);

		if (mustPress)
		{
			if (isSustainNote)
			{
				canBeHit = (strumTime < Conductor.songPosition + Conductor.timings[3] * 1
					&& (prevNote == null ? true : prevNote.wasGoodHit));
			}
			else
			{
				canBeHit = (strumTime > Conductor.songPosition - Conductor.timings[3]
					&& strumTime < Conductor.songPosition + Conductor.timings[3]);
			}

			if (strumTime < Conductor.songPosition - Conductor.timings[3] && !wasGoodHit)
				tooLate = true;
		}
		else
		{
			canBeHit = false;

			if (strumTime <= Conductor.songPosition)
			{
				canBeHit = true;
			}
		}

		// Glow note stuff.

		if (canBeHit && Config.noteGlow && !isSustainNote && !editor && animation.curAnim.name.contains("Scroll"))
		{
			glow();
		}

		if (tooLate && !isSustainNote && !editor && !animation.curAnim.name.contains("Scroll"))
		{
			idle();
		}
	}

	public function glow()
	{
		switch (noteData)
		{
			case 2:
				animation.play('green glow');
			case 3:
				animation.play('red glow');
			case 1:
				animation.play('blue glow');
			case 0:
				animation.play('purple glow');
		}
	}

	public function idle()
	{
		switch (noteData)
		{
			case 2:
				animation.play('greenScroll');
			case 3:
				animation.play('redScroll');
			case 1:
				animation.play('blueScroll');
			case 0:
				animation.play('purpleScroll');
		}
	}
}
