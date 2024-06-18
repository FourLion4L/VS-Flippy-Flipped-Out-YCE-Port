import Settings;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.addons.text.FlxTypeText;
import flixel.util.FlxSave;
import LoadingState;
import PlayState;
import Highscore;
import Song;

var fuckingPosStuf:Bool = false;

var InputTextFieldX:FlxUIInputText;
var InputTextFieldY:FlxUIInputText;
var InputTextFieldAngle:FlxUIInputText;
var ElementPosition:FlxSprite;

var offsetX:Array = [];
var offsetY:Array = [];

var offsetSideX:Array = [];
var offsetSideY:Array = [];

var MenuBG:FlxSprite = null;
var MenuBottom:FlxSprite = null;
var cancer:FlxTween;
var GameModDescTween:FlxTween;

var intendedScore:Int = 0;

var weekData;
var weekSelectSprites:Array<FlxSprite> = [];
var weekSelectTweens:Array<FlxTween> = [];
var selectedWeek:Int = 0;
var arrowfuck:Bool = false;
var gameplayModifierStuff:Array<FlxSprite> = [];
var gameplayModifierValues:Array<Int> = [0, 0, 0];  // difficulty, mechanics, modchart
var selectedGameMod:Int = 0;
var modfuck:Int = 0;

function create()
{
	if (fuckingPosStuf)
	{
		import flixel.addons.ui.FlxInputText;
		import flixel.addons.ui.FlxUIInputText;
	}

	state.mouseControls = false;
	FlxG.mouse.visible = true;
	
	GetOffset();
	GetOffsetSide();
	
	state.options.remove("toolbox");
	state.options.remove("mods");
	state.options.remove("donate");	
	
	var upArrowTween:FlxTween;
	var upArrowAlphaTween:FlxTween;
	var downArrowTween:FlxTween;
	var downArrowAlphaTween:FlxTween;
	weekSelectTweens.push(upArrowTween);
	weekSelectTweens.push(upArrowAlphaTween);
	weekSelectTweens.push(downArrowTween);
	weekSelectTweens.push(downArrowAlphaTween);
	
	var gameModificators:FlxSave = new FlxSave();
	gameModificators.bind("GameModificators");
	gameplayModifierValues[1] = gameModificators.data.mechanics;
	gameplayModifierValues[2] = gameModificators.data.modchart;
}

