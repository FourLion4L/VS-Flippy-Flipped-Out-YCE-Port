import flixel.text.FlxText;
import sys.FileSystem;
import sys.io.File;
import Medals;
import Settings;

var TitleBG:FlxSprite = null;
var logo:FlxSprite = null;
var FlippyDance:FlxSprite;
var FlippyGhost:FlxSprite;

var DebugText:FlxText;

var titleCharPosX:Int = -20;
var titleCharPosY:Int = 35;

var titleChar;

var lastHit:Int = 0;

// -------- Debug Settings ------
var debugTitle:Bool = false;
var allowOffset:Bool = true;
// -------- Debug Settings ------

// -------- Debug Animation -----
var debugMode:Int = 0;
var debugAnim:Int = 0;
var moveMultiplier:Int = 1;
var animList = ["idle", "left", "down", "up", "right"];
var animOffsetTempX = [0, 0];
var animOffsetTempY = [0, 0];
var charScaleTemp = [1.0, 1.0];
var saveToExport:Bool = true;
// -------- Debug Animation -----

// -------- Debug UI ------------
var charNameInputField:FlxUIInputText;
var charChangeButton:FlxUIButton;
var ghostChangeButton:FlxUIButton;
var overrideCheck:FlxUICheckBox;
// -------- Debug UI ------------


function create()
{
	if (debugTitle)
	{
		import flixel.addons.ui.FlxInputText;
		import flixel.addons.ui.FlxUIInputText;
		import flixel.addons.ui.FlxUIButton;
		import flixel.addons.ui.FlxUICheckBox;
	}
	
	var TitleBG = new FlxSprite(0, 0).loadGraphic(Paths.image('titleBG'));
	TitleBG.antialiasing = true;
	add(TitleBG);

	//destroy previous logo
	state.remove(logo);
	
	//add a new one
	var logoskin = Paths.getSparrowAtlas('logoBumpin');
    logo = new FlxSprite(450, -70);
    logo.frames = logoskin;
    logo.animation.addByPrefix('bump', 'logo bumpin0', 24, false);
    logo.animation.play('bump');
    logo.antialiasing = true;
	logo.scale.x = 0.8;
	logo.scale.y = 0.8;
    add(logo);
	
	//also remove gf and add flipster
	state.remove(gfDance);
	
	var titleCharList = Json.parse(Assets.getText(GetTitleCharConfig("mods/VS Flippy Flipped Out")));
	
	var availableChars:Array = [];
	for (i in titleCharList.chars) if (GetAccess(i)) availableChars.push(i);
	trace(availableChars);
	
	var randomChar = GetRandomChar(availableChars.length-1);
	trace(randomChar);
	
	var titleCharName:String;
	var isCharChanceTrue:Bool = FlxG.random.bool(availableChars[randomChar].chance);
	if (!isCharChanceTrue)
	{
		trace ("Start character failed, looking for another...");
		while (!isCharChanceTrue)
		{
			randomChar = GetRandomChar(availableChars.length-1);
			isCharChanceTrue = FlxG.random.bool(availableChars[randomChar].chance);
			if (isCharChanceTrue)
			{
				titleCharName = availableChars[randomChar].name;
				trace (randomChar + " | Chance: " + availableChars[randomChar].chance + " | TRUE");
			}
			else trace("nope");
		}
	 }
	else
	{
		titleCharName = titleCharList.chars[randomChar].name;
		trace (randomChar + " | Chance: " + titleCharList.chars[randomChar].chance);
	}
	
	SetupCharacter(titleCharName);
	OffsetHim();
	
	if (debugTitle)
	{
		DebugText = new FlxText(200, 50, FlxG.width, "curAnim: " + FlippyDance.animation.name + "\nX: " + FlippyDance.x + " | Y: " + FlippyDance.y, 25, true);
		add(DebugText);
		
		switch (titleChar.type)
		{
			case "idle":
				animOffsetTempX = [titleChar.animOffsets.idle[0]];
				animOffsetTempY = [titleChar.animOffsets.idle[1]];
			case "interactable":
				animOffsetTempX = [titleChar.animOffsets.idle[0], titleChar.animOffsets.left[0], titleChar.animOffsets.down[0], titleChar.animOffsets.up[0], titleChar.animOffsets.right[0]];
				animOffsetTempY = [titleChar.animOffsets.idle[1], titleChar.animOffsets.left[1], titleChar.animOffsets.down[1], titleChar.animOffsets.up[1], titleChar.animOffsets.right[1]];
			case "special":
				animOffsetTempX = [titleChar.animOffsets.idle[0], titleChar.animOffsets.left[0], titleChar.animOffsets.down[0], titleChar.animOffsets.up[0], titleChar.animOffsets.right[0], titleChar.animOffsets.hey[0]];
				animOffsetTempY = [titleChar.animOffsets.idle[1], titleChar.animOffsets.left[1], titleChar.animOffsets.down[1], titleChar.animOffsets.up[1], titleChar.animOffsets.right[1], titleChar.animOffsets.hey[1]];
		}
	}
	
	UpdateDebugInfo();
}

