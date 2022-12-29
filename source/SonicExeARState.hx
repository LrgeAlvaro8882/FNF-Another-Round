package;

#if desktop
import Discord.DiscordClient;
#end
import flash.text.TextField;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.addons.display.FlxGridOverlay;
import flixel.addons.display.FlxBackdrop;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.math.FlxMath;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import flixel.tweens.FlxTween;
import flixel.tweens.FlxEase;
#if MODS_ALLOWED
import sys.FileSystem;
import sys.io.File;
#end
import lime.utils.Assets;

using StringTools;

class SonicExeARState extends MusicBeatState
{
	var curSelected:Int = -1;

	private var grpOptions:FlxTypedGroup<Alphabet>;
	private var iconArray:Array<AttachedSprite> = [];
	private var creditsStuff:Array<Array<String>> = [];

	var bg:FlxSprite;
	var descText:FlxText;
	var intendedColor:Int;
	var colorTween:FlxTween;
	var descBox:AttachedSprite;

	var offsetThing:Float = -75;

	var checker:FlxBackdrop = new FlxBackdrop(Paths.image('End_Checker'), #if (flixel < "5.0.0") 0.2, 0.2, true, true #else XY #end);

	override function create()
	{
		#if desktop
		// Updating Discord Rich Presence
		DiscordClient.changePresence("In the Menus", null);
		#end

		persistentUpdate = true;
		bg = new FlxSprite().loadGraphic(Paths.image('menuDesat'));
		bg.scale.set(0.6, 0.6);
		add(bg);
		bg.screenCenter();

		add(checker);
		#if (flixel >= "5.0.0")
		checker.scrollFactor.set(0, 0.07);
		#end
		
		grpOptions = new FlxTypedGroup<Alphabet>();
		add(grpOptions);

		#if MODS_ALLOWED
		var path:String = 'modsList.txt';
		if(FileSystem.exists(path))
		{
			var leMods:Array<String> = CoolUtil.coolTextFile(path);
			for (i in 0...leMods.length)
			{
				if(leMods.length > 1 && leMods[0].length > 0) {
					var modSplit:Array<String> = leMods[i].split('|');
					if(!Paths.ignoreModFolders.contains(modSplit[0].toLowerCase()) && !modsAdded.contains(modSplit[0]))
					{
						if(modSplit[1] == '1')
							pushModCreditsToList(modSplit[0]);
						else
							modsAdded.push(modSplit[0]);
					}
				}
			}
		}

		var arrayOfFolders:Array<String> = Paths.getModDirectories();
		arrayOfFolders.push('');
		for (folder in arrayOfFolders)
		{
			pushModCreditsToList(folder);
		}
		#end

		var pisspoop:Array<Array<String>> = [ //Name - Icon name - Description - Link - BG Color
			['Directors'],
				['Tsu', 'post', 'kool person', 'https://twitter.com/SolidPost1', '303030'],
				['Maoki', 'maokigod', 'Directed. Yes.', 'https://twitter.com/maokishortlegs', 'FF8839'],
			[''],
			
			['Programmers'],
				//THAT'S ME!!!!!
				['RZX_Alvaro888', 'alvaro ME LOLOL', 'Main Programmer and also transformed some sprites.', 'https://twitter.com/RZX_Alvaro888', '00FF00'],
				['RedCat995', 'redcat', 'Put almost all of the assets inside of the mod\nand transformed GIFs to sprites.', 'https://twitter.com/RCat995', '00FF00'],
				['JuanJuega', 'panda', "Made a concept playable even though no one used it.", 'https://twitter.com/RZX_Alvaro888', '00FF00'],
			[''],
			
			['Artists'],
				['gBv2209', 'gbv', 'Made the discord accept sprites and ', 'https://youtube.com/channel/UCw14NbNZUOVhXSf9mWBidlw', 'A06257'],
				['Genko', 'benja', "Made a lot of useful art like sprites, sketches and icons.", 'https://twitter.com/Genko_xddd?t=VthlgWxCziVYsoOy5tnBQg&s=33', 'A06257'],
				//['SugCoffee', 'coffee', "I don't know either.", 'https://www.youtube.com/channel/UCY59lrYAwJYYpSo__wuZfAQ', 'A06257'],
				['J.A.T.D.', 'jatd', "Made some stages.", 'https://twitter.com/El_JATD_ICE', 'A06257'],
				['Gojiron', 'gojiron', "Made a lot of sketches.", 'https://twitter.com/_LionJin', 'A06257'],
				['BaxokerBoi', 'baxoker', "Made a lot of credit icons.", 'https://www.youtube.com/channel/UCNWH5Ee-0D01ZUY0OQmAG8A', 'A06257'],
				['MisRight', 'misright', "Made Kutami's art and Sonic.exe's bg.", 'https://twitter.com/M1sRight?t=hW3kHZMgZ9FC4NYN30th5w&s=09', 'A06257'],
			[''],
			
			['Animators'],
				['gBv2209', 'gbv', "Animated Sing For Fun's GF.", 'https://youtube.com/channel/UCw14NbNZUOVhXSf9mWBidlw', 'A06257'],
				//ME AGAIN!!!!!
				['RZX_Alvaro888', 'alvaro ME LOLOL', 'Animated the sunky boppers and the milky BF.', 'https://twitter.com/RZX_Alvaro888', '00FF00'],
				['maximilianoplaza', 'plaza', 'Animated some sprites.', 'https://www.twitch.tv/maximiliano_plaza81', 'FFCB7D'],
			[''],
			
			['Charters'],
				//why the fuck am I here 3 times
				['RZX_Alvaro888', 'alvaro ME LOLOL', "Charted Sing For Fun, Kutamization and Round 2.", 'https://twitter.com/RZX_Alvaro888', '00FF00'],
				['Ethan22200', 'ethan', 'Charted Welcome Back and Return.', 'https://twitter.com/Ethan22200', '00FF00'],
			[''],
			
			['Composers'],
				['Ziro', 'ziro', 'Made Welcome Back and the Kutami Song.', 'https://twitter.com/Ziro_Senpai_1', 'FFFFFF'],
				['Reridot', 'reridot', 'Made the sunky song.', 'https://twitter.com/ReridotMusic', 'A06257'],
			[''],
			
			['Special Thanks'],
				['Ink', 'ink', 'I had enough balls to add him here without consulting Maoki about it lol\n(THIS WAS BEFORE HE WAS IN THE TEAM)', 'https://twitter.com/Ink48472505', '00FF00'],
				['LooneyDude', 'looney', 'Gave us the permission to use Sunky.', 'https://twitter.com/girdude', '001DFF'],
			['']//,
			
			//['Beta Testers'],
				//okay what the fuck
				//['RZX_Alvaro888', 'alvaro ME LOLOL', 'literally tested everything', 'https://twitter.com/RZX_Alvaro888', '00FF00']
			//['']
		];
		
		for(i in pisspoop){
			creditsStuff.push(i);
		}
	
		for (i in 0...creditsStuff.length)
		{
			var isSelectable:Bool = !unselectableCheck(i);
			var optionText:Alphabet = new Alphabet(0, 70 * i, creditsStuff[i][0], !isSelectable, false);
			optionText.isMenuItem = true;
			optionText.screenCenter(X);
			optionText.yAdd -= 70;
			if(isSelectable) {
				optionText.x -= 70;
			}
			optionText.forceX = optionText.x;
			//optionText.yMult = 90;
			optionText.targetY = i;
			grpOptions.add(optionText);

			if(isSelectable) {
				if(creditsStuff[i][5] != null)
				{
					Paths.currentModDirectory = creditsStuff[i][5];
				}

				if(creditsStuff[i][1] != '')
				{
					var icon:AttachedSprite = new AttachedSprite('credits/sonicteam/' + creditsStuff[i][1]);
					icon.xAdd = optionText.width + 10;
					icon.sprTracker = optionText;
					
					// using a FlxGroup is too much fuss!
					iconArray.push(icon);
					add(icon);
					Paths.currentModDirectory = '';

					if(curSelected == -1) curSelected = i;
				}
			}
		}
		
		descBox = new AttachedSprite();
		descBox.makeGraphic(1, 1, FlxColor.BLACK);
		descBox.xAdd = -10;
		descBox.yAdd = -10;
		descBox.alphaMult = 0.6;
		descBox.alpha = 0.6;
		add(descBox);

		descText = new FlxText(50, FlxG.height + offsetThing - 25, 1180, "", 32);
		descText.setFormat(Paths.font("vcr.ttf"), 32, FlxColor.WHITE, CENTER/*, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK*/);
		descText.scrollFactor.set();
		//descText.borderSize = 2.4;
		descBox.sprTracker = descText;
		add(descText);

		bg.color = getCurrentBGColor();
		intendedColor = bg.color;
		changeSelection();
		super.create();
	}

	var quitting:Bool = false;
	var holdTime:Float = 0;
	override function update(elapsed:Float)
	{
		if (FlxG.sound.music.volume < 0.7)
		{
			FlxG.sound.music.volume += 0.5 * FlxG.elapsed;
		}

		if(creditsStuff[curSelected][2] == '')
		{
			descBox.visible = false;
		}
		else
		{
			descBox.visible = true;
		}

		if(!quitting)
		{
			if(creditsStuff.length > 1)
			{
				var shiftMult:Int = 1;
				if(FlxG.keys.pressed.SHIFT) shiftMult = 3;

				var upP = controls.UI_UP_P;
				var downP = controls.UI_DOWN_P;

				if (upP)
				{
					changeSelection(-1 * shiftMult);
					holdTime = 0;
				}
				if (downP)
				{
					changeSelection(1 * shiftMult);
					holdTime = 0;
				}

				if(controls.UI_DOWN || controls.UI_UP)
				{
					var checkLastHold:Int = Math.floor((holdTime - 0.5) * 10);
					holdTime += elapsed;
					var checkNewHold:Int = Math.floor((holdTime - 0.5) * 10);

					if(holdTime > 0.5 && checkNewHold - checkLastHold > 0)
					{
						changeSelection((checkNewHold - checkLastHold) * (controls.UI_UP ? -shiftMult : shiftMult));
					}
				}
			}

			if(controls.ACCEPT && (creditsStuff[curSelected][3] == null || creditsStuff[curSelected][3].length > 4)) {
				CoolUtil.browserLoad(creditsStuff[curSelected][3]);
			}
			if (controls.BACK)
			{
				if(colorTween != null) {
					colorTween.cancel();
				}
				FlxG.sound.play(Paths.sound('cancelMenu'));
				MusicBeatState.switchState(new CreditsState());
				quitting = true;
			}
		}
		
		for (item in grpOptions.members)
		{
			if(!item.isBold)
			{
				var lerpVal:Float = CoolUtil.boundTo(elapsed * 12, 0, 1);
				if(item.targetY == 0)
				{
					var lastX:Float = item.x;
					item.screenCenter(X);
					item.x = FlxMath.lerp(lastX, item.x - 70, lerpVal);
					item.forceX = item.x;
				}
				else
				{
					item.x = FlxMath.lerp(item.x, 200 + -40 * Math.abs(item.targetY), lerpVal);
					item.forceX = item.x;
				}
			}
		}

		checker.x -= 0.45;
		checker.y += 0.16;
		super.update(elapsed);
	}

	var moveTween:FlxTween = null;
	function changeSelection(change:Int = 0)
	{
		FlxG.sound.play(Paths.sound('scrollMenu'), 0.4);
		do {
			curSelected += change;
			if (curSelected < 0)
				curSelected = creditsStuff.length - 1;
			if (curSelected >= creditsStuff.length)
				curSelected = 0;
		} while(unselectableCheck(curSelected));

		var newColor:Int =  getCurrentBGColor();
		if(newColor != intendedColor) {
			if(colorTween != null) {
				colorTween.cancel();
			}
			intendedColor = newColor;
			colorTween = FlxTween.color(bg, 1, bg.color, intendedColor, {
				onComplete: function(twn:FlxTween) {
					colorTween = null;
				}
			});
		}

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

		descText.text = creditsStuff[curSelected][2];
		descText.y = FlxG.height - descText.height + offsetThing - 60;

		if(moveTween != null) moveTween.cancel();
		moveTween = FlxTween.tween(descText, {y : descText.y + 75}, 0.25, {ease: FlxEase.sineOut});

		descBox.setGraphicSize(Std.int(descText.width + 20), Std.int(descText.height + 25));
		descBox.updateHitbox();
	}

	#if MODS_ALLOWED
	private var modsAdded:Array<String> = [];
	function pushModCreditsToList(folder:String)
	{
		if(modsAdded.contains(folder)) return;

		var creditsFile:String = null;
		if(folder != null && folder.trim().length > 0) creditsFile = Paths.mods(folder + '/data/credits.txt');
		else creditsFile = Paths.mods('data/credits.txt');

		if (FileSystem.exists(creditsFile))
		{
			var firstarray:Array<String> = File.getContent(creditsFile).split('\n');
			for(i in firstarray)
			{
				var arr:Array<String> = i.replace('\\n', '\n').split("::");
				if(arr.length >= 5) arr.push(folder);
				creditsStuff.push(arr);
			}
			creditsStuff.push(['']);
		}
		modsAdded.push(folder);
	}
	#end

	function getCurrentBGColor() {
		var bgColor:String = creditsStuff[curSelected][4];
		if(!bgColor.startsWith('0x')) {
			bgColor = '0xFF' + bgColor;
		}
		return Std.parseInt(bgColor);
	}

	private function unselectableCheck(num:Int):Bool {
		return creditsStuff[num].length <= 1;
	}
}