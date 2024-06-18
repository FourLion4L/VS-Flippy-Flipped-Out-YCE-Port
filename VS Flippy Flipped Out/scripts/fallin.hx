var oldCharacterBF:Character = null;
var newCharacterBF:Character = null;
var oldCharacterDAD:Character = null;
var newCharacterDAD:Character = null;
var stage:Stage = null;

var flashbackPath:String = "fallen-soldier/phase4/flashback/";
var flashbackStuff:Array<FlxSprite> = [];

var preloadGraph = [];

function create()
{
	var fBG = new FlxSprite(-350, -350).loadGraphic(Paths.image(flashbackPath + "background"));
	fBG.scrollFactor.set(1.0, 1.0);
	fBG.antialiasing = EngineSettings.antialiasing;
	fBG.cameras = [camGame];
	add(fBG);
	fBG.visible = false;
	
	var fBackTrees = new FlxSprite(-350, -350).loadGraphic(Paths.image(flashbackPath + "backtrees"));
	fBackTrees.scrollFactor.set(0.95, 1.0);
	fBackTrees.antialiasing = EngineSettings.antialiasing;
	fBackTrees.cameras = [camGame];
	add(fBackTrees);
	fBackTrees.visible = false;

	var fGround = new FlxSprite(-350, -350).loadGraphic(Paths.image(flashbackPath + "ground"));
	fGround.scrollFactor.set(1.0, 1.0);
	fGround.antialiasing = EngineSettings.antialiasing;
	fGround.cameras = [camGame];
	add(fGround);
	fGround.visible = false;
	
	flashbackStuff.push(fBG);
	flashbackStuff.push(fBackTrees);
	flashbackStuff.push(fGround);
	
	for (i in flashbackStuff)
	{
		preloadGraph.push(i);
	}
}

function createPost()
{
	canDie = false;

	boyfriend.addCameraOffset("idle", 0, -50);
	
	boyfriend.addCameraOffset("singLEFT", -10, -50);
    boyfriend.addCameraOffset("singDOWN", -2, -40);
    boyfriend.addCameraOffset("singUP", 3, -60);
    boyfriend.addCameraOffset("singRIGHT", 8, -50);
	
	boyfriend.addCameraOffset("singLEFTmiss", -10, -50);
    boyfriend.addCameraOffset("singDOWNmiss", -2, -40);
    boyfriend.addCameraOffset("singUPmiss", 3, -60);
    boyfriend.addCameraOffset("singRIGHTmiss", 8, -50);
	
	newCharacterBF = new Boyfriend(Std.parseFloat(0.0), Std.parseFloat(0.0), mod + ":" + "bf-tiger");
	newCharacterDAD = new Character(Std.parseFloat(0.0), Std.parseFloat(0.0), mod + ":" + "flippy-fallout");
	
	preloadGraph.push(newCharacterBF);
	preloadGraph.push(newCharacterDAD);
	
	healthBarBG.visible = false;
	healthBar.visible = false;
	iconP1.visible = false;
	iconP2.visible = false;

	scoreTxt.visible = false;
	scoreWarning.text = " ";
	
	timerBG.visible = false;
	timerBar.visible = false;
	timerText.visible = false;
	timerNow.visible = false;
	timerFinal.visible = false;
}

function Flashback()
{
	for (i in flashbackStuff)
	{
		i.visible = true;
	}
	
	bfAdd("bf-tiger", boyfriend.x-150, boyfriend.y+90);
	dadAdd("flippy-fallout", dad.x-40, dad.y+100);
	
	var fBuddy = new FlxSprite(-350, -350).loadGraphic(Paths.image(flashbackPath + "buddies"));
	fBuddy.scrollFactor.set(0.95, 1.0);
	fBuddy.antialiasing = EngineSettings.antialiasing;
	fBuddy.cameras = [camGame];
	add(fBuddy);
	
	flashbackStuff.push(fBuddy);
	
	defaultCamZoom += 0.02;
	
	boyfriend.addCameraOffset("idle", -100, 40);
	
	boyfriend.addCameraOffset("singLEFT", -105, 40);
    boyfriend.addCameraOffset("singDOWN", -101, 42);
    boyfriend.addCameraOffset("singUP", -98, 36);
    boyfriend.addCameraOffset("singRIGHT", -97, 40);
	
	boyfriend.addCameraOffset("singLEFTmiss", -105, 40);
    boyfriend.addCameraOffset("singDOWNmiss", -101, 42);
    boyfriend.addCameraOffset("singUPmiss", -98, 36);
    boyfriend.addCameraOffset("singRIGHTmiss", -97, 40);
	
	dad.addCameraOffset("idle", 0, 120);
	
	dad.addCameraOffset("singLEFT", 0, 120);
    dad.addCameraOffset("singDOWN", 0, 120);
    dad.addCameraOffset("singUP", 0, 120);
    dad.addCameraOffset("singRIGHT", 0, 120);
	
	moveBlackBars(1, 1, true);
}

function SnapBackToReality()
{
	for (i in flashbackStuff)
	{
		remove(i);
	}
	
	PlayState.dads.remove(newCharacterDAD);
	PlayState.remove(newCharacterDAD);
	PlayState.boyfriends.remove(newCharacterBF);
	PlayState.remove(newCharacterBF);
	
	defaultCamZoom -= 0.02;
	
	boyfriend.addCameraOffset("idle", 0, -50);
	
	boyfriend.addCameraOffset("singLEFT", -10, -50);
    boyfriend.addCameraOffset("singDOWN", -2, -40);
    boyfriend.addCameraOffset("singUP", 3, -60);
    boyfriend.addCameraOffset("singRIGHT", 8, -50);
	
	boyfriend.addCameraOffset("singLEFTmiss", -10, -50);
    boyfriend.addCameraOffset("singDOWNmiss", -2, -40);
    boyfriend.addCameraOffset("singUPmiss", 3, -60);
    boyfriend.addCameraOffset("singRIGHTmiss", 8, -50);
	
	dad.addCameraOffset("idle", 0, 0);
	
	dad.addCameraOffset("singLEFT", 0, 0);
    dad.addCameraOffset("singDOWN", 0, 0);
    dad.addCameraOffset("singUP", 0, 0);
    dad.addCameraOffset("singRIGHT", 0, 0);
	
	slideBlackBars(0.2, true);
}

function bfAdd(character:String, xPos:String, yPos:String) {
    oldCharacterBF = PlayState.boyfriend;
    newCharacterBF = new Boyfriend(Std.parseFloat(xPos), Std.parseFloat(yPos), mod + ":" + character);
    newCharacterBF.visible = false;
    PlayState.boyfriends.push(newCharacterBF);
    PlayState.add(newCharacterBF);
    newCharacterBF.visible = true;
}

function dadAdd(character:String, xPos:String, yPos:String) {
    oldCharacterDAD = PlayState.dad;
    newCharacterDAD = new Character(Std.parseFloat(xPos), Std.parseFloat(yPos), mod + ":" + character);
    newCharacterDAD.visible = false;
    PlayState.dads.push(newCharacterDAD);
    PlayState.add(newCharacterDAD);
    newCharacterDAD.visible = true;
}