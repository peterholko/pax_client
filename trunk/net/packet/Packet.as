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
		public static var SUCCESS:int = 20;
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
		public static var TRANSFER_UNIT:int = 61;
		public static var BATTLE_INFO:int = 70;
		public static var BATTLE_ADD_ARMY:int = 71;
		public static var BATTLE_REMOVE_ARMY:int = 72;
		public static var BATTLE_DAMAGE:int = 74;
		public static var BATTLE_TARGET:int = 75;
		public static var BATTLE_RETREAT:int = 76;
		public static var BATTLE_LEAVE:int = 77;
		public static var CITY_QUEUE_UNIT:int = 100;				
		public static var CITY_QUEUE_BUILDING:int = 101;
		public static var CITY_QUEUE_IMPROVEMENT:int = 102;		
		public static var CITY_QUEUE_ITEM:int = 103;
		public static var ADD_CLAIM:int = 125;		
		public static var ASSIGN_TASK:int = 130;
		public static var TRANSFER_ITEM:int = 150;
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
		
		public static function sendCityQueueBuilding(socket:Socket, cityQueueBuilding:CityQueueBuilding) : void
		{
			trace("Packet - sendCityQueueBuilding");
			socket.writeByte(CITY_QUEUE_BUILDING);
			socket.writeInt(cityQueueBuilding.cityId);	
			socket.writeShort(cityQueueBuilding.buildingType);
			socket.flush();
		}
		
		public static function sendCityQueueImprovement(socket:Socket, cityQueueImprovement:CityQueueImprovement) : void
		{
			trace("Packet - sendCityQueueImprovement");
			socket.writeByte(CITY_QUEUE_IMPROVEMENT);
			socket.writeInt(cityQueueImprovement.cityId);
			socket.writeShort(cityQueueImprovement.x);
			socket.writeShort(cityQueueImprovement.y);
			socket.writeShort(cityQueueImprovement.type);
			socket.flush();
		}		
		
		public static function sendCityQueueItem(socket:Socket, cityQueueItem:CityQueueItem) : void
		{
			trace("Packet - sendCityQueueItem");
			trace("itemType: " + cityQueueItem.itemType + " itemSize: " + cityQueueItem.itemSize);
			socket.writeByte(CITY_QUEUE_ITEM);
			socket.writeInt(cityQueueItem.cityId);	
			socket.writeShort(cityQueueItem.itemType);
			socket.writeInt(cityQueueItem.itemSize);
			socket.flush();
		}		
		
		public static function sendTransferUnit(socket:Socket, transferUnit:TransferUnit) : void
		{
			trace("Packet - sendTransferUnit");
			socket.writeByte(TRANSFER_UNIT);
			socket.writeInt(transferUnit.unitId);
			socket.writeInt(transferUnit.sourceId);
			socket.writeShort(transferUnit.sourceType);
			socket.writeInt(transferUnit.targetId);
			socket.writeShort(transferUnit.targetType);
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
		
		public static function sendAssignTask(socket:Socket, assignTask:AssignTask) : void
		{
			trace("Packet - sendAssignTask");
			socket.writeByte(ASSIGN_TASK);
			socket.writeInt(assignTask.cityId);
			socket.writeByte(assignTask.caste);
			socket.writeByte(assignTask.race);
			socket.writeInt(assignTask.amount);
			socket.writeInt(assignTask.targetId);
			socket.writeShort(assignTask.targetType);
			socket.flush();
		}
		
		public static function sendTransferItem(socket:Socket, transferItem:TransferItem) : void
		{
			trace("Packet - sendTransferItem");
			socket.writeByte(TRANSFER_ITEM);
			socket.writeInt(transferItem.itemId);
			socket.writeInt(transferItem.sourceId);
			socket.writeShort(transferItem.sourceType);
			socket.writeInt(transferItem.targetId);
			socket.writeShort(transferItem.targetType);
			socket.flush();
		}
		
		public static function readSuccess(byteArray:ByteArray) : Success
		{
			var success:Success = new Success();
			success.type = byteArray.readUnsignedShort();
			success.id = byteArray.readInt()
			
			return success;
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
				mapObject.subType = byteArray.readUnsignedShort();
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
			var i:int = 0;
			var army:InfoArmy = new InfoArmy();
			army.id = byteArray.readInt();
			army.name = byteArray.readUTF();
			army.kingdomName = byteArray.readUTF();
			army.units = new Array();
			army.items = new Array();
			
			var numUnits:int = byteArray.readUnsignedShort();
			
			for (i = 0; i < numUnits; i++)
			{
				var unit:UnitPacket = new UnitPacket();
				unit.id = byteArray.readInt();
				unit.type = byteArray.readUnsignedShort();
				unit.size = byteArray.readInt();
				
				army.units.push(unit);
			}
			
			var numItems:int = byteArray.readUnsignedShort();
			
			for(i = 0; i < numItems; i++)
			{
				var item:ItemPacket = new ItemPacket();
				item.id = byteArray.readInt();
				item.entityId = byteArray.readInt();
				item.playerId = byteArray.readInt();
				item.type = byteArray.readShort();
				item.value = byteArray.readInt();						
				
				army.items.push(item);
			}
			
			return army;
		}
		
		public static function readInfoCity(byteArray:ByteArray) : InfoCity
		{
			var infoCity:InfoCity = new InfoCity();			
			var buildingList:Array = new Array();			
			var unitList:Array = new Array();		
			var claimList:Array = new Array();
			var improvementList:Array = new Array();
			var assignmentList:Array = new Array();
			var itemList:Array = new Array();
			var populationList:Array = new Array();
			var contractList:Array = new Array();
			
			var i:int;
			
			infoCity.id = byteArray.readInt();
			infoCity.name = byteArray.readUTF();
			
			var numBuildings:int = byteArray.readUnsignedShort();
			
			for (i = 0; i < numBuildings; i++)
			{	
				var buildingInfo:Object = { id: byteArray.readInt(),
											hp: byteArray.readInt(),
											type: byteArray.readUnsignedShort() };
				
				buildingList.push(buildingInfo);
			}
						
			var numUnits:int = byteArray.readUnsignedShort();
			
			for (i = 0; i < numUnits; i++)
			{
				var unitInfo:Object = { id: byteArray.readInt(),
										type: byteArray.readUnsignedShort(),
										size: byteArray.readInt()};
										
				unitList.push(unitInfo);
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
			
			var numImprovements:int = byteArray.readUnsignedShort();
			
			for(i = 0; i < numImprovements; i++)
			{
				var improvement:Object = {id: byteArray.readInt(),
										  type: byteArray.readShort()};
										  
				improvementList.push(improvement);										  
			}
			
			var numAssignments:int = byteArray.readUnsignedShort();

			for(i = 0; i < numAssignments; i++)
			{
				var assignment:AssignmentPacket = new AssignmentPacket();
				assignment.id = byteArray.readInt();
				assignment.caste = byteArray.readByte();
				assignment.race = byteArray.readByte();
				assignment.amount = byteArray.readInt();
				assignment.targetId = byteArray.readInt();
				assignment.targetType = byteArray.readShort();										
										  
				assignmentList.push(assignment);										  
			}					
						
			var numItems:int = byteArray.readUnsignedShort();

			for(i = 0; i < numItems; i++)
			{
				var item:ItemPacket = new ItemPacket();
				item.id = byteArray.readInt();
				item.entityId = byteArray.readInt();
				item.playerId = byteArray.readInt();
				item.type = byteArray.readShort();
				item.value = byteArray.readInt();
				
				itemList.push(item);
			}
			
			var numPopulations:int = byteArray.readUnsignedShort();
			
			for(i = 0; i < numPopulations; i++)
			{
				var population:PopulationPacket = new PopulationPacket();
				population.cityId = byteArray.readInt();
				population.caste = byteArray.readByte();
				population.race = byteArray.readByte();
				population.value = byteArray.readInt();				
				
				populationList.push(population);
			}
			
			var numContracts:int = byteArray.readUnsignedShort();
				
			for(i = 0; i < numContracts; i++)
			{
				var contract:ContractPacket = new ContractPacket();
				contract.id = byteArray.readInt();
				contract.cityId = byteArray.readInt();
				contract.type = byteArray.readShort();
				contract.targetType = byteArray.readShort();
				contract.targetId = byteArray.readInt();
				contract.objectType = byteArray.readShort();
				contract.production = byteArray.readInt();
				contract.createdTime = byteArray.readInt();
				contract.lastUpdate = byteArray.readInt();
				
				contractList.push(contract);
			}
								
			infoCity.buildings = buildingList;			
			infoCity.units = unitList;			
			infoCity.claims = claimList;
			infoCity.improvements = improvementList;
			infoCity.assignments = assignmentList;
			infoCity.items = itemList;
			infoCity.populations = populationList;
			infoCity.contracts = contractList;
								
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
			trace("readBattleInfo");
			var battleInfo:BattleInfo = new BattleInfo();
			battleInfo.battleId = byteArray.readInt();
			battleInfo.armies = new Array();
			
			var numArmies:int = byteArray.readUnsignedShort();
			for (var i:int = 0 ; i < numArmies; i++)
			{
				var army:ArmyPacket = new ArmyPacket();

				army.id = byteArray.readInt();
				army.playerId = byteArray.readInt();				
				army.name = byteArray.readUTF();
				army.kingdomName = byteArray.readUTF();				
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
			trace("readBattleAddArmy");
			var battleAddArmy:BattleAddArmy = new BattleAddArmy();
			battleAddArmy.army = new ArmyPacket();			
			
			battleAddArmy.battleId = byteArray.readInt();
			battleAddArmy.army.id = byteArray.readInt();
			battleAddArmy.army.playerId = byteArray.readInt();
			battleAddArmy.army.name = byteArray.readUTF();
			battleAddArmy.army.kingdomName = byteArray.readUTF();							
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
			trace("readBattleDamage");
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
				
				
				case 1:
					msg = "Bad Login";
					break;
				default:
					msg = "Unknown";
			}
			
			return msg;
		}
	}
}
	