import ModSupport;
import Settings;
import flixel.text.FlxTextBorderStyle;
import flixel.addons.ui.FlxUIText;
import flixel.ui.FlxBar;
import flixel.util.FlxSave;
import Medals;

var bg:FlxSprite;
var medals:MedalsJSON;
var sprites:FlxTypedGroup = new FlxTypedGroup();
var curSelected:Int = 0;
var unlockedMedals:Int = 0;
var rareMedals:Int = 0;
var unlockedRareMedals:Int = 0;
var desc:FlxUIText;
var descBG:FlxSprite;
var progressBar:FlxBar;
var progressBarText:FlxText;
var progressBarPosX:Int = FlxG.width - 600;
var barTweens:Array<FlxTween> = [];
var barSlide:Bool = false;
var progressSave:FlxSave;
var medalsSave:FlxSave;

var multiple = 1;

function create()
{
	bg = CoolUtil.addBG(state);
	bg.scrollFactor.set();
	
	medalsSave = ModSupport.modSaves[Settings.engineSettings.data.selectedMod];
	progressSave = new FlxSave();
	progressSave.bind("MedalProgress");
	if (progressSave == null || progressSave.data.medalProgress == null)
	{
		trace("Medal Progress has just begun..");
		var beginning:Array<Int> = [];
		progressSave.data.medalProgress = beginning;
	}
	
	medals = ModSupport.modMedals[Settings.engineSettings.data.selectedMod];
	if (medals == null)
	{
		if (Assets.exists(Paths.file("medals.json", TEXT, 'mods/${Settings.engineSettings.data.selectedMod}')))
			ModSupport.modMedals[Settings.engineSettings.data.selectedMod] = medals = Json.parse(Assets.getText(Paths.file("medals.json", TEXT, 'mods/${Settings.engineSettings.data.selectedMod}')));
		else
			medals = ModSupport.modMedals[Settings.engineSettings.data.selectedMod] = {medals: []};
	}
	if (medals.medals == null) medals.medals = [];
	
	var e:Int = 0;
	for(k in medals.medals)
	{
		if (k.rare)
			rareMedals++;
		var mSprite = new MedalSprite(Settings.engineSettings.data.selectedMod, k);
		mSprite.y = ((Math.floor(e / multiple)) * 125) + 25;
		mSprite.title.outline = true;
		if (k.secret && mSprite.locked)
		{
			mSprite.title.outline = false;
			mSprite.title.textColor = 0xFF000000;
		}
		sprites.add(mSprite);
		if (!mSprite.locked)
		{
			if (k.rare)
				unlockedRareMedals++;
			else
				unlockedMedals++;
		}
			
		e++;
	}
	add(sprites);	

	bg = new FlxSprite(0, 0).makeGraphic(FlxG.width, 80, 0x88000000, true);
	add(bg);
	
	var title = new AlphabetOptimized(FlxG.width / 2, 17.5, "Medals", true, 0.75);
	title.x -= title.width / 2;
	add(title);
	
	progressBar = new FlxBar(progressBarPosX + 1000, FlxG.height - 75, "LEFT_TO_RIGHT", 500, 20);
	progressBar.createFilledBar(0x69000000, 0xFFAAB5B4);
	add(progressBar);
	
	progressBarText = new FlxText(progressBar.x, progressBar.y, 500, "5 / 69", 12, true);
	progressBarText.setFormat(Paths.font("vcr.ttf"), 30, 0xFFFFFF, "center", FlxTextBorderStyle.OUTLINE, 0xFF000000, true);
	progressBarText.setBorderStyle(FlxTextBorderStyle.OUTLINE, 0xFF000000, 2, 1);
	progressBarText.antialiasing = true;
	add(progressBarText);

	descBG = new FlxSprite(0, 0).makeGraphic(FlxG.width, 46, 0x76000000, true);
	add(descBG);

	desc = new FlxUIText(0, FlxG.height * 0.9, "hjghg");
	desc.setFormat(Paths.font("vcr.ttf"), 24, FlxColor.WHITE, "LEFT", FlxTextBorderStyle.OUTLINE, 0xFF000000);
	desc.antialiasing = true;
	add(desc);

	bg.scrollFactor.set();
	title.scrollFactor.set();
	desc.scrollFactor.set();
	descBG.scrollFactor.set();
	progressBar.scrollFactor.set();
	progressBarText.scrollFactor.set();
	
	var barTween1:FlxTween = new FlxTween(); barTweens.push(barTween1);
	var barTween2:FlxTween = new FlxTween(); barTweens.push(barTween2);
	
	// Hardcoded "achieved achievements amount" values
	medals.medals[medals.medals.length-1].goalValue = medals.medals.length-1;
	medals.medals[medals.medals.length-2].goalValue = rareMedals;
	
	if (unlockedMedals == medals.medals.length)
		Medals.unlock(mod, "Completionist");
	if (unlockedRareMedals == rareMedals)
		Medals.unlock(mod, "Rare Type");
}

