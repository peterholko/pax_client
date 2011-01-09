package net.packet 
{
	public class ArmyPacket implements IPacket
	{
		public var id:int;
		public var playerId:int;
		public var name:String;
		public var kingdomName:String;
		public var units/*Unit*/:Array;
		
		public function ArmyPacket() 
		{
		}
		
	}
	
}