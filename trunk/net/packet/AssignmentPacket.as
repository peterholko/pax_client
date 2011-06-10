package net.packet
{
	public class AssignmentPacket implements IPacket
	{
		public var id:int;
		public var caste:int;
		public var race:int;
		public var amount:int;		
		public var targetId:int;
		public var targetType:int;
		
		public function AssignmentPacket() : void
		{		
		}
	}
	
}