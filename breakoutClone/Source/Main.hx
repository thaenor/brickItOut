package ;

import flash.display.Sprite;
import flash.events.Event;
import flash.Lib;
import openfl.events.KeyboardEvent;
import openfl.geom.Point;
import openfl.text.TextField;
import openfl.text.TextFormat;
import openfl.text.TextFormatAlign;


enum GameState {
	Paused;
	Playing;
	//TODO: add win and loose states
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
	
	private var scorePlayer:Int;
	private var level:Int;
	
	private var messageField:TextField;
	private var currentGameState:GameState;
	private var scoreField:TextField;

	private var arrowKeyRight:Bool;
	private var arrowKeyLeft:Bool;


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
		scorePlayer = 0;
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
			ball.x += ballMovement.x;
			ball.y += ballMovement.y;
			if (platform.x < 5) platform.x = 5;
			if (platform.x > 395) platform.x = 395;
			if (ball.y < 5 ) ballMovement.y *= -1;
			if (ball.y > 495) setGameState(Paused);
			if (ball.x < 5 || ball.x > 495) ballMovement.x *= -1;

			if ( (ball.x > (platform.x) && ball.x < (platform.x+150)) && (ball.y > (platform.y) && ball.y < (platform.y+15)) ) {
				ballMovement.y *= -1;
			}

			if ( (ball.x > (breakable.x) && ball.x < (platform.x+150)) && (ball.y > (platform.y) && ball.y < (platform.y+15)) ) {
				ballMovement.y *= -1;
			}

			var i:Int;
			for (i in 0...map.length) {
				if ( (ball.x > (map[i].x) && ball.x < (map[i].x+20)) && (ball.y > (map[i].y) && ball.y < (map[i].y+20)) ) {
					this.removeChild(map[i]);
					ballMovement.y *= -1;
				}
			}
		}
	}
	
	public function renderMap() {
		for (i in 0...10) {
			breakable = new Breakable();
			breakable.x = i * 50;
			breakable.y = 250;
			this.addChild(breakable);
			map[i] = breakable;
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
		scoreField.text = "Score: " + scorePlayer;
	}

	private function setGameState(state:GameState):Void {
		currentGameState = state;
		updateScore();
		if (state == Paused) {
			messageField.alpha = 1;
			//stop the ball
		}else {
			messageField.alpha = 0;
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