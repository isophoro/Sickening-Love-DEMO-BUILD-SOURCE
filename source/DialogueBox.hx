package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.addons.text.FlxTypeText;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.group.FlxSpriteGroup;
import flixel.input.FlxKeyManager;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;

using StringTools;

class DialogueBox extends FlxSpriteGroup
{
	var box:FlxSprite;

	var curCharacter:String = '';
	var preText:String = '';

	var dialogue:Alphabet;
	var dialogueList:Array<String> = [];

	// SECOND DIALOGUE FOR THE PIXEL SHIT INSTEAD???
	var swagDialogue:FlxTypeText;

	var dropText:FlxText;

	public var finishThing:Void->Void;

	var portraitLeft:FlxSprite;
	var portraitRight:FlxSprite;
	var mochi:FlxSprite;
	var bf:FlxSprite;
	var gf:FlxSprite;
	var warning:FlxText;
	var gfthinks:FlxSprite;

	var handSelect:FlxSprite;
	var bgFade:FlxSprite;

	public function new(talkingRight:Bool = true, ?dialogueList:Array<String>)
	{
		super();

		switch (PlayState.SONG.song.toLowerCase())
		{
			case 'senpai':
				FlxG.sound.playMusic(Paths.music('Lunchbox'), 0);
				FlxG.sound.music.fadeIn(1, 0, 0.8);
			case 'thorns':
				FlxG.sound.playMusic(Paths.music('LunchboxScary'), 0);
				FlxG.sound.music.fadeIn(1, 0, 0.8);
		}

		bgFade = new FlxSprite(-200, -200).makeGraphic(Std.int(FlxG.width * 1.3), Std.int(FlxG.height * 1.3), 0xFFB3DFd8);
		bgFade.scrollFactor.set();
		bgFade.alpha = 0;
		add(bgFade);

		new FlxTimer().start(0.83, function(tmr:FlxTimer)
		{
			bgFade.alpha += (1 / 5) * 0.7;
			if (bgFade.alpha > 0.7)
				bgFade.alpha = 0.7;
		}, 5);

		box = new FlxSprite(-20, 365);
		
		var hasDialog = false;
		switch (PlayState.SONG.song.toLowerCase())
		{
			case 'senpai':
				hasDialog = true;
				box.frames = Paths.getSparrowAtlas('weeb/pixelUI/dialogueBox-pixel');
				box.animation.addByPrefix('normalOpen', 'Text Box Appear', 24, false);
				box.animation.addByIndices('normal', 'Text Box Appear', [4], "", 24);
			case 'first-sight':
				hasDialog = true;
				box.frames = Paths.getSparrowAtlas('dialogue/speech_bubble_talking');
				box.animation.addByPrefix('normalOpen', 'Speech Bubble Normal Open', 24, false);
				box.animation.addByIndices('normal', 'Text Box Appear', [4], "", 24);
				box.animation.addByIndices('ah', 'AHH speech bubble', [4], "", 24);
			case 'roses':
				hasDialog = true;
				FlxG.sound.play(Paths.sound('ANGRY_TEXT_BOX'));

				box.frames = Paths.getSparrowAtlas('weeb/pixelUI/dialogueBox-senpaiMad');
				box.animation.addByPrefix('normalOpen', 'SENPAI ANGRY IMPACT SPEECH', 24, false);
				box.animation.addByIndices('normal', 'SENPAI ANGRY IMPACT SPEECH', [4], "", 24);

			case 'thorns':
				hasDialog = true;
				box.frames = Paths.getSparrowAtlas('weeb/pixelUI/dialogueBox-evil');
				box.animation.addByPrefix('normalOpen', 'Spirit Textbox spawn', 24, false);
				box.animation.addByIndices('normal', 'Spirit Textbox spawn', [11], "", 24);

				var face:FlxSprite = new FlxSprite(320, 170).loadGraphic(Paths.image('weeb/spiritFaceForward'));
				face.setGraphicSize(Std.int(face.width * 6));
				add(face);
		}

		this.dialogueList = dialogueList;
		
		if (!hasDialog)
			return;
		
		portraitLeft = new FlxSprite(-20, 40);
		portraitLeft.frames = Paths.getSparrowAtlas('weeb/senpaiPortrait');
		portraitLeft.animation.addByPrefix('enter', 'Senpai Portrait Enter', 24, false);
		portraitLeft.setGraphicSize(Std.int(portraitLeft.width * PlayState.daPixelZoom * 0.9));
		portraitLeft.updateHitbox();
		portraitLeft.scrollFactor.set();
		add(portraitLeft);
		portraitLeft.visible = false;

		portraitRight = new FlxSprite(0, 40);
		portraitRight.frames = Paths.getSparrowAtlas('weeb/bfPortrait');
		portraitRight.animation.addByPrefix('enter', 'Boyfriend portrait enter', 24, false);
		portraitRight.setGraphicSize(Std.int(portraitRight.width * PlayState.daPixelZoom * 0.9));
		portraitRight.updateHitbox();
		portraitRight.scrollFactor.set();
		add(portraitRight);
		portraitRight.visible = false;

		mochi = new FlxSprite(68, 130);
		mochi.frames = Paths.getSparrowAtlas('dialogue/mochi');
		mochi.animation.addByPrefix('normal', 'mochi normal', 24, false);
		mochi.animation.addByPrefix('mic anim', 'mochi mic up', 24, false);
		mochi.animation.addByPrefix('mic normal', 'mochi mic in hand normal', 24, false);
		mochi.scrollFactor.set();
		add(mochi);
		mochi.visible = false;

		bf = new FlxSprite(740, 195);
		bf.frames = Paths.getSparrowAtlas('dialogue/bf');
		bf.animation.addByPrefix('normal', 'bf normal', 24, false);
		bf.animation.addByPrefix('flip off', 'bf flip off', 24, false);
		bf.animation.addByPrefix('surprised', 'bf surprised', 24, false);
		bf.scrollFactor.set();
		add(bf);
		bf.visible = false;

		gf = new FlxSprite(785, 200);
		gf.frames = Paths.getSparrowAtlas('dialogue/gf');
		gf.animation.addByPrefix('normal', 'gf normal', 24, false);
		gf.animation.addByPrefix('aww', 'gf awww', 24, false);
		gf.animation.addByPrefix('smirk', 'gf smirk', 24, false);
		gf.scrollFactor.set();
		add(gf);
		gf.visible = false;

		gfthinks = new FlxSprite(861, 82);
		gfthinks.frames = Paths.getSparrowAtlas('dialogue/gf');
		gfthinks.animation.addByPrefix('think', 'gf think', 24, false);
		gfthinks.animation.addByPrefix('poof', 'gf poof', 24, false);
		gfthinks.scrollFactor.set();
		add(gfthinks);
		gfthinks.visible = false;
		
		box.animation.play('normalOpen');
		add(box);

		box.screenCenter(X);
		portraitLeft.screenCenter(X);

		handSelect = new FlxSprite(FlxG.width * 0.9, FlxG.height * 0.9).loadGraphic(Paths.image('weeb/pixelUI/hand_textbox'));
		add(handSelect);


		if (!talkingRight)
		{
			// box.flipX = true;
		}

		dropText = new FlxText(242, 502, Std.int(FlxG.width * 0.6), "", 32);
		dropText.font = 'Pixel Arial 11 Bold';
		dropText.color = 0xFFD89494;
		add(dropText);

		swagDialogue = new FlxTypeText(240, 500, Std.int(FlxG.width * 0.6), "", 32);
		swagDialogue.font = 'Pixel Arial 11 Bold';
		swagDialogue.color = 0xFF3F2021;
		swagDialogue.sounds = [FlxG.sound.load(Paths.sound('pixelText'), 0.6)];
		add(swagDialogue);

		dialogue = new Alphabet(0, 80, "", false, true);
		// dialogue.x = 90;
		// add(dialogue);

		warning = new FlxText(0, 675, "*DIALOGUE AND DIALOGUE SPRITES ARENT FINAL EITHER LOL*");
		warning.setFormat(Paths.font('vcr.ttf'), 30, FlxColor.WHITE, CENTER, OUTLINE, FlxColor.BLACK);
		add(warning);
		warning.screenCenter(X);
		warning.alpha = 0.5;
	}

