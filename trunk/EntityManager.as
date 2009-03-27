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
			var entity:Entity;
						
			for(var i:int = 0; i < perceptionEntityList.length; i++)
			{
				var perceptionEntity:Object = perceptionEntityList[i];
				var entityIndex = indexOfEntity(perceptionEntity.id);
				
				if(entityIndex == -1)
				{
					//Entity does not exist create one from perception data
					entity = createEntityFromPerception(perceptionEntity);
					newEntities.push(entity);
					addChild(entity);
				}
				else 
				{	
					//Copy new perception data to entity
					copyPerceptionToEntity(entities[entityIndex], perceptionEntity);
					
					//Update display position
					entities[entityIndex].update();
					
					newEntities.push(entities[entityIndex]);
					entities.splice(entityIndex, 1);
				}
				
				//If entity is player's entity add to Player instance
				if (entity.playerId == Game.INSTANCE.player.id)
						Game.INSTANCE.player.addEntity(entity);				
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
			entity.xPos = perceptionEntity.x;
			entity.yPos = perceptionEntity.y;
			entity.state = perceptionEntity.state;
			entity.initialize();
			
			entity.x = entity.xPos * Tile.WIDTH;
			entity.y = entity.yPos * Tile.HEIGHT;
						
			return entity;
		}
		
		private function copyPerceptionToEntity(entity:Entity, perceptionEntity:Object) : void
		{
			entity.xPos = perceptionEntity.x;
			entity.yPos = perceptionEntity.y;
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
		