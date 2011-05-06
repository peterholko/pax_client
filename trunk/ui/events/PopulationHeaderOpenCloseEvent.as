package ui.events {
	
	import flash.events.Event;

	public class PopulationHeaderOpenCloseEvent extends Event
	{
		public var caste:int;		
		public var state:int;

		public function PopulationHeaderOpenCloseEvent(type:String, bubbles:Boolean = false, cancelable:Boolean = false)
		{
			super(type, bubbles, cancelable);
		}								
	}
	
}
