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
		
		private var unitIconContainer:MovieClip;
		
		public function CityPanelController() : void
		{			
		}
		
		override public function initialize() : void
		{		
			panel = main.cityPanel;
			panel.visible = false;
			panel.barrackButton.visible = false;
			
			panel.panelTitle.htmlText = PANEL_TITLE;
			panel.panelClose.addEventListener(MouseEvent.CLICK, closePanel);
			panel.barrackButton.addEventListener(MouseEvent.CLICK, barrackClicked);
			
			unitIconContainer = new MovieClip();
			panel.unitContainer.addChild(unitIconContainer);
		}	
		
		override public function showPanel() : void
		{
			panel.visible = true;
			
			QueueBuildingPanelController.INSTANCE.buildingType = Building.BARRACKS;
			QueueBuildingPanelController.INSTANCE.queue = city.landQueue;
			
			QueueBuildingPanelController.INSTANCE.setBuildingType();
			QueueBuildingPanelController.INSTANCE.setQueue();			
		}
		
		public function setBuildings() : void
		{
			for (var i:int = 0; i < city.buildings.length; i++)
			{
				if (city.buildings[i] == Building.BARRACKS)
				{
					panel.barrackButton.visible = true;
				}
			}	
		}
		
		public function setUnits() : void
		{
			Util.removeChildren(unitIconContainer);			
			
			for (var i:int = 0; i < city.unitsInCity.length; i++)
			{
				var unit:Unit = city.unitsInCity[i];				
				var unitImage:MovieClip = Unit.getImage(unit.type);		
				var unitSize:int = unit.size;
				
				var iconContainer:MovieClip = new IconContainer();
				iconContainer.iconLayer.addChild(unitImage);
				iconContainer.stackSize.stackSizeTextfield.text = unitSize;
				iconContainer.x = i * SPACER_X;
				
				unitIconContainer.addChild(iconContainer);
			}
		}
		
		private function barrackClicked(e:MouseEvent) : void
		{
			QueueBuildingPanelController.INSTANCE.showPanel();
		}		
	}
}