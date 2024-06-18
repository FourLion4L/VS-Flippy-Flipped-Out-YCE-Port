function create() {
	character.frames = Paths.getCharacter(character.curCharacter);
	character.loadJSON(true);
	
	character.addCameraOffset("singLEFT", -15, 0);
	character.addCameraOffset("singDOWN", 20, 0);
	character.addCameraOffset("singUP", 5, -10);
	character.addCameraOffset("singRIGHT", 45, 0);
}