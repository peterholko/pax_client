package ui 
{
	
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	
	import game.entity.City;
	import game.QueueEntry;
	
	
	public class QueueMarketUI extends MovieClip 
	{
		public static var QUEUE_START_X:int = 0;
		public static var QUEUE_START_Y:int = 18;		
		
		public static var MARKET_INFO_Y_TOP:int = 19;
		public static var MARKET_INFO_Y_BOTTOM:int = 327;
		
		public var city:City;
		
		public var queueInfo:MovieClip;
		public var marketInfo:MovieClip;
		
		private var queueEntryUIList:Array;
		
		public function QueueMarketUI() 
		{
			queueEntryUIList = new Array();
			
			queueInfo.addEventListener(MouseEvent.CLICK, queueInfoClick);
			marketInfo.addEventListener(MouseEvent.CLICK, marketInfoClick);
		}
		
		private function queueInfoClick(e:MouseEvent) : void
		{
			clearInfo();
			bottomMarketInfo();
			
			setQueueEntries();
		}
		
		private function marketInfoClick(e:MouseEvent) : void
		{
			clearInfo();
			topMarketInfo();
		}
		
		private function topMarketInfo() : void
		{
			marketInfo.y = MARKET_INFO_Y_TOP;
		}
		
		private function bottomMarketInfo() : void
		{
			marketInfo.y = MARKET_INFO_Y_BOTTOM;
		}		
		
		private function setQueueEntries() : void
		{
			for(var i:int = 0; i < city.queueEntries.length; i++)
			{								
				var queueEntry:QueueEntry = new QueueEntry();
				var queueEntry:QueueEntry = QueueEntry(city.queueEntries[i]);
				var queueEntryUI:QueueEntryUI = new QueueEntryUI();
				queueEntryUI.city = city;
				queueEntryUI.setQueueEntry(queueEntry);
				queueEntryUI.x = QUEUE_START_X;				
				queueEntryUI.y = QUEUE_START_Y + i * queueEntryUI.height;
												
				queueEntryUIList.push(queueEntryUI);				
				
				addChild(queueEntryUI);
			}
		}
		
		
		private function clearInfo() : void
		{
			removeQueueEntries();
		}		
		
		private function removeQueueEntries() : void
		{
			if(queueEntryUIList != null)
			{
				for(var i = 0; i < queueEntryUIList.length; i++)
				{
					if(this.contains(queueEntryUIList[i]))
						this.removeChild(queueEntryUIList[i]);					
				}
				
				queueEntryUIList.length = 0;
			}
		}
		
		
	}
	
}
