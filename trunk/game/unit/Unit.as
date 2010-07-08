package game.unit
{
	import flash.display.Bitmap;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.display.DisplayObjectContainer;
	
	import net.Connection;
	
	import game.entity.Army;
	import game.entity.City;
	import game.entity.Entity;
	
	import ui.panel.controller.ArmyPanelController;
	import ui.panel.controller.CityPanelController;
	
	public class Unit extends Sprite
	{
		public static var LAND:int = 1;
		public static var SEA:int = 2;
		public static var AIR:int = 3;
		
		public static var FOOTSOLDIER:int = 1;
		public static var ARCHER:int = 2;
		
		public var id:int;
		public var type:int;
		public var size:int;
		public var parentEntity:Entity;
		public var image:MovieClip;
				
		private var iconContainer:MovieClip;
		private var anchorX:int;
		private var anchorY:int;
		
		public function Unit() : void
		{
		}
		
		public function initialize() : void
		{
			image = createImage(type);
		
			iconContainer = new IconContainer();
			iconContainer.iconLayer.addChild(image);
			iconContainer.stackSize.stackSizeTextfield.text = size;
		
			addChild(iconContainer);
		}
		
		public function addDragDrop() : void
		{
			addEventListener(MouseEvent.MOUSE_DOWN, mouseDown);
			addEventListener(MouseEvent.MOUSE_UP, mouseUp);			
		}
				
		public function setAnchorPosition(initialX:int, initialY:int) : void
		{
			anchorX = initialX;
			anchorY = initialY;
			
			x = initialX;
			y = initialY;			
		}
			
		private function mouseDown(e:MouseEvent) : void 
		{
			trace("Unit - mouseDown");			
			e.stopPropagation();
			
			if (parentEntity.type == Entity.ARMY)
			{
				ArmyPanelController.INSTANCE.showPanel();
			}
			else if (parentEntity.type == Entity.CITY)
			{
				CityPanelController.INSTANCE.showPanel();
			}
			
			
			startDrag();
		}
		
		private function mouseUp(e:MouseEvent) : void
		{
			trace("Unit - mouseUp");
			e.stopPropagation();
			stopDrag();
			x = anchorX;
			y = anchorY;
			
			//TODO Move into a seperate function
			if (ArmyPanelController.INSTANCE.getUnitContainer() == dropTarget ||
				ArmyPanelController.INSTANCE.getUnitContainer().contains(dropTarget))
			{
				if (parentEntity.id != ArmyPanelController.INSTANCE.army.id)
				{
					var parameters:Object = {unitId: id, 
											 sourceId: parentEntity.id, 
											 sourceType: parentEntity.type, 
											 targetId: ArmyPanelController.INSTANCE.army.id,
											 targetType: Army.TYPE };
											 
					var transferUnitEvent:ParamEvent = new ParamEvent(Connection.onSendTransferUnit);
					transferUnitEvent.params = parameters;
					
					Connection.INSTANCE.dispatchEvent(transferUnitEvent);			
				}
			}
			else if (CityPanelController.INSTANCE.getUnitContainer() == dropTarget ||
					 CityPanelController.INSTANCE.getUnitContainer().contains(dropTarget))
			{
				if (parentEntity.id != CityPanelController.INSTANCE.city.id)
				{
					var parameters:Object = {unitId: id, 
											 sourceId: parentEntity.id, 
											 sourceType: parentEntity.type, 
											 targetId: CityPanelController.INSTANCE.city.id,
											 targetType: City.TYPE };
											 
					var transferUnitEvent:ParamEvent = new ParamEvent(Connection.onSendTransferUnit);
					transferUnitEvent.params = parameters;
					
					Connection.INSTANCE.dispatchEvent(transferUnitEvent);			
				}				
			}
			
		}	
		
		public function addDamage(damage:int) : void
		{
			var unitHp:int = UnitType.INSTANCE.getHp(type);		
			var numKilled:int = damage / unitHp;
			size -= numKilled;
			iconContainer.stackSize.stackSizeTextfield.text = size;
		}
		
		public static function createImage(unitType:int) : MovieClip
		{
			var imageData;
			
			trace("Unit - getImage - unitType: " + unitType);
			
			switch(unitType)
			{
				case FOOTSOLDIER:
					return new Footsoldier();
				case ARCHER:
					return new Archer();
			}
			
			throw new Error("Invalid Unit Type");
		}
		
		public static function getName(unitType:int) : String
		{
			switch(unitType)
			{
				case FOOTSOLDIER:
					return "Footsoldier";
				case ARCHER:
					return "Archer";
			}
			
			throw new Error("Invalid Unit Type");
		}
		
		public static function removeUnitChildren(displayContainer:DisplayObjectContainer) : void
		{
			var numChildern:int = displayContainer.numChildren - 1;
			
			for (var i:int = numChildern; i >= 0; i--)
			{
				if(displayContainer.getChildAt(i) is Unit)
					displayContainer.removeChildAt(i); 
			}
		}
	}
}