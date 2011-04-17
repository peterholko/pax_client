package net.packet
{
	public class AssignTask implements IPacket
	{
		public var cityId:int;
		public var populationId:int;
		public var amount:int;
		public var taskId:int;
		public var taskType:int;
		
		public function AssignTask() : void
		{		
		}
	}
	
}