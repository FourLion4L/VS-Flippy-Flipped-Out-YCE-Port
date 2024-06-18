import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;

// -- Sprites
var DarkOverlay:FlxSprite;

// -- Tweens
var DarkOverlayRemoveTween:FlxTween;

// -- Variables
var startSplashAlpha;


// -- The CODE
function createPost()
{
	startSplashAlpha = EngineSettings.splashesAlpha;

	AddBlackStuff(1);
	hideHUD(0, 0, 0, 0, 0);
	
	startSong();
}

function update(elapsed)
{
	PauseCheck();
}

function stepHit(curStep)
{
	switch (curStep)
	{
		case 96: showHUDSmooth(2.0, 1, 1, 1, 1, 1);
		case 512: hideHUDSmooth(5.0, 1, 1, 1, 0, 0);
		case 640: showHUDSmooth(1.0, 1, 1, 1, 1, 1);
	}
}

function onCountdown() return false;

function AddBlackStuff(opacity)
{
	if (modchart)
	{
		DarkOverlay = new FlxSprite(0, 0).loadGraphic(Paths.image("blackstuff"));
		DarkOverlay.scrollFactor.set();
		DarkOverlay.alpha = opacity;
		DarkOverlay.cameras = [camHUD];
		add(DarkOverlay);
		
		EngineSettings.splashesAlpha = 0.1;
	}
}

function BlackStuffOpacityChange(opacity)
{
	if (modchart)
	{
		FlxTween.tween(DarkOverlay, {alpha: opacity}, 0.5, {ease: FlxEase.cubeIn});
		EngineSettings.splashesAlpha = opacity / 5;
	}
}

function RemoveBlackStuff() 
{
	if (modchart)
	{
		DarkOverlayRemoveTween = FlxTween.tween(DarkOverlay, {alpha: 0}, 1.0, {ease: FlxEase.smoothOut, onComplete: function(fr) remove(DarkOverlay)});
		FlxTween.tween(EngineSettings, {splashesAlpha: startSplashAlpha}, 1.0, {ease: FlxEase.smoothOut});
	}
}

function PauseCheck()
{
	if (paused)
	{
		if (DarkOverlayRemoveTween != null) DarkOverlayRemoveTween.active = false;
	}
	else
	{
		if (DarkOverlayRemoveTween != null) DarkOverlayRemoveTween.active = true;
	}
}