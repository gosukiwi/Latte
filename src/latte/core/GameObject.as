package latte.core
{
	import starling.display.Image;
	import starling.textures.Texture;

	/**
	 * A superclass of starling.display.Image, it includes:
	 * 
	 * 	- Object locking in the middle of the screen (used by Tilemap)
	 * 	- GAME_OBJECT_MOVE event, dispatched then this object's x or y coordinates are updated
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
		
		public function GameObject(texture:Texture)
		{
			super(texture);
			
			_locked = false;
			_vx = 0;
			_vy = 0;
			_oldvx = 0;
			_oldvy = 0;
		}

		public function get vy():Number
		{
			return _vy;
		}

		public function set vy(value:Number):void
		{
			_oldvy = _vy;
			_vy = value;
			this.dispatchEvent(new GameEvent(GameEvent.GAME_OBJECT_MOVE));
		}

		public function get vx():Number
		{
			return _vx;
		}

		public function set vx(value:Number):void
		{
			_oldvx = _vx;
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
		
		public function rollback():void
		{
			_vx = _oldvx;
			_vy = _oldvy;
		}
	}
}