// ЧЕ НАДО БУДЕТ СДЕЛАТЬ
// 1. КОГДА ТАЙМЕР 0 ГРАНАТА ВЗЫРВАЕТСЯ И СТАНОВИТСЯ НЕАКТИВНА  - ЗРОБЛЕНО
// 1.1. ПОСЛЕ ГРАНАТЫ ОСТАЕТСЯ СЛЕД ВЗРЫВА, КОТОРЫЙ НАДО БУДЕТ НАРИСОВАТЬ  - ЗРОБЛЕНО
// 2. КОГДА ТАЙМЕР МЕНЬШЕ 3 ТАЙМЕР КРАСНЫЙ И ГРАНАТА СТАНОВИТСЯ БОЛЬШЕ И КРАСНЕЕ  - ЗРОБЛЕНО
// 3. СДЕЛАТЬ ДЛЯ КАЖДОГО СЛЕДА ВЗРЫВА ЧТОБ ТАЙМЕР СОЗДАВАЛСЯ И ДЛЯ КАЖДОГО РАБОТАЛ  - ЗРОБЛЕНО
// 3P.S.: Вот примерный план: создать Array FlxTimer, каждый раз создавать новый таймер с ID+1 и пихать туда таймер с этим айди. Потом, в проверке паузы просто проходится по всему Array. Звучит легко :)
// 4. ЗАБИРАТЬ ЗДОРОВЬЕ ЕСЛИ ВЗОРВАЛОСЬ  - ЗРОБЛЕНО
// 5. ВОЗМОЖНОСТЬ РАЗМИНИРОВАТЬ  - ЗРОБЛЕНО
// 5.1. ПОСЛЕ РАЗМИНИРОВАНИЯ ВЫЛЕТАЕТ ПРОПАДАЮЩИЙ ALPHA TWEEN ТЕКСТ "Disarmed!"  - ЗРОБЛЕНО
// 5.2. ИСПРАВИТЬ БАГ КОГДА РАЗМИНИРОВАЛ ГРАНАТУ КАК ТОЛЬКО ОНА ПОЯВИЛАСЬ  - ЗРОБЛЕНО x2
// 5.2P.S.: Возможно дело в TWEEN анимации появления и её надо стопать/убирать если ещё есть когда нажал пробел
// 6. ДОБАВИТЬ BURN ГРАНАТУ  - ЗРОБЛЕНО
// 6.1. СПАВН РАНДОМНЫЙ  - ЗРОБЛЕНО
// 6.2. КРУЧЕНИЕ+ПАДЕНИЕ ГРАНАТЫ  - ЗРОБЛЕНО
// 7. ДЕАКТИВИРОВАТЬ ВСЕ ГРАНАТЫ КОГДА ИГРОК УМЕР (ИСПРАВЛЕНИЕ БАГА)  - ЗРОБЛЕНО
// 8. ДОБАВИТЬ BURN ГРАНАТУ: ЧАСТЬ 2
// 8.1. ЗВУК ПАДЕНИЯ  - ЗРОБЛЕНО
// 8.2. ЗВУК ВЗРЫВА КОГДА УПАЛА  - ЗРОБЛЕНО
// 9. ДОБАВИТЬ BURN ГРАНАТУ: ЧАСТЬ 3 (ФИНАЛ)
// 9.1. ЗАБИРАТЬ 1 ЗДОРОВЬЯ (МОЖНО УКАЗЫВАТЬ ЗДОРОВЬЕ)  - ЗРОБЛЕНО
// 9.2. ДОБАВИТЬ СПРАЙТ ВЗРЫВА С АНИМАЦИЕЙ  - ЗРОБЛЕНО
// 9.3. BOTPLAY SUPPORT  - ЗРОБЛЕНО
// 9.3P.S.: Когда включён BOTPLAY не показывать инфо, и при окончании TWEEN появления гранаты сразу обезвреживать (типа BOTPLAY style)))


