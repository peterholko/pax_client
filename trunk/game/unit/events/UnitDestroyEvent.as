package game.unit.events 
{	
	public class UnitDestroyEvent extends UnitEvent
	{		
		public function UnitDestroyEvent(type:String, bubbles:Boolean = false, cancelable:Boolean = false)
		{
			super(type, bubbles, cancelable);
		}
	}
	
}