// Made by Levka4 AKA FourLion.
// Also don't delete da credits pwease ^-^
// Thank you

import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.FlxG;
import flixel.util.FlxSave;

var scoreWarningText = "";

var FadeSprite:FlxSprite;
var unFadeSprite:FlxSprite;
var FlashSprite:FlxSprite;

var BlackBarUp:FlxSprite;
var BlackBarDown:FlxSprite;

var hudAlphaTweens:Array<FlxTween> = [];

var startZoom;
var startScrollSpeed;

var customBeatTime:Int = 0;
var noteDancePower:Int = 0;

// -- Debug Options --
var dbgMessage = true;
var dbgCurInfo = false;
var dbgPsychMsg = false;
// -- Debug Options --


function create()
{
	BlackBarDown = new FlxSprite(-55, 750).makeGraphic(FlxG.width + 200, FlxG.height * 0.2, 0xFF000000, false);  // y: 650
	BlackBarDown.scrollFactor.set();
	BlackBarDown.cameras = [camHUD];
	add(BlackBarDown);

	BlackBarUp = new FlxSprite(-55, -160).makeGraphic(FlxG.width + 200, FlxG.height * 0.2, 0xFF000000, false);  // y: -60
	BlackBarUp.scrollFactor.set();
	BlackBarUp.cameras = [camHUD];
	add(BlackBarUp);
	
	var gameModificators:FlxSave = new FlxSave();
	gameModificators.bind("GameModificators");
	PlayState.scripts.setVariable("modchart", gameModificators.data.modchart);
}

function update(elapsed) PauseCheck();

function updatePost(elapsed)
{
	FlexNotesAction();
	
	//camHUD.zoom = 0.1;
}

function createPost()
{
	startZoom = defaultCamZoom;
	startScrollSpeed = PlayState.SONG.speed;
	
	PlayState.scripts.setVariable("moveBlackBars", function(duration:Float, position:Int, ?ignoreSetting:Bool)
	{
		MoveBlackBars(duration, position, ignoreSetting);
	});
	PlayState.scripts.setVariable("slideBlackBars", function(duration:Float, ?ignoreSetting:Bool)
	{
		SlideBlackBars(duration, ignoreSetting);
	});
	PlayState.scripts.setVariable("addCameraZoom", function(game:Float, ?hud:Float)
	{
		AddCameraZoom(game, hud);
	});
	PlayState.scripts.setVariable("addDefaultZoom", function(amount:Float)
	{
		AddDefaultZoom(amount);
	});
	PlayState.scripts.setVariable("setDefaultZoom", function(value:Float)
	{
		SetDefaultZoom(value);
	});
	PlayState.scripts.setVariable("resetDefaultZoom", function()
	{
		ResetDefaultZoom();
	});
	PlayState.scripts.setVariable("hideHUD", function(?hb:Bool, ?hbt:Bool, ?timer:Bool, ?pS:Bool, ?cS:Bool)
	{
		HideHUD(hb, hbt, timer, pS, cS);
	});
	PlayState.scripts.setVariable("hideHUDSmooth", function(?duration:Float, ?hb:Bool, ?hbt:Bool, ?timer:Bool, ?pS:Bool, ?cS:Bool)
	{
		HideHUDSmooth(duration, hb, hbt, timer, pS, cS);
	});
	PlayState.scripts.setVariable("showHUDSmooth", function(?duration:Float, ?hb:Bool, ?hbt:Bool, ?timer:Bool, ?pS:Bool, ?cS:Bool)
	{
		ShowHUDSmooth(duration, hb, hbt, timer, pS, cS);
	});
	PlayState.scripts.setVariable("unFadeCommon", function(duration:Float)
	{
		unFade(duration);
	});
}

function beatHit(curBeat)
{
	if (modchart && !autoCamZooming && curBeat % customBeatTime == 0)
	{
		FlxG.camera.zoom += customCAMGAMEbump-0;
		camHUD.zoom += customCAMHUDbump-0;
	}
}

function PlayAnimation(char:String, animName:String)
{
	var charToPlay:Character;
	switch (char)
	{
		case "boyfriend": charToPlay = boyfriend;
		case "dad": charToPlay = dad;
		case "girlfriend": charToPlay = girlfriend;
	}
	charToPlay.playAnim(animName, true);
}

function AddCameraZoom(game, ?hud) 
{
	if (modchart)
	{
		FlxG.camera.zoom += game-0;
		camHUD.zoom += hud-0;
	}
}

function AddDefaultZoom(amount)
{
	if (modchart)
		defaultCamZoom += amount-0;
}

function SetDefaultZoom(value)
{
	if (modchart)
		defaultCamZoom = value;
}

