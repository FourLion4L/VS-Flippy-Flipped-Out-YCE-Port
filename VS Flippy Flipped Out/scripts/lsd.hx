import  openfl.filters.ShaderFilter;
import  Medals;

var LSDShader:CustomShader;
var CumOverlay:FlxSprite;

var highNotes:Bool = false;

function create()
{
	CumOverlay = new FlxSprite(-55, 0).makeGraphic(FlxG.width + 200, FlxG.height, 0xFFFFFFFF, false);
	CumOverlay.scrollFactor.set();
	CumOverlay.cameras = [camHUD];
	CumOverlay.alpha = 0.6;
	CumOverlay.visible = false;
	add(CumOverlay);
}

function createPost()
{
	LSDShader = new CustomShader(Paths.shader("invert"));

	camGame.setFilters([new ShaderFilter(LSDShader)]);
    camGame.filtersEnabled = false;
	camGame.color = 000000000;	
}

function SniffSomeShit()
{
	camGame.filtersEnabled = true;
	CumOverlay.visible = true;
	
	unFadeSprite = new FlxSprite(-350, -200).makeGraphic(FlxG.width * 1.65, FlxG.height * 1.65, 0xFF000000, true);
	unFadeSprite.scrollFactor.set();
	unFadeSprite.cameras = [camHUD];
	add(unFadeSprite);		
	unFadeSprite.alpha = 1;
	FlxTween.tween(unFadeSprite, {alpha: 0}, 0.5, {ease: FlxEase.linear});
	
	FlxG.camera.zoom += 0.2;
	camHUD.zoom += 0.035;
	
	highNotes = true;
}

function AfterMeth()
{
	camGame.filtersEnabled = false;
	CumOverlay.visible = false;
	
	unFadeSprite = new FlxSprite(-350, -200).makeGraphic(FlxG.width * 1.65, FlxG.height * 1.65, 0xFF000000, true);
	unFadeSprite.scrollFactor.set();
	unFadeSprite.cameras = [camHUD];
	add(unFadeSprite);		
	unFadeSprite.alpha = 1;
	FlxTween.tween(unFadeSprite, {alpha: 0}, 0.2, {ease: FlxEase.linear});
	
	highNotes = false;
}

function updatePost(elapsed)
{
	if (modchart && highNotes)
	{
		var currentBeat = (Conductor.songPosition / 1000) * (Conductor.bpm / 60);
		for (i in 0...8)
		{
			if (i < 4)
				cpuStrums.members[i].y = PlayState.strumLine.y + 4 * Math.cos((currentBeat + i*0.5) * Math.PI);
			else
				playerStrums.members[i - 4].y = PlayState.strumLine.y + 4 * Math.cos((currentBeat + i*0.5) * Math.PI);
		}
	}
}

function onDeath()
{
	if (modchart && highNotes)
		Medals.unlock(mod, "Dont Do Drugs.");
		
	AfterMeth();
}