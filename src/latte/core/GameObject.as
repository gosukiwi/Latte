package latte.core
{
	import latte.util.Vector2;
	
	import starling.display.Image;
	import starling.textures.Texture;

	/**
	 * A superclass of starling.display.Image, it includes:
	 * 
	 * 	- Object locking in the middle of the screen (used by Tilemap)
	 * 	- GAME_OBJECT_MOVE event, dispatched then this object's x or y coordinates are updated
	 *  - rollback method to go back to previous location
	 * 
	 * @author Federico Ramírez
	 */
	public class GameObject extends Image
	{
		private var _locked:Boolean;
		
		// Virtual position
		private var _vx:Number;
		private var _vy:Number;

		// Used for rollback method
		private var _oldvx:Number;
		private var _oldvy:Number;
		
		// Used for updating position
		private var _speed:Number;
		private var _direction:Vector2;
		
		public function GameObject(texture:Texture)
		{
			super(texture);
			
			_locked = false;
			_vx = 0;
			_vy = 0;
			_oldvx = -1;
			_oldvy = -1;
			
			_speed = 0;
			_direction = Vector2.zero();
		}

		public function get direction():Vector2
		{
			return _direction;
		}

		public function set direction(value:Vector2):void
		{
			// Direction must always be normalized
			_direction = value.normalize();
		}

		public function get speed():Number
		{
			return _speed;
		}

		public function set speed(value:Number):void
		{
			_speed = value;
		}

		public function get vy():Number
		{
			return _vy;
		}

		public function set vy(value:Number):void
		{
			_oldvy = _oldvy == -1 ? value : _vy;
			_vy = value;
			this.dispatchEvent(new GameEvent(GameEvent.GAME_OBJECT_MOVE));
		}

		public function get vx():Number
		{
			return _vx;
		}

		public function set vx(value:Number):void
		{
			_oldvx = _oldvx == -1 ? value : _vx;
			_vx = value;
			this.dispatchEvent(new GameEvent(GameEvent.GAME_OBJECT_MOVE));
		}

		public function get locked():Boolean
		{
			return _locked;
		}

		public function set locked(value:Boolean):void
		{
			// If locking, center in the middle of the screen
			if(value) {
				this.x = (Latte.WORLD_WIDTH / 2) - (this.width / 2);
				this.y = (Latte.WORLD_HEIGHT / 2) - (this.height / 2);
			}

			_locked = value;
		}
		
		/**
		 * Moves the GameObject a given ammount
		 */
		public function move(x:Number, y:Number):void
		{
			if(this.locked) {
				this.vx += x;
				this.vy += y;
			} else {
				this.x += x;
				this.y += y;
			}
		}
		
		public function update(delta:Number):void
		{
			var pos:Vector2 = _direction.product(_speed * delta);
			move(pos.x, pos.y);
		}
		
		public function rollback():void
		{
			_vx = _oldvx;
			_vy = _oldvy;
		}
	}
}