function ResetDefaultZoom()
{
	if (modchart)
		defaultCamZoom = startZoom;
}

function SetBump(timing, ?game, ?hud)
{
	if (modchart)
	{
		autoCamZooming = false;
		customBeatTime = timing;
		
		switch (game)
		{
			case "same":
				customCAMGAMEbump = customCAMGAMEbump;
			case null:
				customCAMGAMEbump = 0.03;
			default:
				customCAMGAMEbump = game;
		}
		switch (hud)
		{
			case "same":
				customCAMHUDbump = customCAMHUDbump;
			case null:
				customCAMHUDbump = 0.015;
			default:
				customCAMHUDbump = hud;
		}
	}
}

function ResetBump()
{
	if (modchart)
	{
		autoCamZooming = true;
	}
}

function StunBump()
{
	if (modchart)
	{
		autoCamZooming = false;
		customBeatTime = 0;
	}
}

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

function SetScrollSpeed(speed:Float)
{
	if (modchart) { PlayState.SONG.speed = speed; }
}

function ResetScrollSpeed()
{
	if (modchart) { PlayState.SONG.speed = startScrollSpeed; }
}

function HideHUD(hb, hbt, timer, pS, cS)  // to use it as an event, type 1 and 0 instead of true and false
{
	if (modchart)
	{
		healthBarBG.visible = hb;
		healthBar.visible = hb;
		iconP1.visible = hb;
		iconP2.visible = hb;

		scoreTxt.visible = hbt;
		
		if (!hbt)
		{
			if (scoreWarning.text != " ")
			{
				scoreWarningText = scoreWarning.text;
			}
			scoreWarning.text = " ";
		}
		else
		{
			scoreWarning.text = scoreWarningText;
		}
		
		timerBG.visible = timer; 
		timerBar.visible = timer;
		timerText.visible = timer;
		timerNow.visible = timer;
		timerFinal.visible = timer;
		
		for (e in playerStrums.members)
		{
			if (e != null)
			{
				e.visible = pS;
			}
		}
		
		for (e in cpuStrums.members)
		{
			if (e != null)
			{
				e.visible = cS;
			}
		}
	}
}

function HideHUDSmooth(?duration:Float = 1.0, ?hb:Bool = true, ?hbt:Bool = 1, ?timer:Bool = 1, ?pS:Bool = 1, ?cS:Bool = 1)  // to use it as an event, type 1 and 0 instead of true and false
{
	if (modchart)
	{
		var hudTweenEase:FlxEase = FlxEase.smoothIn;
		
		if (hb)
		{
			healthBarBG.visible = true; healthBarBG.alpha = 1;
			var healthBarBGAlphaTween:FlxTween; healthBarBGAlphaTween = FlxTween.tween(healthBarBG, {alpha: 0}, duration, {ease: FlxEase.linear}); hudAlphaTweens.push(healthBarBGAlphaTween);
			healthBar.visible = true; healthBar.alpha = 1;
			var healthBarAlphaTween:FlxTween; healthBarAlphaTween = FlxTween.tween(healthBar, {alpha: 0}, duration, {ease: hudTweenEase}); hudAlphaTweens.push(healthBarAlphaTween);
			iconP1.visible = true; iconP1.alpha = 1;
			var iconP1AlphaTween:FlxTween; iconP1AlphaTween = FlxTween.tween(iconP1, {alpha: 0}, duration, {ease: hudTweenEase}); hudAlphaTweens.push(iconP1AlphaTween);
			iconP2.visible = true; iconP2.alpha = 1;
			var iconP2AlphaTween:FlxTween; iconP2AlphaTween = FlxTween.tween(iconP2, {alpha: 0}, duration, {ease: hudTweenEase}); hudAlphaTweens.push(iconP2AlphaTween);
		}

		if (hbt)
		{
			scoreTxt.visible = true; scoreTxt.alpha = 1;
			var scoreTxtAlphaTween:FlxTween; scoreTxtAlphaTween = FlxTween.tween(scoreTxt, {alpha: 0}, duration, {ease: hudTweenEase}); hudAlphaTweens.push(scoreTxtAlphaTween);
		}
		
		if (!hbt)
		{
			if (scoreWarning.text != " ")
			{
				scoreWarningText = scoreWarning.text;
			}
			scoreWarning.text = " ";
		}
		else
		{
			scoreWarning.text = scoreWarningText;
		}
		
		if (timer)
		{
			timerBG.visible = true; timerBG.alpha = 1;
			var timerBGAlphaTween:FlxTween; timerBGAlphaTween = FlxTween.tween(timerBG, {alpha: 0}, duration, {ease: hudTweenEase}); hudAlphaTweens.push(timerBGAlphaTween);
			timerBar.visible = true; timerBar.alpha = 1;
			var timerBarAlphaTween:FlxTween; timerBarAlphaTween = FlxTween.tween(timerBar, {alpha: 0}, duration, {ease: hudTweenEase}); hudAlphaTweens.push(timerBarAlphaTween);
			timerText.visible = true; timerText.alpha = 1;
			var timerTextAlphaTween:FlxTween; timerTextAlphaTween = FlxTween.tween(timerText, {alpha: 0}, duration, {ease: hudTweenEase}); hudAlphaTweens.push(timerTextAlphaTween);
			timerNow.visible = true; timerNow.alpha = 1;
			var timerNowAlphaTween:FlxTween; timerNowAlphaTween = FlxTween.tween(timerNow, {alpha: 0}, duration, {ease: hudTweenEase}); hudAlphaTweens.push(timerNowAlphaTween);
			timerFinal.visible = true; timerFinal.alpha = 1;
			var timerFinalAlphaTween:FlxTween; timerFinalAlphaTween = FlxTween.tween(timerFinal, {alpha: 0}, duration, {ease: hudTweenEase}); hudAlphaTweens.push(timerFinalAlphaTween);
		}
		
		if (pS)
		{
			for (e in playerStrums.members)
			{
				if (e != null)
				{
					e.visible = true; e.alpha = 1;
					var playerStrumsAlphaTween:FlxTween; playerStrumsAlphaTween = FlxTween.tween(e, {alpha: 0}, duration, {ease: hudTweenEase}); hudAlphaTweens.push(playerStrumsAlphaTween);
				}
			}
		}
		
		if (cS)
		{
			for (e in cpuStrums.members)
			{
				if (e != null)
				{
					e.visible = true; e.alpha = 1;
					var cpuStrumsAlphaTween:FlxTween; cpuStrumsAlphaTween = FlxTween.tween(e, {alpha: 0}, duration, {ease: hudTweenEase}); hudAlphaTweens.push(cpuStrumsAlphaTween);
				}
			}
		}
	}
}

