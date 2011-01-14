package game.entity
{
	public class EntityFactory
	{
		public static function getEntity(EntityType:int) : Entity
		{
			trace("Entity Type: " + EntityType);
			switch(EntityType)
			{
				case Entity.ARMY:
					return new Army();
				case Entity.CITY:
					return new City();
				case Entity.IMPROVEMENT:
					return new Improvement();					
			}
			
			throw new Error("Invalid Entity Type");
		}
		
		
	}
}