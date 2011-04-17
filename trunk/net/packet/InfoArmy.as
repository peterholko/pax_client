package net.packet
{
	public class InfoArmy implements IPacket
	{
		public var id:int;
		public var name:String;
		public var kingdomName:String;		
		public var units/*Unit*/:Array; 
		public var items:Array;
		
		public function InfoArmy() : void
		{		
		}
	}
	
}