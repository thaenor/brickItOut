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
		var rcolor:Int = (Math.random() > .5)?(0xFF99FF):(0xFFFF00);
		return rcolor;
	}
}