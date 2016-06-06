package ;

import flash.display.Sprite;
import flash.events.Event;
import flash.Lib;
import openfl.events.KeyboardEvent;
import openfl.geom.Point;
import openfl.text.TextField;
import openfl.text.TextFormat;
import openfl.text.TextFormatAlign;
import openfl.media.Sound;
import openfl.media.SoundChannel;
import openfl.Assets;
import lime.project.SplashScreen;

enum GameState {
	Paused;
	Playing;
	Lose;
	Win;
}

class Main extends Sprite 
{
	var inited:Bool;
	
	private var platform:Platform;
	private var platformSpeed:Int;
	private var ball:Ball;
	private var ballMovement:Point;
	private var ballSpeed:Int;

	private var map = new Array<Breakable>();
	private var breakable:Breakable;
	
	private var lives:Int;
	private var level:Int;
	
	private var messageField:TextField;
	private var currentGameState:GameState;
	private var scoreField:TextField;

	private var arrowKeyRight:Bool;
	private var arrowKeyLeft:Bool;
	private var backgroundSound:Sound;
	private var backgroundChannel:SoundChannel;
	private var isBackgroundSoundPlaying:Bool = false;
	private var winSound:Sound;
	private var winChannel:SoundChannel;
	private var loseSound:Sound;
	private var loseChannel:SoundChannel;
	/* ENTRY POINT */
	
	function resize(e) 
	{
		if (!inited) init();
		// else (resize or orientation change)
	}
	
	function init() 
	{
		if (inited) return;
		inited = true;
		
		var splashScreen = new SplashScreen("img/default.png",500,500);
		backgroundSound = Assets.getSound("audio/ManoPando.mp3");
		winSound = Assets.getSound("audio/tada.mp3");
		loseSound = Assets.getSound("audio/violin.mp3");

		platform = new Platform();
		platform.x = 150;
		platform.y = 450;
		this.addChild(platform);
		
		ball = new Ball();
		ball.x = 250;
		ball.y = 400;
		this.addChild(ball);
		ballSpeed = 7;
		ballMovement = new Point(0, 0);
		var randomAngle:Float = Math.random() * -(Math.PI/2);
		ballMovement.x = Math.cos(randomAngle) * ballSpeed;
		ballMovement.y = Math.sin(randomAngle) * ballSpeed;
		
		arrowKeyRight = false;
		arrowKeyLeft = false;
		platformSpeed = 7;

		renderMap();
		lives = 3;
		level = 1;
		renderText("Press SPACE to start\nUse ARROW KEYS to move your platform");
		setGameState(Paused);
		stage.addEventListener(KeyboardEvent.KEY_DOWN, keyDown);
		stage.addEventListener(KeyboardEvent.KEY_UP, keyUp);
		this.addEventListener(Event.ENTER_FRAME, everyFrame);
	}

	private function everyFrame(event:Event):Void {
		if(currentGameState == Playing){
			if (arrowKeyRight) {
				platform.x += platformSpeed;
			}
			if (arrowKeyLeft) {
				platform.x -= platformSpeed;
			}

			if (platform.x < 5) platform.x = 5;
			if (platform.x > 345) platform.x = 345;
			if (ball.y < 5 ) ballMovement.y *= -1;
			if (ball.y > 495) setGameState(Lose);
			if (ball.x < 5 || ball.x > 495) ballMovement.x *= -1;

			if ( (ball.x > (platform.x) && ball.x < (platform.x+150)) && (ball.y > (platform.y) && ball.y < (platform.y+15)) ) {
				bounceBall(); //ballMovement.y *= -1;
			}

			ball.x += ballMovement.x;
			ball.y += ballMovement.y;

			var i:Int;
			for (i in 0...map.length) {
				if ( (ball.x > (map[i].x) && ball.x < (map[i].x+20)) && (ball.y > (map[i].y) && ball.y < (map[i].y+20)) ) {
					this.removeChild(map[i]);
					map.remove(map[i]);
					bounceBall(); //ballMovement.y *= -1;
					if(map.length == 0){setGameState(Win);}
					break;
				}
			}
		}
	}