function update(elapsed:Float)
{
	if (FlxG.state.controls.BACK)
		Back();

	var oldSelected = curSelected;
	if (controls.RIGHT_P) curSelected++;
	if (controls.LEFT_P) curSelected--;
	if (controls.DOWN_P) curSelected += multiple;
	if (controls.UP_P) curSelected -= multiple;
	curSelected = CoolUtil.wrapInt(curSelected, 0, sprites.length);
	if (curSelected != oldSelected)
	{
		CoolUtil.playMenuSFX(0);
		desc.alpha = 0;
		desc.offset.y = 25;
		
		onMedalSwitched();
	}
	var descLerpRatio = getLerpRatio(0.25);
	desc.offset.y = FlxMath.lerp(desc.offset.y, 0, descLerpRatio);
	desc.alpha = FlxMath.lerp(desc.alpha, 1, descLerpRatio);
	
	descBG.setPosition(desc.x, desc.y);
	descBG.setGraphicSize(FlxMath.lerp(descBG.width, desc.width + 10, 0.5), Std.int(desc.height + 16));
	descBG.updateHitbox();

	var l = elapsed * 0.25 * 60;

	var k:Int = 0;
	sprites.forEach(function(s) { s.y = FlxMath.lerp(s.y, -125 * (Math.floor(curSelected - k / multiple) + 0.5) + (FlxG.height / 2), l); k++; });

	k = 0;
	for(e in sprites.members)
	{
		e.alpha = FlxMath.lerp(e.alpha, (k == curSelected) ? 1 : 0.3, l);
		if (k == curSelected)
		{
			if (medals.medals[k].secret)
			{
				desc.text = Medals.getState(mod, medals.medals[k].name) ? medals.medals[k].desc : "A mystery of this medal has to be unfold...";
				desc.color = 0xFF07b8ac;
			}
			else
			{
				desc.text = medals.medals[k].desc;
				desc.color = 0xFFFFFFFF;
			}
			desc.x = e.img.x + e.img.width + 5;
			desc.y = e.img.y + (e.img.height * 0.5) + 5;
		}
		e.title.offset.y = FlxMath.lerp(e.title.offset.y, (k == curSelected) ? e.title.height / 2 + 10 : 0, descLerpRatio);
		e.x = (1 - (1 - Math.pow(Math.sin(FlxMath.bound((e.y + (e.height / 2)) / FlxG.height * Math.PI, 0, Math.PI)), 1.5))) * 75;
		k++;
	}
	
	if (FlxG.keys.justPressed.F3) { medalsSave.erase(); progressSave.erase(); }
}

function onMedalSwitched()
{
	if (medals.medals[curSelected].progress && !Medals.getState(mod, medals.medals[curSelected].name))
	{		
		if (!barSlide)
		{
			barTweens[0].cancel(); barTweens[1].cancel();
			barTweens[0] = FlxTween.tween(progressBar, {x: progressBarPosX }, 0.2, {ease: FlxEase.smoothOut});
			barTweens[1] = FlxTween.tween(progressBarText, {x: progressBarPosX}, 0.2, {ease: FlxEase.smoothOut});
			barSlide = true;
		}
		
		var medalProgress, medalProgressGoal:Int;
		medalProgressGoal = medals.medals[curSelected].goalValue;
		if (medals.medals[curSelected] == medals.medals[medals.medals.length-1])
			medalProgress = unlockedMedals;
		else if (medals.medals[curSelected] == medals.medals[medals.medals.length-2])
			medalProgress = unlockedRareMedals;
		else
			medalProgress = progressSave.data.medalProgress[medals.medals[curSelected].progressID] == null ? 0 : progressSave.data.medalProgress[medals.medals[curSelected].progressID];

		progressBarText.text = medalProgress+' / '+medalProgressGoal;
		progressBar.setRange(0, medalProgressGoal);
		progressBar.value = medalProgress;
	}
	else
	{
		if (barSlide)
		{
			barTweens[0].cancel(); barTweens[1].cancel();
			barTweens[0] = FlxTween.tween(progressBar, {x: progressBarPosX + 1000}, 1.0, {ease: FlxEase.cubeIn});
			barTweens[1] = FlxTween.tween(progressBarText, {x: progressBarPosX + 1000}, 1.0, {ease: FlxEase.cubeIn});
			barSlide = false;
		}
	}
}

function Back()
{
	sprites.remove();
	FlxG.switchState(new MainMenuState());
	CoolUtil.playMenuSFX(2);
}