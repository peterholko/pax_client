package net.packet
{
	
	public class ContractPacket implements IPacket
	{
		public var id:int;
		public var cityId:int;
		public var targetType:int
		public var targetId:int
		public var objectType:int;
		public var production:int;
		public var createdTime:int;
		public var lastUpdate:int;
		
		public function ContractPacket() : void
		{
			// constructor code
		}

	}
	
}