	private function bounceBall():Void {
		//var direction:Int = (ballMovement.x > 0)?( -1):(1);
		var randomAngle:Float = (Math.random() * Math.PI / 2) - 45;
		ballMovement.x = -1 * Math.cos(randomAngle) * ballSpeed;
		ballMovement.y = Math.sin(randomAngle) * ballSpeed;
	}
	
	public function renderMap() {
		var i:Int = 5; var j:Int = 5;
		while(i <= 250){
			while(j <= 500){
				var randomizer:Int = (Math.random() > .5)?(1):( -1); //either 1 or -1 draws or not a block
				if(randomizer == 1){
					breakable = new Breakable();
					breakable.x = j;
					breakable.y = i;
					this.addChild(breakable);
					map.push(breakable);
				}
				j = j + 25;
			}
			i = i + 25;
			j = 0;
		}
	}

	public function renderText(message:String){
		var scoreFormat:TextFormat = new TextFormat("Verdana", 24, 0xbbbbbb, true);
		scoreFormat.align = TextFormatAlign.CENTER;

		scoreField = new TextField();
		addChild(scoreField);
		scoreField.width = 500;
		scoreField.y = 30;
		scoreField.defaultTextFormat = scoreFormat;
		scoreField.selectable = false;

		var messageFormat:TextFormat = new TextFormat("Verdana", 18, 0xbbbbbb, true);
		messageFormat.align = TextFormatAlign.CENTER;

		messageField = new TextField();
		addChild(messageField);
		messageField.width = 500;
		messageField.y = 450;
		messageField.defaultTextFormat = messageFormat;
		messageField.selectable = false;
		messageField.text = message;
	}

	private function updateScore():Void {
		scoreField.text = "Lives: " + lives;
	}

	private function setGameState(state:GameState):Void {
		currentGameState = state;
		updateScore();
		if (state == Paused) {
			messageField.alpha = 1;
			if(isBackgroundSoundPlaying){backgroundChannel.stop();}
		}else if(state == Playing){
			messageField.alpha = 0;
			backgroundChannel = backgroundSound.play(0.0, 2);
			isBackgroundSoundPlaying = true;
		}else if(state == Lose){
			lives--;
			messageField.alpha = 1;
			if(lives <= 0){
				loseSound.play();
				messageField.text = "Game over";
				lives = 3;
			}
			platform.x = 150;
			platform.y = 450;
			ball.x = 250;
			ball.y = 400;
			
			backgroundChannel.stop();
			setGameState(Paused);
		}else if(state == Win){
			messageField.alpha = 1;
			platform.x = 150;
			platform.y = 450;
			ball.x = 250;
			ball.y = 400;
			lives = 3;
			renderMap();
			backgroundChannel.stop();
			winSound.play();
			setGameState(Paused);
		}
	}

	private function keyDown(event:KeyboardEvent):Void {
		if (event.keyCode == 32) { //space
			if(currentGameState == Playing){
				setGameState(Paused);
			}else {setGameState(Playing);}
		} else if (event.keyCode == 39){ // right
			arrowKeyRight = true;
		} else if (event.keyCode == 37){ // left
			arrowKeyLeft = true;
		} else if(event.keyCode == 87){ // W key
			var i:Int;
			for (i in 0...map.length) {
					this.removeChild(map[i]);
					map.remove(map[i]);
					if(map.length == 0){setGameState(Win);}
			}
		}
	}

	private function keyUp(event:KeyboardEvent):Void {
		if (event.keyCode == 39) { // right
			arrowKeyRight = false;
		}else if (event.keyCode == 37) { // left
			arrowKeyLeft = false;
		}
	}

	/* SETUP */

	public function new() 
	{
		super();	
		addEventListener(Event.ADDED_TO_STAGE, added);
	}

	function added(e) 
	{
		removeEventListener(Event.ADDED_TO_STAGE, added);
		stage.addEventListener(Event.RESIZE, resize);
		#if ios
		haxe.Timer.delay(init, 100); // iOS 6
		#else
		init();
		#end
	}
	
	public static function main() 
	{
		// static entry point
		Lib.current.stage.align = flash.display.StageAlign.TOP_LEFT;
		Lib.current.stage.scaleMode = flash.display.StageScaleMode.NO_SCALE;
		Lib.current.addChild(new Main());
		//
	}
}