var wavePower:Int = 0;

function updatePost(elapsed)
{
	WavyNotesAction();
}

function WavyNotes(power) wavePower = power;

function WavyNotesAction()
{
	var currentBeat = (Conductor.songPosition / 1000) * (Conductor.bpm / 60);
	for (i in 0...8)
	{
		if (i < 4)
			cpuStrums.members[i].y = PlayState.strumLine.y + wavePower * Math.cos((currentBeat + i*0.5) * Math.PI);
		else
			playerStrums.members[i - 4].y = PlayState.strumLine.y + wavePower * Math.cos((currentBeat + i*0.5) * Math.PI);
	}
}