function createPost()
{
	//Settings.engineSettings.data.developerMode = true;

	state.autoCamPos = false;

	for (item in state.menuItems)
	{
		item.y = 550;
		item.scale.x = 0.6;
		item.scale.y = 0.6;
		item.scrollFactor.set(1.0, 1.0);
		item.autoPos = false;
	}
		
	FlxG.camera.follow(null);
	
	OffsetThem();
	FlxG.camera.scroll.x = state.menuItems.members[state.curSelected].x;
	
	MenuBG = new FlxSprite(-30,0).loadGraphic(Paths.image("mainmenu/menuBG"));
	MenuBG.antialiasing = true;
	MenuBG.scrollFactor.set(0, 0);
	MenuBG.scale.set(1.2, 1.2);
	
	MenuBottom = new FlxSprite(0,0).loadGraphic(Paths.image("mainmenu/menuBottom"));
	MenuBottom.antialiasing = true;
	MenuBottom.scrollFactor.set(0, 0);
	
	MenuFlip = new FlxSprite(0,0).loadGraphic(Paths.image("mainmenu/menuFlip"));
	MenuFlip.antialiasing = true;
	MenuFlip.scrollFactor.set(0, 0);
	
	state.replace(bg, MenuBG);
	state.replace(magenta, MenuBG);
	state.insert(5, MenuFlip);
	state.insert(6, MenuBottom);
	
	var selectAtlas = Paths.getSparrowAtlas("mainmenu/weekSelect");
	
	WeekTitle = new FlxSprite(510, 450);
	WeekTitle.frames = selectAtlas;
	WeekTitle.animation.addByPrefix("main", "main0", 24, false);
	WeekTitle.animation.addByPrefix("alt", "alt0", 24, false);
	WeekTitle.animation.addByPrefix("bonus", "bonus0", 24, false);
	WeekTitle.animation.play("main", true);
	WeekTitle.scrollFactor.set(0, 0);
	WeekTitle.antialiasing = true;
	add(WeekTitle);
	weekSelectSprites.push(WeekTitle);
	
	WeekArrowUp = new FlxSprite(580, 400);
	WeekArrowUp.frames = selectAtlas;
	WeekArrowUp.animation.addByPrefix("arrow", "uparrow", 24, false);
	WeekArrowUp.animation.addByPrefix("select", "upselect", 24, false);
	WeekArrowUp.animation.play("arrow", true);
	WeekArrowUp.scrollFactor.set(0, 0);
	WeekArrowUp.antialiasing = true;
	add(WeekArrowUp);
	weekSelectSprites.push(WeekArrowUp);
	
	WeekArrowDown = new FlxSprite(580, 400);
	WeekArrowDown.frames = selectAtlas;
	WeekArrowDown.animation.addByPrefix("arrow", "downarrow", 24, false);
	WeekArrowDown.animation.addByPrefix("select", "downselect", 24, false);
	WeekArrowDown.animation.play("arrow", true);
	WeekArrowDown.scrollFactor.set(0, 0);
	WeekArrowDown.antialiasing = true;
	WeekArrowDown.alpha = 0;
	add(WeekArrowDown);
	weekSelectSprites.push(WeekArrowDown);
	
	GameplayModBG = new FlxSprite(360, 100).makeGraphic(500, 300, 0xFF000000, false);
	GameplayModBG.alpha = 0.7;
	GameplayModBG.scrollFactor.set(0, 0);
	add(GameplayModBG);
	GameplayModBG.visible = false;
	gameplayModifierStuff.push(GameplayModBG);
	
	PersonalBestText = new FlxText(305, 100, FlxG.width, "Personal Best: 69420", 30, true);
	PersonalBestText.alignment = "center";
	add(PersonalBestText);
	PersonalBestText.visible = false;
	gameplayModifierStuff.push(PersonalBestText);
	
	DiffText = new FlxText(305, 150, FlxG.width, "Difficulty", 25, true);
	DiffText.alignment = "center";
	add(DiffText);
	DiffText.visible = false;
	gameplayModifierStuff.push(DiffText);
	
	DiffSprite = new FlxSprite(510, 200);
	if (!gameplayModifierStuff[0])
	{
		DiffSprite.frames = Paths.getSparrowAtlas("campaign_menu_UI_assets");
		DiffSprite.animation.addByPrefix("hard", "HARD", 1, false);
		DiffSprite.animation.play("hard", true);
	}
	DiffSprite.antialiasing = true;
	DiffSprite.scrollFactor.set(0,0);
	add(DiffSprite);
	DiffSprite.visible = false;
	gameplayModifierStuff.push(DiffSprite);
	
	GameModArrowLeft = new FlxSprite(400, 156);
	GameModArrowLeft.frames = selectAtlas;
	GameModArrowLeft.animation.addByPrefix("arrow", "uparrow", 24, false);
	GameModArrowLeft.animation.addByPrefix("select", "upselect", 24, false);
	GameModArrowLeft.animation.play("arrow", true);
	GameModArrowLeft.scrollFactor.set(0, 0);
	GameModArrowLeft.antialiasing = true;
	GameModArrowLeft.angle = 270;
	GameModArrowLeft.visible = false;
	add(GameModArrowLeft);
	gameplayModifierStuff.push(GameModArrowLeft); // member number 4
	
	GameModArrowRight = new FlxSprite(690, 230);
	GameModArrowRight.frames = selectAtlas;
	GameModArrowRight.animation.addByPrefix("arrow", "uparrow", 24, false);
	GameModArrowRight.animation.addByPrefix("select", "upselect", 24, false);
	GameModArrowRight.animation.play("arrow", true);
	GameModArrowRight.scrollFactor.set(0, 0);
	GameModArrowRight.antialiasing = true;
	GameModArrowRight.angle = 90;
	GameModArrowRight.visible = false;
	add(GameModArrowRight);
	gameplayModifierStuff.push(GameModArrowRight); // member number 5
	
	GameModDescText = new FlxTypeText(205, 300, FlxG.width, "", 15);
	GameModDescText.alignment = "center";
	add(GameModDescText);
	GameModDescText.start(0.01, false);
	GameModDescText.visible = false;
	gameplayModifierStuff.push(GameModDescText);
	
	GameModAgreeText1 = new AlphabetOptimized(800 - (gameplayModifierValues[2] ? 28 : 0), 320, (gameplayModifierValues[1] ? "YES" : "NO"), 5);
	GameModAgreeText1.textColor = (gameplayModifierValues[1] ? 0xFF00FF00 : 0xFFFF0000);
	GameModAgreeText1.visible = false;
	add(GameModAgreeText1);
	gameplayModifierStuff.push(GameModAgreeText1);
	
	GameModAgreeText2 = new AlphabetOptimized(1000 - (gameplayModifierValues[2] ? 28 : 0), 320, (gameplayModifierValues[2] ? "YES" : "NO"), 5);
	GameModAgreeText2.textColor = (gameplayModifierValues[2] ? 0xFF00FF00 : 0xFFFF0000);
	GameModAgreeText2.visible = false;
	add(GameModAgreeText2);
	gameplayModifierStuff.push(GameModAgreeText2);
	
	GameModDescText = new FlxTypeText(205, 300, FlxG.width, "Mechanics", 15);
	GameModDescText.alignment = "center";
	add(GameModDescText);
	GameModDescText.start(0.01, false);
	GameModDescText.visible = false;
	gameplayModifierStuff.push(GameModDescText);
	
	MechanicsWarnText = new FlxText(-20, 542, FlxG.width, "<<WARNING!! With mechanics disabled, you get only half of your song score !!WARNING>>", 20, true);
	MechanicsWarnText.color = 0xFFFF0000;
	MechanicsWarnText.alignment = "center";
	MechanicsWarnText.visible = false;
	MechanicsWarnText.scrollFactor.set(0,0);
	add(MechanicsWarnText);
	gameplayModifierStuff.push(MechanicsWarnText);
	
	versionShit.text = "VS Flippy Flipped Out! YCE Port+ [preRelease]\n" + versionShit.text;
	versionShit.y -= 20;
	
	if (fuckingPosStuf)
	{
		// add ElementPosition object here
	
		InputTextFieldX = new FlxUIInputText(1200, 0, 80, "x");
		add(InputTextFieldX);
		InputTextFieldY = new FlxUIInputText(1200, 100, 80, "y");
		add(InputTextFieldY);
		InputTextFieldAngle = new FlxUIInputText(1500, 100, 80, "angle");
		add(InputTextFieldAngle);
	}

	if (Assets.exists(Paths.getPath('weeks.json', "TEXT", 'mods/' + mod)))
	{
		var json = Json.parse(Assets.getText(Paths.getPath('weeks.json', "TEXT", 'mods/' + mod)));
		
		if (json == null) return;
		if (json.weeks == null)
		{
			LogsOverlay.error('"week" value for ' + mod + ' weeks.json is null. Skipping...');
			return;
		}
		
		weekData = json.weeks;
		//trace(json);
	}
	
	intendedScore = Highscore.getModWeekScore(Settings.engineSettings.data.selectedMod, weekData[selectedWeek].name, weekData[selectedWeek].difficulties[gameplayModifierValues[0]]);
	PersonalBestText.text = "Personal Best: " + intendedScore;
	//trace(Highscore.songScores);
}

