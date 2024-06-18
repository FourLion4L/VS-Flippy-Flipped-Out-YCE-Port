var stage:Stage = null;
function create() {
	stage = loadStage('alleyway');
}
function createPost()
{
	boyfriend.camOffset.x -= 150;
	boyfriend.camOffset.y -= 20;
}
function update(elapsed) {
	stage.update(elapsed);
}
function beatHit(curBeat) {
	stage.onBeat();
}