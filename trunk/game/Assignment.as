package game 
{	

	public class Assignment
	{		
		public static var TASK_BUILDING:int = 0;
		public static var TASK_UNIT:int = 1;
		public static var TASK_IMPROVEMENT:int = 2;
		public static var TASK_ITEM:int = 3;
	
		public var id:int;
		public var cityId:int;
		public var caste:int;
		public var race:int;
		public var amount:int;
		public var targetId:int;
		public var targetType:int;

		public function Assignment() 
		{			
		}

	}
	
}
