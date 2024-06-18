import flixel.tweens.FlxTween;
import flixel.tweens.FlxEase;

var camSwing:Bool = false;
var camSwingTiming:Int = 2;
var camSwingPower:Int = 1;

function beatHit(curBeat)
{
	if (camSwing)
	{	
		if (curBeat % camSwingTiming == 0)
		{
			camSwingPower = -camSwingPower;
			camHUD.angle = camSwingPower*3;
			camGame.angle = camSwingPower*3;
			FlxTween.tween(camHUD, {angle: 0}, Conductor.stepCrochet*0.003, {ease: FlxEase.circOut});
			FlxTween.tween(camHUD, {x: 0}, Conductor.stepCrochet*0.0015, {ease: FlxEase.linear});
			FlxTween.tween(camGame, {angle: 0}, Conductor.stepCrochet*0.003, {ease: FlxEase.circOut});
			FlxTween.tween(camGame, {x: 0}, Conductor.stepCrochet*0.0015, {ease: FlxEase.linear});
		}
	}
}

function stepHit(curStep)
{
	if (camSwing)
	{
		if (curStep % camSwingTiming*2 == camSwingTiming*2)
		{
			FlxTween.tween(camHUD, {y: -12}, Conductor.stepCrochet*0.002, {ease: FlxEase.circOut});
		}
		if (curStep % camSwingTiming*2 == camSwingTiming*4)
		{
			FlxTween.tween(camHUD, {y: 0}, Conductor.stepCrochet*0.002, {ease: FlxEase.sineIn});
		}
	}
}

function HudSwing(?timing)
{
	if (timing != null) camSwingTiming = timing;
	else camSwingTiming = 1;
	
	camSwing = !camSwing;
}