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
import Medals;

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

var mechanics:Bool;

var bombSpriteGroup:FlxTypedGroup = new FlxTypedGroup();
var bombs:Array<FlxSprite> = [];
var bombTimer:Array<Int> = [];
var bombTweens:Array<FlxTween> = [];
var bombTextTweens:Array<FlxTween> = [];
var bombTextTimerTweens:Array<FlxTween> = [];
var bombText:Array<FlxText> = [];
var bombTextTimer:Array<FlxText> = [];
var bombFadeTweenArray:Array<FlxTween> = [];
var bombDisarmedText:Array<FlxText> = [];

var burnActive:Bool = false;
var burnDamage:Float = 0.5;

var dbgTraceBombsInUse:Bool = false;  //set to true if you want to see that some grenades are in use ("Grenade number N is currently active")
var dbgTraceSpawnCase:Bool = true;  //set to true if you want to see how did or didn't bomb spawn ("BOMB SPAWN/NO FREE NADES")
var dbgTraceSpawnBombIndex:Bool = true;  //set to true if you want to see index of spawned grenade
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
	PlayState.scripts.setVariable("mechanics", gameModificators.data.mechanics);
}

function createPost()
{
	if (mechanics)
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
		bombSpriteGroup.add(BurnSprite);
		
		BurnExplosion = new FlxSprite(0, -500);
		BurnExplosion.frames = Paths.getSparrowAtlas('mechanics/ExplosionShroom');
		BurnExplosion.animation.addByPrefix('burn', 'burn explosion shroom', 12, false);
		BurnExplosion.animation.play('burn');
		BurnExplosion.cameras = [camHUD];
		BurnExplosion.antialiasing = true;
		bombSpriteGroup.add(BurnExplosion);
		
		add(bombSpriteGroup);
		
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
		TestText.text = "BOMBS: " + bombs + "\nBomb Timers: " + bombTimer + "\n\nBomb Tweens: " + bombTweens + "\nBombText Tweens: " + bombTextTweens + "\nBombTextTimer Tweens: " + bombTextTimerTweens + "\n\n\nBurn Y: " + BurnSprite.y;

	PauseCheck();
	
	if (FlxG.keys.justPressed.SPACE && !botplay)
	{	
		var bombTime:Int = 10;
		var bombID:Int = -1;
	
		for (x in 0...bombTimer.length)
		{
			if (bombTimer[x] <= bombTime)
			{
				bombID = x;
				bombTime = bombTimer[x];
			}
		}
		
		if (bombID >= 0) DefuseBomb(bombID);
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
			BurnSprite.y += 40 - (elapsed * 0.3);
		}
		else
		{
			if (!firstBurn) { firstBurn = true; }
		
			FlxG.sound.play(Paths.sound("boom"));

			BurnExplosion.animation.play('burn', true);
			BurnExplosion.x = BurnSprite.x - 170;  //170 is sthe offsst
			BurnExplosion.y = 385;
			
			if (health <= burnDamage)
				Medals.unlock(mod, "Burned To The Ground");
			health -= burnDamage;
			
			burnActive = false;
		}
	}
}

function DefuseBomb(bombID)
{
	
	var disarmedText = new FlxText(bombs[bombID].x-560, bombs[bombID].y+50, guiSize.x, "Disarmed!", 20, true);
	disarmedText.setFormat(Paths.font("vcr.ttf"), 20, 0xFFFFFF, "center", FlxTextBorderStyle.OUTLINE, 0xFF000000, true);
	disarmedText.setBorderStyle(FlxTextBorderStyle.OUTLINE, 0xFF000000, 2, 1);
	disarmedText.antialiasing = true;
	disarmedText.cameras = [camHUD];
	add(disarmedText);
	bombDisarmedText.push(disarmedText);

	RemoveBomb(bombID);	
	
	FlxG.sound.play(Paths.sound("disarmed"));
}

function RemoveBomb(bombID)
{
	if (bombTweens[bombID] != null) { bombTweens[bombID].cancel(); bombTweens.remove(bombTweens[bombID]); }  // tweens cancel+removal in case if bomb has been disarmed before tween ended
	if (bombTextTweens[bombID] != null) { bombTextTweens[bombID].cancel(); bombTextTweens.remove(bombTextTweens[bombID]); }
	if (bombTextTimerTweens[bombID] != null) { bombTextTimerTweens[bombID].cancel(); bombTextTimerTweens.remove(bombTextTimerTweens[bombID]); }

	if (bombs[bombID] != null) bombs[bombID].destroy();
	bombs.remove(bombs[bombID]);
	if (bombText[bombID] != null) bombText[bombID].destroy();
	bombText.remove(bombText[bombID]);
	bombTimer.remove(bombTimer[bombID]);
	if (bombTextTimer[bombID] != null) bombTextTimer[bombID].destroy();
	bombTextTimer.remove(bombTextTimer[bombID]);
	
}

function Bomb(?timer:Int)
{
	if (mechanics) BombSpawn(timer);
}

function Burn(?damage:Float)
{
	if (mechanics) BurnSpawn(damage);
}

