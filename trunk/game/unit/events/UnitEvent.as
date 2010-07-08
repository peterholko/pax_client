package game.unit.events
{
	import flash.events.Event;
	
	public class UnitEvent extends Event
	{
		public static const REMOVED:String = "removed";
		public static const DESTROYED:String = "destroyed";	
		public static const DAMAGED:String = "damaged";
		
		public var unitId:int;
		
		public function UnitEvent(type:String, bubbles:Boolean = false, cancelable:Boolean = false)
		{
			super(type, bubbles, cancelable);
		}
		
		override public function clone() : Event
		{
			var event:UnitEvent = new UnitEvent(this.type, this.bubbles, this.cancelable);
			event.unitId = this.unitId;
			return event;
		}		
	}
	
}