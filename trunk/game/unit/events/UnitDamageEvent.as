package game.unit.events 
{
	public class UnitDamageEvent extends UnitEvent 
	{
		public var sourceId:int;
		public var damage:int;
		
		public function UnitDamageEvent(type:String, bubbles:Boolean = false, cancelable:Boolean = false)
		{	
			super(type, bubbles, cancelable);
		}
		
	}
	
}