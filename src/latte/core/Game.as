package latte.core
{
	import flash.display.Sprite;
	
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
		
		public function Game()
		{
			_stats = new Stats();
			_starling = new Starling(World, stage);
			_starling.antiAliasing = 0;
			_starling.start();
			
			this.addChild(_stats);
			
			// Call the init method once the world exists.
			_starling.addEventListener(starling.events.Event.ROOT_CREATED, init);
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