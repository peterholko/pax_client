package
{
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	
	public class ArmyPanelController extends PanelController
	{		
		public static var INSTANCE:ArmyPanelController = new ArmyPanelController();
		public static var PANEL_TITLE:String = "Army Info";
				
		public function ArmyPanelController() : void
		{		
		}
		
		override public function initialize() : void
		{
			panel = main.armyPanel;
			panel.visible = false;
			
			panel.panelTitle.htmlText = PANEL_TITLE;
			panel.panelClose.addEventListener(MouseEvent.CLICK, closePanel);	
		}
	}
}