import("flixel.util.FlxTimer");
import("flixel.text.FlxText");
import("flixel.text.FlxTextBorderStyle");
import("flixel.tweens.FlxTween");
import("flixel.tweens.FlxEase");
import flixel.util.FlxSave;

var TestText:FlxText;

var warningTitleText:FlxText;
var warningText:FlxText;
var warningBombEx:FlxSprite;
var warningBurnEx:FlxSprite;

var wTTTween:FlxTween;
var wTTween:FlxTween;
var wBombExTween:FlxTween;
var wBurnExTween:FlxTween;

var secCheckTimer:FlxTimer;

var firstBomb:Bool = false;
var firstBurn:Bool = false;

var diffMechanics:Int;

var bombTween1:FlxTween;
var bombTween2:FlxTween;
var bombTween3:FlxTween;
var bombTextTween1:FlxTween;
var bombTextTween2:FlxTween;
var bombTextTween3:FlxTween;
var bombTextTimerTween1:FlxTween;
var bombTextTimerTween2:FlxTween;
var bombTextTimerTween3:FlxTween;

var bombs:Array<FlxSprite> = [];
var bombActive:Array<Bool> = [false, false, false];
var bombTimer:Array<Int> = [69, 69, 69];
var bombTweens:Array<FlxTween> = [bombTween1, bombTween2, bombTween3];
var bombTextTweens:Array<FlxTween> = [bombTextTween1, bombTextTween2, bombTextTween3];
var bombTextTimerTweens:Array<FlxTween> = [bombTextTimerTween1, bombTextTimerTween2, bombTextTimerTween3];
var bombText:Array<FlxText> = [];
var bombTextTimer:Array<FlxText> = [];
var bombFadeTweenArray:Array<FlxTween> = [];
var bombDisarmedText:Array<FlxText> = [];

var burnActive:Bool = false;
var burnDamage:Float = 0.5;

var dbgTraceBombsInUse:Bool = false;  //set to true if you want to see that some grenades are in use ("Grenade number N is currently active")
var dbgTraceSpawnCase:Bool = true;  //set to true if you want to see how did or didn't bomb spawn ("BOMB SPAWN/NO FREE NADES")
var dbgTraceSpawnBombIndex:Bool = true;  //set to true if you want to see index of spawned grenade
var dbgTraceSpawnBombActive:Bool = true;  //set to true if you want to see if spawned grenade is active
var dbgTraceSpawnBombTimer:Bool = true;  //set to true if you want to see the timer of spawned grenade
var dbgTimer:Bool = true;  //set to true if you wanna see a timer on the grenades

var preloadGraph = [];

var lowestTimer:Int = 0;  // delete when done testing
var lowestTimerID:Int = 0;

function create()  // just preload stuff :)
{
	for (i in 1...4) { preloadGraph.push(Paths.image("mechanics/bomb explosion" + i)); }
	preloadGraph.push(Paths.getSparrowAtlas("mechanics/ExplosionShroom"));
	
	var gameModificators:FlxSave = new FlxSave();
	gameModificators.bind("GameModificators");
	diffMechanics = gameModificators.data.mechanics;
	trace(diffMechanics);
}

