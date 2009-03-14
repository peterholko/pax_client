package
{
	import flash.display.MovieClip;
	import flash.events.MouseEvent;	
	import flash.events.KeyboardEvent;
	import flash.utils.getTimer;
	import flash.utils.Timer;
	import flash.events.Event;
	import flash.geom.Rectangle;
	
	public class Game extends MovieClip
	{				
		public static var INSTANCE:Game = new Game();
	
		public static var onMoveArmy:String = "onMoveArmy";
	
		public static var GAME_LOOP_TIME:int = 50;	
		
		public var selectedTarget:Army;
		public var playerId:Number;
		
		private var lastLoopTime:Number;
		private var map:Map;
		private var entities:Array;
		
		public function Game() : void
		{
			selectedTarget = null;			
			entities = new Array();
						
			map = new Map();
			addChild(map);			
			
			Connection.INSTANCE.addEventListener(Connection.onMapEvent, connectionMap);
			Connection.INSTANCE.addEventListener(Connection.onPerceptionEvent, connectionPerception);			
			addEventListener(Tile.onClick, tileClicked);
			addEventListener(Army.onClick, armyClicked);
			addEventListener(City.onClick, cityClicked);
		}
		
		public function setLastLoopTime(time:Number) : void
		{
			lastLoopTime = time;
		}
		
		public function addPerceptionData(perception:Object) : void
		{						
			var perceptionEntityList:Array = perception.entities;
			var newEntities:Array = new Array();
			var tileList:Array = perception.tiles;
			
			trace("perceptionEntityList.length: " +perceptionEntityList.length);
			
			for(var i:int = 0; i < perceptionEntityList.length; i++)
			{
				var perceptionEntity:Object = perceptionEntityList[i];
				var entityIndex = indexOfEntity(perceptionEntity.id);
				
				if(entityIndex == -1)
				{
					if(perceptionEntity.type == 0)
					{
						var army:Army = new Army();
						army.id = perceptionEntity.id;
						army.playerId = perceptionEntity.playerId;
						army.xPos = perceptionEntity.x;
						army.yPos = perceptionEntity.y;
						army.state = perceptionEntity.state;
						army.initialize();
						
						army.x = army.xPos * Tile.WIDTH;
						army.y = army.yPos * Tile.HEIGHT;
						addChild(army);	
						
						newEntities.push(army);
					}
					else if(perceptionEntity.type == 1)
					{
						var city:City = new City();
						city.id = perceptionEntity.id;
						city.playerId = perceptionEntity.playerId;
						city.xPos = perceptionEntity.x;
						city.yPos = perceptionEntity.y;
						city.state = perceptionEntity.state;	
						city.initialize();
						
						city.x = city.xPos * Tile.WIDTH;
						city.y = city.yPos * Tile.HEIGHT;
						addChild(city);
						
						newEntities.push(city);
					}				
				}
				else 
				{					
					entities[entityIndex].xPos = perceptionEntity.x;
					entities[entityIndex].yPos = perceptionEntity.y;
					entities[entityIndex].state = perceptionEntity.state;
					entities[entityIndex].x = entities[entityIndex].xPos * Tile.WIDTH;
					entities[entityIndex].y = entities[entityIndex].yPos * Tile.HEIGHT;
					
					newEntities.push(entities[entityIndex]);
					entities.splice(entityIndex, 1);
					trace("entities: " + entities);
				}
			}
			
			trace("entities.length: " + entities.length);
			trace("entities: " + entities);
			
			for(var j = 0; j < entities.length; j++)
			{
				trace("entities[j]: " + entities[j]);
				
				if(entities[j] != null)
					removeChild(entities[j]);
			}
			
			entities.length = 0;
			entities = newEntities;
			
			map.setTiles(tileList);
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
		
		private function indexOfEntity(id:int) : int
		{
			for(var i = 0; i < entities.length; i++)
			{
				if(id == entities[i].id)
				{
					return i;
				}
			}
			return -1;
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
			if(selectedTarget != null)
			{
				if(e.params.playerId != playerId)
				{
					selectedTarget.hideBorder();
					
					var parameters:Object = {id: selectedTarget.id, targetId: e.params.id};
					var pEvent = new ParamEvent(Connection.onSendAttackTarget);
					pEvent.params = parameters;				
					Connection.INSTANCE.dispatchEvent(pEvent);
				}				
			}
			
			if(e.params.playerId == playerId)
			{
				selectedTarget = e.params;
				selectedTarget.showBorder();
				trace("Game - armyClicked - selectedTarget: " + selectedTarget.id);
			}
		}
		
		public function keyDownEvent(e:KeyboardEvent) : void
		{
			var rect:Rectangle = Game.INSTANCE.scrollRect;
		
			if (e.keyCode == 87) //w
			{
				trace("Send Move North");
				rect.y -= 5;	
			}
			else if (e.keyCode == 68) //d
			{
				trace("Send Move East");
				rect.x += 5;
			}
			else if (e.keyCode == 83) //s
			{
				trace("Send Move South"); 
				rect.y += 5;						 
			}
			else if (e.keyCode == 65) //a
			{
				trace("Send Move West"); 
				rect.x -= 5;					 
			}			
			
			Game.INSTANCE.scrollRect = rect;
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
			addPerceptionData(e.params);
		}		
	}
}