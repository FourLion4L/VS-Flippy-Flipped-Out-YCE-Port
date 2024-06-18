import flixel.tweens.FlxTween;
import flixel.tweens.FlxEase;

var camFuck:Bool = false;
var camFuckTiming:Int = 2;
var camFuckPower:Int = 2;

var arrowCamFuck:Array<Bool> = [false, false];
var arrowCamFuckTiming:Int = 2;
var lerpShit:Array<Int> = [-50, -50];

var funnyBump:Bool = false;
var funnyBumpTiming:Int = 2;
var strumScaleLerp:Float = 0.0;

var camStick:Bool = false;
var darkenBG:Bool = false;
var StickBG:FlxSprite;

var fastBump:Bool = false;
var fastBumpValue:Int = 8;

function updatePost(elapsed)
{
	if (funnyBump)
	{
		for (i in 0...8)
		{			
			strumScaleLerp = FlxMath.lerp(strumScaleLerp, 0.7, 0.0152 * 60 * elapsed);
			
			if (i < 4) cpuStrums.members[i].scale.set(strumScaleLerp, strumScaleLerp);
			else playerStrums.members[i - 4].scale.set(strumScaleLerp, strumScaleLerp);
			
			FlxG.camera.setScale(strumScaleLerp, strumScaleLerp);
		}
	}
}

function beatHit(curBeat)
{
	if (camFuck)
	{	
		if (curBeat % camFuckTiming == 0)
		{
			camFuckPower = -camFuckPower;
			camHUD.angle = camFuckPower*3;
			camGame.angle = camFuckPower*3;
			FlxTween.tween(camHUD, {angle: 0}, Conductor.stepCrochet*0.003, {ease: FlxEase.circOut});
			FlxTween.tween(camHUD, {x: 0}, Conductor.stepCrochet*0.0015, {ease: FlxEase.linear});
			FlxTween.tween(camGame, {angle: 0}, Conductor.stepCrochet*0.003, {ease: FlxEase.circOut});
			FlxTween.tween(camGame, {x: 0}, Conductor.stepCrochet*0.0015, {ease: FlxEase.linear});
		}
	}
	
	if (funnyBump)
	{
		if (curBeat % funnyBumpTiming == 0)
		{
			FlxG.camera.zoom += 0.1;
			strumScaleLerp += 0.25;
		}
	}
}

function stepHit(curStep)
{
	if (fastBump)
	{
		if (curStep % fastBumpValue == 0) FlxG.camera.zoom += 0.03-0;
	}

	if (camFuck)
	{
		if (curStep % camFuckTiming*2 == camFuckTiming*2)
		{
			FlxTween.tween(camHUD, {y: -12}, Conductor.stepCrochet*0.002, {ease: FlxEase.circOut});
		}
		if (curStep % camFuckTiming*2 == camFuckTiming*4)
		{
			FlxTween.tween(camHUD, {y: 0}, Conductor.stepCrochet*0.002, {ease: FlxEase.sineIn});
		}
	}
}

function onPlayerHit() 
{
	if (arrowCamFuck[0])
	{
		FlxG.camera.zoom += 0.05;
		strumScaleLerp += 0.01;
	}
}
function onDadHit()
{
	if (arrowCamFuck[1])
	{
		FlxG.camera.zoom += 0.05;
		strumScaleLerp += 0.01;
	}
}

function FuckCam(?timing, ?power) 
{
	if (modchart)
	{
		if (timing != null) camFuckTiming = timing;
		else camFuckTiming = 2;
		if (power != null) camFuckPower = power;
		else camFuckPower = 1;
		camFuck = !camFuck;

		if (!camFuck)
		{
			camHUD.angle = 0;
			camHUD.x = 0;
			camHUD.y = 0;
			camGame.angle = 0;
			camGame.x = 0;
		}
	}
}

function FuckCamArrows(character)
	if (modchart) arrowCamFuck[character] = !arrowCamFuck[character];
	
function FunnyBump(?timing)
{
	if (modchart)
	{
		if (timing != null) funnyBumpTiming = timing;
		funnyBump = !funnyBump;
		strumScaleLerp = 0.7;
	
		if (!funnyBump)
		{
			for (i in 0...8)
			{
				if (i < 4)
				{
					cpuStrums.members[i].scale.set(0.7, 0.7);
				}
				else
				{
					playerStrums.members[i - 4].scale.set(0.7, 0.7);
				}
			
				FlxG.camera.setScale(1.0, 1.0);
			}
		}
	}
}

function StickToHUD()
{
	if (modchart)
	{
		camStick = !camStick;
		unFadeCommon(1);
		
		if (camStick)
		{
			moveBlackBars(1, 1);
			tempFollow = new FlxSprite(gf.camOffset.x + 400, gf.camOffset.y + 350);
			FlxG.camera.follow(tempFollow, "LOCKON", 0.04);
			dad.cameras = [camHUD];
			dad.setPosition(dad.x+250, dad.y-50);
			boyfriend.cameras = [camHUD];
			boyfriend.setPosition(boyfriend.x-50, boyfriend.y+50);
		}
		else
		{
			tempFollow.destroy();
			slideBlackBars(0.2);
			FlxG.camera.follow(camFollow, "LOCKON", 0.04);
			dad.cameras = [camGame];
			dad.setPosition(dad.x-250, dad.y+50);
			boyfriend.cameras = [camGame];
			boyfriend.setPosition(boyfriend.x+50, boyfriend.y-50);
		}
	}
}

function FastBump(value:Int)
{
	if (value == 0) fastBump = false;
	else fastBump = true;
	fastBumpValue = value;
}