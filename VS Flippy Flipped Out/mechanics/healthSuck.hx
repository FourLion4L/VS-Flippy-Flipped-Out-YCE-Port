import flixel.util.FlxSave;

var mechanics:Bool;
var drainHealth:Bool = false;

function create()
{
	var gameModificators:FlxSave = new FlxSave();
	gameModificators.bind("GameModificators");
	PlayState.scripts.setVariable("mechanics", gameModificators.data.mechanics);
}

function onDadHit(note)
{
	if (mechanics && drainHealth)
	{
		health -= note.isSustainNote ? 0.01225 : 0.0162;
	}
}

function onPreEndSong()
{
	if (!mechanics)
	{
		songScore /= 2;
		trace("You have mechanics off. Your score was halfed!");
	}
}

function ToggleDrain() drainHealth = !drainHealth;