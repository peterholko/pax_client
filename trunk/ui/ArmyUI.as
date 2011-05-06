package ui 
{
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	import fl.text.TLFTextField;
	import flash.utils.Dictionary;
	
	import game.Game;
	import game.entity.Army;
	import game.unit.Unit;
	import game.unit.events.UnitDamageEvent;
	import game.unit.events.UnitDestroyEvent;
	import game.battle.BattleEventDispatcher;
	import game.unit.events.UnitEvent;
	import game.Item;
	
	public class ArmyUI extends MovieClip 
	{
		public static var ARMY_TAB:int = 0;
		public static var SOCKETS_TAB:int = 1;
		public static var ABILITIES_TAB:int = 2;
		public static var HERO_TAB:int = 3;
		
		public static var COMMAND_TAB:int = 0;
		public static var INVENTORY_TAB:int = 1;
		
		public static var UNIT_SPACER_X:int = 4;
		
		public var army:Army;
		
		public var closeButton:MovieClip;
		
		public var armyTab:ArmyTab;
		public var socketsTab:MovieClip;
		public var abilitiesTab:MovieClip;
		public var heroTab:MovieClip;
		
		public var commandTab:MovieClip;
		public var inventoryTab:MovieClip;		

		public var unitLayer:MovieClip;
		
		private var iconUnits:Dictionary;
		private var iconItems:Array;
		
		public function ArmyUI() 
		{		
			iconUnits = new Dictionary();
			iconItems = new Array();
			
			addEventListener(MouseEvent.MOUSE_DOWN, mouseDown);	
			addEventListener(MouseEvent.MOUSE_UP, mouseUp);			
						
			BattleEventDispatcher.INSTANCE.addEventListener(UnitEvent.DESTROYED, unitDestroyed);
            BattleEventDispatcher.INSTANCE.addEventListener(UnitEvent.DAMAGED, unitDamaged);					
		}
		
		public function setArmy(army:Army) : void
		{						
			this.army = army;			
			
			removeUnits();
			removeItems();
			
			setUnits();
			setItems();
			
			armyTab.armyNameText.htmlText = army.armyName;
			armyTab.kingdomNameText.htmlText = army.kingdomName;
			armyTab.numSoldiersText.htmlText = army.getNumSoldiers().toString();
		}
		
		public function showPanel() : void
		{
			this.parent.setChildIndex(this, this.parent.numChildren - 1);	
			showTab(ARMY_TAB);
			showCommandInventoryTab(INVENTORY_TAB);
		}
		
		public function setTopDisplayOrder() : void
		{
			this.parent.setChildIndex(this, this.parent.numChildren - 1);
		}
		
		private function setUnits() : void
		{
			var numUnits:int = 0;
			
			for each (var unit:Unit in army.units)
			{				
				var iconUnit:IconUnit = new IconUnit();
				iconUnit.setUnit(unit);		
				iconUnit.x = numUnits * (iconUnit.width + UNIT_SPACER_X);
				iconUnit.y = 0				
				//iconUnit.addEventListener(MouseEvent.CLICK, unitClick);
				iconUnit.addEventListener(MouseEvent.MOUSE_DOWN, unitMouseDown);
				iconUnit.addEventListener(MouseEvent.MOUSE_UP, unitMouseUp);

				unitLayer.addChild(iconUnit);
				iconUnits[unit.id] = iconUnit;
				numUnits++;
			}			
		}
		
		private function removeUnits() : void
		{
			for each (var iconUnit:IconUnit in iconUnits)
			{
				if(unitLayer.contains(iconUnit))
					unitLayer.removeChild(iconUnit);
			}					
			
			iconUnits = new Dictionary();
		}
		
		private function unitMouseDown(e:MouseEvent) : void
		{
			trace("unitMouseDown");
			this.parent.setChildIndex(this, this.parent.numChildren - 1);	
			e.stopPropagation();
			
			var iconUnit:IconUnit = IconUnit(e.target);
			
			iconUnit.anchorX = x;
			iconUnit.anchorY = y;
						
			iconUnit.startDrag();			
		}
		
		private function unitMouseUp(e:MouseEvent) : void
		{
			trace("unitMouseUp");
			this.parent.setChildIndex(this, this.parent.numChildren - 1);	
			e.stopPropagation();
			
			var iconUnit:IconUnit = IconUnit(e.target);
			
			iconUnit.stopDrag()
			iconUnit.visible = false;
			
			var parameters:Object = {sourceUnitId: iconUnit.unit.id,
									 sourceUI: this,
									 sourceType: Army.TYPE,
									 targetUI: iconUnit.dropTarget};
			
			var pEvent:ParamEvent = new ParamEvent(Game.transferUnitEvent);
			pEvent.params = parameters;

			Game.INSTANCE.dispatchEvent(pEvent);						
		}
		
		public function setItems() : void
		{
			if(iconItems != null)
			{			
				for(var i = 0; i < army.items.length; i++)
				{
					var item:Item = Item(army.items[i]);
					var iconItem:IconItem = new IconItem();
					iconItem.setItem(item);
					iconItem.x = i * (iconItem.width + UNIT_SPACER_X);
					iconItem.y = 0;
					iconItem.anchorX = iconItem.x;
					iconItem.anchorY = iconItem.y;					
					iconItem.addEventListener(MouseEvent.MOUSE_DOWN, itemMouseDown);
					iconItem.addEventListener(MouseEvent.MOUSE_UP, itemMouseUp);							
					
					inventoryTab.addChild(iconItem);
					
					iconItems.push(iconItem);
				}
			}
		}		
		
		private function removeItems() : void
		{
			if(iconItems != null)
			{
				for(var i = 0; i < iconItems.length; i++)
				{
					var iconItem:IconItem = iconItems[i];
					
					if(inventoryTab.contains(iconItem))		
					{
						iconItem.stackSize = null;
						iconItem.item = null;						
						inventoryTab.removeChild(iconItem);
					}
				}
			}
			
			iconItems = new Array();
		}
		
		private function itemMouseDown(e:MouseEvent) : void
		{
			trace("itemMouseDown");
			this.parent.setChildIndex(this, this.parent.numChildren - 1);	
			e.stopPropagation();
			
			var iconItem:IconItem = IconItem(e.target);
			
			iconItem.anchorX = x;
			iconItem.anchorY = y;
						
			iconItem.startDrag();						
		
		}
		
		private function itemMouseUp(e:MouseEvent) : void
		{
			trace("itemMouseUp");
			this.parent.setChildIndex(this, this.parent.numChildren - 1);	
			e.stopPropagation();
			
			var iconItem:IconItem = IconItem(e.target);
			
			iconItem.stopDrag()
			iconItem.visible = false;		
			
			iconItem.x = iconItem.anchorX;
			iconItem.y = iconItem.anchorY;			
			
			var parameters:Object = {itemId: iconItem.item.id,
									 sourceUI: this,
									 sourceType: Army.TYPE,
									 targetUI: iconItem.dropTarget};
			
			var pEvent:ParamEvent = new ParamEvent(Game.transferItemEvent);
			pEvent.params = parameters;

			Game.INSTANCE.dispatchEvent(pEvent);										
		}
				
		private function mouseDown(e:MouseEvent) : void
		{	
			this.parent.setChildIndex(this, this.parent.numChildren - 1);	
			startDrag();			
		}		
		
		private function mouseUp(e:MouseEvent) : void
		{
			trace("MouseUp: " + parent);			
			stopDrag();
		}		
		
		private function showTab(tab:int) : void
		{
			armyTab.visible = false;
			socketsTab.visible = false;
			abilitiesTab.visible = false;		
			heroTab.visible = false;
			
			switch(tab)
			{
				case ARMY_TAB:
					armyTab.visible = true;				
					break;
				case SOCKETS_TAB:					
					socketsTab.visible = true;
					break;
				case ABILITIES_TAB:
					abilitiesTab.visible = true;
					break;
				case HERO_TAB:
					heroTab.visible = true;
					break;					
			}			
		}
		
		private function showCommandInventoryTab(tab:int) : void
		{
			commandTab.visible = false;
			inventoryTab.visible = false;
			
			switch(tab)
			{
				case COMMAND_TAB:
					commandTab.visible = true;
					break;
				case INVENTORY_TAB:
					inventoryTab.visible = true;
					break;
			}
		}
		
		private function unitClick(e:MouseEvent) : void
		{
			
		}
		
		private function unitDamaged(e:UnitDamageEvent) : void
		{			
			trace("ArmyUI - unitDamaged");		
			var iconUnit:IconUnit = iconUnits[e.unitId];
			
			if(iconUnit != null)
				iconUnit.updateStackSize();
		}
		
		private function unitDestroyed(e:UnitDestroyEvent) : void
		{
			trace("ArmyUI - unitDestroyed");
            var iconUnit:IconUnit = iconUnits[e.unitId];

            if(iconUnit != null)
                if (unitLayer.contains(iconUnit))
                    unitLayer.removeChild(iconUnit);			
		}		
	}
	
}
