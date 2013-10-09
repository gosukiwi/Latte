package latte.core
{
	import flash.display.BitmapData;
	import flash.geom.Rectangle;

	public class ScrollingTilemap extends Tilemap
	{
		private var _hero:GameObject;
		private var _scene:Scene;
		private var _solidsEnabled:Boolean;
		
		public function ScrollingTilemap(map:String, tiles:BitmapData, scene:Scene)
		{
			super(map, tiles);
			
			_hero = null;
			_scene = scene;
			_solidsEnabled = true;
		}
		
		public function get solidsEnabled():Boolean
		{
			return _solidsEnabled;
		}

		public function set solidsEnabled(value:Boolean):void
		{
			_solidsEnabled = value;
		}

		/**
		 * Make this map follow a DisplayObject
		 */
		public function follow(hero:GameObject):void
		{
			_hero = hero;
			_hero.locked = true;
			_hero.addEventListener(GameEvent.GAME_OBJECT_MOVE, onHeroMove);
			// Call it once, so the map positions the first time
			onHeroMove();
		}		
		/**
		 * This is called when the hero this maps follows move
		 * We have to update the viewport!
		 */
		private function onHeroMove():void
		{
			/* The hero moved, it's new locations are in _hero.vx and _hero.vy
			If the solids are enabled, check if it's a valid move */
			if(_solidsEnabled) {
				var rect:Rectangle = new Rectangle(_hero.vx, _hero.vy, _hero.width, _hero.height);
				for each(var solid:Rectangle in _solids) {
					if(rect.intersects(solid)) {
						_hero.rollback();
						return;
					}
				}
			}
			
			/* Adjust "camera" to center hero */
			this.x = (Latte.WORLD_WIDTH / 2) - (_hero.width / 2) - _hero.vx;
			this.y = (Latte.WORLD_HEIGHT / 2) - (_hero.height / 2) - _hero.vy;
		}
	}
}