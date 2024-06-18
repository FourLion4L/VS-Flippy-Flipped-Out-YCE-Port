import flixel.util.FlxSave;

var mechanics:Bool;
var extraHealth:Float = 0.0;

function create()
{
	var gameModificators:FlxSave = new FlxSave();
	gameModificators.bind("GameModificators");
	PlayState.scripts.setVariable("mechanics", gameModificators.data.mechanics);
}

function onDadHit(note)
{
	if (mechanics)
	{
		var iDrainMultiplier:Float = 1.0;
		if (health < maxHealth / 5) iDrainMultiplier = 0.5;
		else if (health > maxHealth / 2) iDrainMultiplier = 1.182;
	
		if (extraHealth > 0) extraHealth -= (note.isSustainNote ? 0.00441 : 0.0172) * iDrainMultiplier;
		else 
		{
			health -= (note.isSustainNote ? 0.0031 : 0.016) * iDrainMultiplier;
			extraHealth = 0.0;
		}
	}
}

function onPlayerHit(note)
{
	if (mechanics)
	{
		if (health < maxHealth / 5) health += FlxG.random.float(0.015, 0.0323);
		
		var iExtraGainMultiplier:Float = 1.0; if (note.isSustainNote) iExtraGainMultiplier = 0.4;
		if (health + (note.isSustainNote ? 0.0072 : 0.019) > maxHealth) extraHealth += FlxG.random.float(0.01 * iExtraGainMultiplier, 0.02 * iExtraGainMultiplier);
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