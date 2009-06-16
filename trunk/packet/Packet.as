package net.packet
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
		public static var INFO_UNIT_QUEUE:int = 55;
		public static var CITY_QUEUE_UNIT:int = 60;
		public static var TRANSFER_UNIT:int = 61;
		public static var ADD_TARGET:int = 85;
		public static var BATTLE_JOINED:int = 70;
		public static var BATTLE_ADD_ARMY:int = 71;
		public static var BATTLE_DAMAGE:int = 72;
		public static var BATTLE_TARGET:int = 72;
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
		
		public static function sendCityQueueUnit(socket:Socket, cityId:int, unitType:int, unitSize:int) : void
		{
			trace("Packet - sendCityQueueUnit");
			socket.writeByte(CITY_QUEUE_UNIT);
			socket.writeInt(cityId);
			socket.writeShort(unitType);
			socket.writeInt(unitSize);
			socket.flush();
		}
		
		public static function sendTransferUnit(socket:Socket, unitId:int, sourceId:int, sourceType:int, targetId:int, targetType:int) : void
		{
			trace("Packet - sendTransferUnit");
			socket.writeByte(TRANSFER_UNIT);
			socket.writeInt(unitId);
			socket.writeInt(sourceId);
			socket.writeShort(sourceType);
			socket.writeInt(targetId);
			socket.writeShort(targetType);
			socket.flush();
		}
		
		public static function sendBattleTarget(socket:Socket, battleId:int, sourceArmyId:int, sourceUnitId:int, targetArmyId:int, targetUnitId:int) : void
		{
			trace("Packet - sendBattleTarget");
			socket.writeByte(ADD_TARGET);
			socket.writeInt(battleId);
			socket.writeInt(sourceArmyId);
			socket.writeInt(sourceUnitId);
			socket.writeInt(targetArmyId);
			socket.writeInt(targetUnitId);
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
		
		public static function readInfoArmy(byteArray:ByteArray) : InfoArmy
		{
			var infoArmy:InfoArmy = new InfoArmy();
			infoArmy.id = byteArray.readInt();
			infoArmy.units = new Array();
			
			var numUnits:int = byteArray.readUnsignedShort();
			
			for (var i:int = 0; i < numUnits; i++)
			{
				var unit:Unit = new Unit();
				unit.id = byteArray.readInt();
				unit.type = byteArray.readUnsignedShort();
				unit.size = byteArray.readInt();
				
				infoArmy.units.push(unit);
			}
			
			return infoArmy;
		}
		
		public static function readInfoCity(byteArray:ByteArray) : Object
		{
			var cityId:int = byteArray.readInt();
			var buildingList:Array = new Array();
			var unitList:Array = new Array();
			var unitQueueList:Array = new Array();
			var i:int;
			
			var numBuildings:int = byteArray.readUnsignedShort();
			
			for (i = 0; i < numBuildings; i++)
			{	
				buildingList.push(byteArray.readInt());
			}
			
			var numUnits:int = byteArray.readUnsignedShort();
			
			for (i = 0; i < numUnits; i++)
			{
				var unitInfo:Object = { id: byteArray.readInt(),
										type: byteArray.readUnsignedShort(),
										size: byteArray.readInt()};
										
				unitList.push(unitInfo);
			}
			
			var numUnitQueues:int = byteArray.readUnsignedShort();
			
			for (i = 0; i < numUnitQueues; i++)
			{
				var unitQueueInfo:Object = {id: byteArray.readInt(),
											type: byteArray.readUnsignedShort(),
											size: byteArray.readInt(),
											startTime: byteArray.readInt(),
											endTime: byteArray.readInt() };
											
				unitQueueList.push(unitQueueInfo);											
			}
								
			var infoCity:Object = { id: cityId, 
									buildings: buildingList, 
									units: unitList,
									unitsQueue: unitQueueList};			
			return infoCity;
		}	
		
		public static function readBattleJoined(byteArray:ByteArray) : BattleJoined
		{
			var battleJoined:BattleJoined = new BattleJoined();
			battleJoined.battleId = byteArray.readInt();
			battleJoined.armies = new Array();
			
			var numArmies:int = byteArray.readUnsignedShort();
			for (var i:int = 0 ; i < numArmies; i++)
			{
				var army:Army = new Army();

				army.id = byteArray.readInt();
				army.playerId = byteArray.readInt();
				army.units = new Array();
				
				var numUnits:int = byteArray.readUnsignedShort();
				
				for (var j:int = 0; j < numUnits; j++)
				{
					var unit:Unit = new Unit();
					unit.id = byteArray.readInt();
					unit.type = byteArray.readUnsignedShort();
					unit.size = byteArray.readInt();
					
					army.units.push(unit);
				}
				
				battleJoined.armies.push(army);
			}
			
			return battleJoined;
		}
		
		public static function readBattleAddArmy(byteArray:ByteArray) : BattleAddArmy
		{
			var battleAddArmy:BattleAddArmy = new BattleAddArmy();
			battleAddArmy.army = new Army();			
			
			battleAddArmy.battleId = byteArray.readInt();
			battleAddArmy.army.id = byteArray.readInt();
			battleAddArmy.army.playerId = byteArray.readInt();
			battleAddArmy.army.units = new Array();
			
			var numUnits:int = byteArray.readUnsignedShort();				
			for (var j:int = 0; j < numUnits; j++)
			{
				var unit:Unit = new Unit();
				unit.id = byteArray.readInt();
				unit.type = byteArray.readUnsignedShort();
				unit.size = byteArray.readInt();
				
				battleAddArmy.army.units.push(unit);
			}			
			
			return battleAddArmy;
		}
		
		public static function readBattleDamage(byteArray:ByteArray) : BattleDamage
		{
			var battleDamage:BattleDamage = new BattleDamage();
			
			battleDamage.battleId = byteArray.readInt();
			battleDamage.sourceId = byteArray.readInt();
			battleDamage.targetId = byteArray.readInt();
			battleDamage.damage = byteArray.readInt();
			
			return battleDamage;
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
	