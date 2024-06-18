var camAdd:Float = 0.0;

function createPost()
{
	var dadCamPos = dad.getCamPos();
	camFollow.setPosition(dadCamPos.x, dadCamPos.y);
	FlxG.camera.scroll.set(dadCamPos.x-300, dadCamPos.y-250);
}

function beatHit(curBeat)
{
	if (section.duetCamera) defaultCamZoom = 0.5 + camAdd;
	else if (section.mustHitSection) defaultCamZoom = 0.65 + camAdd;
	else defaultCamZoom = 0.4 + camAdd;
}

function AddDefaultZoom(amount)	camAdd += amount-0;
function addDefaultZoom(amount) camAdd += amount-0;
function SetDefaultZoom(set) camAdd = set;
function setDefaultZoom(set) camAdd = set;
function ResetDefaultZoom() camAdd = 0.0;
function resetDefaultZoom() camAdd = 0.0;