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
	import game.Building;
	import game.Contract;

	public class City extends Entity
	{
		public static var TYPE:int = Entity.CITY;
		public static var onClick:String = "onCityClick";
		public static var onDoubleClick:String = "onCityDoubleClick";

		public var cityName:String;

		public var buildings:Array;
		public var units:Array;
		public var claims:Array;
		public var improvements:Array;
		public var assignments:Array;
		public var items:Array;
		public var populations:Array;		
		public var contracts:Array;

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
			contracts = new Array();
			
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
		
		public function getPopulation(caste:int) : Array
		{
			var populationList:Array = new Array();
			
			for(var i = 0; i < populations.length; i++)
			{
				var population:Population = Population(populations[i]);

				if(population.caste == caste)
				{
					populationList.push(population);
				}
			}
			
			return populationList;
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
		
		public function getBuilding(buildingId:int) : Building
		{
			for(var i:int = 0; i < buildings.length; i++)
			{
				var building:Building = Building(buildings[i]);
				
				if(building.id == buildingId)
					return building;
			}
			
			return null;
		}
		
		public function getBuildingByType(buildingType:int) : Building
		{
			for(var i:int = 0; i < buildings.length; i++)
			{
				var building:Building = Building(buildings[i]);
				
				if(building.type == buildingType)
					return building;
			}
			
			return null;
		}
		
		public function getBuildingConstructionRate(building:Building) : Number
		{
			for(var i = 0; i < assignments.length; i++)
			{
				var assignment:Assignment = Assignment(assignments[i]);
				
				if(assignment.targetId == building.id && 
				   assignment.targetType == Assignment.TASK_BUILDING)
				{
					var productionRatePerGameDay:Number = Population.getProductionRate(assignment.caste);				
					var productionRatePerSecond:Number = productionRatePerGameDay / (3600 * 6);
					
					return (productionRatePerSecond * assignment.amount);
				}
			}
			
			return 0.0;
		}
		
		public function getAvailableBuildings() : Array
		{	
			var buildings:Array = new Array();
			
			var barracks:Building = new Building();
			var market:Building = new Building();
			var temple:Building = new Building();
			
			barracks.type = Building.BARRACKS;
			market.type = Building.MARKET;
			temple.type = Building.TEMPLE;
			
			buildings.push(barracks);
			buildings.push(market);
			buildings.push(temple);
			
			return buildings;
		}

		public function setCityInfo(cityInfo:InfoCity):void
		{
			trace("City - setCityInfo");
			cityName = cityInfo.name;

			setBuildings(cityInfo.buildings);
			setUnits(cityInfo.units);
			setClaims(cityInfo.claims);
			setImprovements(cityInfo.improvements);
			setAssignments(cityInfo.assignments);
			setItems(cityInfo.items);
			setPopulations(cityInfo.populations);
			setContracts(cityInfo.contracts);
		}

		private function setBuildings(buildingsInfo:Array):void
		{
			buildings.length = 0;

			for (var i:int = 0; i < buildingsInfo.length; i++)
			{
				var building:Building = new Building();
				
				building.id = buildingsInfo[i].id;
				building.hp = buildingsInfo[i].hp;
				building.type = buildingsInfo[i].type;
				
				buildings.push(building);
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
				assignment.race = assignmentsInfo[i].race;				
				assignment.amount = assignmentsInfo[i].amount;
				assignment.targetId = assignmentsInfo[i].targetId;
				assignment.targetType = assignmentsInfo[i].targetType;
				
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
			
			trace("City - populationsInfo.length: " + populationsInfo.length);
			
			for(var i = 0; i < populationsInfo.length; i++)
			{
				var population:Population = new Population();
				population.cityId = populationsInfo[i].cityId;
				population.caste = populationsInfo[i].caste;
				population.race = populationsInfo[i].race;
				population.value = populationsInfo[i].value;
				
				populations.push(population);
			}
		}
		
		private function setContracts(contractsInfo:Array) : void
		{
			contracts.length = 0;
			
			trace("City - contractsInfo.lenght: " + contractsInfo.length);
			
			for(var i = 0; i < contractsInfo.length; i++)
			{
				var contract:Contract = new Contract();
				
				contract.id = contractsInfo[i].id;
				contract.cityId = contractsInfo[i].cityId;
				contract.targetType = contractsInfo[i].targetType;
				contract.targetId = contractsInfo[i].targetId;
				contract.objectType = contractsInfo[i].objectType;
				contract.production = contractsInfo[i].production;
				contract.createdTime = contractsInfo[i].createdTime;
				contract.lastUpdate = contractsInfo[i].lastUpdate;
				
				contracts.push(contract);
			}
		}
		
		private function timerHandler(e:TimerEvent):void
		{
		}

	}
}