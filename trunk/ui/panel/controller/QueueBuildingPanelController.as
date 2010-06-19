package ui.panel.controller
{
	import flash.display.Bitmap;
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	
	import game.unit.Unit;
	import game.unit.UnitQueue;
	
	import ui.panel.view.Panel;
	import ui.panel.view.QueueBuildingPanel;
	
	import Footsoldier;
	
	public class QueueBuildingPanelController extends PanelController
	{	
		public static var INSTANCE:QueueBuildingPanelController = new QueueBuildingPanelController();
		public static var TICK:int = 1000;
		
		public var buildingType:int;
		public var queue:Array;				
		
		private var queueBuildingPanel:QueueBuildingPanel;
		private var unitIcons:Array;
		private var buildTimer:Timer;
				
		public function QueueBuildingPanelController() : void
		{
		}
		
		override public function initialize(main:Main) : void
		{					
			//Must use two variables as Actionscript does not have generics
			panel = Panel(main.queueBuildingPanel);
			queueBuildingPanel = main.queueBuildingPanel;
			
			queue = new Array();
			unitIcons = new Array();
			buildTimer = new Timer(TICK);
			
			queueBuildingPanel.unitQueue1.visible = false;
			queueBuildingPanel.unitQueue2.visible = false;
			queueBuildingPanel.unitQueue3.visible = false;
			queueBuildingPanel.unitQueue4.visible = false;
			queueBuildingPanel.unitQueue5.visible = false;
			
			buildTimer.addEventListener(TimerEvent.TIMER, buildTimeHandler);
			
			queueBuildingPanel.createUnitButton.addEventListener(MouseEvent.CLICK, createUnitClicked);
			
			super.initialize(main);
		}		
		
		override public function showPanel() : void
		{
			trace("QueueBuildingPanel showPanel()");
			super.showPanel();	
			
			buildTimer.start();
		}
		
		public function setBuildingType() : void
		{
			queueBuildingPanel.panelTitle.htmlText = "Barrack Training Queue";
		}		
				
		public function setQueue() : void
		{	
			clearUnitIcons();
			unitIcons.length = 0;
			
			queue.sortOn("startTime", Array.NUMERIC);
			
			for (var i:int = 0; i < queue.length; i++)
			{	
				var unitQueue:UnitQueue = queue[i];
				setUnitDisplay(unitQueue, i + 1);				
			}						
		}
		
		private function setUnitDisplay(unitQueue:UnitQueue, queuePosition:int) : void
		{	
			var image:MovieClip = Unit.createImage(unitQueue.type);
			var name:String = Unit.getName(unitQueue.type);
			var size:String = String(unitQueue.size);
			var remainingTime:String = String(unitQueue.remainingTime);
			
			switch(queuePosition)
			{
				case 1:
					setUnitQueueView(queueBuildingPanel.unitQueue1, name, size, remainingTime, image);
					break;
				case 2:
					setUnitQueueView(queueBuildingPanel.unitQueue2, name, size, remainingTime, image);
					break;
				case 3:
					setUnitQueueView(queueBuildingPanel.unitQueue3, name, size, remainingTime, image);
					break;
				case 4:
					setUnitQueueView(queueBuildingPanel.unitQueue4, name, size, remainingTime, image);
					break;
				case 5:
					setUnitQueueView(queueBuildingPanel.unitQueue5, name, size, remainingTime, image);
					break;	
				default:
					throw new Error("Invalid Queue Position");
			}
		}
		
		private function setUnitQueueView(unitQueueContainer:MovieClip, name:String, size:String, remainingTime:String, image:MovieClip)
		{
			unitQueueContainer.unitName.htmlText = name;
			unitQueueContainer.iconContainer.stackSize.stackSizeTextfield.text = size;
			unitQueueContainer.iconContainer.iconLayer.addChild(image);
			unitQueueContainer.unitRemainingTime.htmlText = remainingTime;
			unitQueueContainer.visible = true;
		}
		
		private function clearUnitIcons() : void
		{		
			Util.removeChildren(queueBuildingPanel.unitQueue1.iconContainer.iconLayer);
			Util.removeChildren(queueBuildingPanel.unitQueue2.iconContainer.iconLayer);
			Util.removeChildren(queueBuildingPanel.unitQueue3.iconContainer.iconLayer);
			Util.removeChildren(queueBuildingPanel.unitQueue4.iconContainer.iconLayer);
			Util.removeChildren(queueBuildingPanel.unitQueue5.iconContainer.iconLayer);
			
			queueBuildingPanel.unitQueue1.visible = false;
			queueBuildingPanel.unitQueue2.visible = false;
			queueBuildingPanel.unitQueue3.visible = false;
			queueBuildingPanel.unitQueue4.visible = false;
			queueBuildingPanel.unitQueue5.visible = false;
		}
		
		private function createUnitClicked(e:MouseEvent) : void
		{
			e.stopPropagation();
			CreateUnitPanelController.INSTANCE.showPanel();
		}
		
		private function buildTimeHandler(e:TimerEvent) : void
		{
			//TODO Send request for updated city info when timer reachs 0
			if(queue[0] != null)
				queueBuildingPanel.unitQueue1.unitRemainingTime.htmlText = queue[0].remainingTime;
		}
		
	}
}