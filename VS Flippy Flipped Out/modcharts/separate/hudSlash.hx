import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;

var unFadeSprite:FlxSprite;
var elementArray:Array<Dynamic> = [];

function createPost()
{
	elementArray = [healthBar, healthBarBG, iconP1, iconP2, scoreTxt, msScoreLabel, hitCounter, watermark, timerText, timerBG, timerBar, timerNow, timerFinal];

	if (PlayState.SONG.song == "Disturbed")
	{
		for (i in elementArray) { if (i != null) i.visible = false; }
		
		for (i in 0...8)
		{
			if (i < 4)
				cpuStrums.members[i].visible = false;
			else
				playerStrums.members[i - 4].visible = false;
		}
		
		startSong();
	}
}

function onCountdown() if (PlayState.SONG.song == "Disturbed") { return false; }

function SlashHud()
{
	unFade(0.5);

	var amount:Int;
	elementArray = [healthBar, healthBarBG, iconP1, iconP2, scoreTxt, msScoreLabel, hitCounter, watermark, timerText, timerBG, timerBar, timerNow, timerFinal];
	for (i in 0...8)
	{
		if (i < 4)
			elementArray.push(cpuStrums.members[i]);
		else
			elementArray.push(playerStrums.members[i - 4]);
	}
	trace(elementArray.length);
	for (elem in 0...elementArray.length)
	{
		if (elementArray[elem] != null && elementArray[elem].visible)
		{
			if (amount == 5) break;
			
			if (FlxG.random.bool(50))
			{
				if (elem == 0 || elem == 1) // Health Bar Group
				{
					elementArray[0].visible = false;
					elementArray[1].visible = false;
				}
				else if (elem == 9 || elem == 10) // Timer Bar Group
				{
					elementArray[9].visible = false;
					elementArray[10].visible = false;
				}
				else elementArray[elem].visible = false; // the rest
				
				amount++;
			}
		}
	}
}
		
function unFade(duration)
{
	//if (modchart)
	//{		
		unFadeSprite = new FlxSprite(-350, -200).makeGraphic(FlxG.width * 1.65, FlxG.height * 1.65, 0xFF000000, true);
		unFadeSprite.scrollFactor.set();
		unFadeSprite.cameras = [camHUD];
		add(unFadeSprite);
			
		unFadeSprite.alpha = 1;
		FlxTween.tween(unFadeSprite, {alpha: 0}, duration, {ease: FlxEase.linear});
	//}
}

function ReturnHud()
{
	hideHUD(1, 1, 1, 1, 1);
	hideHUDSmooth(0.001, 1, 1, 1, 1, 1);
	showHUDSmooth(1.0, 1, 1, 1, 1, 1);
}