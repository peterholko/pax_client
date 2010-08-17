package net.packet
{
	public class InfoCity implements IPacket
	{
		public var id:int;
		public var name:String;
		public var buildings:Array
		public var buildingsQueue:Array
		public var units/*Unit*/:Array;
		public var unitsQueue:Array;
		
		public function InfoCity() : void
		{		
		}
	}
	
}