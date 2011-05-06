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
				workingNum = round3(num / 1000000);
				return ( workingNum.toString() + "M");
			}
			else if(num >= 1000)
			{
				workingNum = round3(num / 1000);
				return ( workingNum.toString() + "K");
			}			
			else
			{
				return num.toString();
			}
		}
		
		public static function round3(num:Number) : Number
		{
			var rounded:Number = Math.round(num * 1000);
			return rounded / 1000;
		}
	}
	
}
