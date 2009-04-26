package
{
	import flash.display.Sprite;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.events.Event;
	import flash.events.MouseEvent;	
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	
	import CityImage;
	
	public class City extends Entity
	{
		public static var TYPE:int = Entity.CITY;
		public static var onClick:String = "onCityClick";	
		public static var onDoubleClick:String = "onCityDoubleClick";
		
		public var buildings:Array;
		public var units:Array;
		public var landQueue:Array;
		public var seaQueue:Array;
		public var airQueue:Array;
		
		private var remainingTimer:Timer;
		
		public function City() : void
		{
			buildings = new Array();
			units = new Array();
			landQueue = new Array();
			seaQueue = new Array();
			airQueue = new Array();
		}
				
		override public function initialize() : void
		{
			var imageData:BitmapData = null;
			imageData = new CityImage(0, 0);
			
			remainingTimer = new Timer(1000);
			remainingTimer.addEventListener(TimerEvent.TIMER, timerHandler);
			remainingTimer.start();
			
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
		
		public function setCityInfo(cityInfo:Object) : void
		{
			trace("City - setCityInfo");
			
			var buildingsInfo:Array = cityInfo.buildings;
			var unitsInfo:Array = cityInfo.units;
			var unitsQueueInfo:Array = cityInfo.unitsQueue;
					
			setBuildings(buildingsInfo);
			setUnits(unitsInfo);
			setUnitsQueue(unitsQueueInfo);
		}
		
		private function setBuildings(buildingsInfo:Array) : void
		{
			buildings.length = 0;
			
			for (var i:int = 0; i < buildingsInfo.length; i++)
			{
				buildings[i] = buildingsInfo[i];
			}
		}
		
		private function setUnits(unitsInfo:Array ) : void
		{
			units.length = 0;
			
			for (var i:int = 0; i < unitsInfo.length; i++)
			{
				var unit:Unit = new Unit();
				
				unit.id = unitsInfo[i].id;
				unit.type = unitsInfo[i].type;
				unit.size = unitsInfo[i].size;
				unit.parentEntity = this;
									
				units.push(unit);
			}
			
			trace("units; " + units.length);
		}
		
		private function setUnitsQueue(unitsQueueInfo:Array) : void
		{
			landQueue.length = 0;
			seaQueue.length = 0;
			airQueue.length = 0;			
			
			var currentDate:Date = new Date();
			var currentTime:int = currentDate.getTime() / 1000;				
			
			for (var i:int = 0; i < unitsQueueInfo.length; i++)
			{
				var unitQueue:UnitQueue = new UnitQueue();
				
				unitQueue.id = unitsQueueInfo[i].id;
				unitQueue.type = unitsQueueInfo[i].type;
				unitQueue.size = unitsQueueInfo[i].size;
				unitQueue.startTime = unitsQueueInfo[i].startTime;
				unitQueue.endTime = unitsQueueInfo[i].endTime;
								
				unitQueue.remainingTime = unitQueue.endTime - currentTime;

				//TODO: Add other types of queues
				landQueue.push(unitQueue);
			}			
		}
		
		/*private function setUnit(unit:Unit) : void
		{

			
			trace("unit.size: " + unit.size + " unit.endTime: " + unit.endTime + " currentTime: " + currentTime);
			if (unit.endTime > currentTime)
			{
				unit.remainingTime = unit.endTime - currentTime;
				landQueue.push(unit);
				
				//TODO: Add other types of queues
				switch(unit.type)
				{
					case Unit.LAND:
						landQueue.push(unit);
						break;
					case Unit.SEA:
						seaQueue.push(unit);
						break;
					case Unit.AIR:
						airQueue.push(unit);
						break;	
					default:
						throw new Error("Invalid Unit Type");
				}
			}
		}*/
		
		private function timerHandler(e:TimerEvent) : void
		{
			for (var i:int = 0; i < landQueue.length; i++)
			{
				landQueue[i].remainingTime--;
			}
		}

	}
}