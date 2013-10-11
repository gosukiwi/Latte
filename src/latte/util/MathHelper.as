package latte.util
{
	public class MathHelper
	{
		/**
		 * Given a nummber n, finds the closest multiple of n for the given divisor
		 */
		public static function closestMultiple(n:Number, divisor:int):int
		{
			return int(divisor * Math.round(n / divisor)); 
		}
	}
}