function updatePost(elapsed)
{
	//FlxG.camera.zoom = 0.1;
	FlxG.camera.scroll.y = 0;
	
	if (!selectedSomethin)
	{
		if (FlxG.keys.justPressed.W || FlxG.keys.justPressed.UP)  // block vertical choose
		{
			changeItem(1);
			var tempFrame = state.menuItems.members[state.curSelected].animation.curAnim.curFrame;
			FlxG.sound.destroy(false);
			state.menuItems.members[state.curSelected].animation.curAnim.curFrame = tempFrame+2;
			
			if (state.curSelected == 0)
			{
				ChangeSelectedWeek(true);
			}
		}
		if (FlxG.keys.justPressed.S || FlxG.keys.justPressed.DOWN)
		{
			changeItem(-1);
			var tempFrame = state.menuItems.members[state.curSelected].animation.curAnim.curFrame;
			FlxG.sound.destroy(false);
			state.menuItems.members[state.curSelected].animation.curAnim.curFrame = tempFrame+2;
			
			if (state.curSelected == 0)
			{
				ChangeSelectedWeek(false);
			}
		}
		if (FlxG.keys.justPressed.A || FlxG.keys.justPressed.LEFT)  // include horizontal
		{
			changeItem(-1);
			CoolUtil.playMenuSFX(0);
			
			if (state.curSelected == 0)
			{
				for (i in weekSelectSprites)
					i.visible = true;
			}
			else
			{
				for (i in weekSelectSprites)
					i.visible = false;
			}
		}
		if (FlxG.keys.justPressed.D || FlxG.keys.justPressed.RIGHT)
		{
			changeItem(1);
			CoolUtil.playMenuSFX(0);
			
			if (state.curSelected == 0)
			{
				for (i in weekSelectSprites)
					i.visible = true;
			}
			else
			{
				for (i in weekSelectSprites)
					i.visible = false;
			}
		}
		
		var c = FlxControls.justPressed;
		if (c.W || c.UP || c.S || c.DOWN || c.A || c.LEFT || c.D || c.RIGHT)
		{		
			FlxG.camera.scroll.x = state.menuItems.members[state.curSelected].x;
			if (state.curSelected == 2)  state.menuItems.members[state.curSelected].offset.set(-250-offsetX[state.curSelected], offsetY[state.curSelected]);
			
			if (cancer != null)
				cancer.cancel();
			if (state.curSelected >= 3)
			{
				cancer = FlxTween.tween(MenuBG, {x: 150 - state.curSelected*30}, 0.2, {ease:FlxEase.smootherStepOut});
			}
			else
			{
				cancer = FlxTween.tween(MenuBG, {x: -30 - state.curSelected*30}, 0.2, {ease:FlxEase.smootherStepOut});
			}
			
			OffsetThem();
		}
			
		if (FlxG.keys.justPressed.F10)
		{
			GetOffset();
			GetOffsetSide();
			OffsetThem();
		}
	}
	else
	{
		if (modfuck)
		{
			var c = FlxControls.justPressed;
			if (c.W || c.UP)
			{
				switch (selectedGameMod)
				{
					case 0:
						selectedGameMod = 2;
						
						if (GameModDescTween != null) GameModDescTween.cancel();
						GameModDescTween = FlxTween.tween(gameplayModifierStuff[gameplayModifierStuff.length-2], {x: 405}, 0.2, {ease:FlxEase.elasticInOut});
						gameplayModifierStuff[gameplayModifierStuff.length-2].x = 405;
						
						gameplayModifierStuff[gameplayModifierStuff.length-2].resetText("Modchart");
						gameplayModifierStuff[gameplayModifierStuff.length-2].start(0.02, true);
						gameplayModifierStuff[gameplayModifierStuff.length-2].visible = true;
						
						gameplayModifierStuff[4].animation.play("arrow", true);
						gameplayModifierStuff[5].animation.play("arrow", true);
						if (gameplayModifierValues[selectedGameMod])
						{
							gameplayModifierStuff[4].setPosition(558, 282);
							gameplayModifierStuff[5].setPosition(730, 355);
						}
						else
						{
							gameplayModifierStuff[4].setPosition(578, 282);
							gameplayModifierStuff[5].setPosition(710, 355);
						}
					case 1:
						selectedGameMod--;
						
						if (GameModDescTween != null) GameModDescTween.cancel();
						
						gameplayModifierStuff[gameplayModifierStuff.length-2].visible = false;
						gameplayModifierStuff[gameplayModifierStuff.length-2].x = 405;
						
						gameplayModifierStuff[4].animation.play("select", true);
						gameplayModifierStuff[5].animation.play("select", true);
						gameplayModifierStuff[4].setPosition(400, 156);
						gameplayModifierStuff[5].setPosition(690, 230);
					case 2:
						selectedGameMod--;
						
						if (GameModDescTween != null) GameModDescTween.cancel();
						GameModDescTween = FlxTween.tween(gameplayModifierStuff[gameplayModifierStuff.length-2], {x: 205}, 0.2, {ease:FlxEase.elasticInOut});
						
						gameplayModifierStuff[gameplayModifierStuff.length-2].resetText("Mechanics");
						gameplayModifierStuff[gameplayModifierStuff.length-2].start(0.02, true);
						gameplayModifierStuff[gameplayModifierStuff.length-2].visible = true;
						
						gameplayModifierStuff[4].animation.play("arrow", true);
						gameplayModifierStuff[5].animation.play("arrow", true);
						if (gameplayModifierValues[selectedGameMod])
						{
							gameplayModifierStuff[4].setPosition(358, 282);
							gameplayModifierStuff[5].setPosition(530, 355);
						}
						else
						{
							gameplayModifierStuff[4].setPosition(378, 282);
							gameplayModifierStuff[5].setPosition(510, 355);
						}
				}
			}
			if (c.S || c.DOWN)
			{
				switch (selectedGameMod)
				{
					case 0:					
						selectedGameMod++;
						
						if (GameModDescTween != null) GameModDescTween.cancel();
						//GameModDescTween = FlxTween.tween(gameplayModifierStuff[gameplayModifierStuff.length-2], {x: 205}, 0.2, {ease:FlxEase.elasticInOut});
						gameplayModifierStuff[gameplayModifierStuff.length-2].x = 205;
						
						gameplayModifierStuff[gameplayModifierStuff.length-2].resetText("Mechanics");
						gameplayModifierStuff[gameplayModifierStuff.length-2].start(0.02, true);
						gameplayModifierStuff[gameplayModifierStuff.length-2].visible = true;
						
						gameplayModifierStuff[4].animation.play("arrow", true);
						gameplayModifierStuff[5].animation.play("arrow", true);
						if (gameplayModifierValues[selectedGameMod])
						{
							gameplayModifierStuff[4].setPosition(358, 282);
							gameplayModifierStuff[5].setPosition(530, 355);
						}
						else
						{
							gameplayModifierStuff[4].setPosition(378, 282);
							gameplayModifierStuff[5].setPosition(510, 355);
						}
					case 1:
						selectedGameMod++;
						
						if (GameModDescTween != null) GameModDescTween.cancel();
						GameModDescTween = FlxTween.tween(gameplayModifierStuff[gameplayModifierStuff.length-2], {x: 405}, 0.2, {ease:FlxEase.elasticInOut});
						
						gameplayModifierStuff[gameplayModifierStuff.length-2].resetText("Modchart");
						gameplayModifierStuff[gameplayModifierStuff.length-2].start(0.02, true);
						gameplayModifierStuff[gameplayModifierStuff.length-2].visible = true;
						
						gameplayModifierStuff[4].animation.play("arrow", true);
						gameplayModifierStuff[5].animation.play("arrow", true);
						if (gameplayModifierValues[selectedGameMod])
						{
							gameplayModifierStuff[4].setPosition(558, 282);
							gameplayModifierStuff[5].setPosition(730, 355);
						}
						else
						{
							gameplayModifierStuff[4].setPosition(578, 282);
							gameplayModifierStuff[5].setPosition(710, 355);
						}
					case 2:					
						selectedGameMod = 0;
						
						if (GameModDescTween != null) GameModDescTween.cancel();
						
						gameplayModifierStuff[gameplayModifierStuff.length-2].visible = false;
						gameplayModifierStuff[gameplayModifierStuff.length-2].x = 205;
						
						gameplayModifierStuff[4].animation.play("select", true);
						gameplayModifierStuff[5].animation.play("select", true);
						gameplayModifierStuff[4].setPosition(400, 156);
						gameplayModifierStuff[5].setPosition(690, 230);
				}
			}
			
			if (c.A || c.LEFT || c.D || c.RIGHT)
			{
				CoolUtil.playMenuSFX(0);
				if (selectedGameMod != 0) gameplayModifierValues[selectedGameMod] = !gameplayModifierValues[selectedGameMod];
				
				switch (selectedGameMod)
				{
					case 1:
						if (gameplayModifierValues[selectedGameMod])
						{
							gameplayModifierStuff[gameplayModifierStuff.length-4].textColor = 0xFF00FF00;
							gameplayModifierStuff[gameplayModifierStuff.length-4].text = "YES";
							gameplayModifierStuff[gameplayModifierStuff.length-4].x -= 28;
							gameplayModifierStuff[4].setPosition(358, 282);
							gameplayModifierStuff[5].setPosition(530, 355);
							gameplayModifierStuff[gameplayModifierStuff.length-1].visible = false;
						}
						else
						{
							gameplayModifierStuff[gameplayModifierStuff.length-4].textColor = 0xFFFF0000;
							gameplayModifierStuff[gameplayModifierStuff.length-4].text = "NO";
							gameplayModifierStuff[gameplayModifierStuff.length-4].x += 28;
							gameplayModifierStuff[4].setPosition(378, 282);
							gameplayModifierStuff[5].setPosition(510, 355);
							gameplayModifierStuff[gameplayModifierStuff.length-1].visible = true;
						}
					case 2:
						if (gameplayModifierValues[selectedGameMod])
						{
							gameplayModifierStuff[gameplayModifierStuff.length-3].textColor = 0xFF00FF00;
							gameplayModifierStuff[gameplayModifierStuff.length-3].text = "YES";
							gameplayModifierStuff[gameplayModifierStuff.length-3].x -= 28;
							gameplayModifierStuff[4].setPosition(558, 282);
							gameplayModifierStuff[5].setPosition(730, 355);
						}
						else
						{
							gameplayModifierStuff[gameplayModifierStuff.length-3].textColor = 0xFFFF0000;
							gameplayModifierStuff[gameplayModifierStuff.length-3].text = "NO";
							gameplayModifierStuff[gameplayModifierStuff.length-3].x += 28;
							gameplayModifierStuff[4].setPosition(578, 282);
							gameplayModifierStuff[5].setPosition(710, 355);
						}
				}
			}
		
			if (controls.BACK)  // discard story mode choose
			{
				if (modfuck != 2) DiscardStoryMode();
			}
			if (controls.ACCEPT)
			{
				modfuck = 2;
				CoolUtil.playMenuSFX(1);
				
				for (s in gameplayModifierStuff)
				{
					FlxTween.tween(s, {alpha: 0}, 1, {ease:FlxEase.linear, onComplete: function(balls) { StartStoryMode(selectedWeek, gameplayModifierStuff[0], gameplayModifierStuff[1]); }});
				}
			}
		}
	}
	
	if (FlxG.keys.justPressed.F2 && fuckingPosStuf)
	{
		ElementPosition.setPosition(InputTextFieldX.text, InputTextFieldY.text);
		ElementPosition.angle = InputTextFieldAngle.text;
	}
}
	
