package game.unit
{
	public class UnitType 
	{	
		public static var INSTANCE:UnitType = new UnitType();
		
		private static const FOOTSOLDIER_HP:int = 1;
		private static const ARCHER_HP:int = 2;
		
		public function UnitType() 
		{		
		}
		
		public function getHp(type:int) : int
		{
			var hp:int;
			
			switch(type)
			{
				case Unit.FOOTSOLDIER:
					hp = FOOTSOLDIER_HP;
					break;
				case Unit.ARCHER:
					hp = ARCHER_HP;
					break;
				default:
					throw new Error("Invalid Unit Type");
					
			}
			
			return hp;
		}
		
	}
	
}