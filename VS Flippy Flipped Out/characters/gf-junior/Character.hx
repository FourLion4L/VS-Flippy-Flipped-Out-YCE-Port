function create() {
	character.frames = Paths.getCharacter(character.curCharacter);
	character.loadJSON(false);
}

function dance()
{
	if (PlayState.startingSong || PlayState.SONG.song == "Slasher" && PlayState.curBeat < 10 || PlayState.SONG.song == "Disturbed" && PlayState.curBeat < 10) return;
	
	if (animation.getByName("danceLeft") != null && animation.getByName("danceRight") != null)
	{
		character.playAnim(danced ? "danceLeft" : "danceRight");
		danced = !danced;
	} else {
		character.playAnim("idle");
	}
}