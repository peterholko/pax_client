package ui 
{
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	import fl.text.TLFTextField;
	
	import game.entity.Army;
	import game.unit.Unit;
	import game.unit.events.UnitDamageEvent;
	import game.unit.events.UnitDestroyEvent;
	import flash.utils.Dictionary;
	import game.battle.BattleEventDispatcher;
	import game.unit.events.UnitEvent;
	
	public class ArmyUI extends MovieClip 
	{
		public static var ARMY_TAB:int = 0;
		public static var SOCKETS_TAB:int = 1;
		public static var ABILITIES_TAB:int = 2;
		public static var HERO_TAB:int = 3;
		
		public static var COMMAND_TAB:int = 0;
		public static var INVENTORY_TAB:int = 1;
		
		public static var UNIT_SPACER_X:int = 3;
		
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
		
		public function ArmyUI() 
		{			
		}
		
		public function setArmy(army:Army) : void
		{
			this.army = army;
			iconUnits = new Dictionary();
			
			setUnits();
			
			armyTab.armyNameText.htmlText = army.armyName;
			armyTab.kingdomNameText.htmlText = army.kingdomName;
			armyTab.numSoldiersText.htmlText = army.getNumSoldiers().toString();
			
			addEventListener(MouseEvent.MOUSE_DOWN, mouseDown);	
			addEventListener(MouseEvent.MOUSE_UP, mouseUp);			
						
			BattleEventDispatcher.INSTANCE.addEventListener(UnitEvent.DESTROYED, unitDestroyed);
            BattleEventDispatcher.INSTANCE.addEventListener(UnitEvent.DAMAGED, unitDamaged);			
		}
		
		public function showPanel() : void
		{
			showTab(ARMY_TAB);
			showCommandInventoryTab(INVENTORY_TAB);
		}
		
		private function setUnits() : void
		{
			var numUnits:int = 0;
			
			for each (var unit:Unit in army.units)
			{				
				var iconUnit:IconUnit = new IconUnit();
				iconUnit.setUnit(unit);
				iconUnit.width = 36;
				iconUnit.height = 36;				
				iconUnit.x = numUnits * (iconUnit.width + UNIT_SPACER_X);
				iconUnit.y = 0				
				iconUnit.addEventListener(MouseEvent.CLICK, unitClick);

				unitLayer.addChild(iconUnit);
				iconUnits[unit.id] = iconUnit;
				numUnits++;
			}			
		}
				
		private function mouseDown(e:MouseEvent) : void
		{	
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
