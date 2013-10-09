package latte.core
{
	/**
	 * For performance and convenience issues this class holds a bunch of
	 * global variables, like game width, height, zoom, etc.
	 */
	public class Latte
	{
		public static var GAME_WIDTH:int = 0;
		public static var GAME_HEIGHT:int = 0;
		public static var GAME_ZOOM:Number = 0;

		public static function get WORLD_WIDTH():Number {
			return GAME_WIDTH / GAME_ZOOM;
		}

		public static function get WORLD_HEIGHT():Number {
			return GAME_HEIGHT / GAME_ZOOM;
		}
	}
}