function beatHit(curBeat)
{
	logo.animation.play('bump', true);

	if (debugMode != 1 && FlippyDance.animation.curAnim.numFrames - FlippyDance.animation.curAnim.curFrame <= 2 && lastHit == 0)
	{
		FlippyDance.animation.play('idle', true);
		OffsetHim();
		UpdateDebugInfo();
	}
}

function updatePost(elapsed)
{
	if (FlxG.keys.justPressed.F5)  // refresh state :)
		FlxG.switchState(new TitleState());
		
	if (lastHit > 0) lastHit--;
	
	if (FlxG.keys.justPressed.LEFT)
	{
		if (debugMode == 1)
			animOffsetTempX[debugAnim] -= moveMultiplier;
		else
		{
			if (titleChar.type != "idle")
				FlippyDance.animation.play('left', true);
		}
	}

	if (FlxG.keys.justPressed.DOWN)
	{
		if (debugMode == 1)
			animOffsetTempY[debugAnim] += moveMultiplier;
		else
		{
			if (titleChar.type != "idle")
				FlippyDance.animation.play('down', true);
		}
	}

	if (FlxG.keys.justPressed.UP)
	{
		if (debugMode == 1)
			animOffsetTempY[debugAnim] -= moveMultiplier;
		else
		{
			if (titleChar.type != "idle")
				FlippyDance.animation.play('up', true);
		}
	}

	if (FlxG.keys.justPressed.RIGHT)
	{
		if (debugMode == 1)
			animOffsetTempX[debugAnim] += moveMultiplier;
		else
		{
			if (titleChar.type != "idle")
				FlippyDance.animation.play('right', true);
		}
	}	
		
	if (debugTitle && FlxG.keys.justPressed.F2)  // enable/disable offset editor
	{
		ToggleDebugMode();
	}
	
	if (debugMode)
	{
		if (FlxG.keys.pressed.SHIFT)  //  faster movement
			moveMultiplier = 5;
		else if (FlxG.keys.pressed.ALT)  // slower movement
			moveMultiplier = 0.5;
		else
			moveMultiplier = 1;
			
		if (FlxG.keys.justPressed.SPACE) FlippyDance.animation.play(FlippyDance.animation.name); // replay selected animation
			
		if (FlxG.keys.justPressed.W) PlayAnimFromList(true); // select next animation
			
		if (FlxG.keys.justPressed.S) PlayAnimFromList(false); // select previous animation 
			
		if (FlxG.keys.justPressed.Q)  // lessen character scale
		{
			charScaleTemp[0] -= 0.1;
			charScaleTemp[1] -= 0.1;
			FlippyDance.scale.x = charScaleTemp[0];
			FlippyDance.scale.y = charScaleTemp[1];
			FlippyGhost.scale.x = charScaleTemp[0];
			FlippyGhost.scale.y = charScaleTemp[1];
		}
			
		if (FlxG.keys.justPressed.E)  // increase character scale
		{
			charScaleTemp[0] += 0.1;
			charScaleTemp[1] += 0.1;
			FlippyDance.scale.x = charScaleTemp[0];
			FlippyDance.scale.y = charScaleTemp[1];
			FlippyGhost.scale.x = charScaleTemp[0];
			FlippyGhost.scale.y = charScaleTemp[1];
		}
		
		if (FlxG.keys.justPressed.F10)  // refresh json
			SetupCharacter(titleChar.name);
			
		if (FlxG.keys.justPressed.F12)  // save json
			SaveTitleCharJSON();
	}
	
	var c = FlxControls.justPressed;
	
	if (c.LEFT || c.DOWN || c.UP || c.RIGHT || c.W || c.S || c.Q || c.E || c.SPACE || c.F10)
	{
		lastHit = FlippyDance.animation.curAnim.numFrames + 5;
		OffsetHim();
		UpdateDebugInfo();
	}
}

