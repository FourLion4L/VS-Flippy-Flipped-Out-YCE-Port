import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.FlxG;
import flixel.util.FlxSave;

// -- Script Variables --
var DarkSprite:FlxSprite;

var BlackBarUp:FlxSprite;
var BlackBarDown:FlxSprite;
var startUpBarPosY:Int;
var startDownBarPosY:Int;

var startSplashAlpha;
var closeup:Bool = false;
var preCloseupZoom:Int;

var upY:Int;
var downY:Int;
// -- Script Variables --

// -- Debug Options --
var dbgMessage = true;
var dbgCurInfo = false;
var dbgPsychMsg = false;
// -- Debug Options --


function create()
{
	BlackBarDown = new FlxSprite(0, 750).makeGraphic(FlxG.width, FlxG.height * 0.2, 0xFF000000, false);  // y: 650
	BlackBarDown.scrollFactor.set();
	BlackBarDown.cameras = [camHUD];
	add(BlackBarDown);
	startDownBarPosY = BlackBarDown.y;

	BlackBarUp = new FlxSprite(0, -160).makeGraphic(FlxG.width, FlxG.height * 0.2, 0xFF000000, false);  // y: -60
	BlackBarUp.scrollFactor.set();
	BlackBarUp.cameras = [camHUD];
	add(BlackBarUp);
	startUpBarPosY = BlackBarUp.y;
}

function createPost()
{
	startZoom = defaultCamZoom;
	startSplashAlpha = EngineSettings.splashesAlpha;
	
	AddBlackStuff(1);
	hideHUD(1, false, false, true, true);
	
	boyfriend.addCameraOffset("singLEFT", 0, 0);
	boyfriend.addCameraOffset("singDOWN", 0, 0);
	boyfriend.addCameraOffset("singUP", 0, 0);
	boyfriend.addCameraOffset("singRIGHT", 0, 0);
}

function update()
{
	//camHUD.zoom = 0.1;
}

function stepHit(cs)
{
	if (modchart)
	{
		switch (cs)
		{
			case 1:
				moveBlackBars(1, 1);
			case 128:
				moveBlackBars(1, 2);
			case 320:
				aZ(0.2);
			case 384:
				aZ(-0.05);
				moveBlackBars(0.25, 2);
				hideHUD(true, true, true, true, true);
			case 560:
				aZI(0.2, 0);
			case 564:
				aZI(0.2, 0);
			case 568:
				aZI(0.2, 0);
				rZ();
			case 572:
				aZI(-0.5, -0.1);
				moveBlackBars(3, 3);
			case 896:
				moveBlackBars(1, 2);
			case 1160:
				moveBlackBars(0.25, 3);
			case 1200:
				aZI(0.2, 0);
			case 1204:
				aZI(0.2, 0);
			case 1208:
				aZI(0.2, 0);
			case 1212:
				aZI(0.2, 0);
			case 1216:
				aZI(0.5, -0.035);
			case 1328:
				aZI(0.2, 0);
			case 1332:
				aZI(-0.5, 0);
			case 1336:
				aZI(0.2, 0);
			case 1340:
				aZI(0.1, 0);
			case 1408:
				moveBlackBars(2, 2);
				sZ(0.8);
			case 1664:
				moveBlackBars(0.1, 1);
			case 1920:
				moveBlackBars(1, 2);
				sZ(0.9);
				hideHUD(true, false, false, true, true);
			case 2468:
				slideBlackBars(1);
			case 2560:
				hideHUD(true, true, true, true, true);
			case 3072:
				sZ(0.7);
				moveBlackBars(3, 2);
			case 3184:
				aZI(0.2, 0.05);
			case 3188:
				aZI(0.2, 0.05);
			case 3192:
				aZI(0.2, 0.05);
			case 3196:
				aZI(0.2, 0.05);
			case 3200:
				aZI(-0.4, 0);
			case 3264:
				aZ(-0.05);
			case 3328:
				aZ(0.15);
			case 3456:
				aZ(-0.05);
			case 3520:
				rZ();
			case 3584:
				sZ(0.8);
			case 3648:
				sZ(0.75);
			case 3712:
				hideHUD(true, false, false, true, true);
			case 3840:
				hideHUD(false, false, false, true, true);
			case 3920:
				hideHUD(false, false, false, false, false);
		}
	}
}

// CHARTER ACCESSIBLE FUNCTIONS
// Zoom and other camera stuff

function AddZoom(amount) { if (modchart) addDefaultZoom(amount); }

function AddZoomInstant(game, hud) { if (modchart) addCameraZoom(game, hud); }

function SetZoom(value) { if (modchart) setDefaultZoom(value); }

function ResetZoom() { if (modchart) resetDefaultZoom(); }

// Psych Engine event compatibility

