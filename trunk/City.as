package
{
	import flash.display.Sprite;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.events.Event;
	import flash.events.MouseEvent;	
	
	import CityImage;
	
	public class City extends Entity
	{
		public static var TYPE:int = Entity.CITY;
		public static var onClick:String = "onCityClick";	
		public static var onDoubleClick:String = "onCityDoubleClick";
		
		public var buildings:Array;
		
		private var landQueue:Array;
		private var seaQueue:Array;
		private var airQueue:Array;
		
		public function City() : void
		{
			buildings = new Array();
			landQueue = new Array();
			seaQueue = new Array();
			airQueue = new Array();
		}
				
		override public function initialize() : void
		{
			var imageData:BitmapData = null;
			
			imageData = new CityImage(0,0);
			
			this.image = new Bitmap(imageData);
			this.addChild(this.image);	
		}
		
		override protected function mouseClick(e:Event) : void
		{
			trace("City - mouseClick");			
			var pEvent:ParamEvent = new ParamEvent(City.onClick);
			pEvent.params = this;
			
			Game.INSTANCE.dispatchEvent(pEvent);
		}
		
		override protected function mouseDoubleClick(e:Event) : void
		{
			trace("City - mouseDoubleClick");
			var pEvent:ParamEvent = new ParamEvent(City.onDoubleClick);
			pEvent.params = this;
						
			Game.INSTANCE.dispatchEvent(pEvent);
		}	
		
		public function setLandQueue(queue:Array) : void
		{
			landQueue = setQueue(queue);
		}
		
		public function setSeaQueue(queue:Array) : void 
		{
			seaQueue = setQueue(queue);
		}
		
		public function setAirQueue(queue:Array) : void 
		{
			airQueue = setQueue(queue);
		}		
		
		public function getLandQueue() : Array
		{
			return landQueue;
		}
		
		public function getSeaQueue() : Array
		{
			return seaQueue;
		}
		
		public function getAirQueue() : Array
		{
			return airQueue;
		}			
		
		private static function setQueue(queue:Array) : Array
		{
			var unitQueueList:Array = new Array();
			
			for (var i = 0; i < queue.length; i++)
			{
				var unitQueue:UnitQueue = new UnitQueue();
				unitQueue.unitId = queue[i].unitId;
				unitQueue.unitAmount = queue[i].unitAmount;
				unitQueue.startTime = queue[i].startTime;
				unitQueue.buildTime = queue[i].buildTime;
				
				trace("City - unitQueue: " + unitQueue.unitId);
				
				unitQueueList.push(unitQueue);
			}
			
			return unitQueueList;
		}
	}
}