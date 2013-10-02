package latte.core
{
	import starling.core.Starling;
	import starling.display.Sprite;

	/**
	 * A game object is a special kind of starling.display.Sprite you
	 * can inherit from, aside from Sprite, this class implements:
	 * 	- Object locking in the middle of the screen (used by Tilemap)
	 * 	- GAME_OBJECT_MOVE event, dispatched then this object's x or y coordinates are updated
	 * 
	 * @author Federico Ramírez
	 */
	public class GameObject extends Sprite
	{
		private var _locked:Boolean;
		
		// Virtual x
		private var _vx:Number;
		// Virtual y
		private var _vy:Number;
		
		public function GameObject()
		{
			super();
			
			_locked = false;
			_vx = 0;
			_vy = 0;
		}

		public function get vy():Number
		{
			return _vy;
		}

		public function set vy(value:Number):void
		{
			_vy = value;
			this.dispatchEvent(new GameEvent(GameEvent.GAME_OBJECT_MOVE));
		}

		public function get vx():Number
		{
			return _vx;
		}

		public function set vx(value:Number):void
		{
			_vx = value;
			this.dispatchEvent(new GameEvent(GameEvent.GAME_OBJECT_MOVE));
		}

		public function get locked():Boolean
		{
			return _locked;
		}

		public function set locked(value:Boolean):void
		{
			// If we are locking this object, we must center it with the real coordinates
			if(value) {
				/*_vx = this.x;
				_vy = this.y;*/
				this.x = (Starling.current.stage.stageWidth / 2) - (this.width / 2);
				this.y = (Starling.current.stage.stageHeight / 2) - (this.height / 2);
			}

			_locked = value;
		}
	}
}