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
		
		private var createUnitPanel:CreateUnitPanel;
				
		public function CreateUnitPanelController() : void
		{
		}
		
		override public function initialize(main:Main) : void
		{					
			//Must use two variables as Actionscript does not have generics
			panel = main.createUnitPanel;
			createUnitPanel = main.createUnitPanel;
			
			createUnitPanel.iconContainer.visible = false;
			createUnitPanel.iconContainer.stackSize.visible = false;
			
			createUnitPanel.footsoldierButton.addEventListener(MouseEvent.CLICK, footsoldierClicked);
			createUnitPanel.archerButton.addEventListener(MouseEvent.CLICK, archerClicked);
			createUnitPanel.unitSize.addEventListener(MouseEvent.MOUSE_DOWN, unitSizeDown);
			createUnitPanel.createUnit.addEventListener(MouseEvent.CLICK, createUnitClicked);	
			
			super.initialize(main);	
		}			
		
		private function footsoldierClicked(e:MouseEvent) : void
		{
			e.stopPropagation();
			unitType = Unit.FOOTSOLDIER;
			
			Util.removeChildren(createUnitPanel.iconContainer.iconLayer);
			createUnitPanel.iconContainer.iconLayer.addChild(new Footsoldier);
			createUnitPanel.iconContainer.visible = true;
		}
		
		private function archerClicked(e:MouseEvent) : void
		{
			e.stopPropagation();
			unitType = Unit.ARCHER;
			
			Util.removeChildren(createUnitPanel.iconContainer.iconLayer);
			createUnitPanel.iconContainer.iconLayer.addChild(new Archer);
			createUnitPanel.iconContainer.visible = true;
		}
		
		private function unitSizeDown(e:MouseEvent) : void
		{
			e.stopPropagation();
		}
		
		private function createUnitClicked(e:MouseEvent) : void
		{
			e.stopPropagation();
			unitSize = int(createUnitPanel.unitSize.text);
			
			if (unitType != 0 && unitSize != 0)
			{
				var cityId = CityPanelController.INSTANCE.city.id;				
				var parameters:Object = { cityId: cityId, unitType: unitType, unitSize: unitSize };
				var cityQueueUnitEvent:ParamEvent = new ParamEvent(Connection.onSendCityQueueUnit);
				
				cityQueueUnitEvent.params = parameters;
				Connection.INSTANCE.dispatchEvent(cityQueueUnitEvent);	
				
				panel.visible = false;
			}
			else
			{
				//TODO: Error message
			}
		}
	}
	
}