package latte.core
{
	import starling.display.Sprite;
	import starling.events.Event;

	/**
	 * A world contain many scenes. Scenes represent states of the game,
	 * for example, main menu, credits, playing, pause, save, settings, etc.
	 */
	public class Scene extends Sprite
	{
		private var _active:Boolean;
		private var _world:World;
		
		public function Scene()
		{
			_active = false;
			_world = null;

			this.addEventListener(Event.ADDED_TO_STAGE, init);
		}

		public function get world():World
		{
			return _world;
		}

		public function set world(value:World):void
		{
			_world = value;
		}

		public function init():void
		{
			this.removeEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		/**
		 * Update all elements inside this scene
		 */
		public function update(delta:Number):void
		{
		}
		
		public function get active():Boolean
		{
			return _active;
		}
		
		public function set active(value:Boolean):void
		{
			_active = value;
			this.visible = value;
		}
	}
}