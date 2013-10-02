package latte.core
{
	import starling.events.KeyboardEvent;

	public class Input
	{
		/** PUBLIC CONSTANTS **/
		
		// Arrows
		public static const KEY_DOWN_ARROW:uint = 40;
		public static const KEY_RIGHT_ARROW:uint = 39;
		public static const KEY_UP_ARROW:uint = 38;
		public static const KEY_LEFT_ARROW:uint = 37;
		
		// Alphabet
		public static const KEY_A:uint = 65;
		public static const KEY_B:uint = 66;
		public static const KEY_C:uint = 67;
		public static const KEY_D:uint = 68;
		public static const KEY_E:uint = 69;
		public static const KEY_F:uint = 70;
		public static const KEY_G:uint = 71;
		public static const KEY_H:uint = 72;
		public static const KEY_I:uint = 73;
		public static const KEY_J:uint = 74;
		public static const KEY_K:uint = 75;
		public static const KEY_L:uint = 76;
		public static const KEY_M:uint = 77;
		public static const KEY_N:uint = 78;
		public static const KEY_O:uint = 79;
		public static const KEY_P:uint = 80;
		public static const KEY_Q:uint = 81;
		public static const KEY_R:uint = 82;
		public static const KEY_S:uint = 83;
		public static const KEY_T:uint = 84;
		public static const KEY_U:uint = 85;
		public static const KEY_V:uint = 86;
		public static const KEY_W:uint = 87;
		public static const KEY_X:uint = 88;
		public static const KEY_Y:uint = 89;
		public static const KEY_Z:uint = 90;
		
		// Numbers
		public static const KEY_KEYPAD_0:uint = 48;
		public static const KEY_KEYPAD_1:uint = 49;
		public static const KEY_KEYPAD_2:uint = 50;
		public static const KEY_KEYPAD_3:uint = 51;
		public static const KEY_KEYPAD_4:uint = 52;
		public static const KEY_KEYPAD_5:uint = 53;
		public static const KEY_KEYPAD_6:uint = 54;
		public static const KEY_KEYPAD_7:uint = 55;
		public static const KEY_KEYPAD_8:uint = 56;
		public static const KEY_KEYPAD_9:uint = 57;

		public static const KEY_NUMPAD_0:uint = 96;
		public static const KEY_NUMPAD_1:uint = 97;
		public static const KEY_NUMPAD_2:uint = 98;
		public static const KEY_NUMPAD_3:uint = 99;
		public static const KEY_NUMPAD_4:uint = 100;
		public static const KEY_NUMPAD_5:uint = 101;
		public static const KEY_NUMPAD_6:uint = 102;
		public static const KEY_NUMPAD_7:uint = 103;
		public static const KEY_NUMPAD_8:uint = 104;
		public static const KEY_NUMPAD_9:uint = 105;
		
		// Functions
		public static const KEY_F1:uint = 112;
		public static const KEY_F2:uint = 113;
		public static const KEY_F3:uint = 114;
		public static const KEY_F4:uint = 115;
		public static const KEY_F5:uint = 116;
		public static const KEY_F6:uint = 117;
		public static const KEY_F7:uint = 118;
		public static const KEY_F8:uint = 119;
		public static const KEY_F9:uint = 120;
		public static const KEY_F10:uint = 121;
		public static const KEY_F11:uint = 122;
		public static const KEY_F12:uint = 123;
		
		// Others
		public static const KEY_ENTER:uint = 13;
		public static const KEY_ESC:uint = 27;
		public static const KEY_BACKSPACE:uint = 8;
		public static const KEY_SPACEBAR:uint = 32;
		public static const KEY_CTRL:uint = 17;
		public static const KEY_SHIFT:uint = 16;
		public static const KEY_INSERT:uint = 45;
		public static const KEY_DELETE:uint = 46;
		
		/** FUNCTIONS **/
		private static var _keys:Vector.<Boolean> = new Vector.<Boolean>();
		
		public static function init():void
		{
			for(var i:int = 0; i < 512; i++) {
				_keys.push(false);
			}
		}
		
		public static function isKeyDown(key:uint):Boolean
		{
			return _keys[key];
		}

		public static function isKeyUp(key:uint):Boolean
		{
			return !_keys[key];
		}
		
		public static function onKeyDown(event:KeyboardEvent):void
		{
			trace(event.keyCode);
			_keys[event.keyCode] = true;
		}
		
		public static function onKeyUp(event:KeyboardEvent):void
		{
			_keys[event.keyCode] = false;
		}
	}
}