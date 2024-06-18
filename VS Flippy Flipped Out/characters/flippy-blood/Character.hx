function create() {
	character.frames = Paths.getCharacter(character.curCharacter);
	character.loadJSON(true); // Setting to true will override getColors() and dance().
	
	character.addCameraOffset("singLEFT", -25, -80);
	character.addCameraOffset("singDOWN", 40, 80);
	character.addCameraOffset("singUP", 30, -50);
	character.addCameraOffset("singRIGHT", 50, 20);
}