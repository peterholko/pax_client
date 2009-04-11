package
{
	import flash.display.Bitmap;
	import flash.display.MovieClip;
	
	public class Unit
	{
		public static var LAND:int = 1;
		public static var SEA:int = 2;
		public static var AIR:int = 3;
		
		public static var FOOTSOLDIER:int = 1;
		public static var ARCHER:int = 2;
		
		public var id:int;
		public var type:int;
		public var size:int;
		public var startTime:int;
		public var endTime:int;
		public var remainingTime:int;		
		
		public function Unit() : void
		{
		}
		
		public static function getImage(unitType:int) : MovieClip
		{
			var imageData;
			
			trace("Unit - getImage - unitType: " + unitType);
			
			switch(unitType)
			{
				case FOOTSOLDIER:
					return new Footsoldier();
				case ARCHER:
					return new Archer();
			}
			
			throw new Error("Invalid Unit Type");
		}
		
		public static function getName(unitType:int) : String
		{
			switch(unitType)
			{
				case FOOTSOLDIER:
					return "Footsoldier";
				case ARCHER:
					return "Archer";
			}
			
			throw new Error("Invalid Unit Type");
		}
	}
}