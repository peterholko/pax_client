package game.battle
{
	import net.packet.Army;
	
	import game.entity.Army;
	import game.entity.EntityManager;
	
	public class Battle 
	{
		public var id:int;
		public var armies/*game.entity.Army*/:Array;				
		
		public function Battle() : void
		{
		}		
		
		public function createArmies(armiesPacket/*packet.Army*/:Array) : void
		{
			armies = new Array();
			
			for (var i:int = 0; i < armiesPacket.length; i++)
			{
				var armyId:int = armiesPacket[i].id;
				var army:game.entity.Army = game.entity.Army(EntityManager.INSTANCE.getEntity(armyId));
				
				trace("armiesPacket[i]: " + armiesPacket[i]);
				army.setArmyInfo(armiesPacket[i]);			
				
				armies.push(army);
			}
		}
	}
	
}