package game.perception
{
	import flash.display.Sprite;
	import flash.events.MouseEvent;	
	import flash.utils.Dictionary;
		
	import game.map.Map;
	import game.map.MapObjectType;
	import game.map.Tile;
	import game.entity.EntityFactory;
	import game.entity.Entity;
	import game.entity.City;	
	
	import net.packet.MapObject;
	import net.packet.Perception;
	
	public class PerceptionManager
	{
		public static var INSTANCE:PerceptionManager = new PerceptionManager();	
		
		private var entities:Dictionary = new Dictionary();
		private var previousEntities:Dictionary = new Dictionary();
		
		private var battles:Dictionary = new Dictionary();
		private var previousBattles:Dictionary = new Dictionary();
		
		private var improvements:Dictionary = new Dictionary();
		private var previousImprovements:Dictionary = new Dictionary();
		
		public function PerceptionManager() : void
		{
		}
		
		public function setMapObjects(mapObjects/*MapObject*/:Array) : void
		{
			previousEntities = entities;
			entities = new Dictionary();
			
			previousBattles = battles;
			battles = new Dictionary();
			
			previousImprovements = improvements;
			improvements = new Dictionary();
			
			for (var i:int = 0; i < mapObjects.length; i++)
			{
				var mapObject:MapObject = mapObjects[i];
				
				switch(mapObject.type)
				{
					case MapObjectType.ARMY:
					case MapObjectType.CITY:
					case MapObjectType.IMPROVEMENT:
						setEntity(mapObject);
						break;
					case MapObjectType.BATTLE:
						setBattle(mapObject);
						break;
					default:
						throw new Error("Invalid MapObject type.");
				}
			}
						
			clearPreviousEntities();
			clearPreviousBattles();			
		}
						
		public function getEntities() : Dictionary
		{
			return entities;
		}
				
		public function getEntity(id:int) : Entity
		{
			trace("PerceptionManager - getEntity: " + id);
			if (!Util.hasId(entities, id))
				throw new Error("Entity not found");
			
			return entities[id];
		}
		
		private function setEntity(mapObject:MapObject) : void
		{						
			var entity:Entity;
						
			trace("mapObject.id: " + mapObject.id);
			if(Util.hasId(previousEntities, mapObject.id))
			{
				trace("Entity already exists");
				//Entity already exists
				entity = previousEntities[mapObject.id];
				
				//Remove the entity from the previous map tile
				Map.INSTANCE.removeEntity(entity);
				
				//Copy new perception data to entity
				copyPerceptionToEntity(entity, mapObject);
				
				//Add updated entity to the map tile
				Map.INSTANCE.addEntity(entity);					
				
				//Update display position
				entity.update();

				//Update lists
				entities[entity.id] = entity;
				previousEntities[entity.id] = null;			
			}
			else 
			{	
				trace("Entity does not exist");
				//Entity does not exist create one from perception data
				entity = createEntityFromPerception(mapObject);
				
				//Add entity to the map tile
				Map.INSTANCE.addEntity(entity);
				
				entities[entity.id] = entity;
			}				
		}
		
		private function setBattle(mapObject:MapObject) : void
		{
			battles[mapObject.id] = mapObject;
			
			Map.INSTANCE.addBattle(mapObject);
		}
		
		/*private function setImprovement(mapObject:MapObject) : void
		{
			improvements[mapObject.id] = mapObject;
			
			Map.INSTANCE.addImprovement(mapObject);
		}*/
		
		private function createEntityFromPerception(mapObject:MapObject) : Entity
		{
			trace("mapObject.type: " + mapObject.type);
			var entity:Entity = EntityFactory.getEntity(mapObject.type);		
			
			entity.id = mapObject.id;
			entity.playerId = mapObject.playerId;
			entity.gameX = mapObject.x;
			entity.gameY = mapObject.y;
			entity.state = mapObject.state;
			entity.subType = mapObject.subType;
			entity.type = mapObject.type;
			entity.initialize();
			
			entity.x = entity.gameX * Tile.WIDTH;
			entity.y = entity.gameY * Tile.HEIGHT;
									
			return entity;
		}
		
		private function copyPerceptionToEntity(entity:Entity, mapObject:MapObject) : void
		{
			trace("mapObject.type: " + mapObject.type);
			entity.gameX = mapObject.x;
			entity.gameY = mapObject.y;
			entity.state = mapObject.state;
		}
		
		private function clearPreviousEntities() : void
		{
			//Clear remaining previous entities
			for (var entityId:Object in previousEntities)
			{		
				var entity:Entity = previousEntities[entityId];
				
				if (entity != null)
					Map.INSTANCE.removeEntity(entity);
			}		
		}
		
		private function clearPreviousBattles() : void
		{
			for (var mapObjectId:Object in previousBattles)
			{			
				trace("mapObjectId: " + mapObjectId + " previousBattles[mapObjectId]: " + previousBattles[mapObjectId]);
				var mapObject:MapObject = previousBattles[mapObjectId];
				
				if(mapObject != null)
					Map.INSTANCE.removeBattle(mapObject);
			}
		}
		
		/*private function clearPreviousImprovements() : void
		{
			for (var mapObjectId:Object in previousImprovements)
			{							
				var mapObject:MapObject = previousImprovements[mapObjectId];
				
				if(mapObject != null)
					Map.INSTANCE.removeImprovement(mapObject);
			}
		}*/
	}
}
		