	var dialogueOpened:Bool = false;
	var dialogueStarted:Bool = false;

	override function update(elapsed:Float)
	{
		// HARD CODING CUZ IM STUPDI
		if (PlayState.SONG.song.toLowerCase() == 'roses')
			portraitLeft.visible = false;
		if (PlayState.SONG.song.toLowerCase() == 'thorns')
		{
			portraitLeft.visible = false;
			swagDialogue.color = FlxColor.WHITE;
			dropText.color = FlxColor.BLACK;
		}

		dropText.text = swagDialogue.text;

		if (box.animation.curAnim != null)
		{
			if (box.animation.curAnim.name == 'normalOpen' && box.animation.curAnim.finished)
			{
				box.animation.play('normal');
				dialogueOpened = true;
			}
		}

		if (dialogueOpened && !dialogueStarted)
		{
			startDialogue();
			dialogueStarted = true;
		}

		if (PlayerSettings.player1.controls.ACCEPT && dialogueStarted == true)
		{
			remove(dialogue);
				
			FlxG.sound.play(Paths.sound('clickText'), 0.8);

			if (dialogueList[1] == null && dialogueList[0] != null)
			{
				if (!isEnding)
				{
					isEnding = true;

					if (PlayState.SONG.song.toLowerCase() == 'senpai' || PlayState.SONG.song.toLowerCase() == 'thorns')
						FlxG.sound.music.fadeOut(2.2, 0);

					new FlxTimer().start(0.2, function(tmr:FlxTimer)
					{
						box.alpha -= 1 / 5;
						bgFade.alpha -= 1 / 5 * 0.7;
						portraitLeft.visible = false;
						portraitRight.visible = false;
						swagDialogue.alpha -= 1 / 5;
						dropText.alpha = swagDialogue.alpha;
					}, 5);

					new FlxTimer().start(1.2, function(tmr:FlxTimer)
					{
						finishThing();
						kill();
					});
				}
			}
			else
			{
				dialogueList.remove(dialogueList[0]);
				startDialogue();
			}
		}
		
		super.update(elapsed);
	}

