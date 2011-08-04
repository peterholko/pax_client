﻿package ui 
{
	import flash.display.MovieClip;
	import flash.events.MouseEvent;	

	import game.Game;
	import game.entity.City;		
	import game.Building;
	import game.Item;
		
	public class ProductionUI extends Panel
	{
		public static var ICON_X_SPACER:int = 5;
		public static var ICON_X_START:int = 10;
		public static var ICON_Y_START:int = 38;	
		
		public var city:City;		
		public var cityUI:CityUI;
				
		private var iconBuildings:Array;
		private var iconItems:Array;
		
		private var iconX:int;
		private var iconY:int;
		
		private var queuePopup:QueuePopUp;		
				
		public function ProductionUI() 
		{
			iconBuildings = new Array();
			iconItems = new Array();	
			queuePopup = new QueuePopUp();
		}
		
		override public function hidePanel() : void
		{			
			this.visible = false;
			
			removeBuildings();
			removeItems();
		}
		
		override public function showPanel() : void
		{
			this.visible = true;
			
			iconX = ICON_X_START;
			iconY = ICON_Y_START;			
			
			removeBuildings();
			removeItems();
			setBuildings();
			setItems();
		}
		
		private function setBuildings() : void
		{
			var buildings:Array = city.getAvailableBuildings();
			
			for(var i:int = 0; i < buildings.length; i++)
			{
				var building:Building = Building(buildings[i]);
				
				var iconBuilding:IconBuilding = new IconBuilding();
				iconBuilding.setBuilding(building);
				
				iconBuilding.x = iconX + i * (iconBuilding.width + ICON_X_SPACER);
				iconBuilding.y = iconY;
				iconBuilding.anchorX = iconBuilding.x;
				iconBuilding.anchorY = iconBuilding.y;		
				iconBuilding.addEventListener(MouseEvent.MOUSE_DOWN, mouseDownBuilding);
				iconBuilding.addEventListener(MouseEvent.MOUSE_UP, mouseUpBuilding);								
				
				addChild(iconBuilding);
				
				iconBuildings.push(iconBuilding);
			}
			
			iconY = iconY + iconBuilding.height + ICON_X_SPACER; 
		}	
		
		private function setItems() : void
		{
			var harvestItems:Array = city.getAvailableHarvestItems();
			
			for(var i:int = 0; i < harvestItems.length; i++)
			{
				trace("harvestItem: " + harvestItems[i]);
				
				var iconItem:IconItem = new IconItem();
				var item:Item = new Item();
				
				item.id = -1;
				item.entityId = -1;
				item.type = harvestItems[i];
				item.value = -1;								
				
				iconItem.setItem(item);
				iconItem.hideStackSize();
				iconItem.x = iconX + i * (iconItem.width + ICON_X_SPACER);
				iconItem.y = iconY;
				iconItem.anchorX = iconItem.x;
				iconItem.anchorY = iconItem.y;								
				iconItem.addEventListener(MouseEvent.MOUSE_DOWN, mouseDownItem);
				iconItem.addEventListener(MouseEvent.MOUSE_UP, mouseUpItem);								
				
				addChild(iconItem);
				
				iconItems.push(iconItem);				
			}
		}
		
		private function mouseDownBuilding(e:MouseEvent) : void
		{
			trace("Mouse down");
			var iconBuilding:IconBuilding = IconBuilding(e.currentTarget);
			iconBuilding.startDrag();
			e.stopPropagation();
		}
		
		private function mouseUpBuilding(e:MouseEvent) : void
		{
			trace("ProductionUI - Mouse up");	
			e.stopPropagation();					
				
			var iconBuilding:IconBuilding = IconBuilding(e.currentTarget);
			iconBuilding.stopDrag();
						
			if(cityUI.queueMarketUI.contains(iconBuilding.dropTarget))
			{
				trace("City Queue building");
				var parameters:Object = {cityId: city.id,
										 buildingType: iconBuilding.building.type};
				
				var pEvent:ParamEvent = new ParamEvent(Game.cityQueueBuildingEvent);
				pEvent.params = parameters;	
				
				Game.INSTANCE.dispatchEvent(pEvent);					
			}
			
			iconBuilding.x = iconBuilding.anchorX;
			iconBuilding.y = iconBuilding.anchorY;
		}				
		
		private function mouseDownItem(e:MouseEvent) : void
		{
			trace("Item Mouse down");
			var iconItem:IconItem = IconItem(e.currentTarget);
			iconItem.startDrag();
			e.stopPropagation();
		}
		
		private function mouseUpItem(e:MouseEvent) : void
		{
			trace("ProductionUI - Item Mouse up");	
			e.stopPropagation();					
				
			var iconItem:IconItem = IconItem(e.currentTarget);
			iconItem.stopDrag();
						
			if(cityUI.queueMarketUI.contains(iconItem.dropTarget))
			{
				trace("City Queue Item");				
				cityUI.queueItem(iconItem.item.type);
			}
			
			iconItem.x = iconItem.anchorX;
			iconItem.y = iconItem.anchorY;
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
		
		private function removeItems() : void
		{
			for(var i = 0; i < iconItems.length; i++)
			{
				var iconItem:IconItem = iconItems[i];
				
				if(this.contains(iconItem))		
				{								
					removeChild(iconItem);
				}
			}
			
			iconItems = new Array();			
		}
	}
	
}