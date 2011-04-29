package game.entity
{
	import flash.display.Sprite;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.utils.Timer;

	import game.Game;
	import game.unit.Unit;
	import game.unit.UnitQueue;
	import game.map.Tile;
	import game.Claim;
	import game.entity.Improvement;
	
	import CityImage;
	import game.perception.PerceptionManager;
	import game.Assignment;
	import net.packet.InfoCity;
	import game.Item;
	import game.Population;

	public class City extends Entity
	{
		public static var TYPE:int = Entity.CITY;
		public static var onClick:String = "onCityClick";
		public static var onDoubleClick:String = "onCityDoubleClick";
		public static var TASK_IMPROVEMENT:int = 1;		
		
		public static var CASTE_SLAVES:int = 0;		
		public static var CASTE_SOLDIERS:int = 1;
		public static var CASTE_COMMONERS:int = 2;
		public static var CASTE_NOBLES:int = 3;

		public var cityName:String;

		public var buildings:Array;
		public var units:Array;
		public var claims:Array;
		public var improvements:Array;
		public var assignments:Array;
		public var items:Array;
		public var populations:Array;

		public var landQueue:Array;
		public var seaQueue:Array;
		public var airQueue:Array;

		private var remainingTimer:Timer;

		public function City():void
		{
			buildings = new Array();
			units = new Array();
			claims = new Array();
			improvements = new Array();
			assignments = new Array();
			items = new Array();
			populations = new Array();
			
			landQueue = new Array();
			seaQueue = new Array();
			airQueue = new Array();
		}

		override public function initialize():void
		{
			var imageData:BitmapData = null;
			imageData = new CityImage(0,0);

			remainingTimer = new Timer(1000);
			remainingTimer.addEventListener(TimerEvent.TIMER, timerHandler);
			remainingTimer.start();

			this.image = new Bitmap(imageData);
			this.addChild(this.image);
		}

		override protected function mouseClick(e:Event):void
		{
			var pEvent:ParamEvent = new ParamEvent(Tile.onClick);
			pEvent.params = tile;

			Game.INSTANCE.dispatchEvent(pEvent);

			/*trace("City - mouseClick");
			var pEvent:ParamEvent = new ParamEvent(City.onClick);
			pEvent.params = this;
			
			Game.INSTANCE.dispatchEvent(pEvent);*/
		}

		override protected function mouseDoubleClick(e:Event):void
		{
			trace("City - mouseDoubleClick");
			var pEvent:ParamEvent = new ParamEvent(City.onDoubleClick);
			pEvent.params = this;

			Game.INSTANCE.dispatchEvent(pEvent);
		}
		
		public static function getCasteName(casteType:int) : String
		{
			switch(casteType)
			{
				case CASTE_SLAVES:
					return "Slaves";
				case CASTE_SOLDIERS:
					return "Soldiers";
				case CASTE_COMMONERS:
					return "Commoners";
				case CASTE_NOBLES:
					return "Nobles";
			}
			
			return "Unknown";
		}
		
		public static function getCasteId(casteName:String) : int
		{
			switch(casteName)
			{
				case "Slaves":
					return CASTE_SLAVES;
				case "Soldiers":
					return CASTE_SOLDIERS;
				case "Commoners":
					return CASTE_COMMONERS;
				case "Nobles":
					return CASTE_NOBLES;
			}
			
			return -1;			
		}
		
		public function getCasteValue(casteType:int) : int
		{
			for(var i = 0; i < populations.length; i++)
			{
				var population:Population = Population(populations[i]);
				trace("Population.caste: " + population.caste + " value: " + population.value);
				if(population.caste == casteType)
				{
					return population.value;
				}
			}
			
			return 0;
		}
		
		public function getTotalPop() : int
		{
			var total:int = 0;
			
			for(var i = 0; i < populations.length; i++)
			{
				var population:Population = Population(populations[i]);
				total += population.value;				
			}
			
			return total;
		}	
		
		public function addClaim(claim:Claim) : void
		{
			claims.push(claim);
		}
		
		public function getImprovement(improvementId:int) : Improvement
		{
			for(var i:int = 0; i < improvements.length; i++)
			{
				var improvement:Improvement = Improvement(improvements[i]);
				
				if(improvement.id == improvementId)
					return improvement;
			}
			
			return null;
		}

		public function setCityInfo(cityInfo:InfoCity):void
		{
			trace("City - setCityInfo");

			cityName = cityInfo.name;

			var buildingsInfo:Array = cityInfo.buildings;
			var unitsInfo:Array = cityInfo.units;
			var unitsQueueInfo:Array = cityInfo.unitsQueue;
			var claimsInfo:Array = cityInfo.claims;
			var improvementsInfo:Array = cityInfo.improvements;
			var assignmentsInfo:Array = cityInfo.assignments;
			var itemsInfo:Array = cityInfo.items;
			var populationsInfo:Array = cityInfo.populations;

			setBuildings(buildingsInfo);
			setUnits(unitsInfo);
			setUnitsQueue(unitsQueueInfo);
			setClaims(claimsInfo);
			setImprovements(improvementsInfo);
			setAssignments(assignmentsInfo);
			setItems(itemsInfo);
			setPopulations(populationsInfo);
		}

		private function setBuildings(buildingsInfo:Array):void
		{
			buildings.length = 0;

			for (var i:int = 0; i < buildingsInfo.length; i++)
			{
				buildings[i] = buildingsInfo[i];
			}
		}

		private function setUnits(unitsInfo:Array ):void
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

		private function setUnitsQueue(unitsQueueInfo:Array):void
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

		private function setClaims(claimsInfo:Array):void
		{
			claims.length = 0;

			trace("claimsInfo.length: " + claimsInfo.length);

			for (var i:int = 0; i < claimsInfo.length; i++)
			{
				trace("claims: " + claimsInfo[i]);
				var claim:Claim = new Claim();

				claim.id = claimsInfo[i].id;
				claim.tileIndex = claimsInfo[i].tileIndex;
				claim.cityId = claimsInfo[i].cityId;

				claims.push(claim);
			}
		}
		
		private function setImprovements(improvementsInfo:Array) : void
		{
			improvements.length = 0;
			
			for(var i = 0; i < improvementsInfo.length; i++)
			{
				var entity:Entity = PerceptionManager.INSTANCE.getEntity(improvementsInfo[i].id);								
				improvements.push(Improvement(entity));				
			}
		}
		
		private function setAssignments(assignmentsInfo:Array) : void
		{
			assignments.length = 0;
			
			for(var i = 0; i < assignmentsInfo.length; i++)
			{
				var assignment:Assignment = new Assignment();
				
				assignment.id = assignmentsInfo[i].id;
				assignment.caste = assignmentsInfo[i].caste;
				assignment.amount = assignmentsInfo[i].amount;
				assignment.taskId = assignmentsInfo[i].taskId;
				assignment.taskType = assignmentsInfo[i].taskType;
				
				assignments.push(assignment);
			}
		}
		
		private function setItems(itemsInfo:Array) : void
		{
			items.length = 0;
			
			trace("City - itemsInfo.length: " + itemsInfo.length);
			
			for(var i = 0; i < itemsInfo.length; i++)
			{
				var item:Item = new Item();
				
				item.id = itemsInfo[i].id;
				item.entityId = itemsInfo[i].entityId;
				item.type = itemsInfo[i].type;
				item.value = itemsInfo[i].value;
				
				items.push(item);
			}
		}
		
		private function setPopulations(populationsInfo:Array) : void
		{
			populations.length = 0;
			
			for(var i = 0; i < populationsInfo.length; i++)
			{
				var population:Population = new Population();
				population.cityId = populationsInfo[i].cityId;
				population.caste = populationsInfo[i].caste;
				population.value = populationsInfo[i].value;
				
				populations.push(population);
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

		private function timerHandler(e:TimerEvent):void
		{
			for (var i:int = 0; i < landQueue.length; i++)
			{
				landQueue[i].remainingTime--;
			}
		}

	}
}