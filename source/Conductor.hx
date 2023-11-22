package;

import Song.SwagSong;

typedef BPMChangeEvent =
{
	var stepTime:Int;
	var songTime:Float;
	var bpm:Float;
}

class Conductor
{
	public static var bpm:Float = 100;
	public static var crochet:Float = ((60 / bpm) * 1000); // beats in milliseconds
	public static var stepCrochet:Float = crochet / 4; // steps in milliseconds
	public static var songPosition:Float;
	public static var lastSongPos:Float;
	public static var offset:Float = 0;

	// public static var safeFrames:Float = 8;
	// stepmania judge4 eu acho??
	// public static var safeFrames:Float = (180 * 60) / 1000;

	// keeping this just because
	// public static var safeZoneOffset:Float = (safeFrames / 60) * 1000; // calculated in create(), is safeFrames in milliseconds
	public static var safeZoneOffset:Float = 180; // e se a gente so usasse os milissegundos direto msm
	
	/* timings funny! um pouco baseado no metodo usado na forever engine
	milissegundos maximos pra tudo:
	
	22.5ms	swag 
	45ms	sick 
	90ms	good 
	135ms	bad 
	180ms	shit 
	
	se ceis quiserem fazer seus proprios timings ai podem muda
	btw 180ms e o limite maximo
		- neon */
	public static var timings:Array<Float> = [22.5, 45, 90, 135, 180];
	public static var timingAccuracies:Array<Float> = [1, 1, 0.75, 0.5, 0.25];
	public static var timingScores:Array<Int> = [350, 350, 200, 100, 50];

	public static var bpmChangeMap:Array<BPMChangeEvent> = [];

	public function new()
	{
	}

	public static function mapBPMChanges(song:SwagSong)
	{
		bpmChangeMap = [];

		var curBPM:Float = song.bpm;
		var totalSteps:Int = 0;
		var totalPos:Float = 0;
		for (i in 0...song.notes.length)
		{
			if (song.notes[i].changeBPM && song.notes[i].bpm != curBPM)
			{
				curBPM = song.notes[i].bpm;
				var event:BPMChangeEvent = {
					stepTime: totalSteps,
					songTime: totalPos,
					bpm: curBPM
				};
				bpmChangeMap.push(event);
			}

			var deltaSteps:Int = song.notes[i].lengthInSteps;
			totalSteps += deltaSteps;
			totalPos += ((60 / curBPM) * 1000 / 4) * deltaSteps;
		}
		trace("new BPM map BUDDY " + bpmChangeMap);
	}

	public static function changeBPM(newBpm:Float)
	{
		bpm = newBpm;

		crochet = ((60 / bpm) * 1000);
		stepCrochet = crochet / 4;
	}
}
