package net.packet 
{
	public class BattleAddArmy implements IPacket
	{
		public var battleId:int;
		public var army:ArmyPacket;
		
		public function BattleAddArmy() : void
		{
		}
	}
	
}