	var isEnding:Bool = false;

	function startDialogue():Void
	{
			cleanDialog();
			// var theDialog:Alphabet = new Alphabet(0, 70, dialogueList[0], false, true);
			// dialogue = theDialog;
			// add(theDialog);

			// swagDialogue.text = ;

		var blockedCharacters:Array<String> = ['showmochi', 'poofnoise', 'auto', 'autotwo'];
		if(!blockedCharacters.contains(curCharacter))
		{
				
			swagDialogue.resetText(dialogueList[0]);
			swagDialogue.start(0.04, true);

			switch (curCharacter)
			{
				case 'dad':
					portraitRight.visible = false;
					if (!portraitLeft.visible)
					{
						portraitLeft.visible = true;
						portraitLeft.animation.play('enter');
					}
				case 'bf':
					portraitLeft.visible = false;
					if (!portraitRight.visible)
					{
						portraitRight.visible = true;
						portraitRight.animation.play('enter');
					}
				case 'mochi':
					bf.visible = false;
					gf.visible = false;
					gfthinks.visible = false;
					mochi.animation.play('normal');
					if (!mochi.visible)
					{
						box.flipX = true;
						mochi.visible = true;
						mochi.animation.play('normal');
					}
				case 'mochimic':
					bf.visible = false;
					gf.visible = false;
					gfthinks.visible = false;
					mochi.animation.play('mic anim');
					if (!mochi.visible)
					{
						box.flipX = true;
						mochi.visible = true;
						mochi.animation.play('mic anim');
					}
				case 'mochimictalk':
					bf.visible = false;
					gf.visible = false;
					gfthinks.visible = false;
					mochi.animation.play('mic normal');
					if (!mochi.visible)
					{
						box.flipX = true;
						mochi.visible = true;
						mochi.animation.play('mic normal');
					}
				case 'bfnorm':
					mochi.visible = false;
					gf.visible = false;
					gfthinks.visible = false;
					bf.animation.play('normal');
					if (!bf.visible)
					{
						box.flipX = false;
						bf.visible = true;
						bf.animation.play('normal');
					}
				case 'bfflip':
					mochi.visible = false;
					gf.visible = false;
					gfthinks.visible = false;
					bf.animation.play('flip off');
					if (!bf.visible)
					{
						box.flipX = false;
						bf.visible = true;
						bf.animation.play('flip off');
					}
				case 'bfwow':
					mochi.visible = false;
					gf.visible = false;
					gfthinks.visible = false;
					bf.animation.play('surprised');
					if (!bf.visible)
					{
						box.flipX = false;
						bf.visible = true;
						bf.animation.play('surprised');
					}
				case 'gf':
					mochi.visible = false;
					bf.visible = false;
					gfthinks.visible = false;
					gf.animation.play('normal');
					if (!gf.visible)
					{
						box.flipX = false;
						gf.visible = true;
						gf.animation.play('normal');
					}
				case 'gfaw':
					mochi.visible = false;
					bf.visible = false;
					gfthinks.visible = false;
					gf.animation.play('aww');
					if (!gf.visible)
					{
						box.flipX = false;
						gf.visible = true;
						gf.animation.play('aww');
					}
				case 'gfsmirk':
					mochi.visible = false;
					bf.visible = false;
					gfthinks.visible = false;
					gf.animation.play('smirk');
					if (!gf.visible)
					{
						box.flipX = false;
						gf.visible = true;
						gf.animation.play('smirk');
					}
				case 'gfthink':
					mochi.visible = false;
					bf.visible = false;
					gf.visible = false;
					gfthinks.animation.play('think');
					if (!gfthinks.visible)
					{
						box.flipX = false;
						gfthinks.visible = true;
						gfthinks.animation.play('think');
					}
				case 'gfpoof':
					mochi.visible = false;
					bf.visible = false;
					gf.visible = false;
					gfthinks.animation.play('poof');
					if (!gfthinks.visible)
					{
						box.flipX = false;
						gfthinks.visible = true;
						gfthinks.animation.play('poof');
					}
			}
		}
		else
		{
			switch(curCharacter.toLowerCase())
			{
				case 'showmochi':
					PlayState.dad.visible = true;
					FlxG.camera.follow(PlayState.dad, LOCKON, 0.3);
					FlxTween.tween(FlxG.camera, {zoom: 1.1}, 0.4, {ease: FlxEase.expoOut});
				case 'poofnoise':
					FlxG.sound.play(Paths.music(dialogueList[0]));
				case 'auto':
					new FlxTimer().start(0.87, autoText, 1);
				case 'autotwo':
					new FlxTimer().start(0.56, autoText, 1);
			}
			dialogueList.remove(dialogueList[0]);
			startDialogue();				
		}
	}
	function autoText(timer:FlxTimer):Void
	{
		//stole this from b3 LOL
		preText = "";
					remove(dialogue);
			
						if (dialogueList[1] == null && dialogueList[0] != null)
						{
							if (!isEnding)
							{
								isEnding = true;
								finishThing();
								kill();
							}
						}
						else
						{
							dialogueList.remove(dialogueList[0]);
							startDialogue();
						}
	}
	function cleanDialog():Void
	{
		var splitName:Array<String> = dialogueList[0].split(":");
		curCharacter = splitName[1];
		dialogueList[0] = dialogueList[0].substr(splitName[1].length + 2).trim();
	}
}
