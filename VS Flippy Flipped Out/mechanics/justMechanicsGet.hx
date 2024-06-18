import flixel.util.FlxSave;

function createPost()
{
	var mechanics:Bool;
	var gameModificators:FlxSave = new FlxSave();
	gameModificators.bind("GameModificators");
	mechanics = gameModificators.data.mechanics;
}