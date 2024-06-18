function create() {
	character.frames = Paths.getCharacter(character.curCharacter);
	character.loadJSON(true); // Setting to true will override getColors() and dance().
	
	character.addCameraOffset("singLEFT", -10, -30);
	character.addCameraOffset("singDOWN", 20, 40);
	character.addCameraOffset("singUP", 5, -25);
	character.addCameraOffset("singRIGHT", 40, 0);
}