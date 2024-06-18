import ModSupport;
import Settings;
import Medals;

function create()
{
	var save:FlxSave = ModSupport.modSaves[ModSupport.currentMod];
	
	if (save == null)
        FlxG.log.error("Mod Save for " + ModSupport.currentMod + " not found.");
}

function onPreEndSong()
{
	switch (PlayState.curSong)
	{
		case "Triggered":
			if (GetPlayerAccuracy() >= 90)
				Medals.unlock(mod, "Really TRIGGERED");
		case "Slaughter":
		{
			if (GetPlayerAccuracy() >= 90)
				Medals.unlock(mod, "Arrow Slaughterer");
			if (GetPlayerAccuracy() >= 69 && GetPlayerAccuracy() <= 70)
				Medals.unlock(mod, "ball slaughter");
		}
		case "Overkill":
			if (GetPlayerAccuracy() >= 90)
				Medals.unlock(mod, "Killing Spree");
		case "Kapow":
			if (PlayState.misses == 0 && !botplay)
				Medals.unlock(mod, "KaPoW!");
		case "Shell-Shanked":
			if (PlayState.misses == 0 && !botplay)
				Medals.unlock(mod, "Shell Shanked");
		case "Extinction":
			if (PlayState.misses < 10 && !botplay)
				Medals.unlock(mod, "Extinct fingers");
	}
	if (PlayState.isStoryMode)
	{
		switch (PlayState.curSong)
		{
			case "Fallout": Medals.unlock(mod, "Fallen Soldier");
			case "Bombshell": Medals.unlock(mod, "Happy Tree Foe");
			case "Disturbed": Medals.unlock(mod, "Slaughter In The Woods");
		}
	}
}

function GetPlayerAccuracy()
{
	switch(Settings.engineSettings.data.accuracyMode)
	{
            default:
                return FlxMath.roundDecimal(accuracy / numberOfNotes * 100, 2);
            case 1:
			{
                var accuracyFloat:Float = 0;

                for(rat in ratings) {
                    accuracyFloat += hits[rat.name] * rat.accuracy;
                }

                return FlxMath.roundDecimal(accuracyFloat / numberOfArrowNotes * 100, 2);
			}
	}
}