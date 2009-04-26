package
{	
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	
	public class CityPanelController extends PanelController
	{		
		public static var INSTANCE:CityPanelController = new CityPanelController();
		public static var PANEL_TITLE:String = "City Info";
		public static var SPACER_X:int = 54;
		
		public var city:City;

		private var cityPanel:CityPanel;
		
		public function CityPanelController() : void
		{			
		}
		
		override public function initialize() : void
		{		
			//Must use two variables as Actionscript does not have generics
			panel = main.cityPanel;
			cityPanel = main.cityPanel;
			
			cityPanel.barrackButton.visible = false;
			
			cityPanel.panelTitle.htmlText = PANEL_TITLE;
			cityPanel.barrackButton.addEventListener(MouseEvent.CLICK, barrackClicked, false, 1);
			
			super.initialize();
		}	
		
		override public function showPanel() : void
		{		
			trace("City Panel showPanel()");
			super.showPanel();
						
			QueueBuildingPanelController.INSTANCE.buildingType = Building.BARRACKS;
			QueueBuildingPanelController.INSTANCE.queue = city.landQueue;
			
			QueueBuildingPanelController.INSTANCE.setBuildingType();
			QueueBuildingPanelController.INSTANCE.setQueue();			
			
			if (QueueBuildingPanelController.INSTANCE.isVisible())
				QueueBuildingPanelController.INSTANCE.showPanel();
		}
		
		public function setBuildings() : void
		{
			for (var i:int = 0; i < city.buildings.length; i++)
			{
				if (city.buildings[i] == Building.BARRACKS)
				{
					cityPanel.barrackButton.visible = true;
				}
			}	
		}
		
		public function setUnits() : void
		{
			trace("CityPanelController - setUnits() - city.units.length: " + city.units.length);
			Unit.removeUnitChildren(cityPanel.cityUnitContainer);			
			
			for (var i:int = 0; i < city.units.length; i++)
			{
				var unit:Unit = city.units[i];				
				unit.initialize();
				unit.setAnchorPosition(i * SPACER_X, 0);				
				
				cityPanel.cityUnitContainer.addChild(unit);
			}
		}
		
		public function getUnitContainer():CityUnitContainer
		{
			return cityPanel.cityUnitContainer;
		}		
		
		private function barrackClicked(e:MouseEvent) : void
		{
			e.stopPropagation();
			QueueBuildingPanelController.INSTANCE.showPanel();
		}		
	}
}