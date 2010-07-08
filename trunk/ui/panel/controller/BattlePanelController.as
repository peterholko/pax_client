package ui.panel.controller 
{
	import fl.accessibility.LabelButtonAccImpl;
	import flash.events.MouseEvent;
	import flash.utils.Dictionary;
	
	import game.battle.Battle;
	import game.entity.Army;
	import game.unit.Unit;
	import game.unit.UnitEventDispatcher;
	import game.unit.events.UnitEvent;
	import game.unit.events.UnitDestroyEvent;
	import game.unit.events.UnitDamageEvent;
	import game.Game;
	
	import ui.panel.view.Panel;
	import ui.panel.view.BattlePanel;
	
	public class BattlePanelController extends PanelController
	{
		public static var INSTANCE:BattlePanelController = new BattlePanelController();
		public static var SPACER_X:int = 20;
		public static var SPACER_Y:int = 60;
		
		private static var NONE:int = 0;
		private static var ATTACK:int = 1;
		
		public var battle:Battle;
		
		private var battlePanel:BattlePanel
		private var state:int = NONE;
		private var selectedUnit:Unit = null;
		private var units:Dictionary;
		private var numUnits:int;
		
		public function BattlePanelController() : void
		{
		}
		
		override public function initialize(main:Main) : void
		{			
			//Must use two variables as Actionscript does not have generics
			panel = Panel(main.battlePanel);
			battlePanel = main.battlePanel;
			
			battlePanel.attackButton.addEventListener(MouseEvent.CLICK, attackClick);

			UnitEventDispatcher.INSTANCE.addEventListener(UnitEvent.DESTROYED, unitDestroyed);
			UnitEventDispatcher.INSTANCE.addEventListener(UnitEvent.DAMAGED, unitDamaged);
			
			super.initialize(main);
		}		
		
		public function setArmies() : void
		{
			units = new Dictionary();
			numUnits = 0;

			for (var i:int = 0; i < battle.armies.length; i++)
			{
				var army:Army = battle.armies[i];
				var j:int = 0;
				
				for each (var unit:Unit in army.units)
				{					
					unit.initialize();
					unit.addEventListener(MouseEvent.CLICK, unitClick);
					
					if (unit.parentEntity.playerId == Game.INSTANCE.player.id)
					{
						unit.x = SPACER_X;
					}
					else
					{
						unit.x = battlePanel.width - SPACER_X - unit.width;
					}
					
					unit.y = SPACER_Y * ((j++) + 1);
					
					battlePanel.background.addChild(unit);
					units[unit.id] = unit;
					numUnits++;
				}
			}
			
			for (var id:Object in units)
			{
				trace("id: " + id);
			}			
		}
				
		private function attackClick(e:MouseEvent) : void
		{
			state = ATTACK;
		}
		
		private function unitClick(e:MouseEvent) : void
		{
			var unit:Unit = Unit(e.currentTarget);
			
			if (state == ATTACK)
			{
				if (unit.parentEntity.playerId != Game.INSTANCE.player.id)
				{
					if (selectedUnit != null)
					{
						sendTarget(selectedUnit, unit);
					}					
				}		
				
				selectedUnit = null;
				state = NONE;
			}
			else
			{
				if (unit.parentEntity.playerId == Game.INSTANCE.player.id)
					selectedUnit = unit;
			}
		}	
		
		private function unitDestroyed(e:UnitDestroyEvent) : void
		{									
			var unit:Unit = units[e.unitId];
			
			if(unit != null)
				if (battlePanel.background.contains(unit))
					battlePanel.background.removeChild(unit);
		}
		
		private function unitDamaged(e:UnitDamageEvent) : void
		{		
			var damageMessage:String = "";
			
			damageMessage = "Unit " + e.sourceId + " did " + e.damage + " damage to Unit " + e.unitId + "<br>";
			battlePanel.textBackground.battleLog.htmlText += damageMessage;
		}
		
		private function sendTarget(source:Unit, target:Unit) : void
		{
			Game.INSTANCE.sendTarget(battle.id, source.parentEntity.id, source.id, target.parentEntity.id, target.id);
		}
		
	}
	
}