function create() {
	character.frames = Paths.getCharacter(character.curCharacter);
	character.loadJSON(true);
	
	character.addCameraOffset("singLEFT", -20, 0);
	character.addCameraOffset("singDOWN", 15, 40);
	character.addCameraOffset("singUP", -100, -80);
	character.addCameraOffset("singRIGHT", 120, 20);
}