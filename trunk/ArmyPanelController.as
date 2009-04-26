package
{
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	
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
		
		override public function initialize() : void
		{
			//Must use two variables as Actionscript does not have generics
			panel = main.armyPanel;
			armyPanel = main.armyPanel;
			
			armyPanel.panelTitle.htmlText = PANEL_TITLE;
			
			super.initialize();
		}
		
		public function getUnitContainer():ArmyUnitContainer
		{
			return armyPanel.armyUnitContainer;
		}
				
		public function setUnits() : void
		{
			trace("ArmyPanelController - setUnits()");
			Unit.removeUnitChildren(armyPanel.armyUnitContainer);			
			
			for (var i:int = 0; i < army.units.length; i++)
			{				
				var unit:Unit = army.units[i];				
				unit.initialize();
				unit.setAnchorPosition(i * SPACER_X, 0);				
				
				armyPanel.armyUnitContainer.addChild(unit);
			}
		}
	}
}