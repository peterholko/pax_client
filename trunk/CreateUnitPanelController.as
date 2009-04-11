package 
{
	import flash.display.DisplayObjectContainer;
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	
	public class CreateUnitPanelController extends PanelController
	{
		public static var INSTANCE:CreateUnitPanelController = new CreateUnitPanelController();
			
		private var unitType:int = 0;
		private var unitSize:int = 0;
				
		public function CreateUnitPanelController() : void
		{
			
		}
		
		override public function initialize() : void
		{			
			panel = main.createUnitPanel;
			panel.visible = false;
			panel.iconContainer.visible = false;
			panel.iconContainer.stackSize.visible = false;
			
			panel.footsoldierButton.addEventListener(MouseEvent.CLICK, footsoldierClicked);
			panel.archerButton.addEventListener(MouseEvent.CLICK, archerClicked);
			panel.createUnit.addEventListener(MouseEvent.CLICK, createUnitClicked);
						
			panel.panelClose.addEventListener(MouseEvent.CLICK, closePanel);
		}		
		
		private function footsoldierClicked(e:MouseEvent) : void
		{
			unitType = Unit.FOOTSOLDIER;
			
			Util.removeChildren(panel.iconContainer.iconLayer);
			panel.iconContainer.iconLayer.addChild(new Footsoldier);
			panel.iconContainer.visible = true;
		}
		
		private function archerClicked(e:MouseEvent) : void
		{
			unitType = Unit.ARCHER;
			
			Util.removeChildren(panel.iconContainer.iconLayer);
			panel.iconContainer.iconLayer.addChild(new Archer);
			panel.iconContainer.visible = true;
		}
		
		private function createUnitClicked(e:MouseEvent) : void
		{
			unitSize = panel.unitSize.text;
			
			if (unitType != 0 && unitSize != 0)
			{
				var cityId = CityPanelController.INSTANCE.city.id;				
				var parameters:Object = { cityId: cityId, unitType: unitType, unitSize: unitSize };
				var cityQueueUnitEvent:ParamEvent = new ParamEvent(Connection.onSendCityQueueUnit);
				
				cityQueueUnitEvent.params = parameters;
				Connection.INSTANCE.dispatchEvent(cityQueueUnitEvent);				
			}
			else
			{
				//TODO: Error message
			}
		}
	}
	
}