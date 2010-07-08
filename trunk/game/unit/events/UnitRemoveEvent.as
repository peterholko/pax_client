package game.unit.events 
{
	public class UnitRemoveEvent extends UnitEvent
	{
		public function UnitRemoveEvent(type:String, bubbles:Boolean = false, cancelable:Boolean = false) 
		{
			super(type, bubbles, cancelable);
		}
		
	}
	
}