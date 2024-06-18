function create() {
	if (PlayState.isStoryMode)
	{
		PlayState.canDie = false;
		var mFolder = Paths_.modsPath;
		
		var path = Paths.video("flippyfuckingdies", 'mods/' + PlayState_.songMod);
		trace(path);
		if (!Assets.exists(path)) {
			trace("Video not found.");
			startCountdown();
			return;
		}

		var wasWidescreen = PlayState.isWidescreen;
		var videoSprite:FlxSprite = null;
		var skipText:FlxText;
		
		skipText = new FlxText(20, 680, FlxG.width, "Press ENTER or SPACE to skip cutscene.", 20, true);
		skipText.cameras = [PlayState.camHUD];
		skipBG = new FlxSprite(20, 680).makeGraphic(skipText.width/2.5, 25, 0xFF000000);
		skipBG.alpha = 0.4;
		skipBG.cameras = [PlayState.camHUD];
		
		PlayState.isWidescreen = false;
		PlayState.camHUD.bgColor = 0xFF000000;
		videoSprite = MP4Video.playMP4(Assets.getPath(path),
			function() {
				PlayState.canDie = true;
				PlayState.remove(videoSprite);
				PlayState.remove(skipText);
				PlayState.remove(skipBG);
				skipText.destroy();
				skipBG.destroy();
				PlayState.isWidescreen = wasWidescreen;
				PlayState.camHUD.bgColor = 0x00000000;
				startCountdown();
			},
			// If midsong.
			false, FlxG.width, FlxG.height);

		videoSprite.cameras = [PlayState.camHUD];
		videoSprite.scrollFactor.set();
		PlayState.add(videoSprite);
		PlayState.add(skipBG);
		PlayState.add(skipText);
	}
}

function updatePost(elapsed)
{
	if (FlxG.keys.justPressed.R)
		PlayState.health = 1;
}