function ShowHUDSmooth(?duration:Float = 1.0, ?hb:Bool = true, ?hbt:Bool = true, ?timer:Bool = true, ?pS:Bool = true, ?cS:Bool = true)  // to use it as an event, type 1 and 0 instead of true and false
{
	if (modchart)
	{
		var hudTweenEase:FlxEase = FlxEase.smoothIn;
		
		if (hb)
		{
			healthBarBG.visible = true; healthBarBG.alpha = 0;
			var healthBarBGAlphaTween:FlxTween; healthBarBGAlphaTween = FlxTween.tween(healthBarBG, {alpha: 1}, duration, {ease: FlxEase.linear}); hudAlphaTweens.push(healthBarBGAlphaTween);
			healthBar.visible = true; healthBar.alpha = 0;
			var healthBarAlphaTween:FlxTween; healthBarAlphaTween = FlxTween.tween(healthBar, {alpha: 1}, duration, {ease: hudTweenEase}); hudAlphaTweens.push(healthBarAlphaTween);
			iconP1.visible = true; iconP1.alpha = 0;
			var iconP1AlphaTween:FlxTween; iconP1AlphaTween = FlxTween.tween(iconP1, {alpha: 1}, duration, {ease: hudTweenEase}); hudAlphaTweens.push(iconP1AlphaTween);
			iconP2.visible = true; iconP2.alpha = 0;
			var iconP2AlphaTween:FlxTween; iconP2AlphaTween = FlxTween.tween(iconP2, {alpha: 1}, duration, {ease: hudTweenEase}); hudAlphaTweens.push(iconP2AlphaTween);
		}

		if (hbt)
		{
			scoreTxt.visible = true; scoreTxt.alpha = 0;
			var scoreTxtAlphaTween:FlxTween; scoreTxtAlphaTween = FlxTween.tween(scoreTxt, {alpha: 1}, duration, {ease: hudTweenEase}); hudAlphaTweens.push(scoreTxtAlphaTween);
		}
		
		if (!hbt)
		{
			if (scoreWarning.text != " ")
			{
				scoreWarningText = scoreWarning.text;
			}
			scoreWarning.text = " ";
		}
		else
		{
			scoreWarning.text = scoreWarningText;
		}
		
		if (timer)
		{
			timerBG.visible = true; timerBG.alpha = 0;
			var timerBGAlphaTween:FlxTween; timerBGAlphaTween = FlxTween.tween(timerBG, {alpha: 1}, duration, {ease: hudTweenEase}); hudAlphaTweens.push(timerBGAlphaTween);
			timerBar.visible = true; timerBar.alpha = 0;
			var timerBarAlphaTween:FlxTween; timerBarAlphaTween = FlxTween.tween(timerBar, {alpha: 1}, duration, {ease: hudTweenEase}); hudAlphaTweens.push(timerBarAlphaTween);
			timerText.visible = true; timerText.alpha = 0;
			var timerTextAlphaTween:FlxTween; timerTextAlphaTween = FlxTween.tween(timerText, {alpha: 1}, duration, {ease: hudTweenEase}); hudAlphaTweens.push(timerTextAlphaTween);
			timerNow.visible = true; timerNow.alpha = 0;
			var timerNowAlphaTween:FlxTween; timerNowAlphaTween = FlxTween.tween(timerNow, {alpha: 1}, duration, {ease: hudTweenEase}); hudAlphaTweens.push(timerNowAlphaTween);
			timerFinal.visible = true; timerFinal.alpha = 0;
			var timerFinalAlphaTween:FlxTween; timerFinalAlphaTween = FlxTween.tween(timerFinal, {alpha: 1}, duration, {ease: hudTweenEase}); hudAlphaTweens.push(timerFinalAlphaTween);
		}
		
		if (pS)
		{
			for (e in playerStrums.members)
			{
				if (e != null)
				{
					e.visible = true; e.alpha = 0;
					var playerStrumsAlphaTween:FlxTween; playerStrumsAlphaTween = FlxTween.tween(e, {alpha: 1}, duration, {ease: hudTweenEase}); hudAlphaTweens.push(playerStrumsAlphaTween);
				}
			}
		}
		
		if (cS)
		{
			for (e in cpuStrums.members)
			{
				if (e != null)
				{
					e.visible = true; e.alpha = 0;
					var cpuStrumsAlphaTween:FlxTween; cpuStrumsAlphaTween = FlxTween.tween(e, {alpha: 1}, duration, {ease: hudTweenEase}); hudAlphaTweens.push(cpuStrumsAlphaTween);
				}
			}
		}
	}
}

