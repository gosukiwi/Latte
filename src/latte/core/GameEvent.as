package latte.core
{
	import starling.events.Event;
	
	public class GameEvent extends Event
	{
		public static const GAME_OBJECT_MOVE:String = "object_move";
		public static const ANIMATED_GAME_OBJECT_ADVANCED:String = "animated_game_object_advanced";

		
		public function GameEvent(type:String, bubbles:Boolean=false, data:Object=null)
		{
			super(type, bubbles, data);
		}
	}
}