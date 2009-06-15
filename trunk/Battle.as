package 
{
	public class Battle 
	{
		public var id:int;
		public var armies/*Army*/:Array;				
		
		public function Battle() : void
		{
		}		
		
		public function createArmies(armiesPacket/*packet.Army*/:Array) : void
		{
			armies = new Array();
			
			for (var i:int = 0; i < armiesPacket.length; i++)
			{
				var armyId:int = armiesPacket[i].id;
				var army:Army = Army(EntityManager.INSTANCE.getEntity(armyId));
				
				trace("armiesPacket[i]: " + armiesPacket[i]);
				army.setArmyInfo(armiesPacket[i]);			
				
				armies.push(army);
			}
		}
	}
	
}