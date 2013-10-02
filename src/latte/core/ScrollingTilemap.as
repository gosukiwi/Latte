package latte.core
{
	import flash.display.BitmapData;
	import starling.core.Starling;

	public class ScrollingTilemap extends Tilemap
	{
		private var _hero:GameObject;
		private var _stageWidth:Number;
		private var _stageHeight:Number;
		
		public function ScrollingTilemap(map:String, tiles:BitmapData)
		{
			super(map, tiles);
			
			_hero = null;
			_stageWidth = Starling.current.stage.stageWidth;
			_stageHeight = Starling.current.stage.stageHeight;
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
			/* Our hero is locked in the middle of the screen, therefor, if the hero
			is at (0, 0) the map should be with it's top left border in (0, 0) */
			this.x =  (_stageWidth / 2) - _hero.vx;
			this.y =  (_stageHeight / 2) - _hero.vy;
		}
	}
}