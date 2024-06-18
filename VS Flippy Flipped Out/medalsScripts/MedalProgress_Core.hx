import flixel.util.FlxSave;
import Medals;
import Settings;
import ModSupport;

var progressSave:FlxSave;
var medals:MedalsJSON;
var medalsExist:Bool = true;

var debugMode:Bool = true;

function createPost()
{
	medals = ModSupport.modMedals[Settings.engineSettings.data.selectedMod];
	if (medals == null)
	{
		if (Assets.exists(Paths.file("medals.json", TEXT, 'mods/${Settings.engineSettings.data.selectedMod}')))
			ModSupport.modMedals[Settings.engineSettings.data.selectedMod] = medals = Json.parse(Assets.getText(Paths.file("medals.json", TEXT, 'mods/${Settings.engineSettings.data.selectedMod}')));
		else
		{
			medals = ModSupport.modMedals[Settings.engineSettings.data.selectedMod] = {medals: []};
			medalsExist = false;
		}
	}
	if (medals.medals == null) { medals.medals = []; medalsExist = false; }

	if (medalsExist)
	{
		progressSave = new FlxSave();
		progressSave.bind("MedalProgress");
		if (progressSave == null || progressSave.data.medalProgress == null)
		{
			trace("Medal Progress has just begun..");
			var beginning:Array<Int> = [];
			progressSave.data.medalProgress = beginning;
		}
		trace(progressSave.data);
		
		PlayState.scripts.setVariable("AddMedalProgress", function(progressID:Int, progressAmount:Int) { addMedalProgress(progressID, progressAmount); });
	}
	else
		trace("[MedalP_CORE] Medals does not exist for this mod. Therefore, we're not getting a progress on our achievements.");
}

function addMedalProgress(progressID, progressAmount)
{
	if (!medalsExist)
		trace("[MedalP_CORE] Unable to add progress to a medal since medals don't exist for this mod.");
	else
	{
		var sameIDMedals:Array<Int> = [];
		for (i in medals.medals)
		{
			if (i.progressID == progressID)
				sameIDMedals.push(medals.medals.indexOf(i));
		}
		if (sameIDMedals[0] == null)
			trace("[MedalP_CORE] No medals with progressID " + progressID + " were not found.");
		else
		{
			for (i in sameIDMedals)
			{
				trace(i);
				var madeProgress:Int = Std.parseInt((progressSave.data.medalProgress[progressID] == null ? "0" : progressSave.data.medalProgress[progressID]));
				madeProgress += progressAmount;
				progressSave.data.medalProgress[progressID] = madeProgress;
				progressSave.flush();
				checkMedalProgress(progressID, i);
				if (debugMode) trace("[MedalP_CORE] SUCCESSFULLY added progress to the medal with progressID " + progressID + " !");
			}
		}
	}
}

function checkMedalProgress(progressID, neededMedal)
{
	if (progressSave.data.medalProgress[progressID] >= medals.medals[neededMedal].goalValue)
		Medals.unlock(mod, medals.medals[neededMedal].name);
}

function destroy()
{
	if (debugMode) trace("[MedalP_CORE] DESTROY");
	progressSave.close();
}