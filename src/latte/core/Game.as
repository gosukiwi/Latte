package latte.core
{
	import flash.display.Sprite;
	import flash.geom.Point;
	
	import net.hires.debug.Stats;
	
	import starling.core.Starling;
	import starling.events.Event;
	
	/**
	 * A regular flash.display.Sprite with starling
	 */
	public class Game extends Sprite
	{
		private var _stats:Stats;
		private var _starling:Starling;
		private var _zoom:Point;
		
		public function Game()
		{
			_stats = new Stats();
			_starling = new Starling(World, stage);
			_starling.antiAliasing = 0;
			_starling.start();
			_zoom = new Point(1, 1);
			
			this.addChild(_stats);
			
			// Call the init method once the world exists.
			_starling.addEventListener(starling.events.Event.ROOT_CREATED, init);
		}
		
		public function get zoom():Point
		{
			return _zoom;
		}

		public function set zoom(value:Point):void
		{
			_zoom = value;
			this.world.scaleX = _zoom.x;
			this.world.scaleY = _zoom.y;
		}

		/**
		 * Use this method to initialize your game, do not use the constructor!
		 */
		public function init():void
		{
		}
		
		public function get world():World
		{
			return _starling.root as World;
		}
	}
}