var stage:Stage = null;
function create() {
	stage = loadStage('camp-alt');
}
function update(elapsed) {
	stage.update(elapsed);
}
function beatHit(curBeat) {
	stage.onBeat();
}