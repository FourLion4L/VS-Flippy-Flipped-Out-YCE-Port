function createPost() {
	
	for(e in PlayState.ratings)  { e.health = 0.025; }
	
	EngineSettings.ghostTapping = true;
	tapMissHealth = 0.05;
}

function onPlayerHit(note)
{
    if(note.isSustainNote)
	{
		PlayState.currentSustains.push({
							time: note.strumTime,
							healthVal: -0.0045
						});
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
}