function createPost()
{
	if (diffMechanics > 0)
	{
		warningTitleText = new FlxText(0, -200, guiSize.x, "WARNING", 12, true);
		warningTitleText.setFormat(Paths.font("vcr.ttf"), 50, 0xA30000, "center", FlxTextBorderStyle.OUTLINE, 0xFF000000, true);
		warningTitleText.setBorderStyle(FlxTextBorderStyle.OUTLINE, 0xFF000000, 5, 1);
		warningTitleText.antialiasing = true;
		warningTitleText.cameras = [camHUD];
		add(warningTitleText);
		
		warningText = new FlxText(0, -100, guiSize.x, "Disarm grenade by pressing [SPACE] \nNot all nades can be disarmed...", 12, true);
		warningText.setFormat(Paths.font("vcr.ttf"), 30, 0xFFFFFF, "center", FlxTextBorderStyle.OUTLINE, 0xFF000000, true);
		warningText.setBorderStyle(FlxTextBorderStyle.OUTLINE, 0xFF000000, 2, 1);
		warningText.antialiasing = true;
		warningText.cameras = [camHUD];
		add(warningText);
		
		warningBombEx = new FlxSprite(-175, 400).loadGraphic(Paths.image("mechanics/bomb"));
		warningBombEx.scrollFactor.set();
		warningBombEx.scale.x = 0.8;
		warningBombEx.scale.y = 0.8;
		warningBombEx.antialiasing = true;
		warningBombEx.cameras = [camHUD];
		add(warningBombEx);
		
		warningBurnEx = new FlxSprite(1240, 360).loadGraphic(Paths.image("mechanics/burn"));
		warningBurnEx.scrollFactor.set();
		warningBurnEx.scale.x = 0.55;
		warningBurnEx.scale.y = 0.55;
		warningBurnEx.antialiasing = true;
		warningBurnEx.cameras = [camHUD];
		add(warningBurnEx);
		
		BurnSprite = new FlxSprite(740, -200).loadGraphic(Paths.image("mechanics/burn"));
		BurnSprite.scrollFactor.set();
		BurnSprite.scale.x = 0.55;
		BurnSprite.scale.y = 0.55;
		BurnSprite.antialiasing = true;
		BurnSprite.cameras = [camHUD];
		add(BurnSprite);
		
		BombSprite1 = new FlxSprite(170, 800).loadGraphic(Paths.image("mechanics/bomb"));
		BombSprite1.scrollFactor.set();
		BombSprite1.scale.x = 0.8;
		BombSprite1.scale.y = 0.8;
		BombSprite1.antialiasing = true;
		BombSprite1.cameras = [camHUD];
		add(BombSprite1);
		
		BombSprite2 = new FlxSprite(220, 800).loadGraphic(Paths.image("mechanics/bomb"));
		BombSprite2.scrollFactor.set();
		BombSprite2.scale.x = 0.8;
		BombSprite2.scale.y = 0.8;
		BombSprite2.antialiasing = true;
		BombSprite2.cameras = [camHUD];
		add(BombSprite2);
		
		BombSprite3 = new FlxSprite(270, 800).loadGraphic(Paths.image("mechanics/bomb"));
		BombSprite3.scrollFactor.set();
		BombSprite3.scale.x = 0.8;
		BombSprite3.scale.y = 0.8;
		BombSprite3.antialiasing = true;
		BombSprite3.cameras = [camHUD];
		add(BombSprite3);
		
		BurnExplosion = new FlxSprite(0, -500);
		BurnExplosion.frames = Paths.getSparrowAtlas('mechanics/ExplosionShroom');
		BurnExplosion.animation.addByPrefix('burn', 'burn explosion shroom', 12, false);
		BurnExplosion.animation.play('burn');
		BurnExplosion.cameras = [camHUD];
		BurnExplosion.antialiasing = true;
		add(BurnExplosion);
		
		PressText1 = new FlxText(-50, 800, guiSize.x, "[SPACE]", 15, true);
		PressText1.setFormat(Paths.font("vcr.ttf"), 20, 0xFFFFFF, "center", FlxTextBorderStyle.OUTLINE, 0xFF000000, true);
		PressText1.setBorderStyle(FlxTextBorderStyle.OUTLINE, 0xFF000000, 3, 1);
		PressText1.antialiasing = true;
		PressText1.cameras = [camHUD];
		add(PressText1);
		
		PressText2 = new FlxText(0, 800, guiSize.x, "[SPACE]", 15, true);
		PressText2.setFormat(Paths.font("vcr.ttf"), 20, 0xFFFFFF, "center", FlxTextBorderStyle.OUTLINE, 0xFF000000, true);
		PressText2.setBorderStyle(FlxTextBorderStyle.OUTLINE, 0xFF000000, 3, 1);
		PressText2.antialiasing = true;
		PressText2.cameras = [camHUD];
		add(PressText2);
		
		PressText3 = new FlxText(50, 800, guiSize.x, "[SPACE]", 15, true);
		PressText3.setFormat(Paths.font("vcr.ttf"), 20, 0xFFFFFF, "center", FlxTextBorderStyle.OUTLINE, 0xFF000000, true);
		PressText3.setBorderStyle(FlxTextBorderStyle.OUTLINE, 0xFF000000, 3, 1);
		PressText3.antialiasing = true;
		PressText3.cameras = [camHUD];
		add(PressText3);
		
		if (dbgTimer)
		{
			BombTimerText1 = new FlxText(-50, 800, guiSize.x, "5", 15, true);
			BombTimerText1.setFormat(Paths.font("vcr.ttf"), 30, 0xFFFFFF, "center", FlxTextBorderStyle.OUTLINE, 0xFF000000, true);
			BombTimerText1.setBorderStyle(FlxTextBorderStyle.OUTLINE, 0xFF000000, 3, 1);
			BombTimerText1.antialiasing = true;
			BombTimerText1.cameras = [camHUD];
			add(BombTimerText1);
			
			BombTimerText2 = new FlxText(-50, 800, guiSize.x, "5", 15, true);
			BombTimerText2.setFormat(Paths.font("vcr.ttf"), 30, 0xFFFFFF, "center", FlxTextBorderStyle.OUTLINE, 0xFF000000, true);
			BombTimerText2.setBorderStyle(FlxTextBorderStyle.OUTLINE, 0xFF000000, 3, 1);
			BombTimerText2.antialiasing = true;
			BombTimerText2.cameras = [camHUD];
			add(BombTimerText2);
			
			BombTimerText3 = new FlxText(-50, 800, guiSize.x, "5", 15, true);
			BombTimerText3.setFormat(Paths.font("vcr.ttf"), 30, 0xFFFFFF, "center", FlxTextBorderStyle.OUTLINE, 0xFF000000, true);
			BombTimerText3.setBorderStyle(FlxTextBorderStyle.OUTLINE, 0xFF000000, 3, 1);
			BombTimerText3.antialiasing = true;
			BombTimerText3.cameras = [camHUD];
			add(BombTimerText3);
		}
		
		bombs.push(BombSprite1);
		bombs.push(BombSprite2);
		bombs.push(BombSprite3);
		
		bombText.push(PressText1);
		bombText.push(PressText2);
		bombText.push(PressText3);
		
		if (dbgTimer)
		{
			bombTextTimer.push(BombTimerText1);
			bombTextTimer.push(BombTimerText2);
			bombTextTimer.push(BombTimerText3);
		}
		
		TestText = new FlxText(100, 150, guiSize.x, "KYS", 12, true);
		TestText.setFormat(Paths.font("vcr.ttf"), 30, 0xFFFFFF, "left", FlxTextBorderStyle.OUTLINE, 0xFF000000, true);
		TestText.setBorderStyle(FlxTextBorderStyle.OUTLINE, 0xFF000000, 2, 1);
		TestText.antialiasing = true;
		TestText.cameras = [camHUD];
		add(TestText);
		TestText.text = "Bomb Timers: " + bombTimer;
		
		secCheckTimer = new FlxTimer().start(1, function(CHECK)
														{
															SecCheck();
														});
	}
}

