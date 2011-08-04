package game
{
	public class Contract
	{
		public static var CONTRACT_BUILDING:int = 0;
		public static var CONTRACT_UNIT:int = 1;
		public static var CONTRACT_IMPROVEMENT:int = 2;
		public static var CONTRACT_ITEM:int = 3;
		
		public var id:int;
		public var cityId:int;
		public var type:int;
		public var targetType:int
		public var targetId:int;
		public var objectType:int;
		public var production:int;
		public var createdTime:int;
		public var lastUpdate:int;
		
		public function Contract () : void
		{			
		}
	}
}