function OffsetHim()
{
	if (allowOffset)
	{
		if (debugMode)
		{
			switch (FlippyDance.animation.name)
			{
				case 'idle': FlippyDance.x = titleCharPosX + animOffsetTempX[0]; FlippyDance.y = titleCharPosY + animOffsetTempY[0];
				case 'left': FlippyDance.x = titleCharPosX + animOffsetTempX[1]; FlippyDance.y = titleCharPosY + animOffsetTempY[1];
				case 'down': FlippyDance.x = titleCharPosX + animOffsetTempX[2]; FlippyDance.y = titleCharPosY + animOffsetTempY[2];
				case 'up': FlippyDance.x = titleCharPosX + animOffsetTempX[3]; FlippyDance.y = titleCharPosY + animOffsetTempY[3];
				case 'right': FlippyDance.x = titleCharPosX + animOffsetTempX[4]; FlippyDance.y = titleCharPosY + animOffsetTempY[4];
			}
		}
		else
		{
			switch (FlippyDance.animation.name)
			{
				case 'idle': FlippyDance.x = titleCharPosX + titleChar.animOffsets.idle[0]; FlippyDance.y = titleCharPosY + titleChar.animOffsets.idle[1];
				case 'left': FlippyDance.x = titleCharPosX + titleChar.animOffsets.left[0]; FlippyDance.y = titleCharPosY + titleChar.animOffsets.left[1];
				case 'down': FlippyDance.x = titleCharPosX + titleChar.animOffsets.down[0]; FlippyDance.y = titleCharPosY + titleChar.animOffsets.down[1];
				case 'up': FlippyDance.x = titleCharPosX + titleChar.animOffsets.up[0]; FlippyDance.y = titleCharPosY + titleChar.animOffsets.up[1];
				case 'right': FlippyDance.x = titleCharPosX + titleChar.animOffsets.right[0]; FlippyDance.y = titleCharPosY + titleChar.animOffsets.right[1];
			}
		}
	}
}

function GetTitleCharConfig(modPath)  return Paths.file("titleCharsConfig.json", "TEXT", modPath);

function GetRandomChar(length)  return FlxG.random.int(0, length);

function GetAccess(character)
{
	switch (character.unlockType)
	{
		case "none": return true;
		case "medal": 
				if (Medals.getState(Settings.engineSettings.data.selectedMod, character.unlock)) 
				{
					trace("HAS MEDAL");
					return true;
				}
				else return false;
		default: return false;
	}
}

