package game.unit
{
	import flash.events.EventDispatcher;
	
	public class UnitEventDispatcher extends EventDispatcher
	{
		public static var INSTANCE:UnitEventDispatcher = new UnitEventDispatcher();
		
		public function UnitEventDispatcher() 
		{
		}
		
	}
	
}