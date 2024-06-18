function createPost()
{
	var dadCamPos = dad.getCamPos();
	camFollow.setPosition(dadCamPos.x, dadCamPos.y);
	FlxG.camera.scroll.set(dadCamPos.x-300, dadCamPos.y-250);
	this.destroy();
}