function OffsetThem()
{
	for (b in state.menuItems)
	{
		b.offset.set(5000, 5000);
	}

	if (state.menuItems.members[state.curSelected-1] != null)
	{
		if (state.curSelected == 2)  state.menuItems.members[state.curSelected-1].offset.set(-50-offsetSideX[state.curSelected-1], offsetSideY[state.curSelected]);
		else  state.menuItems.members[state.curSelected-1].offset.set(50-offsetSideX[state.curSelected-1], offsetSideY[state.curSelected-1]);
	}
	else
	{
		state.menuItems.members[4].offset.set(110-offsetSideX[5], -32+offsetSideY[5]);
	}
	
	state.menuItems.members[state.curSelected].offset.set(-300-offsetX[state.curSelected], offsetY[state.curSelected]);
	
	if (state.menuItems.members[state.curSelected+1] != null)
	{
		state.menuItems.members[state.curSelected+1].offset.set(-800-offsetSideX[state.curSelected+1], offsetSideY[state.curSelected+1]);
	}
	else
	{
		state.menuItems.members[0].offset.set(-750-offsetSideX[0], offsetSideY[0]);
	}
	
	if (state.curSelected == 2) state.menuItems.members[1].offset.set(10-offsetSideX[1], -25+offsetSideY[1]);
}

