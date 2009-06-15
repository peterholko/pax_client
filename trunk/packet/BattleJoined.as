package packet 
{
	public class BattleJoined implements IPacket
	{
		public var battleId:int;
		public var armies/*Army*/:Array;
		
		public function BattleJoined() : void
		{
		}
		
	}
	
}