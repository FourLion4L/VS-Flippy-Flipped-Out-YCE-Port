import flixel.util.FlxSave;

function create() {
		var mechanics:Bool;
		var gameModificators:FlxSave = new FlxSave();
		gameModificators.bind("GameModificators");
		mechanics = gameModificators.data.mechanics;
		trace(gameModificators.data.mechanics);

		note.mustPress = true;
		note.frames = Paths.getSparrowAtlas("notes/camoNotes");  // make a script to add notes manually
		note.colored = false;
		switch(note.noteDirection) {
			case 0:
				note.animation.addByPrefix("scroll", "purple0");
			case 1:
				note.animation.addByPrefix("scroll", "blue0");
			case 2:
				note.animation.addByPrefix("scroll", "green0");
			case 3:
				note.animation.addByPrefix("scroll", "red0");
		}
		note.splashColor = DefineSongForSplashColor();
		note.animation.addByPrefix("holdpiece", "red hold piece");
		note.animation.addByPrefix("holdend", "red hold end");
		
		note.scale.set(0.7, 0.7);
		note.updateHitbox();
}

function DefineSongForSplashColor()
{
	switch (PlayState.SONG.song)
	{
		case "Overkill", "Slaughter", "disclosed":
			return 0xFFFF0000;
		default:
			return 0xFF15A110;
	}
}

function onMiss(noteData)
{
	switch (noteData)
	{
		case 0:
			for (b in boyfriends)
				if (b != null)
					b.playAnim("singLEFTmiss", true);
		case 1:
			for (b in boyfriends)
				if (b != null)
					b.playAnim("singDOWNmiss", true);
		case 2:
			for (b in boyfriends)
				if (b != null)
					b.playAnim("singUPmiss", true);
		case 3:
			for (b in boyfriends)
				if (b != null)
					b.playAnim("singRIGHTmiss", true);
	}

	noteMiss(noteData);
	health -= note.isSustainNote ? 0.00125 : 0.025;
}