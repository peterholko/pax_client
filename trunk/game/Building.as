package game
{
	import flash.display.BitmapData;
	
	public class Building
	{
		public static const TYPE:int = 3;
		
		public static const BARRACKS:int = 1;
		public static const MARKET:int = 2;
		public static const TEMPLE:int = 3;
		
		public var id:int = -1;
		public var hp:int;
		public var type:int;
		
		public function Building () : void
		{
		}
		
		public function getImage() : BitmapData
		{			
			trace("Building - GetImage() type: " + type);
		
			switch(type)
			{
				case BARRACKS:
					return new BarracksImage;
				case MARKET:
					return new MarketImage;
				case TEMPLE:
					return new TempleImage;
			}
			
			return null;
		}			
		
		public function getProductionCost() : int
		{
			switch(type)
			{
				case BARRACKS:
					return 100;
				case TEMPLE:
					return 100;
				case MARKET:
					return 100;
			}
			
			return Number.MAX_VALUE;
		}
	}
}