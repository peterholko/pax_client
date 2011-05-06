package ui 
{
	import flash.display.MovieClip;
	import flash.events.MouseEvent;	

	import game.Game;
	import game.entity.City;		
	import game.Building;
		
	public class ProductionUI extends Panel
	{
		public static var ICON_X_SPACER:int = 5;
		public static var ICON_X_START:int = 10;
		public static var ICON_Y_START:int = 38;	
		
		public var city:City;		
		public var cityUI:CityUI;
				
		private var iconBuildings:Array;
				
		public function ProductionUI() 
		{
			iconBuildings = new Array();
		}
		
		override public function hidePanel() : void
		{			
			this.visible = false;
			
			removeBuildings();
		}
		
		override public function showPanel() : void
		{
			this.visible = true;
			
			removeBuildings();
			setBuildings();
		}
		
		private function setBuildings() : void
		{
			var buildings:Array = city.getAvailableBuildings();
			
			for(var i:int = 0; i < buildings.length; i++)
			{
				var building:Building = Building(buildings[i]);
				
				var iconBuilding:IconBuilding = new IconBuilding();
				iconBuilding.setBuilding(building);
				
				iconBuilding.x = ICON_X_START + i * (iconBuilding.width + ICON_X_SPACER);
				iconBuilding.y = ICON_Y_START;
				iconBuilding.anchorX = iconBuilding.x;
				iconBuilding.anchorY = iconBuilding.y;		
				iconBuilding.addEventListener(MouseEvent.MOUSE_DOWN, mouseDown);
				iconBuilding.addEventListener(MouseEvent.MOUSE_UP, mouseUp);								
				
				addChild(iconBuilding);
				
				iconBuildings.push(iconBuilding);
			}
		}	
		
		private function mouseDown(e:MouseEvent) : void
		{
			trace("Mouse down");
			var iconBuilding:IconBuilding = IconBuilding(e.currentTarget);
			iconBuilding.startDrag();
			e.stopPropagation();
		}
		
		private function mouseUp(e:MouseEvent) : void
		{
			trace("ProductionUI - Mouse up");	
			e.stopPropagation();					
				
			var iconBuilding:IconBuilding = IconBuilding(e.currentTarget);
			iconBuilding.stopDrag();
						
			if(cityUI.queueMarketUI.contains(iconBuilding.dropTarget))
			{
				trace("City Queue building");
				var parameters:Object = {buildingId: iconBuilding.building.id,
										 cityId: city.id,
										 buildingType: iconBuilding.building.type};
				
				var pEvent:ParamEvent = new ParamEvent(Game.cityQueueBuildingEvent);
				pEvent.params = parameters;	
				
				Game.INSTANCE.dispatchEvent(pEvent);					
			}
			
			iconBuilding.x = iconBuilding.anchorX;
			iconBuilding.y = iconBuilding.anchorY;
		}				
		
		private function removeBuildings() : void
		{
			for(var i = 0; i < iconBuildings.length; i++)
			{
				var iconBuilding:IconBuilding = iconBuildings[i];
				
				if(this.contains(iconBuilding))		
				{								
					removeChild(iconBuilding);
				}
			}
			
			iconBuildings = new Array();
		}		
	}
	
}