function UpdateDebugInfo()
{
	if (debugTitle)
	{
		var FlippyXInfo:Int = FlippyDance.x - titleCharPosX;
		var FlippyYInfo:Int = FlippyDance.y - titleCharPosY;
		if (debugMode == 1)
		{
			DebugText.text = "ANIMATION DEBUG MODE\ncurAnim: " + FlippyDance.animation.name + "\nTemp Offset X: " + FlippyXInfo + " | Temp Offset Y: " + FlippyYInfo + "\nScale X: " + charScaleTemp[0] + " | Scale Y: " + charScaleTemp[1];
		}
		else
		{
			if (DebugText != null) DebugText.text = "curAnim: " + FlippyDance.animation.name + "\nOffset X: " + FlippyXInfo + " | Offset Y: " + FlippyYInfo;
		}
	}
}

function PlayAnimFromList(up)
{
	switch (debugAnim)
	{
		case 0: if (!up) { debugAnim = 4; } else { debugAnim++; }
		case 4: if (up) { debugAnim = 0; } else { debugAnim--; }
		default: if (up) { debugAnim++; } else { debugAnim--; }
	}
	
	FlippyDance.animation.play(animList[debugAnim], true);
	OffsetHim();
}

function SaveTitleCharJSON()
{
	var saveData;
	
	switch (titleChar.spriteSource)
	{
		case "character":
			saveData = {
			animOffsets:
			{
				right:[animOffsetTempX[4], animOffsetTempY[4]],
				up:   [animOffsetTempX[3], animOffsetTempY[3]],
				down: [animOffsetTempX[2], animOffsetTempY[2]],
				left: [animOffsetTempX[1], animOffsetTempY[1]],
				idle: [animOffsetTempX[0], animOffsetTempY[0]]
			},
			scale: [charScaleTemp[0], charScaleTemp[1]],
			spriteSheet: titleChar.spriteSheet,
			spriteSource: titleChar.spriteSource,
			spriteType: titleChar.spriteType,
			type: titleChar.type,
			name: titleChar.name
		}
		case "folder":
		case "other":
			saveData = {
			animOffsets:
			{
				right:[animOffsetTempX[4], animOffsetTempY[4]],
				up:   [animOffsetTempX[3], animOffsetTempY[3]],
				down: [animOffsetTempX[2], animOffsetTempY[2]],
				left: [animOffsetTempX[1], animOffsetTempY[1]],
				idle: [animOffsetTempX[0], animOffsetTempY[0]]
			},
			name: titleChar.name,
			scale: [charScaleTemp[0], charScaleTemp[1]],
			spriteSheet: titleChar.spriteSheet,
			spriteSource: titleChar.spriteSource,
			spriteType: titleChar.spriteType,
			type: titleChar.type,
			animXML: titleChar.animXML
		}
	}

	trace(saveData);
	if (!FileSystem.exists(Paths.getLibraryPath("titlechars/export", "mods/VS Flippy Flipped Out")))
		FileSystem.createDirectory(Paths.getModsPath() + "/VS Flippy Flipped Out/titlechars/export");
	File.saveContent(Paths.getModsPath() + "/VS Flippy Flipped Out/titlechars" + (saveToExport ? "/export/" : "/") + titleChar.name + ".json", Json.stringify(saveData));
	
	CoolUtil.playMenuSFX(1);
}