function update()
{
	//camHUD.zoom = 0.3;

	if (TestText != null)
		TestText.text = "Bomb Timers: " + bombTimer + "\nBurn Y: " + BurnSprite.y;

	PauseCheck();
	
	if (FlxG.keys.justPressed.SPACE && !botplay)
	{	
		for (x in 0...bombTimer.length)
		{
			if (bombActive[x])
			{
				DefuseBomb(x);
				break;
			}
		}
	}
	
	for (i in 0...bombDisarmedText.length)
	{
		if (!paused)
		{
			bombDisarmedText[i].y -= 5;
			if (bombDisarmedText[i].alpha == 0)
			{
				bombDisarmedText[i].destroy();
				bombDisarmedText.remove(i);
			}
			else
			{
				bombDisarmedText[i].alpha -= 0.03;
			}
		}
	}
	
	if (!paused && burnActive)
	{
		if (BurnSprite.y < 800)
		{
			BurnSprite.angle += 20;
			BurnSprite.y += 40;
		}
		else
		{
			if (!firstBurn) { firstBurn = true; }
		
			FlxG.sound.play(Paths.sound("boom"));

			BurnExplosion.animation.play('burn', true);
			BurnExplosion.x = BurnSprite.x - 170;  //170 is sthe offsst
			BurnExplosion.y = 385;
			
			health -= burnDamage;
			
			burnActive = false;
		}
	}
}

