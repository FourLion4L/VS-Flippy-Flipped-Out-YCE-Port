import flixel.tweens.FlxTween;
import flixel.tweens.FlxEase;
import MainMenuState;
import LoadingState;
import sys.FileSystem;
import Settings;
import Alphabet;
import StringTools;

var curSelected = 1;
var quitting:Bool = false;

var holdTime:Int = 0;

var camFollow:FlxSprite;

var moveTween:FlxTween;

var descBG:FlxSprite;
var descText:FlxText;

var grpOptions:FlxTypedGroup;
var iconArray:Array<FlxSprite> = [];
var creditsStuff:Array<String> = [];
var iconSprTracker:Array<Int> = [];
var boxSprTracker;
var iconChangeX:Array<Bool> = [];

var playingVideo:Bool = false;

function create()
{
    var bg:FlxSprite;
	var intendedColor:Int;
	var colorTween:FlxTween;
	var descBox:FlxSprite;

	bg = new FlxSprite(0, 0);
    bg.loadGraphic(Paths.image('creditBG'));
    bg.antialiasing = true;
	bg.scrollFactor.y = 0.0;
    add(bg);
	bg.screenCenter();
	
	camFollow = new FlxSprite(FlxG.width / 2, 0);
	FlxG.camera.follow(camFollow, "LOCKON", 0.2);
	
	grpOptions = new FlxTypedGroup();
	add(grpOptions);
	
	var creditsPath:String = 'credits.json';
	
	var pisspoop:Array<Array<String>> = [ //Name - Icon name - Description - Link - BG Color
			['Flipped Out Dev Team'],
			['MayC',				'mayc',				'Director, Animator, & Charter',								'',										'444444'],	
			['Johhny Redwick',		'redwick',			'Director, Artist, Charter, & Coder',							'[Video] floppy',										'444444'],	
			['Seberster',			'seb',				RandomSebDesc(),												'',										'444444'],	
			['junee',				'junee',			'Director, Musician',											'',										'444444'],	
			['PJ9D',				'pj9d',				'Coder & Charter',												'',										'444444'],	
			['Rushfox',				'rushfox',			'Coder',														'',										'444444'],	
			['GoatXND',				'xnd',				'Artist',														'',										'444444'],	
			['Regulus',				'regulus',			'Artist',														'',										'444444'],	
			['TheBoredArtist',		'bored',			'Artist & Animator',											'',										'444444'],	
			['D.J.',				'Dj',				'Animator',														'',										'444444'],	
			['Scooter',				'scooter',			'Artist',														'',										'444444'],	
			['Redsty Phoenix',		'redsty',			'Artist, Animator & Writer',									'',										'444444'],	// I hope you're okay man
			['Elemenopee',			'elemenopee',		'Artist',														'',										'444444'],	
			['Ethma Reiner',		'ethma',			'Artist & Animator',											'',										'444444'],	
			['2xSmiles',			'smile',			'Artist & Animator',											'[Sound] milk',										'444444'],	
			['StoneSteve',			'stonesteve',		'Artist & Animator',											'',										'444444'],	
			['Staletide',			'staletide',		'Artist',														'',										'444444'],	
			['ShpexBoi',			'shpexBoi',			'Artist',														'',										'444444'],	
			['EZHALT',				'ezhalt',			'Music',														'',										'444444'],	
			['GalXE',				'galXE',			'Music',														'',										'444444'],	
			['mark e',				'empty',			'Music',														'[Song] Disclosed',										'444444'],	
			['Mr_Nol',				'mrnol',			'Music',														'',										'444444'],	
			['top10awesome',		'top10awesome',		'Music',														'',										'444444'],	
			['veneso dnv',			'empty',			'Music',														'',										'444444'],	
			['canofspaghettios',	'canofspaghettios',	'Charter',														'',										'444444'],	
			['Dioma',				'dioma'				'Video Editor',													'[Sound] yippee',										'444444'],	
			['TheSpyGuy',			'spyguy',			'Emotional Support + Playtester',								'[Song] Extinction',										'444444'],	
			['Mad Man Halloween',	'madman',			'Emotional Support',											'[Sound] bruh',										'444444'],	
			['zayders',				'zayders',			'Emotional Support + Flaky lover :)',							'[Sound] bruh',										'444444'],	
			['Doug Walker',			'doug',				'Being Doug Walker',											'',										'444444'],	
			[''],
			['People who ported the mod'],
			['FourLion',			'empty',			'Ported the WHOLE MOD bruhhhhh'									'',										'444444'],
			[''],
			['Special Thanks (Port)'],
			['Shadow Mario',		'shadowmario',		"Half of the code for this state is from this guy's engine lol",'https://twitter.com/Shadow_Mario_',	'444444'],
			[''],
			['YoshiCrafter Engine'],
			['YoshiCrafter29',		'yoshicrafter29',	"Engine developer & Doge GF's n°1 fan.",						'https://twitter.com/YoshiCrafter29',	'444444'],
			['Siivkoi',				'siivkoi',			'Artist & Animator - Note Splashes & Drew the update and loading screen background (and drew this icon). Made the secret Yoshi song and is very based imo',		'https://twitter.com/SillySil220',		'B42F71'],
			['CaptainKirb',			'captainkirb',		'Helper - Made YouTube tutorials and helped me out with some stuff',		'https://twitter.com/kirb_captain',			'5E99DF'],
			['KiyuuuSama',			'kiyuusama',		"Artist - Drew the icons & the engine's logo",					'https://twitter.com/KiyuuuSama',		'5E99DF'],
			['PolybiusProxy',		'polybius',			'MP4 Video Cutscene support',									'https://twitter.com/polybiusproxy',	'5E99DF'],
			['Smokey',				'empty',			'Adobe Animate Atlas extension developer',						'https://twitter.com/Smokey_5_',		'5E99DF'],
			[''],
			['Engine Socials'],
			['Discord Server',		'empty',			'Join the official Discord Server',								'https://discord.com/invite/5tC7vf3wSK', '3E813A'],
			['Twitter Account',		'empty',			"Follow the engine's Twitter",									'https://twitter.com/FNFYoshiEngine',   '3E813A'],
			[''],
			[''],
			["Friday Night Funkin"],
			['ninjamuffin99',		'ninjamuffin99',	"Programmer of Friday Night Funkin'",							'https://twitter.com/ninja_muffin99',	'CF2D2D'],
			['PhantomArcade',		'phantomarcade',	"Animator of Friday Night Funkin'",								'https://twitter.com/PhantomArcade3K',	'FADC45'],
			['evilsk8r',			'evilsk8r',			"Artist of Friday Night Funkin'",								'https://twitter.com/evilsk8r',			'5ABD4B'],
			['kawaisprite',			'kawaii_sprite',	"Composer of Friday Night Funkin'",								'https://twitter.com/kawaisprite',		'378FC7'],
			['Tom Fulp',			'tom_fulp',			"Creator of Newgrounds and Pico",								'https://twitter.com/TomFulp',			'378FC7'],
			['Sr Pelo',				'sr_pelo',			"Creator of Skid and Pump",										'https://twitter.com/SrPelo',			'378FC7'],
			['BassetFilms',			'bassetfilms',		"Made Monster's soundtrack",									'https://twitter.com/Bassetfilms',		'378FC7']
		];
		
		for(i in pisspoop)
			creditsStuff.push(i);
		
		for (i in 0...creditsStuff.length)
		{
			var isSelectable:Bool = !unselectableCheck(i);
			var optionText:AlphabetOptimized = new AlphabetOptimized(FlxG.width / 500, 30, creditsStuff[i][0], !isSelectable);
			optionText.doOptimisationStuff = false;
			optionText.targetY = i;
			optionText.screenCenter();
			grpOptions.add(optionText);
			
			var icon:FlxSprite = new FlxSprite(optionText.x - 100, optionText.y + (optionText.height / 2) - (125 / 2));
			icon.antialiasing = true;
			var iconPath = "credits/" + creditsStuff[i][1];
			if (iconPath != null)
			{
				var tex = Paths.image(iconPath);
				if (tex != null && creditsStuff[i][1] != null && creditsStuff[i][1] != "empty")
					icon.loadGraphic(tex);
				else
					icon.visible = false;
			}
			icon.x = optionText.x - 10 - icon.width;
			if (grpOptions.length >= 36) icon.setGraphicSize(125, 125);
			icon.updateHitbox();
			iconArray.push(icon);
			add(icon);
			icon.alpha = 0.6;
			iconSprTracker[i] = optionText;
		}
		for (o in grpOptions)
		{
			if (!o.bold) 
			{
				o.alpha = 0.6;
				o.textColor = 0x00000000;
				o.x -= 250;
			}
		}
		
		descBG = new FlxSprite(0, 0).makeGraphic(Std.int(FlxG.width * 0.5), 99, 0xFF000000, true);
		descBG.screenCenter(FlxAxes.XY);
		descBG.alpha = 0.6;
		descBG.scrollFactor.set();
		add(descBG);
		
		descText = new FlxText(0, 200, 1200, creditsStuff[1][2], 30, true);
		descText.screenCenter(FlxAxes.XY);
		descText.y += 280;
		descText.scrollFactor.set();
		descText.setFormat(Paths.font("vcr.ttf"), 32, descText.color, "center", descText.borderStyle, descText.borderColor);
		add(descText);
		
		boxSprTracker = descText;
		descBG.setGraphicSize(Std.int(descText.width + 20), Std.int(descText.height + 25));
		
		UpdateFollow(69, true);
		UpdateText();
		
		PosStuff();
		
		trace(creditsStuff[3][2]);
}

