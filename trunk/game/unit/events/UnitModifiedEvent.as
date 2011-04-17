package game.unit.events 
{
	public class UnitModifiedEvent extends UnitEvent
	{
		public function UnitModifiedEvent(type:String, bubbles:Boolean = false, cancelable:Boolean = false) 
		{
			super(type, bubbles, cancelable);
		}
		
	}
	
}