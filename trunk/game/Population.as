package game
{
	import flash.display.BitmapData;
	
	public class Population 
	{
		public static var RACE_HUMAN:int = 0;
		public static var RACE_ELF:int = 1;
		public static var RACE_DWARF:int = 2;
		public static var RACE_GOBLIN:int = 3;
		
		public static var CASTE_SLAVES:int = 0;		
		public static var CASTE_SOLDIERS:int = 1;
		public static var CASTE_COMMONERS:int = 2;
		public static var CASTE_NOBLES:int = 3;		
		
		public var cityId:int;
		public var caste:int;
		public var race:int;
		public var value:Number;

		public function Population() 
		{
			// constructor code
		}
		
		public static function getCasteName(casteType:int) : String
		{
			switch(casteType)
			{
				case CASTE_SLAVES:
					return "Slaves";
				case CASTE_SOLDIERS:
					return "Soldiers";
				case CASTE_COMMONERS:
					return "Commoners";
				case CASTE_NOBLES:
					return "Nobles";
			}
			
			return "Unknown";
		}
		
		public static function getRaceName(race:int) : String
		{
			switch(race)
			{
				case RACE_HUMAN:
					return "Human";					
				case RACE_ELF:
					return "Elf";
				case RACE_DWARF:
					return "Dwarf";
				case RACE_GOBLIN:
					return "Goblin";
			}
			
			return "Unknown";
		}
		
		public static function getCasteId(casteName:String) : int
		{
			switch(casteName)
			{
				case "Slaves":
					return CASTE_SLAVES;
				case "Soldiers":
					return CASTE_SOLDIERS;
				case "Commoners":
					return CASTE_COMMONERS;
				case "Nobles":
					return CASTE_NOBLES;
			}
			
			return -1;			
		}		
		
		public static function getImage(race:int) : BitmapData
		{
			switch(race)
			{
				case RACE_HUMAN:
					return new HumanIcon;															
					break;
				case RACE_ELF:
					return new ElfIcon;
					break;
				case RACE_DWARF:
					return new DwarfIcon;
					break;
				case RACE_GOBLIN:
					return new GoblinIcon;
			}				
			
			return null;
		}

	}
	
}