function GetOffset()
{
	var offsets:Array<String> = [];
	
	var file = Paths.txt("mainMenuOffset", "mods/" + Settings.engineSettings.data.selectedMod);
	
	var text = Assets.getText(file);

	if (Assets.exists(file))
	{
		var text = Assets.getText(file);
		//trace("(OFFSET)
		//" + text);
		
		for (b in text.split("\n"))
		{
			offsets.push(b.split(" "));
		}
	}
	
	var offsetsX:Array<String> = [];
	var offsetsY:Array<String> = [];
	
	for (offset in offsets)
	{
		offsetsX.push(offset[0]);
		offsetsY.push(offset[1]);
	}
	
	offsetX = offsetsX;
	offsetY = offsetsY;
}

function GetOffsetSide()
{
	var offsets:Array<String> = [];
	
	var file = Paths.txt("mainMenuOffsetSide", "mods/" + Settings.engineSettings.data.selectedMod);
	
	if (Assets.exists(file))
	{
		var text = Assets.getText(file);
		//trace("(SIDE OFFSET)
		//" + text);
		
		for (b in text.split("\n"))
		{
			offsets.push(b.split(" "));
		}
	}
	
	var offsetsX:Array<String> = [];
	var offsetsY:Array<String> = [];
	
	for (offset in offsets)
	{
		offsetsX.push(offset[0]);
		offsetsY.push(offset[1]);
	}
	
	offsetSideX = offsetsX;
	offsetSideY = offsetsY;
}

