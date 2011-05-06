package game
{
	import flash.display.BitmapData;

	public class Item 
	{
		public static var PLANTS:int = 0;
		
		public var id:int;
		public var entityId:int;
		public var type:int;
		public var value:int;

		public function Item() 
		{
		}
		
		
		public function getImage() : BitmapData
		{
			trace("Item - GetImage()");
			trace("type: " + type);
			
			switch(type)
			{
				case PLANTS:
					return new PlantImage;
			}
			
			return null;
		}		

	}
	
}
