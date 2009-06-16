package game.entity
{
	public class EntityFactory
	{
		public static function getEntity(EntityType:int) : Entity
		{
			switch(EntityType)
			{
				case Entity.ARMY:
					return new Army();
				case Entity.CITY:
					return new City();
			}
			
			throw new Error("Invalid Entity Type");
		}
		
		
	}
}