package;
import flixel.FlxG;

using StringTools;

class SaveManager
{
    inline public static function global():Void {
        FlxG.save.close();
        FlxG.save.bind("global", "neontflame/FPSPlusYF");
    }

    inline public static function scores():Void {
        FlxG.save.close();
        FlxG.save.bind("scores", "neontflame/FPSPlusYF/" + openfl.Lib.current.stage.application.meta["company"].replace(" ", "-") + "." + openfl.Lib.current.stage.application.meta["file"].replace(" ", "-"));
    }

    inline public static function modSpecific():Void {
        FlxG.save.close();
        FlxG.save.bind("data", "neontflame/FPSPlusYF/" + openfl.Lib.current.stage.application.meta["company"].replace(" ", "-") + "." + openfl.Lib.current.stage.application.meta["file"].replace(" ", "-"));
    }

    inline public static function chartAutosave(song:String):Void {
        FlxG.save.close();
        FlxG.save.bind(song, "neontflame/FPSPlusYF/" + openfl.Lib.current.stage.application.meta["company"].replace(" ", "-") + "." + openfl.Lib.current.stage.application.meta["file"].replace(" ", "-") + "/Chart-Editor-Autosaves");
    }

    inline public static function flush():Void {
        FlxG.save.flush();
    }

    inline public static function close():Void {
        FlxG.save.close();
    }
}