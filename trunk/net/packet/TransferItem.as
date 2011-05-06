package net.packet 
{
	
	public class TransferItem implements IPacket
	{
		public var itemId:int;
		public var sourceId:int;
		public var sourceType:int; 
		public var targetId:int;
		public var targetType:int;
		
		public function TransferItem() : void
		{		
		}
	}
	
}
