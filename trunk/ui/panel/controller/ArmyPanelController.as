package ui.panel.controller
{
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	
	import game.unit.Unit;
	import game.entity.Army;
	
	import ui.panel.view.Panel;
	import ui.panel.view.ArmyPanel;
	
	public class ArmyPanelController extends PanelController
	{		
		public static var INSTANCE:ArmyPanelController = new ArmyPanelController();
		public static var PANEL_TITLE:String = "Army Info";
		public static var SPACER_X:int = 54;
		
		public var army:Army;
		
		private var armyPanel:ArmyPanel;
				
		public function ArmyPanelController() : void
		{		
		}
		
		override public function initialize(main:Main) : void
		{			
			//Must use two variables as Actionscript does not have generics
			panel = Panel(main.armyPanel);
			armyPanel = main.armyPanel;
			
			armyPanel.panelTitle.htmlText = PANEL_TITLE;
			
			super.initialize(main);
		}
		
		public function getUnitContainer():ArmyUnitContainer
		{
			return armyPanel.armyUnitContainer;
		}
				
		public function setUnits() : void
		{
			trace("ArmyPanelController - setUnits()");
			var i:int = 0; 
			Unit.removeUnitChildren(armyPanel.armyUnitContainer);			
			
			for each (var unit:Unit in army.units)
			{							
				unit.initialize();
				unit.addDragDrop();
				unit.setAnchorPosition(i * SPACER_X, 0);				
				
				armyPanel.armyUnitContainer.addChild(unit);
				
				i++;
			}
		}
	}
}