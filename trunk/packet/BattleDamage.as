package net.packet  
{
	public class BattleDamage implements IPacket
	{
		public var battleId:int;
		public var sourceId:int;
		public var targetId:int;
		public var damage:int;
		
		public function BattleDamage() : void
		{		
		}
	}
	
}