function DiscardStoryMode()
{
	for (i in gameplayModifierStuff)  i.visible = false;
	
	state.menuItems.forEach(function(spr:FlxSprite)
	{
		if (state.curSelected != spr.ID)
		{
			spr.revive();
			spr.alpha = 1;
		}
		else
		{
			spr.visible = true;
		}
	});
	
	modfuck = false;
	state.selectedSomethin = false;
	
	CoolUtil.playMenuSFX(2);
}

function onCredits() FlxG.switchState(new ModState("CustomCreditsState", mod));
function onMedals() FlxG.switchState(new ModState("CustomMedalsState", mod));

function onStoryMode()
{
	for (i in gameplayModifierStuff)  i.visible = true;
	
	if (selectedGameMod == 0)
	{
		gameplayModifierStuff[gameplayModifierStuff.length-2].visible = false;
		gameplayModifierStuff[4].animation.play("select", true);
		gameplayModifierStuff[5].animation.play("select", true);
	}
	
	if (gameplayModifierValues[1]) gameplayModifierStuff[gameplayModifierStuff.length-1].visible = false;
	else gameplayModifierStuff[gameplayModifierStuff.length-1].visible = true;
	
	modfuck = true;
}

function StartStoryMode(week, diff, ?modchart)
{
	var mod = Settings.engineSettings.data.selectedMod;
	var jsonPath = Paths.getPath('weeks.json', "TEXT", 'mods/' + mod);
	if (Assets.exists(jsonPath))
	{
		var json = Json.parse(Assets.getText(jsonPath));
		
		if (json == null) return;
		if (json.weeks == null)
		{
			LogsOverlay.error('"week" value for ' + mod + ' weeks.json is null. Skipping...');
			return;
		}
		
		weekData = json.weeks;
		//trace(json);
	}
	
	var gameModificators:FlxSave = new FlxSave();
	gameModificators.bind("GameModificators");
	
	//trace("Week name: " + weekData[week].name);
	PlayState.actualModWeek = weekData[week];
	PlayState.actualModWeek.mod = Settings.engineSettings.data.selectedMod;
	PlayState.songMod = Settings.engineSettings.data.selectedMod;
	PlayState.storyPlaylist = weekData[week].songs;
	
	//trace(Highscore.formatSong(PlayState.storyPlaylist[0].toLowerCase(), weekData[week].difficulties[gameplayModifierValues[0]]), Settings.engineSettings.data.selectedMod, PlayState.storyPlaylist[0].toLowerCase());
	PlayState._SONG = Song.loadModFromJson(Highscore.formatSong(PlayState.storyPlaylist[0].toLowerCase(), weekData[week].difficulties[gameplayModifierValues[0]]), Settings.engineSettings.data.selectedMod, PlayState.storyPlaylist[0].toLowerCase());
	PlayState._SONG.validScore = true;
	PlayState.isStoryMode = true;
	PlayState.startTime = 0;
	PlayState.jsonSongName = PlayState.storyPlaylist[0].toLowerCase();
	PlayState.storyDifficulty = weekData[week].difficulties[gameplayModifierValues[0]];
	PlayState.fromCharter = false;
	PlayState.blueballAmount = 0;
	gameModificators.data.mechanics = gameplayModifierValues[1];
	gameModificators.data.modchart = gameplayModifierValues[2];
	gameModificators.flush();
	
	LoadingState.loadAndSwitchState(new PlayState_());
}

