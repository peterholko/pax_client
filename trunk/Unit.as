package
{
	import flash.display.Bitmap;
	
	public class Unit
	{
		public function Unit() : void
		{
		}
		
		public static function getImage(unitType:int) : Bitmap
		{
			var imageData;
			
			trace("Unit - getImage - unitType: " + unitType);
			
			switch(unitType)
			{
				case 1:
					return new Bitmap(new FootsoldierImage(0, 0));
				case 2:
					return new Bitmap(new ArcherImage(0, 0));
			}
			
			throw new Error("Invalid Unit Type");
		}
		
		public static function getName(unitType:int) : String
		{
			switch(unitType)
			{
				case 1:
					return "Footsoldier";
				case 2:
					return "Archer";
			}
			
			throw new Error("Invalid Unit Type");
		}
	}
}