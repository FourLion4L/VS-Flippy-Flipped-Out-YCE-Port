import flixel.text.FlxText;
import flixel.text.FlxTextBorderStyle;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxTimer;

var partNotes:Int = 5;
var notesHit:Int = 0;
var notesMissedPre:Int = 0;
var notesMissedPost:Int = 0;
var colorFactor:Int = 0;

var partSuccess:Int = 0;

var stupidConditionWorkaroundTimer:FlxTimer;
var partTextFadeTimer:FlxTimer;
var partTextFadeTween:FlxTween;

var fullpartActive:Bool = true;

var partText:FlxText;

function createPost()
{
	partText = new FlxText(0, 500, guiSize.x, "0 / 5", 12, true);
	partText.setFormat(Paths.font("vcr.ttf"), 35, 0xA30000, "center", FlxTextBorderStyle.OUTLINE, 0xFF000000, true);
	partText.screenCenter(FlxAxes.X);
	partText.setBorderStyle(FlxTextBorderStyle.OUTLINE, 0xFF000000, 2, 1);
	partText.antialiasing = true;
	partText.cameras = [camHUD];
	add(partText);
	partText.visible = false;
}

function FullPartBegin(notesToHit, colorMult)
{
	for(e in PlayState.ratings)  { e.health = 0.000; }

	if (stupidConditionWorkaroundTimer != null && !stupidConditionWorkaroundTimer.finished) stupidConditionWorkaroundTimer.cancel();
	if (partTextFadeTimer != null && !partTextFadeTimer.finished) partTextFadeTimer.cancel();
	if (partTextFadeTween != null && !partTextFadeTween.finished) partTextFadeTween.cancel();
	partText.alpha = 1;

	notesHit = 0;
	notesMissedPre = misses;
	colorFactor = colorMult;
	partNotes = notesToHit;
	fullpartActive = true;
	
	var textColor = new FlxColor();	textColor.setRGB(255, 0, 0, 255);
	partText.text = "0 / " + notesToHit;
	partText.color = textColor.get_color();
	partText.visible = true;
}

function FullPartUpdate()
{
	partText.text = notesHit + " / " + partNotes;
	var textColor = new FlxColor();	textColor.setRGB(255 - colorFactor*notesHit, 0 + colorFactor*notesHit, 0, 255);
	partText.color = textColor.get_color();
}

function FullPartEnd()
{
	for(e in PlayState.ratings)  { e.health = 0.025; }
	
	fullpartActive = false;
	
	stupidConditionWorkaroundTimer = new FlxTimer().start(0.1, function(CHECK)
	{
		FullPartFullEnd();
	});	
}

function FullPartFullEnd()
{
	notesMissedPost = misses - notesMissedPre;
	var partQuoteString:String = "you suck lol";

	if (notesMissedPost == 0)
	{
		if (partSuccess >= 2)
		{
			partQuoteString = "Too perfect...";
			partText.color = 0xFFF00200;
		}
		else if (partSuccess == 1) partQuoteString = "Excellent!";
		else partQuoteString = "Good job.";
		
		health += 0.35;
		partSuccess++;
	}
	else if (notesHit < partNotes/1.5)
	{
		switch (FlxG.random.int(0, 3))
		{
			case 0: partQuoteString = "This is so bad";
			case 1: partQuoteString = "You've messed up..";
			case 2: partQuoteString = "You're done.";
			case 3: partQuoteString = "This is the end...";
		}
		
		partSuccess = 0;
		health -= 0.2;
	}
	else
	{
		switch (FlxG.random.int(0, 1))
		{
			case 0: partQuoteString = "Not bad";
			case 1: partQuoteString = "Almost there!";
		}
		
		partSuccess = 0;
		health += 0.1;
	}
	
	partText.text = partQuoteString + (notesMissedPost > 0 ? " (" + notesMissedPost + " misses)" : "");
	
	partTextFadeTimer = new FlxTimer().start(1.0, function(SWAG)
	{
		partTextFadeTween = FlxTween.tween(partText, {alpha: 0}, 1.0, {ease: FlxEase.linear});
	});	
}

function onPlayerHit(note)
{	
	if (fullpartActive)
	{
		note.sustainHealth = 0.000;
	
		if (!note.isSustainNote) notesHit++;
		FullPartUpdate();
	}
}