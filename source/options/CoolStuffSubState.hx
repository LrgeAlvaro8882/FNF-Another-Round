package options;

#if desktop
import Discord.DiscordClient;
#end
import flixel.addons.display.FlxGridOverlay;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.math.FlxMath;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import lime.utils.Assets;
import flixel.FlxSubState;
import flash.text.TextField;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.util.FlxSave;
import haxe.Json;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxTimer;
import flixel.input.keyboard.FlxKey;
import flixel.graphics.FlxGraphic;
import Controls;

using StringTools;

class CoolStuffSubState extends BaseOptionsMenu
{
	var textTween1:FlxTween;
	var textTween2:FlxTween;

	var textTimer1:FlxTimer = null;
	var textTimer2:FlxTimer = null;

	var sunkyTweenAngle:FlxTween;

	public function new()
	{
		title = 'Extra options';
		rpcTitle = 'Changing misc options'; //for Discord Rich Presence

		var option:Option = new Option('Icon Movement',
			'Check this if you want the icons\nto move side to side on the beat.',
			'iconMovement',
			'bool',
			true);
		addOption(option);

		var option:Option = new Option('No Backgrounds',
			'Check this if you want to make\nthe backgrounds black while playing.',
			'noBg',
			'bool',
			false);
		addOption(option);

		var option:Option = new Option('Hit Sound Type',
			"Which hit sound should play?\n(Only if Hitsound Volume is greater than 0)",
			'hitSoundType',
			'string',
			'Osu',
			['Osu', 'Indie Cross', 'Oof']);
		addOption(option);
		option.onChange = onChangeHitsoundVolumeButNormal;

		var option:Option = new Option('Opponent Hitsound Volume',
			'Funny notes does \"Tick!\" when\nthe opponent hits them."',
			'hitSoundVolumeOpponent',
			'percent',
			0);
		addOption(option);
		option.scrollSpeed = 1.6;
		option.minValue = 0.0;
		option.maxValue = 1;
		option.changeValue = 0.1;
		option.decimals = 1;
		option.onChange = onChangeHitsoundVolume;

		var option:Option = new Option('Opponent Hit Sound Type',
			"Which hit sound should play?\n(Opponent notes, only if Opponent Hitsound Volume is\ngreater than 0)",
			'hitSoundTypeOpponent',
			'string',
			'Osu',
			['Osu', 'Indie Cross']);
		addOption(option);
		option.onChange = onChangeHitsoundVolume;

		var option:Option = new Option('Opponent Note Splashes',
			'Check this if you want the opponent\nto be able to get sicks randomly and\nhave note splashes.',
			'noteSplashesOpponent',
			'bool',
			true);
		addOption(option);

		var option:Option = new Option('Health Bar Colors',
			'Check this if you want the health bar\nto change colors depending on\nthe character.',
			'healthBarColors',
			'bool',
			true);
		addOption(option);

		var option:Option = new Option('Note Shape',
			"Changes the notes' shape.",
			'noteType',
			'string',
			'Arrow Notes',
			['Arrow Notes', 'Circle Notes']);
		addOption(option);

		var option:Option = new Option('Shaders',
			'Check this if you want shaders in determined songs.',
			'shaders',
			'bool',
			true);
		addOption(option);

		var option:Option = new Option('Move Cam When Note Pressed',
			'Check this if you want the camera to move\ndepending on the note that a character presses.\n(MAY DEACTIVATE SOMETIMES BECAUSE EVENTS)',
			'moveCamWhenNote',
			'bool',
			true);
		addOption(option);

		var option:Option = new Option('Dumb option',
			'what the fuck is this option for',
			'actuallyUnlockedTheSecretSong',
			'bool',
			false);
		addOption(option);
		option.onChange = whenActivatedCoolOption;

		super();
	}

	function whenActivatedCoolOption()
	{
		if(!ClientPrefs.actuallyUnlockedTheSecretSong)
		{
			unlockSunky(false, false);
		}
		else
		{
			if(FlxG.save.data.hasUnlockedFreeplay)
			{
				unlockSunky(true, false);
			}
			else
			{
				unlockSunky(false, true);
			}
		}
	}

	function unlockSunky(canUnlock:Bool, canDeactivate:Bool)
	{
		if(!canUnlock)
		{
			if(textTimer1 != null)
			{
				textTimer1.cancel();
				textTimer1 = null;
			}

			if(textTimer2 != null)
			{
				textTimer2.cancel();
				textTimer2 = null;
			}

			if(textTween1 != null)
			{
				textTween1.cancel();
				textTween1 = null;
			}

			if(textTween2 != null)
			{
				textTween2.cancel();
				textTween2 = null;
			}

			if(sunkyTweenAngle != null)
			{
				sunkyTweenAngle.cancel();
				sunkyTweenAngle = null;
			}

			secretText1.alpha = 0;
			sunky.alpha = 0;
			secretText2.alpha = 1;
			textTimer2 = new FlxTimer().start(1, function(tmr:FlxTimer)
			{
				textTween2 = FlxTween.tween(secretText2, {alpha: 0}, 1.5, {ease: FlxEase.sineIn, onComplete: function(twn:FlxTween)
					{
						textTween2 = null;
					}
				});
				textTimer2 = null;
			});
			ClientPrefs.actuallyUnlockedTheSecretSong = true;
			FlxG.sound.play(Paths.sound('discordError'));
			FlxG.camera.shake(0.005, 0.07);
		}
		else
		{
			FlxG.sound.music.volume = 0;
			FlxG.sound.play(Paths.sound('sonic-extra-life'));
			secretText1.alpha = 1;

			new FlxTimer().start(2.5, function (tmr:FlxTimer){FlxG.sound.music.fadeIn(2, 0, 1);});
			
			textTimer1 = new FlxTimer().start(1, function(tmr:FlxTimer)
			{
				textTween1 = FlxTween.tween(secretText1, {alpha: 0}, 1.5, {ease: FlxEase.sineIn, onComplete: function(twn:FlxTween)
					{
						textTween1 = null;
						sunkyTweenAngle.cancel();
						sunkyTweenAngle = null;
						sunky.alpha = 0;
					}
				});
				textTimer1 = null;
			});

			sunky.alpha = 1;
			sunkyTweenAngle = FlxTween.tween(sunky, {angle: 14400}, 3, {onComplete: function(twn:FlxTween){sunkyTweenAngle = null;}});
		}
	}

	function onChangeHitsoundVolume()
	{
		if(ClientPrefs.hitSoundTypeOpponent == 'Indie Cross')
		{
			FlxG.sound.play(Paths.sound('hitsoundindiecross'), ClientPrefs.hitSoundVolumeOpponent);
		}
		else if(ClientPrefs.hitSoundTypeOpponent == 'Osu')
		{
			FlxG.sound.play(Paths.sound('hitsound'), ClientPrefs.hitSoundVolumeOpponent);
		}
	}

	function onChangeHitsoundVolumeButNormal()
	{
		if(ClientPrefs.hitSoundType == 'Indie Cross')
		{
			FlxG.sound.play(Paths.sound('hitsoundindiecross'), ClientPrefs.hitsoundVolume);
		}
		else if(ClientPrefs.hitSoundType == 'Osu')
		{
			FlxG.sound.play(Paths.sound('hitsound'), ClientPrefs.hitsoundVolume);
		}
	}
}