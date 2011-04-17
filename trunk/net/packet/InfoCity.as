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
		public var claims:Array;
		public var improvements:Array;
		public var assignments:Array;
		public var items:Array;
		public var populations:Array;
		
		public function InfoCity() : void
		{		
		}
	}
	
}