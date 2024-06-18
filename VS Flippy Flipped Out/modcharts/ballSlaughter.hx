var DarkSprite:FlxSprite;
var startSplashAlpha;

function createPost()
{
	startSplashAlpha = EngineSettings.splashesAlpha;
}

function AddBlackStuff(opacity)
{
	if (modchart)
	{
		DarkSprite = new FlxSprite(0, 0).loadGraphic(Paths.image("blackstuff"));
		DarkSprite.scrollFactor.set();
		DarkSprite.alpha = opacity;
		DarkSprite.cameras = [camHUD];
		add(DarkSprite);
		
		EngineSettings.splashesAlpha = 0.1;
	}
}

function RemoveBlackStuff() 
{
	if (modchart)
	{
		remove(DarkSprite);
		EngineSettings.splashesAlpha = startSplashAlpha;
	}
}