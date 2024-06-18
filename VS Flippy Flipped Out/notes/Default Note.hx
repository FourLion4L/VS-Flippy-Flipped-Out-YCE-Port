function onMiss(note)
{
	switch (note.noteData)
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

	noteMiss(note.noteData);
	health -= note.isSustainNote ? 0.00125 : 0.025;
}