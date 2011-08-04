package ui 
{	
	import flash.display.MovieClip;
	import fl.text.TLFTextField;
	
	import game.Contract;
	import game.Building;
	import game.entity.City;
	
	import QueueProgressIcon;
	import game.Assignment;
	import game.entity.Improvement;
	import flash.display.BitmapData;
	import flash.display.Bitmap;
	
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
		
		public function getContract() : Contract
		{
			return contract;
		}
		
		private function setQueueEntryIcon() : void
		{
			switch(contract.type)
			{
				case Contract.CONTRACT_BUILDING:
					var building:Building = city.getBuildingByType(contract.objectType);
					var constructionRate:Number = city.getBuildingConstructionRate(building);
					
					setBuildingIcon(building);
					setProgressIcons(contract.production, building.getProductionCost());
					setQueueEntryName(Building.getNameByType(building.type));
					setRemainingTime(contract.production, constructionRate, building.getProductionCost());
					
					break;		
				case Contract.CONTRACT_IMPROVEMENT:
					var improvement:Improvement = city.getImprovement(contract.targetId);
					
					setImprovementIcon(improvement);
					setProgressIcons(contract.production, improvement.getProductionCost());
					setQueueEntryName(improvement.getName());
					break;
			}					
		}
		
		private function setBuildingIcon(building:Building) : void
		{							
			var iconBitmapData:BitmapData = building.getImage();			
			var image:Bitmap = new Bitmap(iconBitmapData);
			image.x = 0;
			image.y = 0;
			
			addChild(image);
		}
		
		private function setImprovementIcon(improvement:Improvement) : void
		{
			var iconBitmapData:BitmapData = improvement.getImage();		
			var image:Bitmap = 	new Bitmap(iconBitmapData);
			image.x = 0;
			image.y = 0;
			
			addChild(image);
		}
		
		private function setProgressIcons(currentProduction:Number, productionCost:Number) : void
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