function DefuseBomb(bombID)
{
	bombTweens[bombID].cancel();  // tweens cancel in case if bomb has been disarmed before tween ended
	bombTextTweens[bombID].cancel();
	bombTextTimerTweens[bombID].cancel();
	
	var disarmedText = new FlxText(bombs[bombID].x-560, bombs[bombID].y+50, guiSize.x, "Disarmed!", 20, true);
	disarmedText.setFormat(Paths.font("vcr.ttf"), 20, 0xFFFFFF, "center", FlxTextBorderStyle.OUTLINE, 0xFF000000, true);
	disarmedText.setBorderStyle(FlxTextBorderStyle.OUTLINE, 0xFF000000, 2, 1);
	disarmedText.antialiasing = true;
	disarmedText.cameras = [camHUD];
	add(disarmedText);
	bombDisarmedText.push(disarmedText);

	bombs[bombID].y = 800;
	bombText[bombID].y = 800;
	bombTextTimer[bombID].y = 800;
	bombs[bombID].color = 0xFFFFFF;
	bombs[bombID].scale.x = 0.8;
	bombs[bombID].scale.y = 0.8;
	
	bombActive[bombID] = false;
	bombTimer[bombID] = 10;
	bombText[bombID].alpha = 0;
	bombTextTimer[bombID].alpha = 0;
	
	FlxG.sound.play(Paths.sound("disarmed"));
}



function Bomb(?timer:Int)
{
	switch (diffMechanics)
	{
		case 0:
			// Do nothing
		case 1:
			BombSpawn(timer);
		case 2:
			BombSpawnCrazy();
	}
}

function Burn(?damage:Float)
{
	switch (diffMechanics)
	{
		case 0:
			// Do nothing
		case 1:
			BurnSpawn(damage);
		case 2:
			BurnSpawnCrazy();
	}
}

function BombSpawn(?timer:Int)
{
	if (!firstBomb) firstBomb = true;
	
	var timerForBomb:Int = timer;
	if (timerForBomb == null)
	{
			timerForBomb = 5;
	}

	var cycles:Int = 0;
	var canSpawnBomb:Bool = false;
	var bombSpawnCase:Int = 0;
	var chosenBomb:Int = 0;
	
	for (b in 0...bombs.length)
	{
		if (bombActive[b] == false)
		{
			bombTimer[b] = timerForBomb;
			chosenBomb = b;
			bombActive[b] = true;
			
			canSpawnBomb = true;
			bombSpawnCase = 1; //We will spawn a grenade right away!
			
			break;
		}
		else
		{
			cycles++;
			if (cycles == bombs.length)
			{
				bombSpawnCase = 2; //No free grenades left.
			}
			else
			{
				if (dbgTraceBombsInUse) { trace("Grenade number " + b + " is currently active."); }
			}
		}
	}
	
	if (canSpawnBomb)
	{
		bombs[chosenBomb].x = FlxG.random.int(40, 1160);
		var bombPosY = FlxG.random.int(380, 450);
		bombTweens[chosenBomb] = FlxTween.tween(bombs[chosenBomb], {y: bombPosY}, 0.2, {ease: FlxEase.linear, onComplete: function(dicknball)
																															{
																																if (botplay)
																																{
																																	DefuseBomb(chosenBomb);
																																}
																															}});
		bombText[chosenBomb].y = 800;
		bombText[chosenBomb].x = bombs[chosenBomb].x - 565;
		bombText[chosenBomb].alpha = 1;
		bombTextTweens[chosenBomb] = FlxTween.tween(bombText[chosenBomb], {y: bombPosY}, 0.2, {ease: FlxEase.linear});
		
		bombTextTimer[chosenBomb].text = bombTimer[chosenBomb];
		bombTextTimer[chosenBomb].y = 800;
		bombTextTimer[chosenBomb].x = bombText[chosenBomb].x;
		bombTextTimer[chosenBomb].alpha = 1;
		bombTextTimerTweens[chosenBomb] = FlxTween.tween(bombTextTimer[chosenBomb], {y: bombPosY+62}, 0.2, {ease: FlxEase.linear});
	}

	switch (bombSpawnCase)
	{
		case 0: trace("BOMB DEEZ NUTS");
		case 1:
			var indexInfo:String;
			if (dbgTraceSpawnBombIndex) { indexInfo = " | Index: " + chosenBomb; } else { indexInfo = ""; }
			var activeInfo:String;
			if (dbgTraceSpawnBombActive) { activeInfo = " | Active: " + bombActive[chosenBomb]; } else {	activeInfo = ""; }
			var timerInfo:String;
			if (dbgTraceSpawnBombTimer) { timerInfo = " | Timer: " + bombTimer[chosenBomb] + " seconds"; } else { timerInfo = ""; }
			trace("BOMB SPAWN" + indexInfo + activeInfo + timerInfo);
		case 2: trace("NO BOMBS LEFT");
	}
}

