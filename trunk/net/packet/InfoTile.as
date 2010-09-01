package net.packet
{
	public class InfoTile implements IPacket
	{
		public var tileIndex:int;
		public var tileType:int;
		public var resources:/*Resource*/Array;
		
		public function InfoTile() : void
		{		
		}
	}
	
}