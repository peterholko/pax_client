package ui 
{	
	import flash.display.MovieClip;
	import fl.text.TLFTextField;
	
	import game.Contract;
	import game.Building;
	import game.entity.City;
	
	import QueueProgressIcon;
	import game.Assignment;
	
	public class QueueEntryUI extends MovieClip
	{		
		public static var PROGRESS_START_X:int = 58;
		public static var PROGRESS_START_Y:int = 16;
		public static var PROGRESS_SPACER_X:int = 2;
	
		public var city:City;
	
		public var queueEntryName:TLFTextField;
		public var remainingTimeText:TLFTextField;
		
		private var contract:Contract;
		
		public function QueueEntryUI()
		{			
		}
		
		public function setQueueEntry(contract:Contract) : void
		{
			this.contract = contract;						
			
			clearQueueEntry();
			setQueueEntryIcon();
		}
		
		private function setQueueEntryIcon() : void
		{
			switch(contract.targetType)
			{
				case Contract.CONTRACT_BUILDING:
					var building:Building = city.getBuildingByType(contract.objectType);
					var constructionRate:Number = city.getBuildingConstructionRate(building);
					
					setBuildingIcon(building);
					setProgressIcons(contract.production, building.getProductionCost());
					setQueueEntryName(Building.getName(building.type));
					setRemainingTime(contract.production, constructionRate, building.getProductionCost());
					
					break;					
			}					
		}
		
		private function setBuildingIcon(building:Building) : void
		{							
			var iconBuilding:IconBuilding = new IconBuilding();			
			
			iconBuilding.setBuilding(building);
			iconBuilding.x = 0;
			iconBuilding.y = 0;										
			
			addChild(iconBuilding);
		}
		
		private function setProgressIcons(currentProduction:int, productionCost:int) : void
		{
			trace("currentProduction: " + currentProduction + " productionCost: " + productionCost);
			var progressRatio:Number = 0;
			
			if(currentProduction != 0)
				 progressRatio = currentProduction / productionCost;
			
			var numProgressIcons:int = Math.floor(progressRatio * 10);
			
			for(var i:int = 0; i < numProgressIcons; i++)
			{
				var progressIcon:MovieClip = new QueueProgressIcon();
				
				progressIcon.x = PROGRESS_START_X + i * (progressIcon.width + PROGRESS_SPACER_X);
				progressIcon.y = PROGRESS_START_Y;
				
				addChild(progressIcon);
			}			
		}		
		
		private function setQueueEntryName(entryName:String)
		{
			queueEntryName.text = entryName;
		}
		
		private function setRemainingTime(production:int, progressRate:Number, productionCost:int) : void
		{			
			trace("progressRate: " + progressRate + " productionCost: " + productionCost);		
			var remainingDays:Number;
			var remainingHours:Number;
		
			if(progressRate > 0)
			{
				var date:Date = new Date();
				var currentTime:int = date.getTime() / 1000;
				var remainingProduction:int = productionCost - production;
				var remainingTime:int = remainingProduction / progressRate;		
				remainingDays = remainingTime / (3600 * 24);
				remainingHours = (remainingTime % (3600 * 24)) / 3600;
			}
			else
			{
				remainingDays = Number.POSITIVE_INFINITY;
				remainingHours = Number.POSITIVE_INFINITY;
			}
			
			remainingTimeText.text = remainingDays.toString() + "D " + remainingHours.toString() + "H";			
		}
		
		private function clearQueueEntry() : void
		{
			
		}
	}
	
}
