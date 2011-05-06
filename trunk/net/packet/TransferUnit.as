package net.packet
{
	public class TransferUnit implements IPacket
	{
		public var unitId:int;
		public var sourceId:int;
		public var sourceType:int; 
		public var targetId:int;
		public var targetType:int;
		
		public function TransferUnit() : void
		{		
		}
	}
	
}