package
{
	import flash.net.Socket;
	import flash.system.*;
	import flash.utils.Endian;
	import flash.utils.ByteArray;	
	
	public class Packet 
	{
		//Packet identifier
		public static var LOGIN:int = 1;
		public static var LOGOUT:int = 2;
		public static var CLOCKSYNC:int = 3;
		public static var CLIENTREADY:int = 4;
		public static var PLAYER_ID:int = 5;
		public static var EXPLORED_MAP:int = 39;
		public static var PERCEPTION:int = 40;
		public static var MOVE:int = 42;
		public static var ATTACK:int = 43;	
		public static var REQUEST_INFO:int = 50;
		public static var INFO_ARMY:int = 52; 
		public static var INFO_CITY:int = 53; 
		public static var BAD:int = 255;
		
		//Errors
		public static var ERR_BAD_LOGIN:int = 1;
		
		public function Packet() : void
		{
		}			
		
		public static function sendClockSync(socket:Socket) : void
		{
			socket.writeByte(CLOCKSYNC);
			socket.flush();			
		}
		
		public static function sendLogin(socket:Socket, account:String, password:String) : void
		{
			socket.writeByte(LOGIN);
			socket.writeUTF(account);		
			socket.writeUTF(password);		
			socket.flush();		
		}
		
		public static function sendClientReady(socket:Socket) : void
		{
			socket.writeByte(CLIENTREADY);
			socket.flush();
		}
		
		public static function sendMove(socket:Socket, id:int, xPos:int, yPos:int) : void
		{
			trace("Packet - sendMove");
			socket.writeByte(MOVE);
			socket.writeInt(id);
			socket.writeShort(xPos);
			socket.writeShort(yPos);
			socket.flush();
		}
		
		public static function sendAttack(socket:Socket, id:int, targetId:int) : void
		{
			trace("Packet - sendAttack");
			socket.writeByte(ATTACK);
			socket.writeInt(id);
			socket.writeInt(targetId);
			socket.flush();
		}	
		
		public static function sendRequestInfo(socket:Socket, type:int, targetId:int) : void
		{
			trace("Packet - sendRequestInfo");
			socket.writeByte(REQUEST_INFO);
			socket.writeShort(type);
			socket.writeInt(targetId);
			socket.flush();
		}
		
		public static function readBad(byteArray:ByteArray) : String
		{
			var cmd:int = byteArray.readUnsignedByte();
			var error:int = byteArray.readUnsignedByte();
			var msg:String = "Command: " + Packet.getCmd(cmd) + " - Error: " + Packet.getError(error);
					
			return msg;
		}
		
		public static function readExploredMap(byteArray:ByteArray) : Array
		{
			var numTiles:int = byteArray.readInt();
			var exploredMap:Array = new Array();
						
			for(var i:int = 0; i < numTiles; i++)
			{			
				var tileInfo:Object = {tileIndex: byteArray.readInt(), tile: byteArray.readUnsignedByte()};
				exploredMap.push(tileInfo);
			}
			
			return exploredMap;
		}
		
		public static function readPerception(byteArray:ByteArray) : Object
		{
			var numEntities:int = byteArray.readUnsignedShort();
			var entityList:Array = new Array();
			var i:int;
							
			for(i = 0; i < numEntities; i++)
			{
				var entityInfo:Object = {id: byteArray.readInt(), 
										playerId: byteArray.readInt(),
										type: byteArray.readUnsignedShort(),
										state: byteArray.readUnsignedShort(),
										x: byteArray.readUnsignedShort(),
										y: byteArray.readUnsignedShort()};
							
				entityList.push(entityInfo);
			}			
			
			var numTiles:int = byteArray.readInt();
			var tileList:Array = new Array();
			
			for(i = 0; i < numTiles; i++)
			{
				var tileInfo:Object = {tileIndex: byteArray.readInt(), tile: byteArray.readUnsignedByte()};
				tileList.push(tileInfo);
			}
			
			var perception:Object = {entities: entityList, tiles: tileList};
			
			return perception;
		}
		
		public static function readInfoArmy(byteArray:ByteArray) : Object
		{
			var heroId:int = byteArray.readInt();
			var numUnits:int = byteArray.readUnsignedShort();
			var unitList:Array = new Array();
			
			for (var i:int = 0; i < numUnits; i++)
			{
				var unitInfo:Object = { id: byteArray.readInt(),
										type: byteArray.readUTF(),
										size: byteArray.readInt() };
				
				unitList.push(unitInfo);
			}
			
			var infoArmy:Object = { hero: heroId, units: unitList };
			
			return infoArmy;
		}
		
		public static function readInfoCity(byteArray:ByteArray) : Object
		{
			var numBuildings:int = byteArray.readUnsignedShort();
			var buildingList:Array = new Array();
			
			for (var i:int = 0; i < numBuildings; i++)
			{
				var buildingInfo:Object = { id: byteArray.readInt()};
				
				buildingList.push(buildingInfo);
			}
			
			var infoCity:Object = { buildings: buildingList };
			
			return infoCity;
		}	
		
		public static function getCmd(cmd:int) : String
		{
			var msg:String = "";
			
			switch(cmd)
			{
				case 1:
					msg = "Login";
					break;
				case 4:
					msg = "Bad";
					break;
				default:
					msg = "Unknown";
			}
			
			return msg;				
		}
		
		public static function getError(error:int) : String
		{
			var msg:String = "";
			
			switch(error)
			{
				case 255:
					msg = "Bad Login";
					break;
				default:
					msg = "Unknown";
			}
			
			return msg;
		}
	}
}
	