var defCamOffsetsX:Array<Float> = [0.0, 0.0, 0.0, 0.0, 0.0]; // left, up, down, right
var defCamOffsetsY:Array<Float> = [0.0, 0.0, 0.0, 0.0, 0.0];

function createPost()
{
	var fuckMe:Int = 0;
	for (anim in dad.cameraOffsets)
	{
		defCamOffsetsX[fuckMe] = anim[0];
		defCamOffsetsY[fuckMe] = anim[1];
		fuckMe++;
	}
}

function stepHit(cS)
{
	if (modchart)
	{
		switch (cS)
		{
			case 1280: hideHUDSmooth(3.0, 1, 1, 1, 1, 1);
			case 1392: showHUDSmooth(1.0, 1, 1, 1, 1, 1);
		}
	}
}

function AddDefaultZoom(zoom)
{
	if (modchart)
	{
		for (i in dad.cameraOffsets)
		{
			i[0] -= zoom * 7.5;
			i[1] -= zoom * 7.5;
		}
	}
}

function ResetDefaultZoom()
{
	if (modchart)
	{
		var fuckMe:Int = 0;
		for (i in dad.cameraOffsets)
		{
			i[0] = defCamOffsetsX[fuckMe];
			i[1] = defCamOffsetsY[fuckMe];
			fuckMe++;
		}
	}
}