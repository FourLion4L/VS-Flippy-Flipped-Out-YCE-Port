import flixel.system.FlxSound;

/*function create()
{
	menuItems.push("Your Mom");
}

function onSelect(selected)
{
	if (selected == "Your Mom")
	{
		close();
		PlayState.health = 0;
	}
}*/

function create()
{
	var p = Paths.music('flippy-mood');
	if (!Assets.exists(p)) p = Paths.music('breakfast');
	var newPause = new FlxSound().loadEmbedded(p, true, true);
	state.pauseMusic = newPause;
	state.pauseMusic.play(false, FlxG.random.int(0, Std.int(pauseMusic.length / 2)));
	state.pauseMusic.volume = 0;
}

function update(elapsed)
{
	if (state.pauseMusic.volume < 0.5)
		state.pauseMusic.volume += 0.01 * elapsed;
}