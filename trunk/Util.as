package 
{
	import flash.display.DisplayObjectContainer;
	import flash.utils.Dictionary;
	
	public class Util
	{
        public var test:int;

		public static function removeChildren(displayContainer:DisplayObjectContainer) : void
		{
			while (displayContainer.numChildren)
				displayContainer.removeChildAt(0); 
		}
		
		public static function hasId(dictionary:Dictionary, key:int) : Boolean
		{
			if (dictionary[key] != null)
				return true;
				
			return false;
		}	
	}
	
}
