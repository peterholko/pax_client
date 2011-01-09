package game.map 
{
	public class MapObjectType 
	{
		public static var INSTANCE:MapObjectType = new MapObjectType();
		
		public static const TILE:int = 0;
		public static const ARMY:int = 1;
		public static const CITY:int = 2;
		public static const BUILDING:int = 3;
		public static const BATTLE:int = 4;
		public static const IMPROVEMENT:int = 5;
		
		public function MapObjectType() : void
		{
		}
		
	}
	
}