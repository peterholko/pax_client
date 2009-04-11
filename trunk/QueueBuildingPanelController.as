package
{
	import flash.display.Bitmap;
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	
	import Footsoldier;
	
	public class QueueBuildingPanelController extends PanelController
	{	
		public static var INSTANCE:QueueBuildingPanelController = new QueueBuildingPanelController();
		public static var TICK:int = 1000;
		
		public var buildingType:int;
		public var queue:Array;				
		
		private var unitIcons:Array;
		private var buildTimer:Timer;
				
		public function QueueBuildingPanelController() : void
		{
		}
		
		override public function initialize() : void
		{			
			panel = main.queueBuildingPanel;
			panel.visible = false;
			
			queue = new Array();
			unitIcons = new Array();
			buildTimer = new Timer(TICK);
			
			panel.unitQueue1.visible = false;
			panel.unitQueue2.visible = false;
			panel.unitQueue3.visible = false;
			panel.unitQueue4.visible = false;
			panel.unitQueue5.visible = false;
			
			buildTimer.addEventListener(TimerEvent.TIMER, buildTimeHandler);
			
			panel.createUnitButton.addEventListener(MouseEvent.CLICK, createUnitClicked);
			panel.panelClose.addEventListener(MouseEvent.CLICK, closePanel);
		}		
		
		override public function showPanel() : void
		{
			buildTimer.start();
			panel.visible = true;
		}
		
		public function refresh() : void
		{
			setBuildingType();
			setQueue();
		}
		
		public function setBuildingType() : void
		{
			panel.panelTitle.htmlText = "Barrack Training Queue";
		}		
				
		public function setQueue() : void
		{	
			clearUnitIcons();
			unitIcons.length = 0;
			
			queue.sortOn("startTime", Array.NUMERIC);
			
			for (var i:int = 0; i < queue.length; i++)
			{	
				var unit:Unit = queue[i];
				setUnitDisplay(unit, i + 1);				
			}						
		}
		
		private function setUnitDisplay(unit:Unit, queuePosition:int) : void
		{	
			var image:MovieClip = Unit.getImage(unit.type);
			var name:String = Unit.getName(unit.type);
			var size:String = String(unit.size);
			var remainingTime:String = String(unit.remainingTime);
			
			switch(queuePosition)
			{
				case 1:
					setUnitQueueView(panel.unitQueue1, name, size, remainingTime, image);
					break;
				case 2:
					setUnitQueueView(panel.unitQueue2, name, size, remainingTime, image);
					break;
				case 3:
					setUnitQueueView(panel.unitQueue3, name, size, remainingTime, image);
					break;
				case 4:
					setUnitQueueView(panel.unitQueue4, name, size, remainingTime, image);
					break;
				case 5:
					setUnitQueueView(panel.unitQueue5, name, size, remainingTime, image);
					break;	
				default:
					throw new Error("Invalid Queue Position");
			}
		}
		
		private function setUnitQueueView(unitQueue:MovieClip, name:String, size:String, remainingTime:String, image:MovieClip)
		{
			unitQueue.unitName.htmlText = name;
			unitQueue.iconContainer.stackSize.stackSizeTextfield.text = size;
			unitQueue.iconContainer.iconLayer.addChild(image);
			unitQueue.unitRemainingTime.htmlText = remainingTime;
			unitQueue.visible = true;
		}
		
		private function clearUnitIcons() : void
		{		
			Util.removeChildren(panel.unitQueue1.iconContainer.iconLayer);
			Util.removeChildren(panel.unitQueue2.iconContainer.iconLayer);
			Util.removeChildren(panel.unitQueue3.iconContainer.iconLayer);
			Util.removeChildren(panel.unitQueue4.iconContainer.iconLayer);
			Util.removeChildren(panel.unitQueue5.iconContainer.iconLayer);
			
			panel.unitQueue1.visible = false;
			panel.unitQueue2.visible = false;
			panel.unitQueue3.visible = false;
			panel.unitQueue4.visible = false;
			panel.unitQueue5.visible = false;
		}
		
		private function createUnitClicked(e:MouseEvent) : void
		{
			CreateUnitPanelController.INSTANCE.showPanel();
		}
		
		private function buildTimeHandler(e:TimerEvent) : void
		{
			if(queue[0] != null)
				panel.unitQueue1.unitRemainingTime.htmlText = queue[0].remainingTime;
		}
		
	}
}