function createPost()
{
	remove(healthBarBG);
	
	healthBarBG = new FlxSprite(healthBar.x - 30, healthBar.y - 16).loadGraphic(Paths.image('healthBar2'));
	healthBarBG.cameras = [camHUD];
	healthBarBG.visible = true;
	healthBarBG.antialiasing = true;
	
	add(healthBarBG);
	PlayState.strumLineNotes.add(healthBarBG);  // don't ask why (because it was on top of icons lol)
	
	if (PlayState.timerBar != null) 
		PlayState.timerBar.createFilledBar(0xFF910b09, 0xFFc4100e);
}