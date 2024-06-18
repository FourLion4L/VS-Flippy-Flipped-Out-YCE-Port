function create() {
	character.frames = Paths.getCharacter(character.curCharacter);
	character.loadJSON(true);
	
	character.addCameraOffset("singLEFT", -15, 0);
	character.addCameraOffset("singDOWN", 0, 15);
	character.addCameraOffset("singUP", 0, -15);
	character.addCameraOffset("singRIGHT", 15, 0);
}