function RandomSebDesc()
{
	var descriptions:Array<String> = ["He made Extinction", "He made Playdate", "TF2 Bass", "He made Starving Artist", "He made Overkill", "Hates Happy Tree Friends"];
	return descriptions[FlxG.random.int(0, descriptions.length-1)];
}

function update(elapsed:Float)
{
	if (!playingVideo)
	{
		var multiplier:Int = 1;
		
		if (FlxG.state.controls.BACK)
		{
			FlxG.switchState(new MainMenuState());
			quitting = true;
			CoolUtil.playMenuSFX(2);
		}
		
		if (controls.ACCEPT && !quitting)
		{
			if (StringTools.startsWith(creditsStuff[curSelected][3], "["))
			{
				var stuff:String = StringTools.replace(creditsStuff[curSelected][3], "[", "");
				stuff = StringTools.replace(stuff, "]", "");
				
				var callbackInfo:Array<String> = []; callbackInfo = stuff.split(" ");
				SelectCallback(callbackInfo[0], callbackInfo[1]);
			}
			else if (creditsStuff[curSelected][3] != null && creditsStuff[curSelected][3] != '') FlxG.openURL(creditsStuff[curSelected][3]);
		}
		
		if (FlxG.keys.pressed.SHIFT) multiplier = 3;
		
		var upP = controls.UP_P;
		var downP = controls.DOWN_P;
		
		if (upP)
		{
			changeSelection(-multiplier);
			holdTime = 0;
		}
		if (downP)
		{
			changeSelection(multiplier);
			holdTime = 0;
		}
		
		if(controls.DOWN || controls.UP)
		{
			var checkLastHold:Int = Math.floor((holdTime - 0.5) * 10);
			holdTime += elapsed;
			var checkNewHold:Int = Math.floor((holdTime - 0.5) * 10);

			if(holdTime > 0.5 && checkNewHold - checkLastHold > 0)
			{
				changeSelection((checkNewHold - checkLastHold) * (controls.UP ? -multiplier : multiplier));
			}
		}
		
		for (i in 0...iconArray.length)
		{
			iconArray[i].x = iconSprTracker[i].x + iconSprTracker[i].width + 10;
			iconArray[i].y = iconSprTracker[i].y - 30;
		}
		
		for (i in 0...grpOptions.length)
		{
			grpOptions.members[i].y = 30 + i * 150;
		}
		
		descBG.setPosition(boxSprTracker.x - 10, boxSprTracker.y - 10);
		
		MoveStuff(elapsed);
	}
}