function onPsychEvent(e, v1, v2)
{
	if (dbgMessage && dbgPsychMsg)
	{
		var curInfo:String;
		if (dbgCurInfo) { curInfo = " (curStep = " + curStep + " || curBeat = " + curBeat + ")"; }
		else { curInfo = ""; }
		trace("Psych Engine Event: " + e + " | Value 1: " + v1 + " | Value 2: " + v2 + curInfo);
	}
	
	switch (e)
	{
		case "Add Camera Zoom":
			//AddZoomInstant(v1, v2);  // P.S: IT WORKS OMG OMG OMG
	}
}

// SONG SPECIFIC FUNCTIONS

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

/*function moveBlackBars(duration, position)  // function is not accessible within chart editor (idk about workaround)
{
	if (dbgMessage)
	{
		var curInfo:String;
		if (dbgCurInfo) { curInfo = " (curStep: " + curStep + " || curBeat: " + curBeat + ")"; }
		else { curInfo = ""; }
		trace("[moveBlackBars FUNCTION] Duration: " + duration + " | Position: " + position + curInfo);
	}

	var upY = DefineBars(position, "up");
	var downY = DefineBars(position, "down");
	
	if (modchart)
	{
	FlxTween.tween(BlackBarUp, {y: upY}, duration, {ease: FlxEase.quadOut});
	FlxTween.tween(BlackBarDown, {y: downY}, duration, {ease: FlxEase.quadOut});
	}
}

function ShowBlackBars(show:Bool)
{
	if (dbgMessage)
	{
		var curInfo:String;
		if (dbgCurInfo) { curInfo = " (curStep: " + curStep + " || curBeat: " + curBeat + ")"; }
		else { curInfo = ""; }
		trace("[ShowBlackBars FUNCTION] Show: " + show + curInfo);
	}

	if (modchart)
	{
		BlackBarUp.visible = show;
		BlackBarDown.visible = show;
	}
}

function slideBlackBars(duration)
{
	if (dbgMessage)
	{
		var curInfo:String;
		if (dbgCurInfo) { curInfo = " (curStep: " + curStep + " || curBeat: " + curBeat + ")"; }
		else { curInfo = ""; }
		trace("[slideBlackBars FUNCTION] Duration: " + duration + curInfo);
	}
	
	if (modchart)
	{
	FlxTween.tween(BlackBarUp, {y: startUpBarPosY}, duration, {ease: FlxEase.quadOut});
	FlxTween.tween(BlackBarDown, {y: startDownBarPosY}, duration, {ease: FlxEase.quadOut});
	}
}*/

function OverkillCloseupStart()
{
	if (modchart && !closeup)
	{
		closeup = true;
		defaultCamZoom = 0.8;
		
		dad.addCameraOffset("singUP", -170, -180);
		dad.addCameraOffset("singDOWN", 20, 10);
		dad.addCameraOffset("singLEFT", -180, -80);
		dad.addCameraOffset("singRIGHT", 60, 40);
		dad.addCameraOffset("singUP-alt", -170, -180);
		dad.addCameraOffset("singDOWN-alt", 20, 10);
		dad.addCameraOffset("singLEFT-alt", -180, -80);
		dad.addCameraOffset("singRIGHT-alt", 60, 40);
		
		boyfriend.addCameraOffset("singLEFT", -15, 0);
		boyfriend.addCameraOffset("singDOWN", 0, 15);
		boyfriend.addCameraOffset("singUP", 0, -15);
		boyfriend.addCameraOffset("singRIGHT", 15, 0);
	}
}

function OverkillCloseupEnd()
{
	if (modchart && closeup)
	{
		closeup = false;
		defaultCamZoom = startZoom;
		
		dad.addCameraOffset("singUP", 0, 0);
		dad.addCameraOffset("singDOWN", 0, 0);
		dad.addCameraOffset("singLEFT", 0, 0);
		dad.addCameraOffset("singRIGHT", 0, 0);
		dad.addCameraOffset("singUP-alt", 0, 0);
		dad.addCameraOffset("singDOWN-alt", 0, 0);
		dad.addCameraOffset("singLEFT-alt", 0, 0);
		dad.addCameraOffset("singRIGHT-alt", 0, 0);
		
		boyfriend.addCameraOffset("singLEFT", 0, 0);
		boyfriend.addCameraOffset("singDOWN", 0, 0);
		boyfriend.addCameraOffset("singUP", 0, 0);
		boyfriend.addCameraOffset("singRIGHT", 0, 0);
	}
}

// SHORTER FUNCTIONS
function aZ(a) { AddZoom(a); }
function aZI(g, h) { AddZoomInstant(g, h); }
function sZ(v) { SetZoom(v); }
function rZ() { ResetZoom(); }

// HELPER FUNCTIONS
function DefineBars(p, d)
{
	if (d == "up" || d == 1)
	{
		switch (p)
		{
			case 1: return -60;
			case 2: return -30;
			case 3: return -90;
		}
	}
	else
	{
		switch (p)
		{
			case 1: return 650;
			case 2: return 620;
			case 3: return 680;
		}
	}
}