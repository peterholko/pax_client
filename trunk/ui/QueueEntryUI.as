package ui 
{	
	import flash.display.MovieClip;
	import fl.text.TLFTextField;
	
	import game.QueueEntry;
	import game.Building;
	import game.entity.City;
	
	import QueueProgressIcon;
	
	public class QueueEntryUI extends MovieClip
	{		
		public static var PROGRESS_START_X:int = 58;
		public static var PROGRESS_START_Y:int = 16;
		public static var PROGRESS_SPACER_X:int = 2;
	
		public var city:City;
	
		public var queueEntryName:TLFTextField;
		public var remainingTimeText:TLFTextField;
		
		private var queueEntry:QueueEntry;
		
		public function QueueEntryUI()
		{			
		}
		
		public function setQueueEntry(queueEntry:QueueEntry) : void
		{
			this.queueEntry = queueEntry;
			
			setQueueEntryIcon();
		}
		
		private function setQueueEntryIcon() : void
		{
			switch(queueEntry.objectType)
			{
				case Building.TYPE:
					var building:Building = city.getBuilding(queueEntry.objectId);
					setBuildingIcon(building);
					setProgressIcons(queueEntry.production, building.getProductionCost());
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
			var progressRatio:Number = currentProduction / productionCost;
			var numProgressIcons:int = Math.floor(progressRatio * 10);
			
			for(var i:int = 0; i < numProgressIcons; i++)
			{
				var progressIcon:MovieClip = new QueueProgressIcon();
				
				progressIcon.x = PROGRESS_START_X + i * (progressIcon.width + PROGRESS_SPACER_X);
				progressIcon.y = PROGRESS_START_Y;
				
				addChild(progressIcon);
			}			
		}		
	}
	
}
