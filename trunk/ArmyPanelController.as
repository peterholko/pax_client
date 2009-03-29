package
{
	import flash.events.MouseEvent;
	
	public class ArmyPanelController extends PanelController
	{		
		public static var INSTANCE:ArmyPanelController = new ArmyPanelController();
		public static var PANEL_TITLE:String = "Army Info";
		
		private var panel:ArmyPanel;
		
		public function ArmyPanelController() : void
		{		
		}
		
		public function initialize() : void
		{
			panel = main.armyPanel;
			panel.visible = false;
			
			panel.panelTitle.htmlText = PANEL_TITLE;
			panel.panelClose.addEventListener(MouseEvent.CLICK, closePanel);	
		}
		
		public function showPanel() : void
		{
			panel.visible = true;
		}
	}
}