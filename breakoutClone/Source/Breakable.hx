package ;
import openfl.display.Sprite;

class Breakable extends Sprite
{

	public function new() 
	{
		super();
		var color:Int;
		color = randomizeColor();
		this.graphics.beginFill(color);
		this.graphics.drawRect(0, 0, 20, 20);
		this.graphics.endFill();
	}
	
	public function randomizeColor():Int{
		var rcolor:Int = Math.floor(Math.random() * 4) + 1;
		var setColor:Int = 0;
		switch (rcolor) {
			case 1: setColor = 0xFF99FF;
			case 2: setColor = 0xFFFF00;
			case 3: setColor = 0xFF3300;
			case 4: setColor = 0x666699;
		}
		return setColor;
	}
}