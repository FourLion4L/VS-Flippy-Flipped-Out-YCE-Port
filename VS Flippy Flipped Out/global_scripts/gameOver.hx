import GameOverSubstate;
import Settings;

function createPost()
{
	if (boyfriend.curCharacter == Settings.engineSettings.data.selectedMod+":bf-carry")
		GameOverSubstate.char = "Friday Night Funkin':bf-holding-gf-dead";
}