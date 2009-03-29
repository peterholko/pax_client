package
{
	public class UnitQueue
	{
		public var unitId:int;
		public var unitAmount:int;
		public var startTime:int;
		public var buildTime:int;
		public var remainingTime:int;
		
		public function UnitQueue () : void
		{			
		}
		
		public function setInitialRemainingTime() : void
		{
			var date:Date = new Date();
			var currentTime:int = date.getTime() / 1000;
			
			remainingTime = (startTime + buildTime) - currentTime;
		}
	}
}
