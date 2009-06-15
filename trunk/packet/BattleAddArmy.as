package packet 
{
	public class BattleAddArmy implements IPacket
	{
		public var battleId:int;
		public var army:Army;
		
		public function BattleAddArmy() : void
		{
		}
	}
	
}