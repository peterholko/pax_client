package
{
	public class Player
	{
		public var id:int;
		public var entities:Array;
		
		public function Player() : void
		{
		}
		
		public function clearEntities() : void
		{
			entities = new Array();
		}
		
		public function addEntity(entity:Entity) : void
		{
			entities.push(entity);
		}
	}
}