function SelectCallback(callbackKey, callbackInfo)
{
	switch (callbackKey)
	{
		case "Song":
		{
			CoolUtil.loadSong(Settings.engineSettings.data.selectedMod, callbackInfo, "normal");
			LoadingState.loadAndSwitchState(new PlayState_());
		}
		case "Video": PlayVideo(callbackInfo);
		case "Sound": FlxG.sound.play(Paths.sound(callbackInfo));
	}
}

function unselectableCheck(num:Int):Bool return creditsStuff[num].length <= 1;

function changeSelection(num:Int)
{
	if (quitting || curSelected == -1 || curSelected == grpOptions.length) return;

	var oldSelected = curSelected;

	if (curSelected+num > 0 && curSelected+num < grpOptions.length) curSelected += num;
	else curSelected = (curSelected+num >= grpOptions.length-1 ? 1 : grpOptions.length-1);
	
	UpdateFollow(oldSelected);
	UpdateText();
	PosStuff();
	
	CoolUtil.playMenuSFX(0);
}

function UpdateText()
{
	descText.text = creditsStuff[curSelected][2];
	descText.y = FlxG.height - descText.height - 135;
	descBG.y = FlxG.height - descText.height - 160;
	descBG.setGraphicSize(Std.int(descText.width + 20), Std.int(descText.height + 25));
	descBG.updateHitbox();
	
	if(moveTween != null) moveTween.cancel();
	moveTween = FlxTween.tween(descText, {y : descText.y + 75}, 0.25, {ease: FlxEase.sineOut});
}

