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

		public function getClaim(claimTileIndex:int) : Claim
		{
			var cities:Array = getCities();
			var cityId:int;
			
			for(var i = 0; i < cities.length; i++)
			{
				var city:City = cities[i];
				
				for(var j = 0; j < city.claims.length; j++)
				{
					var claim:Claim = city.claims[j];
					
					if(claim.tileIndex == claimTileIndex)
						return claim;				
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
