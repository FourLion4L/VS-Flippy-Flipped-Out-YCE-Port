import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.FlxG;

var modchart = true;

var FadeSprite:FlxSprite;
var unFadeSprite:FlxSprite;
var FlashSprite:FlxSprite;
var DarkSprite:FlxSprite;

var customBeatTime:Int = 0;

var startZoom;

function createPost()
{
	startZoom = defaultCamZoom;
}

function beatHit(curBeat)
{
	if (modchart && !autoCamZooming && curBeat % customBeatTime == 0)
	{
		FlxG.camera.zoom += 0.015;
		camHUD.zoom += 0.03;
	}
}

function stepHit(cs)
{
	if (modchart)
	{
		switch (cs)
		{
			case 1: aZI(0.05, 0.1);
			case 32: aZI(0.05, 0.1);
			case 64: aZI(0.05, 0.1);
			case 80: aZI(0.05, 0.1);
			case 96: aZI(0.02, 0.08);
			case 100: aZI(0.02, 0.08);
			case 102: aZI(0.02, 0.08);
			case 104: aZI(0.02, 0.08);
			case 108: aZI(0.02, 0.08);
			case 112: aZI(0.02, 0.08);
			case 116: aZI(0.02, 0.08);
			case 118: aZI(0.02, 0.08);
			case 120: aZI(0.02, 0.08);
			case 124: aZI(0.08, 0.08);
			case 256: aZI(0.05, 0.2);
			case 512: sZ(0.8);
			case 638: rZ();
			case 640: sZ(0.78);
			case 704: aZ(0.1);
			case 736: aZ(-0.08);
			case 896: sZ(0.7);
			case 1024: rZ();
			case 1134: sZ(0.8);
			case 1152: rZ();
		}
	}
}

function AddZoom(amount) { defaultCamZoom += amount; }

function AddZoomInstant(game, hud) { FlxG.camera.zoom += game; camHUD.zoom += hud; }

function SetZoom(value) { defaultCamZoom = value; }

function ResetZoom() { defaultCamZoom = startZoom; }

function SetBump(timing)
{
	if (modchart)
	{
		autoCamZooming = false;
		customBeatTime = timing;
	}
}

function ResetBump() { if (modchart) { autoCamZooming = true; } }

function StunBump()
{
	if (modchart)
	{
		autoCamZooming = false;
		customBeatTime = 0;
	}
}

// CHARTER ACCESSIBLE FUNCTIONS 
//(they're all accessible actually except addZoom() I think. for no reason ROFL)

function Fade(duration)
{
	if (modchart)
	{
		remove(unFadeSprite);
		remove(FlashSprite);
		
		FadeSprite = new FlxSprite(-350, -200).makeGraphic(FlxG.width * 1.65, FlxG.height * 1.65, 0xFF000000, true);
		FadeSprite.scrollFactor.set();
		FadeSprite.cameras = [camHUD];
		add(FadeSprite);
		
		FadeSprite.alpha = 0;
		FlxTween.tween(FadeSprite, {alpha: 1}, duration, {ease: FlxEase.linear});
	}
}

function unFade(duration)
{
	if (modchart)
	{
		remove(FadeSprite);
		remove(FlashSprite);
		
		unFadeSprite = new FlxSprite(-350, -200).makeGraphic(FlxG.width * 1.65, FlxG.height * 1.65, 0xFF000000, true);
		unFadeSprite.scrollFactor.set();
		unFadeSprite.cameras = [camHUD];
		add(unFadeSprite);
			
		unFadeSprite.alpha = 1;
		FlxTween.tween(unFadeSprite, {alpha: 0}, duration, {ease: FlxEase.linear});
	}
}

function Flash(duration)
{
	if (modchart)
	{
		remove(FadeSprite);
		remove(unFadeSprite);
		
		FlashSprite = new FlxSprite(-350, -200).makeGraphic(FlxG.width * 1.65, FlxG.height * 1.65, 0xFFFFFFFF, true);
		FlashSprite.scrollFactor.set();
		FlashSprite.cameras = [camHUD];
		add(FlashSprite);
			
		FlashSprite.alpha = 1;
		FlxTween.tween(FlashSprite, {alpha: 0}, duration, {ease: FlxEase.linear});
	}
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
	remove(DarkSprite);
	EngineSettings.splashesAlpha = startSplashAlpha;
}

// SHORTER FUNCTIONS
function aZ(a) { AddZoom(a); }
function aZI(g, h) { AddZoomInstant(g, h); }
function sZ(v) { SetZoom(v); }
function rZ() { ResetZoom(); }