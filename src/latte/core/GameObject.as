package latte.core
{
	import starling.display.Sprite;
	import starling.core.Starling;

	/**
	 * A game object is a special kind of starling.display.Sprite you
	 * can inherit from, aside from Sprite, this class implements:
	 * 	- Object locking in the middle of the screen (used by Tilemap)f
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

		public function get locked():Boolean
		{
			return _locked;
		}

		public function set locked(value:Boolean):void
		{
			// If we are locking this object, we must center it with the real coordinates
			if(value) {
				_vx = super.x;
				_vy = super.y;
				super.x = (Starling.current.stage.stageWidth / 2) - (this.width / 2);
				super.y = (Starling.current.stage.stageHeight / 2) - (this.height / 2);
			}

			_locked = value;
		}
		
		public override function set x(value:Number):void
		{
			if(_locked) {
				_vx = value;
			} else {
				super.x = value;
			}
			
			this.dispatchEvent(new GameEvent(GameEvent.GAME_OBJECT_MOVE));
		}
		
		public override function get x():Number
		{
			return _locked ? _vx : super.x();
		}
		
		public override function set y(value:Number):void
		{
			if(_locked) {
				_vy = value;
			} else {
				super.y = value;
			}
			
			this.dispatchEvent(new GameEvent(GameEvent.GAME_OBJECT_MOVE));
		}

		public override function get y():Number
		{
			return _locked ? _vy : super.y();
		}
	}
}