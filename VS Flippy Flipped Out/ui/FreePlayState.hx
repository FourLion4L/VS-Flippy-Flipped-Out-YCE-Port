import FreeplayState;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxSave;
import ModSupport;
import Settings;
import StringTools;

var isStateChanging:Bool = false;
var freeplayJSON;

var charAppearTween:FlxTween;

var preloadGraph = [];

var gameplayModifierStuff:Array = [];
var gameplayModifierValues:Array<Int> = [1, 1]; //mechanics, modchart
var gameplayModStuffStartPosY:Array<Int> = [];
var selectedGameMod:Int = 0;
var curSelectedMod:Int = 0;
var gameModShowTweens:Array<FlxTween> = [];

var modfuck = false;

function create()
{
	freeplayJSON = Json.parse(Assets.getText(Paths.json("freeplaySonglist")));
	
	for (char in 0...freeplayJSON.songs.length-1)
	{
		preloadGraph.push(GetTheme(freeplayJSON.songs[char].theme, true));
		preloadGraph.push(GetTheme(freeplayJSON.songs[char].theme, false));
	}

	MenuSide = new FlxSprite(0, 0).loadGraphic(Paths.image("freeplay/menuSide"));
	MenuSide.antialiasing = true;
	
	var gameModificators:FlxSave = new FlxSave();
	gameModificators.bind("GameModificators");
	gameplayModifierValues[0] = gameModificators.data.mechanics;
	gameplayModifierValues[1] = gameModificators.data.modchart;
}

function createPost()
{
	state.remove(bg);
	state.insert(0, BackGround);
	state.insert(1, ForeGround);
	state.insert(2, MenuSide);
	
	for (m in state.members)
	{
		if (Std.is(m, FlxText) && StringTools.startsWith(m.text, "[Space]"))
		{
            m.text = "[Space] Listen to selected song | [Shift] Change gameplay modifiers | Selected Mod: " + ModSupport.getModName(Settings.engineSettings.data.selectedMod) + " - Press [Tab] to switch.";
		}
	}
	
	var gameModBG:FlxSprite = new FlxSprite(state.scoreText.x - 326, 0).makeGraphic(Std.int(FlxG.width * 0.25), 99, 0xFF000000, true);
	gameModBG.alpha = 0.6;
	add(gameModBG);
	gameplayModifierStuff.push(gameModBG);
	gameplayModStuffStartPosY.push(gameModBG.y);
	
	var modTextInfo:FlxText = new FlxText(580, 70, FlxG.width, "[Shift] to close", 20, true);
	modTextInfo.setFormat(Paths.font("vcr.ttf"), 20, 0xFFFFFFFF, "right");
	modTextInfo.alignment = "left";
	add(modTextInfo);
	gameplayModifierStuff.push(modTextInfo);
	gameplayModStuffStartPosY.push(modTextInfo.y);
	
	var modText1:FlxText = new FlxText(600, 10, FlxG.width, "Mechanics: " + (gameplayModifierValues[0] ? "Yes" : "No"), 30, true);
	modText1.setFormat(Paths.font("vcr.ttf"), 30, 0xFFFFFFFF, "right");
	modText1.alignment = "left";
	add(modText1);
	gameplayModifierStuff.push(modText1);
	gameplayModStuffStartPosY.push(modText1.y);
	
	var modText2:FlxText = new FlxText(600, 40, FlxG.width, "Modchart: " + (gameplayModifierValues[1] ? "Yes" : "No"), 30, true);
	modText2.setFormat(Paths.font("vcr.ttf"), 30, 0xFFFFFFFF, "right");
	modText2.alignment = "left";
	add(modText2);
	gameplayModifierStuff.push(modText2);
	gameplayModStuffStartPosY.push(modText2.y);
	
	for (cum in gameplayModifierStuff)
		cum.y -= 200;
		
	var t1 = new FlxTween();
	gameModShowTweens.push(t1);
	var t2 = new FlxTween();
	gameModShowTweens.push(t2);
	var t3 = new FlxTween();
	gameModShowTweens.push(t3);
	
	for (i in preloadGraph)  // no lag when scrolling bruh
	{
		var PreloadSprite = new FlxSprite(0, 0).loadGraphic(i);
		add(PreloadSprite);
		remove(PreloadSprite);
	}
}

