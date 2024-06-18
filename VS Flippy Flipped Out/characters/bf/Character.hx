function create() {
    character.frames = Paths.getCharacter(character.curCharacter);

    character.longAnims = ["dodge"];

    character.animation.addByPrefix('idle', 'BF idle dance', 24, false);
    character.animation.addByPrefix('singUP', 'BF NOTE UP0', 24, false);
    character.animation.addByPrefix('singLEFT', 'BF NOTE LEFT0', 24, false);
    character.animation.addByPrefix('singRIGHT', 'BF NOTE RIGHT0', 24, false);
    character.animation.addByPrefix('singDOWN', 'BF NOTE DOWN0', 24, false);
    character.animation.addByPrefix('singUPmiss', 'BF NOTE UP MISS', 24, false);
    character.animation.addByPrefix('singLEFTmiss', 'BF NOTE LEFT MISS', 24, false);
    character.animation.addByPrefix('singRIGHTmiss', 'BF NOTE RIGHT MISS', 24, false);
    character.animation.addByPrefix('singDOWNmiss', 'BF NOTE DOWN MISS', 24, false);
    character.animation.addByPrefix('hey', 'BF HEY', 24, false);
    character.animation.addByPrefix('dodge', 'boyfriend dodge', 24, false);
    character.animation.addByPrefix('hit', 'BF hit', 24, false);
    character.animation.addByPrefix('preAttack', 'bf pre attack', 24, false);

    character.animation.addByPrefix('scared', 'BF idle shaking', 24);

    character.addOffset('idle', -4, 1);
    character.addOffset("singUP", -45, 31);
    character.addOffset("singRIGHT", -48, -5);
    character.addOffset("singLEFT", 4, -4);
    character.addOffset("singDOWN", -20, -51);
    character.addOffset("singUPmiss", -42, 28);
    character.addOffset("singRIGHTmiss", -43, 22);
    character.addOffset("singLEFTmiss", 2, 20);
    character.addOffset("singDOWNmiss", -22, -20);
    character.addOffset("hey", -3, 8);
    character.addOffset('scared', -5, 2);
    character.addOffset('preAttack', -33, -40);
	character.addOffset('dodge', -4, -9);
	character.addOffset('hit', 15, 19);

    character.playAnim('idle');
    character.charGlobalOffset.y = 350;
    character.flipX = true;
	character.antialiasing = true;
	
	/*character.addCameraOffset("singLEFT", -50, 0);
    character.addCameraOffset("singDOWN", 0, 50);
    character.addCameraOffset("singUP", 0, -50);
    character.addCameraOffset("singRIGHT", 50, 0);
	
	character.addCameraOffset("singLEFTmiss", -50, 0);
    character.addCameraOffset("singDOWNmiss", 0, 50);
    character.addCameraOffset("singUPmiss", 0, -50);
    character.addCameraOffset("singRIGHTmiss", 50, 0);*/
}

function dance() {
    if (character.lastHit <= Conductor.songPosition || character.lastHit == 0) {
        character.playAnim('idle');
    }
}

function getColors(altAnim) {
    return [
        0xFF31B0D1,
        EngineSettings.arrowColor0,
        EngineSettings.arrowColor1,
        EngineSettings.arrowColor2,
        EngineSettings.arrowColor3
    ];
}