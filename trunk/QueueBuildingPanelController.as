package
{
	import flash.display.Bitmap;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	
	import FootsoldierImage;
	
	public class QueueBuildingPanelController extends PanelController
	{	
		public static var INSTANCE:QueueBuildingPanelController = new QueueBuildingPanelController();
		public static var TICK:int = 1000;
		
		private var buildingType:int;
		private var queueList:Array;				
		private var unitIcons:Array;
		private var buildTimer:Timer;
		private var panel:QueueBuildingPanel;
				
		public function QueueBuildingPanelController() : void
		{
		}
		
		public function initialize() : void
		{			
			panel = main.queueBuildingPanel;
			panel.visible = false;
			
			queueList = new Array();
			unitIcons = new Array();
			buildTimer = new Timer(TICK);
			
			panel.unitQueue1.visible = false;
			panel.unitQueue2.visible = false;
			panel.unitQueue3.visible = false;
			panel.unitQueue4.visible = false;
			panel.unitQueue5.visible = false;
			
			buildTimer.addEventListener(TimerEvent.TIMER, buildTimeHandler);
			panel.panelClose.addEventListener(MouseEvent.CLICK, closePanel);
		}		
		
		public function showPanel() : void
		{
			panel.visible = true;
		}
				
		public function setQueueList(newQueueList:Array) : void
		{	
			clearUnitIcons();
			queueList.length = 0;
			unitIcons.length = 0;
						
			for (var i:int = 0; i < newQueueList.length; i++)
			{
				var unitQueue:UnitQueue = new UnitQueue();
				unitQueue.unitId = newQueueList[i].unitId;
				unitQueue.unitAmount = newQueueList[i].unitAmount;
				unitQueue.startTime = newQueueList[i].startTime;
				unitQueue.buildTime = newQueueList[i].buildTime;
				unitQueue.setInitialRemainingTime();
				
				setUnitDisplay(unitQueue, i + 1);				
				queueList.push(unitQueue);
			}						
		}
		
		public function setBuildingType(newBuildingType:int) : void
		{
			buildingType = newBuildingType;
			panel.panelTitle.htmlText = "Barrack Training Queue";
		}
		
		private function setUnitDisplay(unitQueue:UnitQueue, queuePosition:int) : void
		{	
			var image:Bitmap = Unit.getImage(unitQueue.unitId);
			var name:String = Unit.getName(unitQueue.unitId);
			var amount:String = String(unitQueue.unitAmount);
			
			switch(queuePosition)
			{
				case 1:
					panel.unitQueue1.unitName.htmlText = name;
					panel.unitQueue1.unitAmount.htmlText = amount;
					panel.unitQueue1.unitIcon.addChild(image);
					panel.unitQueue1.visible = true;
					break;
				case 2:
					panel.unitQueue2.unitName.htmlText = name;
					panel.unitQueue2.unitAmount.htmlText = amount;
					panel.unitQueue2.unitIcon.addChild(image);
					panel.unitQueue2.visible = true;
					break;
				case 3:
					panel.unitQueue3.unitName.htmlText = name;
					panel.unitQueue3.unitAmount.htmlText = amount;
					panel.unitQueue3.unitIcon.addChild(image);
					panel.unitQueue3.visible = true;
					break;
				case 4:
					panel.unitQueue4.unitName.htmlText = name;
					panel.unitQueue4.unitAmount.htmlText = amount;
					panel.unitQueue4.unitIcon.addChild(image);
					panel.unitQueue4.visible = true;
					break;
				case 5:
					panel.unitQueue5.unitName.htmlText = name;
					panel.unitQueue5.unitAmount.htmlText = amount;
					panel.unitQueue5.unitIcon.addChild(image);
					panel.unitQueue5.visible = true;
					break;	
				default:
					throw new Error("Invalid Queue Position");
			}
			
			if(image != null)
				unitIcons.push(image);
		}
		
		private function clearUnitIcons() : void
		{
			for (var i:int = 0; i < unitIcons.length; i++)
			{
				unitIcons[i].parent.parent.visible = false;
				unitIcons[i].parent.removeChild(unitIcons[i]);
			}
		}
		
		private function buildTimeHandler(e:TimerEvent) : void
		{
			var unitQueue1:UnitQueue = queueList[0];
			unitQueue1.remainingTime--;
			panel.unitQueue1.unitRemainingTime.htmlText = String(unitQueue1.remainingTime);
			
		}	
		
		
	}
}