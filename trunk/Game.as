package
{
	import flash.display.Sprite;
	import flash.events.MouseEvent;	
	import flash.events.KeyboardEvent;
	import flash.utils.getTimer;
	import flash.utils.Timer;
	import flash.events.Event;
	import flash.geom.Rectangle;
	
	public class Game extends Sprite
	{				
		public static var INSTANCE:Game = new Game();	
		public static var SCROLL_SPEED:int = 8;
		public static var GAME_LOOP_TIME:int = 50;	
		
		public var main:Main;
		public var selectedTarget:Army;
		public var player:Player;
		
		private var lastLoopTime:Number;
		private var entityManager:EntityManager;
		private var map:Map;
		
		public function Game() : void
		{
			selectedTarget = null;							
			
			player = new Player();
			map = new Map();
			entityManager = new EntityManager();
			
			addChild(map);
			addChild(entityManager);				
			
			Connection.INSTANCE.addEventListener(Connection.onMapEvent, connectionMap);
			Connection.INSTANCE.addEventListener(Connection.onPerceptionEvent, connectionPerception);		
			Connection.INSTANCE.addEventListener(Connection.onInfoArmyEvent, connectionInfoArmy);
			Connection.INSTANCE.addEventListener(Connection.onInfoCityEvent, connectionInfoCity);
			addEventListener(Tile.onClick, tileClicked);
			addEventListener(Army.onClick, armyClicked);
			addEventListener(Army.onDoubleClick, armyDoubleClicked);
			addEventListener(City.onClick, cityClicked);
			addEventListener(City.onDoubleClick, cityDoubleClicked);
		}
				
		public function addPerceptionData(perception:Object) : void
		{	
			//Clear player's entities
			player.clearEntities();
			
			//Set entities from perception
			entityManager.setEntities(perception.entities);
			
			//Set map tiles from perception
			map.setTiles(perception.tiles);
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
				
		private function tileClicked(e:ParamEvent) : void
		{
			trace("Game - tileClicked");
			if(selectedTarget != null)
			{
				var parameters:Object = {id: selectedTarget.id, x: e.params.x, y: e.params.y};
				var pEvent = new ParamEvent(Connection.onSendMoveArmy);
				pEvent.params = parameters;
				Connection.INSTANCE.dispatchEvent(pEvent);
			}
		}
		
		private function armyClicked(e:ParamEvent) : void
		{
			var parameters:Object
			
			if(selectedTarget != null)
			{
				selectedTarget.hideBorder();
				
				if(e.params.playerId != player.id)
				{					
					parameters = {id: selectedTarget.id, targetId: e.params.id};
					var attackEvent = new ParamEvent(Connection.onSendAttackTarget);
					attackEvent.params = parameters;				
					Connection.INSTANCE.dispatchEvent(attackEvent);
				}				
			}
			
			selectedTarget = e.params;
			selectedTarget.showBorder();
		}
		
		private function armyDoubleClicked(e:ParamEvent) : void
		{
			var parameters:Object = { type: Army.TYPE, targetId: e.params.id };
			var requestInfoEvent:ParamEvent = new ParamEvent(Connection.onSendRequestInfo);
			requestInfoEvent.params = parameters;
			Connection.INSTANCE.dispatchEvent(requestInfoEvent);
		}
		
		private function cityDoubleClicked(e:ParamEvent) : void
		{
			var parameters:Object = { type: City.TYPE, targetId: e.params.id };
			var requestInfoEvent:ParamEvent = new ParamEvent(Connection.onSendRequestInfo);
			requestInfoEvent.params = parameters;
			Connection.INSTANCE.dispatchEvent(requestInfoEvent);
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
		
		private function connectionInfoArmy(e:ParamEvent) : void
		{
			trace("Game - infoArmy");
			var army:Army = Army(entityManager.getEntity(e.params.id));
			army.setArmyInfo(e.params);
			
			ArmyPanelController.INSTANCE.army = army;
			ArmyPanelController.INSTANCE.setUnits();
			ArmyPanelController.INSTANCE.showPanel();
		}
		
		private function connectionInfoCity(e:ParamEvent) : void
		{
			trace("Game - infoCity");	
			var city:City = City(entityManager.getEntity(e.params.id));
			city.setCityInfo(e.params);
			
			CityPanelController.INSTANCE.city = city;
			CityPanelController.INSTANCE.setBuildings();
			CityPanelController.INSTANCE.setUnits();
			CityPanelController.INSTANCE.showPanel();
		}				
		
	}
}