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
		
		public static function getName(type:int) : String
		{
			switch(type)
			{
				case BARRACKS:
					return "Barracks";
				case MARKET:
					return "Market";
				case TEMPLE:
					return "Temple";
			}
			
			return "None";
		}
		
		public function getBuildingName() : String
		{
			return getName(type);
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
					return 20;
				case TEMPLE:
					return 5;
				case MARKET:
					return 4;
			}
			
			return Number.MAX_VALUE;
		}
	}
}