package ui
{
	import flash.display.DisplayObject;
	
	public class UtilUI 
	{
		public function UtilUI() 
		{			
		}
		
		public static function bringForward(displayObject:DisplayObject) : void
		{
			displayObject.parent.setChildIndex(displayObject, displayObject.parent.numChildren - 1);	
		}

		public static function FormatNum(num:Number) : String
		{
			var workingNum:Number;
			
			if(num >= 1000000)
			{
				workingNum = num / 1000000;
				return ( workingNum.toPrecision(3) + "M");
			}
			else if(num >= 1000)
			{
				workingNum = num / 1000;
				return ( workingNum.toPrecision(3) + "K");
			}			
			else
			{
				return num.toString();
			}
		}
		
		public static function round1(num:Number) : Number
		{
			var rounded:Number = Math.round(num * 100);
			return rounded / 100;
		}
	}
	
}
