package
{
	import flash.events.Event;
	
	public class ParamEvent extends flash.events.Event
	{
		public var params;
		
		public function ParamEvent(type:String, bubbles:Boolean = false, cancelable:Boolean = false)
		{
			super(type, bubbles, cancelable);
		}
		
		override public function clone() : Event
		{
			var event:ParamEvent = new ParamEvent(this.type, this.bubbles, this.cancelable);
			event.params = this.params;
			return event;
		}
	}
}