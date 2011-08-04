package game.entity
{
	import flash.display.Sprite;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.events.Event;
	import flash.events.MouseEvent;	
	import flash.filters.GlowFilter;
	import flash.utils.Dictionary;
	import game.unit.events.UnitEvent;
	
	import net.packet.InfoArmy;
	import net.packet.ArmyPacket;
	import net.packet.UnitPacket;
	
	import game.Game;
	import game.unit.Unit;
	import game.unit.UnitEventDispatcher;
	import game.map.Tile;
	import game.Item;
	
	import ArmyImage;
	import EnemyImage;	
	
	public class Army extends Entity
	{
		public static var TYPE:int = Entity.ARMY;
		public static var onClick:String = "onArmyClick";
		public static var onDoubleClick:String = "onArmyDoubleClick";
				
		public var units:Dictionary = new Dictionary();
		public var armyName:String;
		public var kingdomName:String;		
		public var items:Array;
		
		private var numUnits:int = 0;		
		private var border:GlowFilter = null;
		
		public function Army() : void
		{			
			this.border = new GlowFilter(0x27F80B, 0);
			this.border.alpha = 0;
			this.filters = [this.border];
		}
		
		override public function initialize() : void
		{
			var imageData:BitmapData = null;
			
			if(playerId == Game.INSTANCE.player.id)
				imageData = new ArmyImage(0,0);
			else
				imageData = new EnemyImage(0,0);
			
			this.image = new Bitmap(imageData);
			this.addChild(this.image);	
		}
		
		override public function getName() : String
		{
			return armyName;
		}
		
		public function showBorder() : void
		{
			this.border.alpha = 1;
			this.filters = [this.border];
		}
		
		public function hideBorder() : void
		{
			this.border.alpha = 0;
			this.filters = [this.border];
		}		
		
		override protected function mouseClick(e:Event) : void
		{
			trace("Army - mouseClick")

			var pEvent:ParamEvent = new ParamEvent(Tile.onClick);
			pEvent.params = tile;
						
			Game.INSTANCE.dispatchEvent(pEvent);			
		}
		
		override protected function mouseDoubleClick(e:Event) : void
		{
			trace("Army - mouseDoubleClick");
			var pEvent:ParamEvent = new ParamEvent(Army.onDoubleClick);
			pEvent.params = this;
						
			Game.INSTANCE.dispatchEvent(pEvent);
		}
		
		public function setArmyInfo(armyInfo:InfoArmy) : void
		{
			trace("Army - setArmyInfo");					
			armyName = armyInfo.name;
			kingdomName = armyInfo.kingdomName;
			
			setUnits(armyInfo.units);		
			setItems(armyInfo.items);
		}
		
		public function setArmyPacket(armyPacket:ArmyPacket) : void
		{
			trace("Army - setArmyPacket");					
			armyName = armyPacket.name;
			kingdomName = armyPacket.kingdomName;			
			
			setUnits(armyPacket.units);		
		}
		
		public function getUnit(unitId:int) : Unit
		{
			return units[unitId];
		}
		
		public function getNumUnits() : int
		{
			return numUnits;
		}
		
		public function getNumSoldiers() : int
		{
			var numSoldiers:int = 0;
			
			for each (var unit:Unit in units)
			{
				numSoldiers += unit.size;
			}
			
			return numSoldiers;
		}
		
		private function setUnits(unitsInfo/*packet.UnitPacket*/:Array ) : void
		{
			var previousUnits:Dictionary = new Dictionary();
			previousUnits = units;
			units = new Dictionary();
			numUnits = 0;
			
			for (var i:int = 0; i < unitsInfo.length; i++)
			{
				var unitInfo:UnitPacket = unitsInfo[i];
				var unit:Unit;
				
				if (previousUnits[unitInfo.id] != null)
				{
					unit = previousUnits[unitInfo.id];
					delete previousUnits[unitInfo.id];
				}
				else
				{
					unit = new Unit();
				}
				
				unit.id = unitsInfo[i].id;
				unit.type = unitsInfo[i].type;
				unit.size = unitsInfo[i].size;
				unit.parentEntity = this;
								
				units[unit.id] = unit;
				numUnits++;
			}
			
			clearPreviousUnits(previousUnits);			
		}	
		
		private function clearPreviousUnits(previousUnits:Dictionary) : void
		{
			for each (var unit:Unit in previousUnits)
			{
				trace("unit: " + unit);
				
				if (unit != null)
				{
					var unitRemovedEvent:UnitEvent = new UnitEvent(UnitEvent.REMOVED);
					unitRemovedEvent.unitId = unit.id;
					
					UnitEventDispatcher.INSTANCE.dispatchEvent(unitRemovedEvent);
				}
			}
		}
		
		private function setItems(itemsInfo:Array) : void
		{
			items = new Array();
			
			for(var i = 0; i < itemsInfo.length; i++)
			{
				var item:Item = new Item();
				
				item.id = itemsInfo[i].id;
				item.entityId = itemsInfo[i].entityId;
				item.type = itemsInfo[i].type;
				item.value = itemsInfo[i].value;
				
				items.push(item);
			}
		}		
	}
}