function MoveBlackBars(duration, position, ?ignoreSetting)
{
	if (modchart || ignoreSetting)
	{
		FlxTween.tween(BlackBarUp, {y: -60}, duration, {ease: FlxEase.quadOut});
		FlxTween.tween(BlackBarDown, {y: 650}, duration, {ease: FlxEase.quadOut});
		
		if (dbgMessage)
		{
		var curInfo:String;
		if (dbgCurInfo) { curInfo = " (curStep: " + curStep + " || curBeat: " + curBeat + ")"; }
		else { curInfo = ""; }
		trace("[MoveBlackBars FUNCTION] Duration: " + duration + " | Position: " + position + curInfo);
		}
	}
}

function ShowBlackBars(show:Bool)
{
	if (modchart)
	{
		BlackBarUp.visible = show;
		BlackBarDown.visible = show;
		
		if (dbgMessage)
		{
		var curInfo:String;
		if (dbgCurInfo) { curInfo = " (curStep: " + curStep + " || curBeat: " + curBeat + ")"; }
		else { curInfo = ""; }
		trace("[ShowBlackBars FUNCTION] Show: " + show + curInfo);
		}
	}
}

function SlideBlackBars(duration, ?ignoreSetting)
{
	if (modchart || ignoreSetting)
	{
		FlxTween.tween(BlackBarUp, {y: -160}, duration, {ease: FlxEase.quadOut});
		FlxTween.tween(BlackBarDown, {y: 750}, duration, {ease: FlxEase.quadOut});
		
		if (dbgMessage)
		{
		var curInfo:String;
		if (dbgCurInfo) { curInfo = " (curStep: " + curStep + " || curBeat: " + curBeat + ")"; }
		else { curInfo = ""; }
		trace("[SlideBlackBars FUNCTION] Duration: " + duration + curInfo);
		}
	}
}

function FlexNotes(power) noteDancePower = power;

function FlexNotesAction()
{
	var currentBeat = (Conductor.songPosition / 1000) * (Conductor.bpm / 60);
	for (i in 0...8)
	{
		if (i < 4)
			cpuStrums.members[i].y = PlayState.strumLine.y + noteDancePower * Math.cos((currentBeat + i*0.5) * Math.PI);
		else
			playerStrums.members[i - 4].y = PlayState.strumLine.y + noteDancePower * Math.cos((currentBeat + i*0.5) * Math.PI);
	}
}

function PauseCheck()
{
	for (t in hudAlphaTweens)
	{
		if (t.finished || t == null)
		{
			t.destroy(true);
			hudAlphaTweens.remove(t);
		}
		else
		{
			if (paused) t.active = false;
			else t.active = true;
		}
	}
}