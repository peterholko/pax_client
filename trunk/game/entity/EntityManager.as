package game.entity
{
	import flash.display.Sprite;
	import flash.events.MouseEvent;		
	
	import game.map.Map;
	import game.map.Tile;
	
	public class EntityManager extends Sprite
	{
		public static var INSTANCE:EntityManager = new EntityManager();	
		
		private var entities:Array;
		
		public function EntityManager() : void
		{
			entities = new Array();			
		}
		
		public function setEntities(perceptionEntities:Array) : void
		{			
			var perceptionEntityList:Array = perceptionEntities;
			var newEntities:Array = new Array();
			var entity:Entity;
						
			for(var i:int = 0; i < perceptionEntityList.length; i++)
			{
				var perceptionEntity:Object = perceptionEntityList[i];
				var entityIndex = indexOfEntity(perceptionEntity.id);
				
				if(entityIndex == -1)
				{
					//Entity does not exist create one from perception data
					entity = createEntityFromPerception(perceptionEntity);
					
					//Add entity to the map tile
					Map.INSTANCE.addEntity(entity);
					
					newEntities.push(entity);
					addChild(entity);
				}
				else 
				{	
					//Entity already exists
					entity = entities[entityIndex];
					
					//Remove the entity from the previous map tile
					Map.INSTANCE.removeEntity(entity);
					
					//Copy new perception data to entity
					copyPerceptionToEntity(entity, perceptionEntity);
					
					//Add updated entity to the map tile
					Map.INSTANCE.addEntity(entity);					
					
					//Update display position
					entity.update();
					
					newEntities.push(entity);
					entities.splice(entityIndex, 1);
				}
				
				//If entity is player's entity add to Player instance
				//if (entity.playerId == Game.INSTANCE.player.id)
				//		Game.INSTANCE.player.addEntity(entity);				
			}
			
			clearEntities();
			entities = newEntities;			
		}
		
		public function getEntity(id:int) : Entity
		{
			var index:int = indexOfEntity(id);
			
			if (index < 0)
				throw new Error("Entity not found");
			
			return entities[index];
		}
		
		private function createEntityFromPerception(perceptionEntity:Object) : Entity
		{
			var entity:Entity = EntityFactory.getEntity(perceptionEntity.type);		
			
			entity.id = perceptionEntity.id;
			entity.playerId = perceptionEntity.playerId;
			entity.gameX = perceptionEntity.x;
			entity.gameY = perceptionEntity.y;
			entity.state = perceptionEntity.state;
			entity.type = perceptionEntity.type;
			entity.initialize();
			
			entity.x = entity.gameX * Tile.WIDTH;
			entity.y = entity.gameY * Tile.HEIGHT;
									
			return entity;
		}
		
		private function copyPerceptionToEntity(entity:Entity, perceptionEntity:Object) : void
		{
			entity.gameX = perceptionEntity.x;
			entity.gameY = perceptionEntity.y;
			entity.state = perceptionEntity.state;
		}
		
		private function clearEntities() : void
		{
			for(var j = 0; j < entities.length; j++)
			{				
				if(entities[j] != null)
					removeChild(entities[j]);
			}
			
			entities.length = 0;			
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
		