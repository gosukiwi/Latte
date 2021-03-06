package latte.core
{
	import flash.utils.Dictionary;
	import flash.utils.getTimer;
	
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.events.KeyboardEvent;

	/**
	 * A starling sprite which will be our world, everything
	 * will be drawn onto this sprite.
	 */
	public class World extends Sprite
	{
		private var _scenes:Dictionary;
		private var _active:String;
		
		// Used to calculate delta
		private var _lastTick:Number;
		
		public function World()
		{
			this.addEventListener(Event.ADDED_TO_STAGE, init);
			this.addEventListener(Event.ENTER_FRAME, update);
			Input.init();
			this.addEventListener(KeyboardEvent.KEY_DOWN, onKeyDown);
			this.addEventListener(KeyboardEvent.KEY_UP, onKeyUp);
		}

		private function onKeyUp(event:KeyboardEvent):void
		{
			Input.onKeyUp(event);
		}
		
		private function onKeyDown(event:KeyboardEvent):void
		{
			Input.onKeyDown(event);
		}
		
		/**
		 * This is called first after adding the world to the stage.
		 * Use this to do all your initialization needs.
		 */
		private function init():void
		{
			_scenes = new Dictionary();
			_active = null;
			_lastTick = 0;
			
			this.scaleX = Latte.GAME_ZOOM;
			this.scaleY = Latte.GAME_ZOOM;
			
			this.removeEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		/**
		 * Called on enter frame
		 */
		private function update():void
		{
			// Calculate delta
			var now:int = flash.utils.getTimer();
			var delta:Number = (now - _lastTick) / 1000;
			_lastTick = now;
			
			// Update stuff!
			if(_active != null) {
				_scenes[_active].update(delta);
			}
		}
		
		/**
		 * Reloads a scene in the world with a new instance. The scene must already exist,
		 * otherwise use addScene.
		 */
		public function reloadScene(name:String, scene:Scene):void
		{
			if(!_scenes[name]) {
				throw new Error("Could not reload scene " + name + " because it does not exists in the first place.");
			}
			
			if(name == _active) {
				this.removeChild(_scenes[_active], true);
				this.addChild(scene);
			}

			addScene(name, scene);
		}
		
		/**
		 * Adds a new scene to this world
		 */
		public function addScene(name:String, scene:Scene):void
		{
			scene.world = this;
			_scenes[name] = scene;
		}
		
		public function get active():String
		{
			return _active;
		}
		
		public function set active(value:String):void
		{
			if(!_scenes[value]) {
				throw new Error("Could not find scene with name: " + value);
			}
			
			// If there's an old scene, set it as not active 
			if(_active != null) {
				_scenes[_active].active = false;
				this.removeChild(_scenes[_active], true);
			}
			
			// Set the new active name
			_active = value;
			// Set the active scene as active
			_scenes[value].active = true;
			// Add the current scene to the stage
			this.addChild(_scenes[_active]);
		}
	}
}