package latte.util
{
	/**
	 * Utility class representing a simple 2d math vector
	 * It has:
	 * 	Modulus
	 * 	Scalar product
	 * 	Addition / Substraction
	 * 	Normalization
	 */
	public class Vector2
	{
		private var _x:Number;
		private var _y:Number;
		
		public function Vector2(x:Number = 0, y:Number = 0)
		{
			_x = x;
			_y = y;
		}
		
		public static function zero():Vector2
		{
			return new Vector2(0, 0);
		}

		public function get y():Number
		{
			return _y;
		}

		public function set y(value:Number):void
		{
			_y = value;
		}

		public function get x():Number
		{
			return _x;
		}

		public function set x(value:Number):void
		{
			_x = value;
		}
		
		public function modulus():Number
		{
			return Math.sqrt((x * x) + (y * y));
		}
		
		public function normalize():Vector2
		{
			var mod:Number = modulus();
			return new Vector2(x / mod, y / mod);
		}
		
		public function product(scalar:Number):Vector2
		{
			return new Vector2(x * scalar, y * scalar);
		}
		
		public function addition(vector:Vector2):Vector2
		{
			return new Vector2(x + vector.x, y + vector.y);
		}
		
		public function substraction(vector:Vector2):Vector2
		{
			return new Vector2(x - vector.x, y - vector.y);
		}
	}
}