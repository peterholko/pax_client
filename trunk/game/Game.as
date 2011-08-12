package game
{
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.MouseEvent;	
	import flash.events.KeyboardEvent;
	import flash.utils.getTimer;
	import flash.utils.Timer;
	import flash.events.EventPhase;
	import flash.events.Event;
	import flash.geom.Rectangle;
	import net.packet.BattleTarget;
	import net.packet.Perception;
	
	import Main;
	
	import game.battle.Battle;
	import game.battle.BattleManager;
	import game.entity.City;
	import game.entity.Army;
	import game.entity.Entity;
	import game.perception.PerceptionManager
	import game.map.Map;
	import game.map.MapObjectType;
	import game.map.MapBattle;
	import game.map.Tile;

	import ui.ArmyUI;
	import ui.CityUI;
	import ui.LandDetailCard;

	import net.Connection;
	import net.packet.InfoKingdom;
	import net.packet.InfoTile;
	import net.packet.BattleInfo;
	import net.packet.BattleAddArmy;
	import net.packet.BattleDamage;	
	import net.packet.AddClaim;
	import net.packet.Success;	
	import net.packet.AssignTask;	
	import net.packet.TransferUnit;
	import net.packet.TransferItem;
	import net.packet.CityQueueBuilding;
	import net.packet.CityQueueItem;
	import net.packet.CityQueueImprovement;
		
	public class Game extends Sprite
	{				
		public static var INSTANCE:Game = new Game();	
		public static var SCROLL_SPEED:int = 8;
		public static var GAME_LOOP_TIME:int = 50;					
		
		//Incoming events
		public static var onInfoArmy:String = "onInfoArmy";
		
		//Outgoing events		
		public static var cityQueueImprovementEvent:String = "cityQueueImprovementEvent";
		public static var assignTaskEvent:String = "assignTaskEvent";
		public static var transferUnitEvent:String = "transferUnitEvent";
		public static var transferItemEvent:String = "transferItemEvent";
		public static var cityQueueBuildingEvent:String = "cityQueueBuildingEvent";
		public static var cityQueueItemEvent:String = "cityQueueItemEvent";
		
		//UI events
		public static var mainUIBuildClickEvent:String = "mainUIBuildClickEvent";
		
		//States
		public static var TileNone:int = 0;
		public static var TileClaimed:int = 1;
		public static var TileImproved:int = 2;
				
		public var main:Main;
		public var player:Player;
		public var kingdom:Kingdom;
		
		public var tileStatus:int;
		
		public var selectedTile:Tile;
		public var selectedEntity:Entity;
		public var targetedEntity:Entity;
		public var action:int = 0;
		
		private var lastLoopTime:Number;
		private var perceptionManager:PerceptionManager;
		private var map:Map;
		
		private var initialPerception:Boolean = true;
		
		private var prevSentPacket:Object;		
		
		private var armyUIList:Array;
		
		public function Game() : void
		{
			selectedEntity = null;							
			targetedEntity = null;
			player = new Player();
			kingdom = new Kingdom();
			
			armyUIList = new Array();
			
			map = Map.INSTANCE;
			perceptionManager = PerceptionManager.INSTANCE;
						
			addChild(map);	
															
			Connection.INSTANCE.addEventListener(Connection.onMapEvent, connectionMap);
			Connection.INSTANCE.addEventListener(Connection.onPerceptionEvent, connectionPerception);	
			Connection.INSTANCE.addEventListener(Connection.onInfoKingdomEvent, connectionInfoKingdom);
			Connection.INSTANCE.addEventListener(Connection.onInfoArmyEvent, connectionInfoArmy);
			Connection.INSTANCE.addEventListener(Connection.onInfoCityEvent, connectionInfoCity);
			Connection.INSTANCE.addEventListener(Connection.onInfoTileEvent, connectionInfoTile);
			Connection.INSTANCE.addEventListener(Connection.onBattleInfoEvent, connectionBattleInfo);
			Connection.INSTANCE.addEventListener(Connection.onBattleDamageEvent, connectionBattleDamage);
			
			Connection.INSTANCE.addEventListener(Connection.onSuccessAddClaim, successAddClaim);			
			Connection.INSTANCE.addEventListener(Connection.onSuccessAssignTask, successAssignTask);
			Connection.INSTANCE.addEventListener(Connection.onSuccessCityQueueImprovement, successCityQueueImprovement);
			
			addEventListener(Tile.onClick, tileClicked);
			addEventListener(Tile.onDoubleClick, tileDoubleClicked);
			addEventListener(Army.onClick, armyClicked);
			addEventListener(Army.onDoubleClick, armyDoubleClicked);
			addEventListener(City.onClick, cityClicked);
			addEventListener(City.onDoubleClick, cityDoubleClicked);
			addEventListener(MapBattle.onDoubleClick, battleDoubleClicked);
			
			addEventListener(mainUIBuildClickEvent, processMainUIBuildClick);
		
			addEventListener(assignTaskEvent, processAssignTask);
			addEventListener(transferUnitEvent, processTransferUnit);
			addEventListener(transferItemEvent, processTransferItem);
			addEventListener(cityQueueBuildingEvent, processCityQueueBuilding);
			addEventListener(cityQueueItemEvent, processCityQueueItem);
			addEventListener(cityQueueImprovementEvent, processCityQueueImprovement);			
		}						
				
		public function addPerceptionData(perception:Perception) : void
		{				
			//Set entities from perception
			perceptionManager.setMapObjects(perception.mapObjects);
			
			//Set map tiles from perception
			map.setTiles(perception.mapTiles);
			
			//Set map fog of war
			map.setFogOfWar(kingdom.getEntities());
		}
		
		public function requestInfo(typeId:int, cityId:int) : void
		{
			var parameters:Object = { type: typeId, targetId: cityId };
			var requestInfoEvent:ParamEvent = new ParamEvent(Connection.onSendRequestInfo);
			requestInfoEvent.params = parameters;
			Connection.INSTANCE.dispatchEvent(requestInfoEvent);
		}		
		
		public function setLastLoopTime(time:Number) : void
		{
			lastLoopTime = time;
		}		
		
		public function startLoop() : void
		{
			addEventListener(Event.ENTER_FRAME, this.gameLoop);
		}
		
		public function gameLoop(e:Event) : void
		{
			var time:Number = getTimer();
						
			if((time - lastLoopTime) >= Game.GAME_LOOP_TIME)
			{
				
			}
		}
		
		public function keyDownEvent(e:KeyboardEvent) : void
		{
			var rect:Rectangle = Game.INSTANCE.scrollRect;
		
			if (e.keyCode == 87) //w
			{
				rect.y -= Game.SCROLL_SPEED;	
			}
			else if (e.keyCode == 68) //d
			{
				rect.x += Game.SCROLL_SPEED;
			}
			else if (e.keyCode == 83) //s
			{ 
				rect.y += Game.SCROLL_SPEED;						 
			}
			else if (e.keyCode == 65) //a
			{
				rect.x -= Game.SCROLL_SPEED;					 
			}			
			
			Game.INSTANCE.scrollRect = rect;
		}	
		
		public function stageClick(e:MouseEvent) : void
		{			
			if (e.eventPhase == EventPhase.AT_TARGET)
			{
				var mapX:int = e.stageX - 100;
				var mapY:int = e.stageY;
				
				var rect:Rectangle = Game.INSTANCE.scrollRect;
				var offsetX:int = rect.x;
				var offsetY:int = rect.y;
				
				var gameX:int = (mapX + offsetX) / Tile.WIDTH;
				var gameY:int = (mapY + offsetY) / Tile.HEIGHT
				
				trace("Stage Click - mapX: " + mapX + " mapY: " + mapY);
				trace("Stage Click - gameX: " + gameX + " gameY: " + gameY + " action: " + action);
				
				processMove(gameX, gameY);
			}
		}
						
		public function setArmyUIDisplayOrder(obj:DisplayObject) : void
		{
			for(var i:int = 0; i < armyUIList.length; i++)
			{
				var armyUI:ArmyUI = ArmyUI(armyUIList[i]);
				
				if(armyUI.contains(obj))
				{
					armyUI.setTopDisplayOrder();
					break;
				}
			}
		}
		
		public function processAttack(targetId:int)
		{
			if (selectedEntity != null)
			{
				trace("Game - processAttack");
				var parameters:Object = {id: selectedEntity.id, targetId: targetId};
				var attackEvent:ParamEvent = new ParamEvent(Connection.onSendAttackTarget);
				attackEvent.params = parameters;				
				Connection.INSTANCE.dispatchEvent(attackEvent);		
			}
		}
		
		public function processBattleTarget(battleId:int, sourceArmyId:int, sourceUnitId:int, targetArmyId:int, targetUnitId:int) : void
		{
			var battleTarget:BattleTarget = new BattleTarget();
			
			battleTarget.battleId = battleId;
			battleTarget.sourceArmyId = sourceArmyId;
			battleTarget.sourceUnitId = sourceUnitId;
			battleTarget.targetArmyId = targetArmyId;
			battleTarget.targetUnitId = targetUnitId;
			
			var battleTargetEvent:ParamEvent = new ParamEvent(Connection.onSendBattleTarget);
			battleTargetEvent.params = battleTarget;
			
			Connection.INSTANCE.dispatchEvent(battleTargetEvent);
		}		
		
		private function processAddClaim(cityId:int, tileX:int, tileY:int) : void
		{
			var addClaim:AddClaim = new AddClaim();
			
			addClaim.cityId = cityId;
			addClaim.x = tileX;
			addClaim.y = tileY;
			prevSentPacket = addClaim;
			
			var addClaimEvent:ParamEvent = new ParamEvent(Connection.onSendAddClaim);
			addClaimEvent.params = addClaim;
			
			Connection.INSTANCE.dispatchEvent(addClaimEvent);
		}		
		
		private function processMainUIBuildClick(e:ParamEvent) : void
		{
			trace("Game - processMainUIBuildClick");
			var claim:Claim = kingdom.getClaim(selectedTile.index);							
									
			if(claim != null)
			{
				trace("Game - processMainUIBuildClick - valid claim");
				
				var city:City = kingdom.getCity(claim.cityId);
				var improvements:Array = city.getAvailableTileImprovements(selectedTile.type);

				main.buildSelector.showPanel();
				main.buildSelector.setImprovements(improvements);	
				main.buildSelector.setTileInfo(selectedTile);				
			}
			else	
			{
				trace("Game - processMainUIBuildClick failed: No claim found.");
			}
		}		
		
		private function processAssignTask(e:ParamEvent) : void
		{
			trace("Game - processAssignTask");
			
			var assignTask:AssignTask = new AssignTask();
			var assignment:Assignment = Assignment(e.params);
			
			assignTask.cityId = assignment.cityId;
			assignTask.caste = assignment.caste;
			assignTask.race = assignment.race;
			assignTask.amount = assignment.amount;
			assignTask.targetId = assignment.targetId;
			assignTask.targetType = assignment.targetType;
			
		    prevSentPacket = assignTask;
			
			var sendAssignTask:ParamEvent = new ParamEvent(Connection.onSendAssignTask);
			sendAssignTask.params = assignTask;
			
			Connection.INSTANCE.dispatchEvent(sendAssignTask);
		}
		
		private function processTransferUnit(e:ParamEvent) : void
		{
			trace("Game - processTransferUnit");		
			var sourceUnitId:int = e.params.sourceUnitId;
			var sourceType:int = e.params.sourceType;
			var targetUI:DisplayObject = e.params.targetUI;
			var transferUnit:TransferUnit = new TransferUnit();
			var sendTransferUnit:ParamEvent = new ParamEvent(Connection.onSendTransferUnit);
			
			if(sourceType == Army.TYPE)
			{
				var sourceArmyUI:ArmyUI = e.params.sourceUI;
						
				if(armyUIUnitLayerContainsDropTarget(sourceArmyUI, targetUI))
				{
					var targetArmyId:int = getArmyUIArmyId(targetUI);
										
					transferUnit.unitId = sourceUnitId;
					transferUnit.sourceId = sourceArmyUI.army.id;
					transferUnit.sourceType = Army.TYPE;
					transferUnit.targetId = targetArmyId;
					transferUnit.targetType = Army.TYPE;
										
					sendTransferUnit.params = transferUnit;					
					Connection.INSTANCE.dispatchEvent(sendTransferUnit);
				}
				else if(main.cityUI.contains(targetUI))
				{					
					transferUnit.unitId = sourceUnitId;
					transferUnit.sourceId = sourceArmyUI.army.id;
					transferUnit.sourceType = Army.TYPE;
					transferUnit.targetId = main.cityUI.getCityId();
					transferUnit.targetType = City.TYPE;				
					
					sendTransferUnit.params = transferUnit;					
					Connection.INSTANCE.dispatchEvent(sendTransferUnit);					
				}
			}			
			else if(sourceType == City.TYPE)
			{
				if(armyUIUnitLayerContainsDropTarget(main.cityUI, targetUI))
				{
					var armyUI:ArmyUI = ArmyUI(targetUI);
					
					transferUnit.unitId = sourceUnitId;
					transferUnit.sourceId = main.cityUI.getCityId();
					transferUnit.sourceType = City.TYPE;
					transferUnit.targetId = armyUI.army.id;
					transferUnit.targetType = Army.TYPE;	
					
					sendTransferUnit.params = transferUnit;					
					Connection.INSTANCE.dispatchEvent(sendTransferUnit);									
				}
			}			
		}
		
		private function processTransferItem(e:ParamEvent) : void
		{
			trace("Game - processTransferUnit");		
			var itemId:int = e.params.itemId;
			var sourceType:int = e.params.sourceType;
			var targetUI:DisplayObject = e.params.targetUI;
			var transferItem:TransferItem = new TransferItem;
			var sendTransferItem:ParamEvent = new ParamEvent(Connection.onSendTransferItem);			
			
			if(sourceType == Army.TYPE)
			{
				var sourceArmyUI:ArmyUI = e.params.sourceUI;
				
				if(armyUIItemContainsDropTarget(sourceArmyUI, targetUI))
				{
					var targetArmyId:int = getArmyUIArmyId(targetUI);

					transferItem.itemId = itemId;
					transferItem.sourceId = sourceArmyUI.army.id;
					transferItem.sourceType = Army.TYPE;
					transferItem.targetId = targetArmyId;
					transferItem.targetType = Army.TYPE;
										
					sendTransferItem.params = transferItem;					
					Connection.INSTANCE.dispatchEvent(sendTransferItem);
				}
				else if(main.cityUI.contains(targetUI))				
				{
					transferItem.itemId = itemId;
					transferItem.sourceId = sourceArmyUI.army.id;
					transferItem.sourceType = Army.TYPE;
					transferItem.targetId = main.cityUI.getCityId();
					transferItem.targetType = City.TYPE;
										
					sendTransferItem.params = transferItem;					
					Connection.INSTANCE.dispatchEvent(sendTransferItem);					
				}
			}
			else if(sourceType == City.TYPE) 
			{
				if(armyUIItemContainsDropTarget(main.cityUI, targetUI))
				{
					var targetArmyId:int = getArmyUIArmyId(targetUI);
					
					transferItem.itemId = itemId;
					transferItem.sourceId = main.cityUI.getCityId();
					transferItem.sourceType = City.TYPE;
					transferItem.targetId = targetArmyId;
					transferItem.targetType = Army.TYPE;					
				
					sendTransferItem.params = transferItem;					
					Connection.INSTANCE.dispatchEvent(sendTransferItem);									
				}				
			}
		}
		
		private function processCityQueueBuilding(e:ParamEvent) : void
		{
			var cityQueueBuilding:CityQueueBuilding = new CityQueueBuilding();
			cityQueueBuilding.buildingId = e.params.buildingId;
			cityQueueBuilding.cityId = e.params.cityId; 
			cityQueueBuilding.buildingType = e.params.buildingType; 
			
			var sendCityQueueBuilding:ParamEvent = new ParamEvent(Connection.onSendCityQueueBuilding);			
			sendCityQueueBuilding.params = cityQueueBuilding;
			
			Connection.INSTANCE.dispatchEvent(sendCityQueueBuilding);
		}
		
		private function processCityQueueItem(e:ParamEvent) : void
		{
			var cityQueueItem:CityQueueItem = new CityQueueItem();			
			cityQueueItem.cityId = e.params.cityId; 
			cityQueueItem.itemType = e.params.itemType; 
			cityQueueItem.itemSize = e.params.itemSize;
			
			var sendCityQueueItem:ParamEvent = new ParamEvent(Connection.onSendCityQueueItem);			
			sendCityQueueItem.params = cityQueueItem;
			
			Connection.INSTANCE.dispatchEvent(sendCityQueueItem);
		}		
		
		private function processCityQueueImprovement(e:ParamEvent) : void
		{
			var claim:Claim = kingdom.getClaim(selectedTile.index);					
			
			if(claim != null)
			{			
				var cityQueueImprovement:CityQueueImprovement = new CityQueueImprovement();
		
				cityQueueImprovement.cityId = claim.cityId;
				cityQueueImprovement.type = e.params;
				cityQueueImprovement.x = selectedTile.gameX;
				cityQueueImprovement.y = selectedTile.gameY;
				
				var sendCityQueueImprovement:ParamEvent = new ParamEvent(Connection.onSendCityQueueImprovement);
				sendCityQueueImprovement.params = cityQueueImprovement;
				
				Connection.INSTANCE.dispatchEvent(sendCityQueueImprovement);
			}
			else
			{
				trace("Game - processCityQueueImprovement failed: No claim found.");
			}
		}		
				
		private function tileClicked(e:ParamEvent) : void
		{
			trace("Game - tileClicked");
			
			var tile:Tile = e.params;
			
			if (tile != null)
			{				
				selectedTile = tile;
				main.mainUI.setSelectedTile(tile);						
				setTileStatus(tile);						

				if(main.mainUI.isAttackCommand())
				{
					main.mainUI.resetCommand();
					if(tile.hasOneEntityOnly())
					{
						var entity:Entity = tile.getSoloEntity();
						processAttack(entity.id);
					}
				}
				else if(main.mainUI.isClaimCommand())
				{
					trace("isClaimCommand");
					main.mainUI.resetCommand();
					
					processAddClaim(selectedEntity.id, tile.gameX, tile.gameY);
				}				
				else if(main.mainUI.isMoveCommand())
				{
					processMove(tile.gameX, tile.gameY);
				}
			}
		}
		
		private function tileDoubleClicked(e:ParamEvent) : void
		{
			trace("Game - tileDoubleClicked");	
			trace("e.params:" + e.params);
			var parameters:Object = { type: MapObjectType.TILE, targetId: e.params.index };
			var requestInfoEvent:ParamEvent = new ParamEvent(Connection.onSendRequestInfo);
			requestInfoEvent.params = parameters;
			Connection.INSTANCE.dispatchEvent(requestInfoEvent);
		}		
		
		private function processMove(gameX:int, gameY:int) : void
		{
			if(selectedEntity != null)
			{
				if (main.mainUI.isMoveCommand())
				{					
					main.mainUI.resetCommand();
					
					var parameters:Object = {id: selectedEntity.id, x: gameX, y: gameY};
					var pEvent = new ParamEvent(Connection.onSendMoveArmy);
					pEvent.params = parameters;
					Connection.INSTANCE.dispatchEvent(pEvent);	
				}
			}
		}
		
		private function armyClicked(e:ParamEvent) : void
		{
		}
		
		private function armyDoubleClicked(e:ParamEvent) : void
		{
			requestInfo(MapObjectType.ARMY, e.params.id);
		}
		
		private function cityDoubleClicked(e:ParamEvent) : void
		{
			requestInfo(MapObjectType.CITY, e.params.id);
		}
		
		private function battleDoubleClicked(e:ParamEvent) : void
		{
			var mapBattle:MapBattle = MapBattle(e.params);
			
			requestInfo(MapObjectType.BATTLE, mapBattle.battleId);
		}
		
		private function improvementDoubleClicked(e:ParamEvent) : void
		{
			requestInfo(MapObjectType.IMPROVEMENT, e.params.id);
		}		
						
		private function cityClicked(e:ParamEvent) : void
		{
			trace("Game - cityClicked");
		}		
		
		private function connectionMap(e:ParamEvent) : void
		{
			trace("Game - connectionMap");
			map.setTiles(e.params);
		}
		
		private function connectionPerception(e:ParamEvent) : void
		{
			trace("Game - perception");
			addPerceptionData(e.params);
		}
		
		private function connectionInfoKingdom(e:ParamEvent) : void
		{
			trace("Game - infoKingdom");
			var infoKingdom:InfoKingdom = InfoKingdom(e.params);
			
			kingdom.id = infoKingdom.id;
			kingdom.playerId = player.id;
			kingdom.name = infoKingdom.name;
			kingdom.gold = infoKingdom.gold;			
		}		
		
		private function connectionInfoArmy(e:ParamEvent) : void
		{
			trace("Game - infoArmy");
			var army:Army = Army(perceptionManager.getEntity(e.params.id));
			army.setArmyInfo(e.params);	
			
			//Check if armyUI is already open due to transfer of unit or item
			var armyUI:ArmyUI = getArmyUIById(army.id);
			
			if(armyUI != null)
			{			
				armyUI.setArmy(army);								
			}
			else
			{
				armyUI = new ArmyUI();
				main.addChild(armyUI);		
			
				armyUI.setArmy(army);			
				armyUI.showPanel();			
				armyUI.closeButton.addEventListener(MouseEvent.CLICK, armyUICloseClick);	
			
				armyUIList.push(armyUI);
			}
		}
		
		private function connectionInfoCity(e:ParamEvent) : void
		{
			
			trace("Game - infoCity");	
			var city:City = City(perceptionManager.getEntity(e.params.id));
			city.setCityInfo(e.params);
			
			if(!initialPerception)
			{
				main.cityUI.setCity(city);
				main.cityUI.showPanel();
			}
			else
			{
				initialPerception = false;
			}
		}		
		
		private function connectionInfoTile(e:ParamEvent) : void
		{
			trace("Game - infoTile");
			var infoTile:InfoTile = InfoTile(e.params);
			var landDetailCard:LandDetailCard = new LandDetailCard();
			
			main.addChild(landDetailCard);	
			
			landDetailCard.setInfo(infoTile);
			landDetailCard.showPanel();
			landDetailCard.closeButton.addEventListener(MouseEvent.CLICK, landDetailCloseClick);						
		}
				
		private function connectionBattleInfo(e:ParamEvent) : void
		{
			trace("Game - battleInfo");
			var battleInfo:BattleInfo = BattleInfo(e.params);			
			var battle:Battle = new Battle();		
			
			battle.id = battleInfo.battleId;
			battle.createArmies(battleInfo.armies);
			
			BattleManager.INSTANCE.addBattle(battle);		
			
			main.battleUI.setBattle(battle);
			main.battleUI.showPanel();
		}

		private function connnectionBattleAddArmy(e:ParamEvent) : void
		{
			trace("Game - battleAddArmy");
			var battleAddArmy:BattleAddArmy = BattleAddArmy(e.params);
			var battle:Battle = BattleManager.INSTANCE.getBattle(battleAddArmy.battleId);
					
		}
		
		private function connectionBattleDamage(e:ParamEvent) : void
		{
			trace("Game - battleDamage");
			var battleDamage:BattleDamage = e.params as BattleDamage;
			var battle:Battle = BattleManager.INSTANCE.getBattle(battleDamage.battleId);
			
			battle.addDamage(battleDamage);			
		}	
		
		private function successAddClaim(e:ParamEvent) : void
		{
			trace("Game - successAddClaim");						
			if(prevSentPacket != null)
			{
				var claimId:int = e.params;				
				var addClaim:AddClaim = AddClaim(prevSentPacket);
				var claim:Claim = new Claim();
				var city:City = City(perceptionManager.getEntity(addClaim.cityId));
				
				if(city != null)
				{
					claim.id = claimId;
					claim.cityId = addClaim.cityId;
					claim.tileIndex = Map.convertCoords(addClaim.x, addClaim.y);
					
					city.addClaim(claim);
				}
				else
				{
					trace("Could not find cityId: " + addClaim.cityId);
				}									
			}
		}
		
		private function successAssignTask(e:ParamEvent) : void
		{
			trace("Game - successAssignTask");
			if(prevSentPacket != null)
			{
				var assignTask:AssignTask = AssignTask(prevSentPacket);				
				requestInfo(MapObjectType.CITY, assignTask.cityId);
			}
		}

        private function successCityQueueImprovement(e:ParamEvent) : void
        {
            trace("Game - successCityQueueImprovement");
            if(prevSentPacket != null)
            {
                mainUI.buildSelector.hidePanel();
            }
        }
		
		private function setTileStatus(tile:Tile) : void
		{
			var claim:Claim = kingdom.getClaim(selectedTile.index);	
			
			trace("Game - claim: " + claim);
			
			if(claim != null)
			{
				tileStatus = TileClaimed;								
			}
			else
			{
				tileStatus = TileNone;
			}
		}
		
		private function armyUIUnitLayerContainsDropTarget(obj:DisplayObject, dropTargetObj:DisplayObject) : Boolean
		{
			if(obj != null && dropTargetObj != null)
			{
				for(var i:int = 0; i < armyUIList.length; i++)
				{
					var armyUI:ArmyUI = ArmyUI(armyUIList[i]);
					
					//ArmyUI does not already contain dragging object
					if(!armyUI.contains(obj))
					{						
						if(armyUI.unitLayer.contains(dropTargetObj))
						{		
							return true;
						}
					}
				}			
			}
			return false;
		}
		
		//TODO ArmyUI functions shouldn't be in Game...
		public function armyUIItemContainsDropTarget(obj:DisplayObject, dropTargetObj:DisplayObject) : Boolean
		{
			if(obj != null && dropTargetObj != null)
			{			
				for(var i:int = 0; i < armyUIList.length; i++)
				{
					var armyUI:ArmyUI = ArmyUI(armyUIList[i]);
					
					//ArmyUI does not already contain dragging object
					if(!armyUI.contains(obj))
					{							
						if(armyUI.inventoryTab.contains(dropTargetObj))
						{
							return true;
						}
					}							
				}
			}
			
			return false;
		}		
		
		private function getArmyUIById(id:int) : ArmyUI
		{
			for(var i:int = 0; i < armyUIList.length; i++)
			{
				var armyUI:ArmyUI = ArmyUI(armyUIList[i]);
				
				if(armyUI.army.id == id)
					return armyUI;
			}
			
			return null;
		}
		
		private function getArmyUIArmyId(obj:DisplayObject) : int
		{
			for(var i:int = 0; i < armyUIList.length; i++)
			{
				var armyUI:ArmyUI = ArmyUI(armyUIList[i]);
				
				if(armyUI.contains(obj))
					return armyUI.army.id;
			}
			
			return -1;
		}		
				
		private function armyUICloseClick(e:MouseEvent) : void
		{
			var armyUI:ArmyUI = ArmyUI(e.target.parent);
			
			if(main.contains(armyUI))
			{
				armyUI.closeButton.removeEventListener(MouseEvent.CLICK, armyUICloseClick);								
				main.removeChild(armyUI);
				
				for(var i:int = 0; i < armyUIList.length; i++)
				{
					if(armyUI == armyUIList[i])
					{
						armyUIList.splice(i, 1);					
						break;
					}
				}				
			}
		}
		
		private function landDetailCloseClick(e:MouseEvent) : void
		{
			var landDetailCard:LandDetailCard = LandDetailCard(e.target.parent);
			
			if(main.contains(landDetailCard))
			{
				landDetailCard.closeButton.removeEventListener(MouseEvent.CLICK, landDetailCloseClick);
				main.removeChild(landDetailCard);
			}			
		}
	}
}
