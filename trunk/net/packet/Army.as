package net.packet 
{
	public class Army implements IPacket
	{
		public var id:int;
		public var playerId:int;
		public var units/*Unit*/:Array;
		
		public function Army() 
		{
		}
		
	}
	
}