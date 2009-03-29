package
{	
	import flash.events.MouseEvent;
	
	public class CityPanelController extends PanelController
	{		
		public static var INSTANCE:CityPanelController = new CityPanelController();
		public static var PANEL_TITLE:String = "City Info";
		
		public var city:City;
		
		private var panel:CityPanel;
				
		public function CityPanelController() : void
		{
		}
		
		public function initialize() : void
		{
			panel = main.cityPanel;
			panel.visible = false;
			panel.barrackButton.visible = false;
			
			panel.panelTitle.htmlText = PANEL_TITLE;
			panel.panelClose.addEventListener(MouseEvent.CLICK, closePanel);
			panel.barrackButton.addEventListener(MouseEvent.CLICK, barrackClicked);
		}	
		
		public function showPanel() : void
		{			
			for (var i:int = 0; i < city.buildings.length; i++)
			{
				if (city.buildings[i] == Building.BARRACKS)
				{
					panel.barrackButton.visible = true;
				}
			}
			
			panel.visible = true;
		}
		
		
		private function barrackClicked(e:MouseEvent) : void
		{
			
			QueueBuildingPanelController.INSTANCE.setQueueList(city.getLandQueue());
			QueueBuildingPanelController.INSTANCE.setBuildingType(Building.BARRACKS);
			QueueBuildingPanelController.INSTANCE.showPanel();
		}		
	}
}