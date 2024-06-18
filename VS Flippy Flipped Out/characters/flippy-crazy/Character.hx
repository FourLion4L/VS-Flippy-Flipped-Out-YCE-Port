function create() {
	character.frames = Paths.getCharacter(character.curCharacter);
	character.loadJSON(true);
	
	/*character.addCameraOffset("singUP", -170, -180);
	character.addCameraOffset("singDOWN", 20, 10);
	character.addCameraOffset("singLEFT", -180, -80);
	character.addCameraOffset("singRIGHT", 60, 40);
	character.addCameraOffset("singUP-alt", -170, -180);
	character.addCameraOffset("singDOWN-alt", 20, 10);
	character.addCameraOffset("singLEFT-alt", -180, -80);
	character.addCameraOffset("singRIGHT-alt", 60, 40);*/
}