package net.packet 
{
	public class BattleTarget implements IPacket
	{
		public var battleId:int;
		public var sourceArmyId:int;
		public var sourceUnitId:int;
		public var targetArmyId:int;
		public var targetUnitId:int;
		
		public function BattleTarget() 
		{
		}
		
	}
	
}