function ChangeSelectedWeek(up)
{
	if (!arrowfuck && !selectedSomethin)
	{
		arrowfuck = true;
	
		for (t in weekSelectTweens)
		{
			if (t != null)
				t.cancel();
		}

		if (up)
		{
			if (selectedWeek < 2)
			{
				selectedWeek++;
				weekSelectSprites[1].animation.play("select", true);
			}
				
			switch (selectedWeek)
			{
				case 1:
					weekSelectTweens[0] = FlxTween.tween(weekSelectSprites[1], {x: 540}, 1, {ease: FlxEase.cubeOut, onComplete: function(what) { arrowfuck = false; 
																																				 weekSelectSprites[1].animation.play("arrow", true);
																																				}});
					weekSelectTweens[1] = FlxTween.tween(weekSelectSprites[1], {alpha: 1}, 1, {ease: FlxEase.cubeOut});
					weekSelectTweens[2] = FlxTween.tween(weekSelectSprites[2], {x: 620}, 1, {ease: FlxEase.cubeOut});
					weekSelectTweens[3] = FlxTween.tween(weekSelectSprites[2], {alpha: 1}, 1, {ease: FlxEase.cubeOut});
					weekSelectSprites[0].animation.play("alt", true);
					weekSelectSprites[0].x = 540;
				case 2:
					weekSelectTweens[0] = FlxTween.tween(weekSelectSprites[1], {x: 580}, 1, {ease: FlxEase.cubeOut, onComplete: function(what) { arrowfuck = false;
																																				 weekSelectSprites[1].animation.play("arrow", true);
																																				}});
					weekSelectTweens[1] = FlxTween.tween(weekSelectSprites[1], {alpha: 0}, 1, {ease: FlxEase.cubeOut});
					weekSelectTweens[2] = FlxTween.tween(weekSelectSprites[2], {x: 580}, 1, {ease: FlxEase.cubeOut});
					weekSelectTweens[3] = FlxTween.tween(weekSelectSprites[2], {alpha: 1}, 1, {ease: FlxEase.cubeOut});
					weekSelectSprites[0].animation.play("bonus", true);
					weekSelectSprites[0].x = 500;
			}
		}
		else
		{
			if (selectedWeek > 0)
			{
				selectedWeek--;
				weekSelectSprites[2].animation.play("select", true);
			}
				
			switch (selectedWeek)
			{
				case 0:
					weekSelectTweens[0] = FlxTween.tween(weekSelectSprites[1], {x: 580}, 1, {ease: FlxEase.cubeOut, onComplete: function(what) { arrowfuck = false; 
																																				 weekSelectSprites[2].animation.play("arrow", true);
																																				}});
					weekSelectTweens[1] = FlxTween.tween(weekSelectSprites[1], {alpha: 1}, 1, {ease: FlxEase.cubeOut});
					weekSelectTweens[2] = FlxTween.tween(weekSelectSprites[2], {x: 580}, 1, {ease: FlxEase.cubeOut});
					weekSelectTweens[3] = FlxTween.tween(weekSelectSprites[2], {alpha: 0}, 1, {ease: FlxEase.cubeOut});
					weekSelectSprites[0].animation.play("main", true);
					weekSelectSprites[0].x = 510;
				case 1:
					weekSelectTweens[0] = FlxTween.tween(weekSelectSprites[1], {x: 540}, 1, {ease: FlxEase.cubeOut, onComplete: function(what) { arrowfuck = false;
																																				 weekSelectSprites[2].animation.play("arrow", true);
																																				}});
					weekSelectTweens[1] = FlxTween.tween(weekSelectSprites[1], {alpha: 1}, 1, {ease: FlxEase.cubeOut});
					weekSelectTweens[2] = FlxTween.tween(weekSelectSprites[2], {x: 620}, 1, {ease: FlxEase.cubeOut});
					weekSelectTweens[3] = FlxTween.tween(weekSelectSprites[1], {alpha: 1}, 1, {ease: FlxEase.cubeOut});
					weekSelectSprites[0].animation.play("alt", true);
					weekSelectSprites[0].x = 540;
			}
		}
	}
	
	intendedScore = Highscore.getModWeekScore(Settings.engineSettings.data.selectedMod, weekData[selectedWeek].name, weekData[selectedWeek].difficulties[gameplayModifierValues[0]]);
	gameplayModifierStuff[1].text = "Personal Best: " + intendedScore;
}