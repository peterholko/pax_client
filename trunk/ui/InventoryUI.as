package ui
{	
	import flash.display.MovieClip;	
	import flash.events.MouseEvent;
	import fl.text.TLFTextField;
	import flash.text.TextFormat;
	import flashx.textLayout.elements.TextFlow;
	import flashx.textLayout.formats.TextLayoutFormat;
	import flash.text.engine.TextLine;
	import flash.display.Sprite;
		
	import game.Game;
	import game.entity.City;	
	import game.Item;
	import game.entity.Army;

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
			iconItems = new Array();		
		}
		
		override public function showPanel() : void
		{
			this.visible = true;
						
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
		
		private function mouseDown(e:MouseEvent) : void
		{
			trace("Mouse down");
			var iconItem:IconItem = IconItem(e.currentTarget);
			iconItem.startDrag();
			e.stopPropagation();
		}
		
		private function mouseUp(e:MouseEvent) : void
		{
			trace("Mouse up");	
			e.stopPropagation();					
		
			trace(e.target);
			trace(e.currentTarget);
		
			var iconItem:IconItem = IconItem(e.currentTarget);			
			iconItem.stopDrag();			
			
			trace("iconItem.dropTarget: " + iconItem.dropTarget);
			
			if(cityUI.queueColumn.contains(iconItem.dropTarget))
			{
				trace("Create market order");
			}
			else 
			{
				var parameters:Object = {itemId: iconItem.item.id,
										 sourceUI: this,
										 sourceType: City.TYPE,
										 targetUI: iconItem.dropTarget};
				
				var pEvent:ParamEvent = new ParamEvent(Game.transferItemEvent);
				pEvent.params = parameters;	
				
				Game.INSTANCE.dispatchEvent(pEvent);		
			}
			
			iconItem.x = iconItem.anchorX;
			iconItem.y = iconItem.anchorY;
		}		
		
		private function removeItems() : void
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
			
			iconItems = new Array();
		}
	}
}