function BombSpawnCrazy()
{
	trace ("BOMB SPAWN crazy~");
}

function BurnSpawn(?damage:Float)
{
	burnActive = true;
	if (damage != null)
		burnDamage = damage;
	else
		burnDamage = 0.5;
	
	BurnSprite.x = FlxG.random.int(160, 480);
	BurnSprite.y = -1000;
	
	FlxG.sound.play(Paths.sound("fall"));
}

function BurnSpawnCrazy()
{
	trace("BURN SPAWN crazy~");
}

function RefreshBombTimer()
{
	for (b in 0...bombs.length)
	{
		if (bombActive[b])
		{
			bombTimer[b]--;
			bombTextTimer[b].text = bombTimer[b];
				
			CheckBombTimer(b);
		}
	}
}

function CheckBombTimer(bombID)
{
	switch (bombTimer[bombID])
	{
		case 0:
			FlxG.sound.play(Paths.sound("boom"));
		
			var randomExplosion:Int = FlxG.random.int(1, 4);
			var BombExplosionSprite:FlxSprite = new FlxSprite(bombs[bombID].x, bombs[bombID].y).loadGraphic(Paths.image("mechanics/bomb explosion" + randomExplosion));
			switch (randomExplosion)  //offsets
			{
				case 1: BombExplosionSprite.x -= 38; BombExplosionSprite.y -= 20;
				case 2: BombExplosionSprite.x -= 30; BombExplosionSprite.y -= 25;
			}
			BombExplosionSprite.antialiasing = true;
			BombExplosionSprite.cameras = [camHUD];
			add(BombExplosionSprite);
			bombExplosionTween = FlxTween.tween(BombExplosionSprite, {alpha: 0}, 10, {ease:FlxEase.linear, onComplete: function(fuck) { BombExplosionSprite.destroy(); }});
			bombFadeTweenArray.push(bombExplosionTween);
			
			health -= 0.5;
		
			bombs[bombID].y = 800;
			bombText[bombID].y = 800;
			bombTextTimer[bombID].y = 800;
			bombs[bombID].color = 0xFFFFFF;
			bombs[bombID].scale.x = 0.8;
			bombs[bombID].scale.y = 0.8;
			
			bombActive[bombID] = false;
			bombTimer[bombID] = 10;
			bombText[bombID].alpha = 0;
			bombTextTimer[bombID].alpha = 0;
		case 1:
			FlxG.sound.play(Paths.sound("beep"));
			
			bombs[bombID].color = 0xFF0000;
			bombs[bombID].scale.x = 1;
			bombs[bombID].scale.y = 1;
		default:
			FlxG.sound.play(Paths.sound("beep"));
	}
}

