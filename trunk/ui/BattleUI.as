﻿package ui 
{
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	import flash.display.Bitmap;
	import flash.display.DisplayObject;
	import flash.text.TextField;
	import flash.utils.Dictionary;	
	import fl.text.TLFTextField;
	import fl.controls.TextArea;	
	
	import game.Game;
	import game.battle.Battle;
	import game.entity.Army;
	import game.unit.Unit;
	import game.unit.UnitEventDispatcher;
	import game.unit.events.UnitEvent;
	import game.unit.events.UnitDestroyEvent;
	import game.unit.events.UnitDamageEvent;
	import game.battle.BattleEventDispatcher;
		
	public class BattleUI extends MovieClip 
	{
		public static var INIT_X:int = 3;
		public static var INIT_Y:int = 3;
		public static var SPACE_Y:int = 3;
		
		public var battle:Battle;
		public var unitIcons:Array;
		
		public var playerBattleArmyTab:BattleArmyTab;
		public var playerBattleHeroTab:BattleHeroTab;
		public var playerBattleAbilitiesTab:BattleAbilitiesTab;
		public var playerBattleSocketsTab:BattleSocketsTab;
		
		public var battleCommandTab:BattleCommandTab;
		public var battleInventoryTab:BattleInventoryTab;
		
		public var enemyBattleArmyTab:BattleArmyTab;
		public var enemyBattleHeroTab:BattleHeroTab;
		//public var enemyBattleAbilitiesTab:BattleAbilitiesTab;
		//public var enemyBattleSocketsTab:BattleSocketsTab;
		
		public var playerArmyTabText:TLFTextField;
		public var playerHeroTabText:TLFTextField;
		public var playerAbilitiesTabText:TLFTextField;
		public var playerSocketsTabText:TLFTextField;
		
		public var commandTabText:TLFTextField;
		public var inventoryTabText:TLFTextField;
		
		public var enemyArmyTabText:TLFTextField;
		public var enemyHeroTabText:TLFTextField;
		public var enemyAbilitiesTabText:TLFTextField;
		public var enemySocketsTabText:TLFTextField;
		
		public var battleMapTabText:TLFTextField;
		public var combatLogTabText:TLFTextField;
		
		public var combatLogTextArea:TextArea;
		
		public var battleMap:BattleMap;
		public var closeButton:MovieClip;
		
        private var selectedUnit:Unit = null;
        private var iconUnits:Dictionary;
        private var numUnits:int;				
		
		public function BattleUI() 
		{			
		}
		
		public function init() : void
		{
			this.visible = false;
			
			playerArmyTabText.addEventListener(MouseEvent.CLICK, playerArmyTextClick);
			playerHeroTabText.addEventListener(MouseEvent.CLICK, playerHeroTextClick);
			playerAbilitiesTabText.addEventListener(MouseEvent.CLICK, playerAbilitiesTextClick);
			playerSocketsTabText.addEventListener(MouseEvent.CLICK, playerSocketsTextClick);
			
			enemyArmyTabText.addEventListener(MouseEvent.CLICK, enemyArmyTextClick);
			enemyHeroTabText.addEventListener(MouseEvent.CLICK, enemyHeroTextClick);
			enemyAbilitiesTabText.addEventListener(MouseEvent.CLICK, enemyAbilitiesTextClick);
			enemySocketsTabText.addEventListener(MouseEvent.CLICK, enemySocketsTextClick);	
			
			battleMapTabText.addEventListener(MouseEvent.CLICK, battleMapTextClick);
			combatLogTabText.addEventListener(MouseEvent.CLICK, combatLogTextClick);
			
			BattleEventDispatcher.INSTANCE.addEventListener(UnitEvent.DESTROYED, unitDestroyed);
            BattleEventDispatcher.INSTANCE.addEventListener(UnitEvent.DAMAGED, unitDamaged);
			
			closeButton.addEventListener(MouseEvent.CLICK, closeButtonClick);	
		}
		
		public function setBattle(battle:Battle) : void
		{
			this.battle = battle;			
			setArmies();
		}
		
		public function showPanel() : void
		{
			this.visible = true;
			
			hidePlayerTabs();
			hideCommandTab();
			hideEnemyTabs();
			
			playerBattleArmyTab.visible = true;
			battleCommandTab.visible = true;
			enemyBattleArmyTab.visible = true;
		}
		
		private function setArmies() : void
		{
			//Clear old units
            iconUnits = new Dictionary();
			clearUnits();
			
            numUnits = 0;
			
			var numPlayerUnits:int = 0;
			var numEnemyUnits:int = 0;
			var numUnitsSpacer:int = 0;

            for (var i:int = 0; i < battle.armies.length; i++)
            {
                var army:Army = battle.armies[i];

                for each (var unit:Unit in army.units)
                {
					var iconUnit:IconUnit = new IconUnit();
					iconUnit.setUnit(unit);

                    if (unit.parentEntity.playerId == Game.INSTANCE.player.id)
                    {
                        iconUnit.x = INIT_X;
						numPlayerUnits++;
						numUnitsSpacer = numPlayerUnits;
                    }
                    else
                    {
                        iconUnit.x = battleMap.width - INIT_X - iconUnit.width;
						numEnemyUnits++;
						numUnitsSpacer = numEnemyUnits;
                    }
					
					iconUnit.addEventListener(MouseEvent.CLICK, unitClick);		
                    iconUnit.y = INIT_Y + (numUnitsSpacer * (iconUnit.height + SPACE_Y));

                    battleMap.addChild(iconUnit);
                    iconUnits[unit.id] = iconUnit;
                    numUnits++;
                }
            }
			
		}
		
		private function clearUnits() : void
		{
			for each(var iconUnit:IconUnit in iconUnits)
			{
				if(battleMap.contains(iconUnit))
					battleMap.removeChild(iconUnit);
			}
		}
		
        private function unitDestroyed(e:UnitDestroyEvent) : void
        {
			trace("BattleUI - unitDestroyed");
			
            var iconUnit:IconUnit = iconUnits[e.unitId];

            if(iconUnit != null)
                if (battleMap.contains(iconUnit))
                    battleMap.removeChild(iconUnit);
        }
		
        private function unitDamaged(e:UnitDamageEvent) : void
        {
            trace("BattleUI - unitDamaged");
			var iconUnit:IconUnit = iconUnits[e.unitId];
			
			if(iconUnit != null)
				iconUnit.updateStackSize();
			
			var damageMessage:String = "";
            damageMessage = "Unit " + e.sourceId + " did " + e.damage + " damage to Unit " + e.unitId + "<br>";
            combatLogTextArea.htmlText += damageMessage;
		}		
		
		private function unitClick(e:MouseEvent) : void
		{
			
		}
		
		private function hidePlayerTabs() : void
		{
			playerBattleArmyTab.visible = false;
			playerBattleHeroTab.visible = false;
			playerBattleAbilitiesTab.visible = false;
			playerBattleSocketsTab.visible = false;
		}
		
		private function hideCommandTab() : void
		{
			battleCommandTab.visible = false;
			battleInventoryTab.visible = false;			
		}
		
		private function hideEnemyTabs() : void
		{
			enemyBattleArmyTab.visible = false;
			enemyBattleHeroTab.visible = false;
			//enemyBattleAbilitiesTab.visible = false;
			//enemyBattleSocketsTab.visible = false;						
		}

		private function playerArmyTextClick(e:MouseEvent) : void
		{
			hidePlayerTabs();
			playerBattleArmyTab.visible = true;
		}
		
		private function playerHeroTextClick(e:MouseEvent) : void
		{
			hidePlayerTabs();
			playerBattleHeroTab.visible = true;
		}
		
		private function playerAbilitiesTextClick(e:MouseEvent) : void
		{
			hidePlayerTabs();
			playerBattleAbilitiesTab.visible = true;
		}		
		
		private function playerSocketsTextClick(e:MouseEvent) : void
		{
			hidePlayerTabs();
			playerBattleSocketsTab.visible = true;
		}
		
		private function enemyArmyTextClick(e:MouseEvent) : void
		{
			hideEnemyTabs();
			enemyBattleArmyTab.visible = true;
		}
		
		private function enemyHeroTextClick(e:MouseEvent) : void
		{
			hideEnemyTabs();
			enemyBattleHeroTab.visible = true;
		}
		
		private function enemyAbilitiesTextClick(e:MouseEvent) : void
		{
			hideEnemyTabs();
			//enemyBattleAbilitiesTab.visible = true;
		}		
		
		private function enemySocketsTextClick(e:MouseEvent) : void
		{
			hideEnemyTabs();
			//enemyBattleSocketsTab.visible = true;
		}		
		
		private function battleMapTextClick(e:MouseEvent) : void
		{
			battleMap.visible = true;
		}		
		
		private function combatLogTextClick(e:MouseEvent) : void
		{
			battleMap.visible = false;
		}				
		
		private function closeButtonClick(e:MouseEvent) : void
		{
			this.visible = false;
		}
	}
	
}
