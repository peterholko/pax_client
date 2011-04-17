package net.packet
{
	public class ItemPacket implements IPacket
	{
		public var id:int;
		public var entityId:int;
		public var playerId:int;
		public var type:int;
		public var value:int;
		
		public function ItemPacket() 
		{			
		}

	}
	
}
