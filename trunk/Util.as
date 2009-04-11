package 
{
	import flash.display.DisplayObjectContainer;
	
	public class Util
	{
		public static function removeChildren(displayContainer:DisplayObjectContainer) : void
		{
			while (displayContainer.numChildren)
				displayContainer.removeChildAt(0); 
		}
	}
	
}