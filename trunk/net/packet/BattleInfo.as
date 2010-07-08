package net.packet 
{
	public class BattleInfo implements IPacket
	{
		public var battleId:int;
		public var armies/*Army*/:Array;
		
		public function BattleJoined() : void
		{
		}
		
	}
	
}