function updatePost(elapsed)
{
	if (FlxG.keys.justPressed.SHIFT)
	{
		modfuck = !modfuck;
	
		for (cum in 0...gameplayModifierStuff.length)
		{
			trace(gameModShowTweens[cum]);
			if (gameModShowTweens[cum] != null) gameModShowTweens[cum].cancel();
			if (modfuck)
			{
				gameModShowTweens[cum] = FlxTween.tween(gameplayModifierStuff[cum], {y: gameplayModStuffStartPosY[cum]}, 1, {ease: FlxEase.elasticOut});
			}
			else
			{
				gameModShowTweens[cum] = FlxTween.tween(gameplayModifierStuff[cum], {y: gameplayModStuffStartPosY[cum]-200}, 0.2, {ease: FlxEase.linear});
			}
		}
		
		for (dick in gameplayModifierStuff)
		{
			dick.alpha = 0.6;
		}
		gameplayModifierStuff[2+curSelectedMod].alpha = 1.0;
		gameplayModifierStuff[1].alpha = 1.0;
	}

	for (icon in 0...state.iconArray.length)
	{
		if (isStateChanging)
		{
			if (icon == state.curSelected)
				if (state.curSelected == 3)
					state.iconArray[icon].animation.curAnim.curFrame = 1;
				else
					state.iconArray[icon].animation.curAnim.curFrame = 2;
			else
				state.iconArray[icon].animation.curAnim.curFrame = 0;
		}
		else if ((icon == state.curSelected) && state.iconBumping && (state.selectedSongInstPath == state.currentInstPath))
			if (state.curSelected == 3)
				state.iconArray[icon].animation.curAnim.curFrame = 1;
			else
				state.iconArray[icon].animation.curAnim.curFrame = 2;
		else
			state.iconArray[icon].animation.curAnim.curFrame = 0;
	}
}

function onChangeSelection(curSelected)
{
	if (modfuck)
	{
		if (curSelectedMod != 1) curSelectedMod++;
		else curSelectedMod = 0;
		for (dick in gameplayModifierStuff)	dick.alpha = 0.6;
		gameplayModifierStuff[2+curSelectedMod].alpha = 1.0;
		gameplayModifierStuff[1].alpha = 1.0;
		
		return false;
	}
}

function onChangeSelectionPost(curS)
{
	var bgPath = GetTheme(freeplayJSON.songs[curS].theme, true);
	var fgPath = GetTheme(freeplayJSON.songs[curS].theme, false);
	
	state.remove(state.members[0]);
	state.remove(state.members[1]);
	
	BackGround = new FlxSprite(0, 0).loadGraphic(bgPath);
	BackGround.antialiasing = true;
	
	ForeGround = new FlxSprite(0, 0).loadGraphic(fgPath);
	ForeGround.antialiasing = true;
	
	state.insert(0, BackGround);
	state.insert(1, ForeGround);
	
	if (charAppearTween != null)
		charAppearTween.cancel();
		
	ForeGround.y = 100;
	charAppearTween = FlxTween.tween(ForeGround, {y: 0}, 0.2, {ease: FlxEase.cubeOut});
}

function GetTheme(theme, bg)
{
	if (theme != null)
	{
		if (bg)
		{
			return Paths.image("freeplay/fallen-soldier/" + theme + "-bg");
		}
		else
		{
			return Paths.image("freeplay/fallen-soldier/" + theme + "-fg");
		}
	}
	else
	{
		if (bg)
		{
			return Paths.image("freeplay/fallen-soldier/og-bg");
		}
		else
		{
			return Paths.image("freeplay/fallen-soldier/og-fg");
		}
	}
}

function onSongPlay()
{
	if (modfuck)
	{
		gameplayModifierValues[curSelectedMod] = !gameplayModifierValues[curSelectedMod];
		switch (curSelectedMod)
		{
			case 0: gameplayModifierStuff[2].text = "Mechanics: " + (gameplayModifierValues[0] ? "Yes" : "No");
			case 1: gameplayModifierStuff[3].text = "Modchart: " + (gameplayModifierValues[1] ? "Yes" : "No");
		}
		
		return false;
	}
}

function onSelect()
{
	if (modfuck)
	{
		gameplayModifierValues[curSelectedMod] = !gameplayModifierValues[curSelectedMod];
		switch (curSelectedMod)
		{
			case 0: gameplayModifierStuff[2].text = "Mechanics: " + (gameplayModifierValues[0] ? "Yes" : "No");
			case 1: gameplayModifierStuff[3].text = "Modchart: " + (gameplayModifierValues[1] ? "Yes" : "No");
		}
		
		return false;
	}
	else
	{
		var gameModificators:FlxSave = new FlxSave();
		gameModificators.bind("GameModificators");
		gameModificators.data.mechanics = gameplayModifierValues[0];
		gameModificators.data.modchart = gameplayModifierValues[1];
		gameModificators.flush();
	
		isStateChanging = true;
	}
}