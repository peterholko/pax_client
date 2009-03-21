package
{
	import flash.display.Sprite;
	import flash.events.MouseEvent;		
	
	public class EntityManager extends Sprite
	{
		private var entities:Array;
		
		public function EntityManager() : void
		{
			entities = new Array();			
		}
		
		public function setEntities(perceptionEntities:Array) : void
		{
			var perceptionEntityList:Array = perceptionEntities;
			var newEntities:Array = new Array();
			
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
	}
}
		