function BombSpawn(?timer:Int)
{
	if (!firstBomb) firstBomb = true;
	
	var timerForBomb:Int = timer;
	if (timerForBomb == null)
	{
			timerForBomb = 5;
	}
	
	BombSprite = new FlxSprite(170, 800).loadGraphic(Paths.image("mechanics/bomb"));  // HERE
	BombSprite.scrollFactor.set();
	BombSprite.scale.x = 0.8;
	BombSprite.scale.y = 0.8;
	BombSprite.antialiasing = true;
	BombSprite.cameras = [camHUD];
	bombSpriteGroup.add(BombSprite);
	bombs.push(BombSprite);
	
	PressText = new FlxText(-50, 800, guiSize.x, "[SPACE]", 15, true);
	PressText.setFormat(Paths.font("vcr.ttf"), 20, 0xFFFFFF, "center", FlxTextBorderStyle.OUTLINE, 0xFF000000, true);
	PressText.setBorderStyle(FlxTextBorderStyle.OUTLINE, 0xFF000000, 3, 1);
	PressText.antialiasing = true;
	PressText.cameras = [camHUD];
	add(PressText);
	bombText.push(PressText);
	
	bombTimer.push(timerForBomb);
	
	if (dbgTimer)
	{
		BombTimerText = new FlxText(-50, 800, guiSize.x, "5", 15, true);
		BombTimerText.setFormat(Paths.font("vcr.ttf"), 30, 0xFFFFFF, "center", FlxTextBorderStyle.OUTLINE, 0xFF000000, true);
		BombTimerText.setBorderStyle(FlxTextBorderStyle.OUTLINE, 0xFF000000, 3, 1);
		BombTimerText.antialiasing = true;
		BombTimerText.cameras = [camHUD];
		add(BombTimerText);
		bombTextTimer.push(BombTimerText);
	}
	
	var bombTween:FlxTween; bombTweens.push(bombTween);
	var bombTextTween:FlxTween; bombTextTweens.push(bombTextTween);
	var bombTextTimerTween:FlxTween; bombTextTimerTweens.push(bombTextTimerTween);

	var canSpawnBomb:Bool = false;
	var bombSpawnCase:Int = 0;
	var chosenBomb:Int = 0;
	
	chosenBomb = bombs.indexOf(BombSprite);
	bombSpawnCase = 1; //We will spawn grenade right away!

	bombs[chosenBomb].x = FlxG.random.int(40, 1160);
	var bombPosY = FlxG.random.int(380, 450);
	bombTweens[chosenBomb] = FlxTween.tween(bombs[chosenBomb], {y: bombPosY}, 0.2, {type: FlxEase.ONESHOT, ease: FlxEase.linear, onComplete: function(dicknball)
																														{
																															if (botplay)
																															{
																																DefuseBomb(chosenBomb);
																															}
																														bombTweens.remove(bombTweens[chosenBomb]);
																														}});
	bombText[chosenBomb].y = 800;
	bombText[chosenBomb].x = bombs[chosenBomb].x - 565;
	bombText[chosenBomb].alpha = 1;
	bombTextTweens[chosenBomb] = FlxTween.tween(bombText[chosenBomb], {y: bombPosY}, 0.2, {type: FlxEase.ONESHOT, ease: FlxEase.linear, onComplete: function(remove) { bombTextTweens.remove(bombTextTweens[chosenBomb]); }});
	
	bombTextTimer[chosenBomb].text = bombTimer[chosenBomb];
	bombTextTimer[chosenBomb].y = 800;
	bombTextTimer[chosenBomb].x = bombText[chosenBomb].x;
	bombTextTimer[chosenBomb].alpha = 1;
	bombTextTimerTweens[chosenBomb] = FlxTween.tween(bombTextTimer[chosenBomb], {y: bombPosY+62}, 0.2, {type: FlxEase.ONESHOT, ease: FlxEase.linear, onComplete: function(remove) { bombTextTimerTweens.remove(bombTextTimerTweens[chosenBomb]); }});

	switch (bombSpawnCase)
	{
		case 0: trace("BOMB DEEZ NUTS");
		case 1:
			var indexInfo:String;
			if (dbgTraceSpawnBombIndex) { indexInfo = " | Index: " + chosenBomb; } else { indexInfo = ""; }
			var timerInfo:String;
			if (dbgTraceSpawnBombTimer) { timerInfo = " | Timer: " + bombTimer[chosenBomb] + " seconds"; } else { timerInfo = ""; }
			trace("BOMB SPAWN" + indexInfo + timerInfo);
	}
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

function RefreshBombTimer()
{
	for (b in 0...bombs.length)
	{
		if (bombs[b] != null)
		{
			bombTimer[b]--;
			bombTextTimer[b].text = bombTimer[b];
				
			CheckBombTimer(b);
		}
	}
	
	if (bombs.length > 0)
	{
		if (bombs.length == 1 && bombTimer[0] == 0) return;
		else if (health > 0) FlxG.sound.play(Paths.sound("beep"));
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
			switch (randomExplosion)  // offsets
			{
				case 1: BombExplosionSprite.x -= 38; BombExplosionSprite.y -= 20;
				case 2: BombExplosionSprite.x -= 30; BombExplosionSprite.y -= 25;
			}
			BombExplosionSprite.antialiasing = true;
			BombExplosionSprite.cameras = [camHUD];
			bombSpriteGroup.add(BombExplosionSprite);
			bombExplosionTween = FlxTween.tween(BombExplosionSprite, {alpha: 0}, 10, {ease:FlxEase.linear, onComplete: function(fuck) { bombSpriteGroup.BombExplosionSprite.destroy(); }});
			bombFadeTweenArray.push(bombExplosionTween);
			
			health -= 0.5;
		
			RemoveBomb(bombID);
		case 1:
			bombs[bombID].color = 0xFF0000;
			bombs[bombID].scale.x = 1;
			bombs[bombID].scale.y = 1;
	}
}

function onDeath()
{
	for (fuck in 0...bombs.length)
	{
		RemoveBomb(fuck);  // well, that was simple :]
	}
}

function SecCheck()
{
	secCheckTimer.cancel();
	secCheckTimer.start(1, function(CHECK)
										{
											SecCheck();
										});
										
	if (health > 0) RefreshBombTimer();
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
		if (mechanics)
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
		if (mechanics)
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