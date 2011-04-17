package ui
{
	
	public class UtilUI 
	{
		public function UtilUI() 
		{			
		}

		public static function FormatNum(num:Number) : String
		{
			var workingNum:Number;
			
			if(num < 1000)
			{
				return num.toString();
			}
			else if(num >= 1000)
			{
				workingNum = num / 1000;
				return ( workingNum.toString() + "K");
			}
			else if(num >= 1000000)
			{
				workingNum = num / 1000000;
				return ( workingNum.toString() + "M");
			}
			else
			{
				return num.toString();
			}
		}
	}
	
}
