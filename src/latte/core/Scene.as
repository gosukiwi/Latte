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
		
		public function Scene()
		{
			this.addEventListener(Event.ADDED_TO_STAGE, init);
		}

		public function init():void
		{
			_active = false;
			
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