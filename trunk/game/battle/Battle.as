package game.battle
{
	import game.entity.Army;
	import game.perception.PerceptionManager;	
	import game.unit.Unit;
	
	import net.packet.ArmyPacket;
	import net.packet.BattleDamage;
	
	import game.unit.events.UnitEvent;
	import game.unit.events.UnitDestroyEvent;
	import game.unit.events.UnitDamageEvent;
	import game.unit.UnitEventDispatcher;
		
	public class Battle 
	{
		public var id:int;
		public var armies/*game.entity.Army*/:Array;				
		
		public function Battle() : void
		{
		}		
		
		public function createArmies(armiesPacket/*packet.ArmyPacket*/:Array) : void
		{
			armies = new Array();
			
			for (var i:int = 0; i < armiesPacket.length; i++)
			{
				var armyId:int = armiesPacket[i].id;
				var army:Army = Army(PerceptionManager.INSTANCE.getEntity(armyId));
				
				trace("armiesPacket[i]: " + armiesPacket[i]);
				army.setArmyInfo(armiesPacket[i]);			
				
				armies.push(army);
			}
		}
		
		public function addDamage(battleDamage:BattleDamage) : void
		{
			var unitDamageEvent:UnitDamageEvent;
			var unitDestroyEvent:UnitDestroyEvent;			
			var targetUnit:Unit = getUnit(battleDamage.targetId);
						
			if (targetUnit != null)
			{
				targetUnit.addDamage(battleDamage.damage);
				
				unitDamageEvent = new UnitDamageEvent(UnitEvent.DAMAGED);			
				unitDamageEvent.damage = battleDamage.damage;
				unitDamageEvent.unitId = battleDamage.targetId;
				unitDamageEvent.sourceId = battleDamage.sourceId;
				
				UnitEventDispatcher.INSTANCE.dispatchEvent(unitDamageEvent);
				
				if (targetUnit.size <= 0)
				{
					var unitDestroyEvent:UnitDestroyEvent = new UnitDestroyEvent(UnitEvent.DESTROYED);
					unitDestroyEvent.unitId = battleDamage.targetId;
					
					UnitEventDispatcher.INSTANCE.dispatchEvent(unitDestroyEvent);
				}				
			}
			else
			{
				throw new Error("Battle - addDamage - Invalid unit id.");
			}
		}
		
		private function getUnit(unitId:int) : Unit
		{
			for (var i:int = 0; i < armies.length; i++)
			{
				var army:Army = armies[i];
				var unit:Unit = army.getUnit(unitId);
				
				if (unit != null)
					return unit;
			}
			
			return null;
		}
		
	}
	
}