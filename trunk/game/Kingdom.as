package game
{
	import flash.utils.Dictionary;
	import game.entity.City;
	import game.perception.PerceptionManager;
	import game.entity.Entity;
	
	public class Kingdom 
	{
		public var id:int;
		public var playerId:int;
		public var name:String;
		public var gold:int;

		public function Kingdom() 
		{
		}

		public function getNumCities() : int
		{
			var cities:Array = getCities();
			return cities.length;
		}
		
		public function getCity() : City
		{
			var cities:Array = getCities();
			return City(cities[0]);
		}

		public function getEntities() : Array
		{
			var entities:Dictionary = PerceptionManager.INSTANCE.getEntities();
			var playerEntities:Array = new Array();
						
			for (var entityId:Object in entities)
			{		
				var entity:Entity = entities[entityId];
				
				if(entity.playerId == playerId)
				{
					playerEntities.push(entity);					
				}
			}		
			
			return playerEntities;			
		}

		public function getClaim(claimTileIndex:int) : Claim
		{
			var cities:Array = getCities();
			var cityId:int;
			
			for(var i = 0; i < cities.length; i++)
			{
				var city:City = City(cities[i]);
				
				for(var j = 0; j < city.claims.length; j++)
				{
					var claim:Claim = city.claims[j];
					
					if(claim.tileIndex == claimTileIndex)
						return claim;				
				}
			}
						
			return null;			
		}
		
		public function getCityById(cityId:int) : City
		{
			var cities:Array = getCities();
			
			for(var i = 0; i < cities.length; i++)
			{
				var city:City = City(cities[i]);
				
				if(cityId == city.id)
				{
					return city;
				}
			}			
			
			return null;
		}
				
		private function getCities() : Array
		{
			var entities:Dictionary = PerceptionManager.INSTANCE.getEntities();
			var cities:Array = new Array();
						
			for (var entityId:Object in entities)
			{		
				var entity:Entity = entities[entityId];
				
				if(entity.playerId == playerId)
				{
					if(entity.type == Entity.CITY)
					{
						var city:City = City(entity);
						cities.push(city);
					}
				}
			}		
			
			return cities;
		}

	}
	
}
