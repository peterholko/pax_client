package game.battle
{
	import flash.events.EventDispatcher;
	
	public class BattleEventDispatcher extends EventDispatcher
	{
		public static var INSTANCE:BattleEventDispatcher = new BattleEventDispatcher();
		
		public function BattleEventDispatcher() 
		{
		}
		
	}
	
}