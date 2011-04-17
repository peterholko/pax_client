package ui
{	
	import flash.display.MovieClip;	
	import flash.events.MouseEvent;
	import fl.text.TLFTextField;
	import flash.text.TextFormat;
	import flashx.textLayout.elements.TextFlow;
	import flashx.textLayout.formats.TextLayoutFormat;
	import flash.text.engine.TextLine;
		
	import game.entity.City;	
	import flash.display.Sprite;
	import game.Item;
	
	public class InventoryUI extends Panel
	{
		public static var INVENTORY_PANEL:int = 5;
		
		public static var ICON_X_SPACER:int = 5;
		public static var ICON_X_START:int = 5;
		public static var ICON_Y_START:int = 23;	
		
		public var city:City;
		public var cityUI:CityUI;
		
		private var iconItems:Array;
		
		public function InventoryUI() : void
		{								
		}
		
		override public function showPanel() : void
		{
			this.visible = true;
			
			iconItems = new Array();
			removeItems();
			setItems();
		}
		
		override public function hidePanel() : void
		{	
			this.visible = false;
			removeItems();
		}
		
		public function setItems() : void
		{
			if(iconItems != null)
			{			
				for(var i = 0; i < city.items.length; i++)
				{
					var item:Item = Item(city.items[i]);
					var iconItem:IconItem = new IconItem();
					iconItem.setItem(item);
					iconItem.x = ICON_X_START + ICON_X_SPACER + i * (iconItem.width + ICON_X_SPACER);
					iconItem.y = ICON_Y_START;
					iconItem.anchorX = iconItem.x;
					iconItem.anchorY = iconItem.y;					
					iconItem.addEventListener(MouseEvent.MOUSE_DOWN, mouseDown);
					iconItem.addEventListener(MouseEvent.MOUSE_UP, mouseUp);							
					
					addChild(iconItem);
					
					iconItems.push(iconItem);
				}
			}
		}
		
		private function mouseDown(e:MouseEvent) : void
		{
			trace("Mouse down");
			var iconItem:IconItem = IconItem(e.target);
			iconItem.startDrag();
		}
		
		private function mouseUp(e:MouseEvent) : void
		{
			trace("Mouse up");	
			e.stopPropagation();
			
			var iconItem:IconItem = IconItem(e.target);			
			iconItem.stopDrag();				
			
			if(cityUI.queueColumn.contains(iconItem.dropTarget))
			{
				trace("Create market order");
			}
			
			iconItem.x = iconItem.anchorX;
			iconItem.y = iconItem.anchorY;
		}		
		
		private function removeItems() : void
		{
			if(iconItems != null)
			{
				for(var i = 0; i < iconItems.length; i++)
				{
					var iconItem:IconItem = iconItems[i];
					
					if(this.contains(iconItem))		
					{
						iconItem.stackSize = null;
						iconItem.item = null;						
						removeChild(iconItem);
					}
				}
			}
		}
	}
}