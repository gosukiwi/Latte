package latte.core
{
	import flash.display.BitmapData;
	import flash.geom.Rectangle;
	
	import starling.core.Starling;

	public class ScrollingTilemap extends Tilemap
	{
		private var _viewPort:Rectangle;
		private var _hero:GameObject;
		
		public function ScrollingTilemap(map:String, tiles:BitmapData)
		{
			super(map, tiles);
			
			_viewPort = new Rectangle(0, 0, Starling.current.stage.stageWidth, Starling.current.stage.stageHeight);
			_hero = null;
		}
		
		/**
		 * Make this map follow a DisplayObject
		 */
		public function follow(hero:GameObject):void
		{
			_hero = hero;
			_hero.locked = true;
			_hero.addEventListener(GameEvent.GAME_OBJECT_MOVE, onHeroMove);
		}		
		/**
		 * This is called when the hero this maps follows move
		 * We have to update the viewport!
		 */
		private function onHeroMove():void
		{
			_viewPort.x = _hero.x;
			_viewPort.y = _hero.y;
			Starling.current.viewPort = _viewPort;
		}
		
		public function get viewPort():Rectangle
		{
			return _viewPort;
		}

		public function set viewPort(value:Rectangle):void
		{
			_viewPort = value;
			Starling.current.viewPort = value;
		}
	}
}