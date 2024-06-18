function create() {
	character.frames = Paths.getCharacter(character.curCharacter);
	character.loadJSON(true);
	
	character.addCameraOffset("singUP", 30, -20);
	character.addCameraOffset("singLEFT", -5, 20);
	character.addCameraOffset("singRIGHT", 175, -50);
	character.addCameraOffset("singDOWN", 40, 80);
}