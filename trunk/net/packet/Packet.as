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
		public static var INFO_KINGDOM:int = 6;
		public static var EXPLORED_MAP:int = 39;
		public static var PERCEPTION:int = 40;
		public static var MOVE:int = 42;
		public static var ATTACK:int = 43;	
		public static var REQUEST_INFO:int = 50;
		public static var INFO_TILE:int = 52;		
		public static var INFO_ARMY:int = 53; 
		public static var INFO_CITY:int = 54; 
		public static var INFO_UNIT_QUEUE:int = 55;
		public static var INFO_GENERIC_ARMY:int = 56;
		public static var INFO_GENERIC_CITY:int = 57;
		public static var CITY_QUEUE_UNIT:int = 60;
		public static var TRANSFER_UNIT:int = 61;
		public static var BATTLE_INFO:int = 70;
		public static var BATTLE_ADD_ARMY:int = 71;
		public static var BATTLE_DAMAGE:int = 72;
		public static var BATTLE_TARGET:int = 73;
		public static var BUILD_IMPROVEMENT:int = 100;		
		public static var ADD_CLAIM:int = 125;		
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
		
		public static function sendBattleTarget(socket:Socket, battleTarget:BattleTarget) : void
		{
			trace("Packet - sendBattleTarget");
			socket.writeByte(BATTLE_TARGET);
			socket.writeInt(battleTarget.battleId);
			socket.writeInt(battleTarget.sourceArmyId);
			socket.writeInt(battleTarget.sourceUnitId);
			socket.writeInt(battleTarget.targetArmyId);
			socket.writeInt(battleTarget.targetUnitId);
			socket.flush();
		}
		
		public static function sendAddClaim(socket:Socket, addClaim:AddClaim) : void
		{
			trace("Packet - sendAddClaim");
			socket.writeByte(ADD_CLAIM);
			socket.writeInt(addClaim.cityId);
			socket.writeShort(addClaim.x);
			socket.writeShort(addClaim.y);
			socket.flush();
		}
		
		public static function sendBuildImprovement(socket:Socket, buildImprovement:BuildImprovement) : void
		{
			trace("Packet - sendBuildImprovement");
			socket.writeByte(BUILD_IMPROVEMENT);
			socket.writeInt(buildImprovement.cityId);
			socket.writeShort(buildImprovement.x);
			socket.writeShort(buildImprovement.y);
			socket.writeShort(buildImprovement.type);
			socket.flush();
		}
		
		public static function readBad(byteArray:ByteArray) : String
		{
			var cmd:int = byteArray.readUnsignedByte();
			var error:int = byteArray.readUnsignedByte();
			var msg:String = "Command: " + Packet.getCmd(cmd) + " - Error: " + Packet.getError(error);
					
			return msg;
		}
		
		public static function readInfoKingdom(byteArray:ByteArray) : InfoKingdom
		{
			var infoKingdom:InfoKingdom = new InfoKingdom();
			infoKingdom.id = byteArray.readInt();
			infoKingdom.name = byteArray.readUTF();
			infoKingdom.gold = byteArray.readInt();
			
			return infoKingdom;
		}
		
		public static function readExploredMap(byteArray:ByteArray) : Array
		{
			var numTiles:int = byteArray.readInt();
			var exploredMap/*MapTiles*/:Array = new Array();
						
			for(var i:int = 0; i < numTiles; i++)
			{			
				var mapTile:MapTile = new MapTile();
				
				mapTile.index = byteArray.readInt();
				mapTile.tile = byteArray.readUnsignedByte();				

				exploredMap.push(mapTile);
			}
			
			return exploredMap;
		}
		
		public static function readPerception(byteArray:ByteArray) : Perception
		{
			var perception:Perception = new Perception();
			perception.mapObjects = new Array();
			perception.mapTiles = new Array();
			
			var numEntities:int = byteArray.readUnsignedShort();
							
			for(var i = 0; i < numEntities; i++)
			{
				var mapObject:MapObject = new MapObject();
				
				mapObject.id = byteArray.readInt();
				mapObject.playerId = byteArray.readInt();
				mapObject.type = byteArray.readUnsignedShort();
				mapObject.state = byteArray.readUnsignedShort();
				mapObject.x = byteArray.readUnsignedShort();
				mapObject.y = byteArray.readUnsignedShort();
							
				perception.mapObjects.push(mapObject);
			}			
			
			var numTiles:int = byteArray.readInt();
			
			for(var i = 0; i < numTiles; i++)
			{
				var mapTile:MapTile = new MapTile();
				
				mapTile.index = byteArray.readInt();
				mapTile.tile = byteArray.readUnsignedByte();
			
				trace("mapTile: " + mapTile.index);
				
				perception.mapTiles.push(mapTile);
			}
			
			return perception;
		}
		
		public static function readInfoTile(byteArray:ByteArray) : InfoTile
		{		
			var infoTile:InfoTile = new InfoTile();
			var resourceList/*Resource*/:Array = new Array();
			
			infoTile.tileIndex = byteArray.readInt();
			infoTile.tileType = byteArray.readUnsignedShort();
			
			var numResources:int = byteArray.readUnsignedShort();
			
			for (var i:int = 0; i < numResources; i++)
			{	
				var resource:Resource = new Resource();
				resource.id = byteArray.readInt();
				resource.type = byteArray.readUnsignedShort();
				resource.total = byteArray.readInt();
				resource.regen_rate = byteArray.readInt();
				
				resourceList.push(resource);
			}
			
			infoTile.resources = resourceList;
			
			return infoTile;
		}		
		
		public static function readInfoArmy(byteArray:ByteArray) : InfoArmy
		{
			var army:InfoArmy = new InfoArmy();
			army.id = byteArray.readInt();
			army.name = byteArray.readUTF();
			army.kingdomName = byteArray.readUTF();
			army.units = new Array();
			
			var numUnits:int = byteArray.readUnsignedShort();
			
			for (var i:int = 0; i < numUnits; i++)
			{
				var unit:UnitPacket = new UnitPacket();
				unit.id = byteArray.readInt();
				unit.type = byteArray.readUnsignedShort();
				unit.size = byteArray.readInt();
				
				army.units.push(unit);
			}
			
			return army;
		}
		
		public static function readInfoCity(byteArray:ByteArray) : InfoCity
		{
			var infoCity:InfoCity = new InfoCity();			
			var buildingList:Array = new Array();
			var buildingQueueList:Array = new Array();
			var unitList:Array = new Array();
			var unitQueueList:Array = new Array();
			var claimList:Array = new Array();
			var i:int;
			
			infoCity.id = byteArray.readInt();
			infoCity.name = byteArray.readUTF();
			
			var numBuildings:int = byteArray.readUnsignedShort();
			
			for (i = 0; i < numBuildings; i++)
			{	
				var buildingInfo:Object = { id: byteArray.readInt(),
											type: byteArray.readUnsignedShort() };
				
				buildingList.push(buildingInfo);
			}
			
			var numBuildingQueues:int = byteArray.readUnsignedShort();
			
			for (i = 0; i < numBuildingQueues; i++)
			{
				var buildingQueueInfo:Object = {id: byteArray.readInt(),
												type: byteArray.readUnsignedShort(),
												startTime: byteArray.readInt(),
												endTime: byteArray.readInt() };
												
				buildingQueueList.push(buildingQueueInfo);
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
			
			var numClaims:int = byteArray.readUnsignedShort();
			
			for(i = 0; i < numClaims; i++)
			{
				var claim:ClaimPacket = new ClaimPacket();
				claim.id = byteArray.readInt();
				claim.tileIndex = byteArray.readInt();
				claim.cityId = byteArray.readInt();
				
				claimList.push(claim);
			}
								
			infoCity.buildings = buildingList;
			infoCity.buildingsQueue = buildingQueueList;
			infoCity.units = unitList;
			infoCity.unitsQueue = unitQueueList;
			infoCity.claims = claimList;
								
			return infoCity;
		}
		
		public static function readInfoGenericArmy(byteArray:ByteArray) : InfoGenericArmy
		{
			var army:InfoGenericArmy = new InfoGenericArmy();
			army.id = byteArray.readInt();
			army.playerId = byteArray.readInt();
			army.name = byteArray.readUTF();
			army.kingdomName = byteArray.readUTF();
		
			return army;
		}
		
		public static function readInfoGenericCity(byteArray:ByteArray) : InfoGenericCity
		{
			var city:InfoGenericCity = new InfoGenericCity();
			city.id = byteArray.readInt();
			city.playerId = byteArray.readInt();
			city.name = byteArray.readUTF();
			city.kingdomName = byteArray.readUTF();
		
			return city;
		}		
		
		public static function readBattleInfo(byteArray:ByteArray) : BattleInfo
		{
			var battleInfo:BattleInfo = new BattleInfo();
			battleInfo.battleId = byteArray.readInt();
			battleInfo.armies = new Array();
			
			var numArmies:int = byteArray.readUnsignedShort();
			for (var i:int = 0 ; i < numArmies; i++)
			{
				var army:ArmyPacket = new ArmyPacket();

				army.id = byteArray.readInt();
				army.playerId = byteArray.readInt();
				army.units = new Array();
				
				var numUnits:int = byteArray.readUnsignedShort();
				
				for (var j:int = 0; j < numUnits; j++)
				{
					var unit:UnitPacket = new UnitPacket();
					unit.id = byteArray.readInt();
					unit.type = byteArray.readUnsignedShort();
					unit.size = byteArray.readInt();
					
					army.units.push(unit);
				}
				
				battleInfo.armies.push(army);
			}
			
			return battleInfo;
		}
		
		public static function readBattleAddArmy(byteArray:ByteArray) : BattleAddArmy
		{
			var battleAddArmy:BattleAddArmy = new BattleAddArmy();
			battleAddArmy.army = new ArmyPacket();			
			
			battleAddArmy.battleId = byteArray.readInt();
			battleAddArmy.army.id = byteArray.readInt();
			battleAddArmy.army.playerId = byteArray.readInt();
			battleAddArmy.army.units = new Array();
			
			var numUnits:int = byteArray.readUnsignedShort();				
			for (var j:int = 0; j < numUnits; j++)
			{
				var unit:UnitPacket = new UnitPacket();
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
	