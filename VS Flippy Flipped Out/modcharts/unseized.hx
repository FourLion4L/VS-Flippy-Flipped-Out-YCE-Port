import flixel.tweens.FlxTween;
import flixel.tweens.FlxEase;

function MoveNotes()
{
	if (modchart && !engineSettings.middlescroll)
	{
		for (strum in playerStrums)
			FlxTween.tween(strum, {x: strum.x - strum.width / 4.5 - FlxG.width / 4.5}, 11);
		for (strum in cpuStrums)
		{
			FlxTween.tween(strum, {x: strum.x - strum.width / 4.5 - FlxG.width / 4.5}, 11);
			FlxTween.tween(strum, {alpha: 0}, 10);
		}
	}
}

function HideNotes() 
{
	if (modchart)
	{
		for (strum in playerStrums)
		{
			var newTween = FlxTween.tween(strum, {alpha: 0}, 8);
		}
	}
}