function UpdateFollow(?oldSelected, ?firstTime:Bool)
{
	if (firstTime)
	{
		camFollow.y = grpOptions.members[0].y - 150;
		grpOptions.members[curSelected].alpha = 1.0;
		iconArray[curSelected].alpha = 1.0;
		return;
	}

	if (!unselectableCheck(curSelected)) camFollow.y = grpOptions.members[curSelected].y + 50;
	else
	{
		var followDirection = (curSelected > oldSelected ? 0 : 1);
		if (followDirection)
		{
			var count:Int = curSelected-1;
			while (count >= 0)
			{
				if (!unselectableCheck(count))
				{
					curSelected = count;
					camFollow.y = grpOptions.members[count].y;
					break;
				}
				count--;
			}
		}
		else
		{
			for (i in curSelected...grpOptions.length-1)
			{
				if (!unselectableCheck(i))
				{
					curSelected = i;
					camFollow.y = grpOptions.members[i].y;
					break;
				}
			}
		}
	}
	
	if (!grpOptions.members[curSelected].bold)
	{
		grpOptions.members[curSelected].alpha = 1.0;
		iconArray[curSelected].alpha = 1.0;
	}
	if (oldSelected > -1 && !grpOptions.members[oldSelected].bold)
	{
		grpOptions.members[oldSelected].alpha = 0.6;
		iconArray[oldSelected].alpha = 0.6;
	}
}

function MoveStuff(elapsed)
{
	for (item in grpOptions.members)
	{
		if(!item.bold)
		{
			var lerpVal:Float = Math.max(0, Math.min(1, elapsed * 12));
			if(item.targetY == 0)
			{
				var lastX:Float = item.x;
				item.screenCenter(FlxAxes.X);
				item.x = FlxMath.lerp(lastX, item.x - 70, lerpVal);
			}
			else
			{
				item.x = FlxMath.lerp(item.x, 200 + -40 * Math.abs(item.targetY), lerpVal);
			}
		}
	}
}

function PosStuff()
{
	var bullShit:Int = 0;
	
	for (item in grpOptions.members)
	{
		item.targetY = bullShit - curSelected;
		bullShit++;

		if(!unselectableCheck(bullShit-1)) {
			item.alpha = 0.6;
			if (item.targetY == 0) {
				item.alpha = 1;
			}
		}
	}
}

function PlayVideo(videoName)
{
	FlxG.sound.music.volume = 0;
	FlxG.sound.music.stop();
	
	var videoSprite:FlxSprite;
	var video = new MP4Handler();

	videoSprite = new FlxSprite(0, 0);
	videoSprite.antialiasing = true;
	videoSprite.scrollFactor.set();
	videoSprite.cameras = [FlxG.camera];
	state.add(videoSprite);

	playingVideo = true;
	video.finishCallback = function()
	{
		playingVideo = false;
		FlxG.sound.music.resume();
		FlxG.sound.music.fadeIn(1, 0, 1);
		state.remove(videoSprite);
	};
	video.canvasWidth = 1280;
	video.canvasHeight = 720;
	video.fillScreen = true;
	video.skippable = false;
	video.playMP4(Assets.getPath(Paths.video(videoName)), false, videoSprite, null, null, true);
}