function SetupCharacter(character)
{
	trace(character);
	titleChar = Json.parse(Assets.getText(Paths.file("titlechars/" + character + ".json", "TEXT", "mods/VS Flippy Flipped Out")));
	trace(titleChar);
	
	var FLIPPY;
	
	if (titleChar.spriteSource != null && titleChar.spriteSheet != null)
	{
		switch (titleChar.spriteSource)
		{
			case "character": FLIPPY = Paths.getCharacter("VS Flippy Flipped Out:" + titleChar.spriteSheet);
			case "folder": FLIPPY = Paths.getSparrowAtlas("titlechars/" + titleChar.spriteSheet, "mods/VS Flippy Flipped Out", true);
			case "other": FLIPPY = Paths.getSparrowAtlas(titleChar.spriteSheet, "mods/VS Flippy Flipped Out", true);
		}
	}
	else
	{
		trace("Can't make title character. There's either no type of source or the name of spritesheet!");
	}
	
	if (titleChar.spriteSource == "character") var charJSON = Json.parse(Assets.getText(Paths.file("characters/" + character + "/Character.json", "TEXT", Settings.engineSettings.data.selectedMod)));
	
	var loopDance:Bool;
	
	if (titleChar.spriteSource == "character")
		loopDance = FindIdleLoop(charJSON.anims);
	if (titleChar.idleLooped != null)
		loopDance = titleChar.idleLooped;
	else
		loopDance = false;
	
	if (debugTitle)
	{
		var oldGhostVisible = (FlippyGhost != null ? FlippyGhost.visible : false);
		if (FlippyGhost != null) FlippyGhost.destroy(true);
		FlippyGhost = new FlxSprite(titleCharPosX + titleChar.animOffsets.idle[0], titleCharPosY + titleChar.animOffsets.idle[1]);
		FlippyGhost.frames = FLIPPY;
		if (titleChar.spriteSource == "character")
		{	
			FlippyGhost.animation.addByPrefix('idle', FindAnimXML(charJSON.anims, "idle"), 24, loopDance ? true : false);
			FlippyGhost.animation.addByPrefix('left', FindAnimXML(charJSON.anims, "singLEFT"), 24, false);
			FlippyGhost.animation.addByPrefix('down', FindAnimXML(charJSON.anims, "singDOWN"), 24, false);
			FlippyGhost.animation.addByPrefix('up', FindAnimXML(charJSON.anims, "singUP"), 24, false);
			FlippyGhost.animation.addByPrefix('right', FindAnimXML(charJSON.anims, "singRIGHT"), 24, false);
		}
		else
		{
			FlippyGhost.animation.addByPrefix('idle', titleChar.animXML.idle, 24, loopDance ? true : false);
			FlippyGhost.animation.addByPrefix('left', titleChar.animXML.left, 24, false);
			FlippyGhost.animation.addByPrefix('down', titleChar.animXML.down, 24, false);
			FlippyGhost.animation.addByPrefix('up', titleChar.animXML.up, 24, false);
			FlippyGhost.animation.addByPrefix('right', titleChar.animXML.right, 24, false);
		}
		FlippyGhost.animation.play('idle');
		FlippyGhost.antialiasing = true;
		FlippyGhost.scale.x = titleChar.scale[0];
		FlippyGhost.scale.y = titleChar.scale[1];
		FlippyGhost.alpha = 0.5;
		add(FlippyGhost);
		FlippyGhost.visible = oldGhostVisible;

		charScaleTemp = [titleChar.scale[0], titleChar.scale[1]];
		
		switch (titleChar.type)
		{
			case "idle":
				animOffsetTempX = [titleChar.animOffsets.idle[0]];
				animOffsetTempY = [titleChar.animOffsets.idle[1]];
			case "interactable":
				animOffsetTempX = [titleChar.animOffsets.idle[0], titleChar.animOffsets.left[0], titleChar.animOffsets.down[0], titleChar.animOffsets.up[0], titleChar.animOffsets.right[0]];
				animOffsetTempY = [titleChar.animOffsets.idle[1], titleChar.animOffsets.left[1], titleChar.animOffsets.down[1], titleChar.animOffsets.up[1], titleChar.animOffsets.right[1]];
			case "special":
				animOffsetTempX = [titleChar.animOffsets.idle[0], titleChar.animOffsets.left[0], titleChar.animOffsets.down[0], titleChar.animOffsets.up[0], titleChar.animOffsets.right[0], titleChar.animOffsets.hey[0]];
				animOffsetTempY = [titleChar.animOffsets.idle[1], titleChar.animOffsets.left[1], titleChar.animOffsets.down[1], titleChar.animOffsets.up[1], titleChar.animOffsets.right[1], titleChar.animOffsets.hey[1]];
		}
	}
	
	if (FlippyDance != null) FlippyDance.destroy(true);
    FlippyDance = new FlxSprite(titleCharPosX, titleCharPosY);
    FlippyDance.frames = FLIPPY;
	if (titleChar.spriteSource == "character")
	{
		FlippyDance.animation.addByPrefix('idle', FindAnimXML(charJSON.anims, "idle"), 24, loopDance ? true : false);
		FlippyDance.animation.addByPrefix('left', FindAnimXML(charJSON.anims, "singLEFT"), 24, false);
		FlippyDance.animation.addByPrefix('down', FindAnimXML(charJSON.anims, "singDOWN"), 24, false);
		FlippyDance.animation.addByPrefix('up', FindAnimXML(charJSON.anims, "singUP"), 24, false);
		FlippyDance.animation.addByPrefix('right', FindAnimXML(charJSON.anims, "singRIGHT"), 24, false);
	}
	else
	{
		FlippyDance.animation.addByPrefix('idle', titleChar.animXML.idle, 24, loopDance ? true : false);
		FlippyDance.animation.addByPrefix('left', titleChar.animXML.left, 24, false);
		FlippyDance.animation.addByPrefix('down', titleChar.animXML.down, 24, false);
		FlippyDance.animation.addByPrefix('up', titleChar.animXML.up, 24, false);
		FlippyDance.animation.addByPrefix('right', titleChar.animXML.right, 24, false);
	}
    FlippyDance.animation.play('idle');
    FlippyDance.antialiasing = true;
	FlippyDance.scale.x = titleChar.scale[0];
	FlippyDance.scale.y = titleChar.scale[1];
    add(FlippyDance);
	
	OffsetHim();
	UpdateDebugInfo();
}