function onDeath()
{
	for (fuck in 0...bombs.length)
	{
		bombActive[fuck] = false;  // well, that was simple :]
	}
}

function SecCheck()
{
	secCheckTimer.cancel();
	secCheckTimer.start(1, function(CHECK)
										{
											SecCheck();
										});
										
	RefreshBombTimer();
}

function onPsychEvent(event, v1, v2)
{
	switch (event)
	{
		case "Bomb": Bomb();
		case "Burn": Burn();
	}
}

function PauseCheck()
{
	if (paused)
	{
		//tweens
		if (wTTTween != null)
			wTTTween.active = false;
		if (wTTween != null)
			wTTween.active = false;
		if (wBombExTween != null)
			wBombExTween.active = false;
		if (wBurnExTween != null)
			wBurnExTween.active = false;
		if (firstBomb)
		{
			for (b in 0...bombTweens.length)
			{
				if (bombTweens[b] != null)
				{
					bombTweens[b].active = false;
					bombTextTweens[b].active = false;
					bombTextTimerTweens[b].active = false;
				}
			}
		}
		
		for (i in 0...bombFadeTweenArray.length)
		{
			if (!bombFadeTweenArray[i].finished)
				bombFadeTweenArray[i].active = false;
		}
		
		//timers
		if (secCheckTimer != null)
			secCheckTimer.active = false;
			
		//animation
		if (firstBurn)
		{
			if (BurnExplosion.animation != null)
				BurnExplosion.animation.paused = true;
		}
	}
	else
	{
		//tweens
		if (wTTTween != null)
			wTTTween.active = true;
		if (wTTween != null)
			wTTween.active = true;
		if (wBombExTween != null)
			wBombExTween.active = true;
		if (wBurnExTween != null)
			wBurnExTween.active = true;
		if (firstBomb)
		{
			for (b in 0...bombTweens.length)
			{	
				if (bombTweens[b] != null)
				{
					bombTweens[b].active = true;
					bombTextTweens[b].active = true;
					bombTextTimerTweens[b].active = true;
				}
			}
		}
		
		for (i in 0...bombFadeTweenArray.length)
		{
			if (!bombFadeTweenArray[i].finished)
				bombFadeTweenArray[i].active = true;
		}
		
		//timers
		if (secCheckTimer != null)
			secCheckTimer.active = true;
			
		//animation
		if (firstBurn)
		{
			if (BurnExplosion.animation != null)
				BurnExplosion.animation.paused = false;
		}
	}
}

// ONE-TIME FUNCTIONS (not used often really)
function WarningShow()
{
	if (!botplay)
	{
		if (diffMechanics == 1)
		{
			wTTTween = FlxTween.tween(warningTitleText, {y: 200}, 2, {ease: FlxEase.linear});
			wTTween = FlxTween.tween(warningText, {y: 300}, 2, {ease:FlxEase.linear});
			wBombExTween = FlxTween.tween(warningBombEx, {x: 475}, 3.5, {ease:FlxEase.backIn});
			wBurnExTween = FlxTween.tween(warningBurnEx, {x: 640}, 3.5, {ease:FlxEase.backIn});
		}
	}
}

function WarningHide()
{
	if (!botplay)
	{
		if (diffMechanics == 1)
		{
			wTTTween = FlxTween.tween(warningTitleText, {alpha: 0}, 3, {ease: FlxEase.linear});
			wTTween = FlxTween.tween(warningText, {alpha: 0}, 3, {ease:FlxEase.linear});
			wBombExTween = FlxTween.tween(warningBombEx, {alpha: 0}, 3, {ease: FlxEase.linear});
			wBurnExTween = FlxTween.tween(warningBurnEx, {alpha: 0}, 3, {ease:FlxEase.linear, onComplete: function(helloboi)
																												{
																													warningTitleText.destroy();
																													warningText.destroy();
																													warningBombEx.destroy();
																													warningBurnEx.destroy();
																												}});
		}
	}
}