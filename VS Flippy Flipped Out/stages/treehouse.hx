var stage:Stage = null;
function create() {
	stage = loadStage('treehouse');
}
function update(elapsed) {
	stage.update(elapsed);
}
function beatHit(curBeat) {
	stage.onBeat();
}