function FindAnimXML(animsArray, animToFind)
{
	for (i in animsArray)
	{
		trace(i.name);
		if (i.name == animToFind) 
		{
			return i.anim;
			break;
		}
	}
}

function FindIdleLoop(animsArray)
{
	for (i in animsArray)
	{
		trace(i.name);
		if (i.name == "idle") 
		{
			return i.loop;
			break;
		}
	}
}

function ToggleDebugMode()
{
	debugMode = debugMode ? 0 : 1; 
	if (debugMode) trace("Press ARROWS to change position and W and S to change animation. F10 to refresh and F12 to save");
	
	if (lastHit > 0) lastHit = 0;	
	FlippyDance.scale.set(titleChar.scale[0], titleChar.scale[1]);
	FlippyGhost.visible = debugMode ? true : false;
	
	if (debugMode)
	{
		charNameInputField = new FlxUIInputText(1000, 50, 100, "char name");
		add(charNameInputField);
		charChangeButton = new FlxUIButton(1120, 47, "Change Character", function() SetupCharacter(charNameInputField.text));
		charChangeButton.resize(100,20);
		charChangeButton.updateHitbox();
		add(charChangeButton);
		ghostChangeButton = new FlxUIButton(1120, 87, "Set as Ghost Character", function()
		{
			FlippyGhost.setPosition(FlippyDance.x, FlippyDance.y);
			FlippyGhost.scale.set(FlippyDance.scale.x, FlippyDance.scale.y);
			FlippyGhost.animation.play(FlippyDance.animation.curAnim.name);
		});
		ghostChangeButton.resize(100,20);
		ghostChangeButton.updateHitbox();
		add(ghostChangeButton);
		overrideCheck = new FlxUICheckBox(1120, 150, null, null, "Save to export folder?", 100, null, function() saveToExport = overrideCheck.checked);
		overrideCheck.checked = saveToExport;
		add(overrideCheck);
		overrideCheck.textIsClickable = true;
	}
	else
	{
		charNameInputField.destroy(true);
		charChangeButton.destroy(true);
		ghostChangeButton.destroy(true);
		overrideCheck.destroy(true);
	}
	
	UpdateDebugInfo();
}