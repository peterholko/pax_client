package game.entity
{
	import flash.display.Sprite;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import game.Game;
	import game.map.Tile;
	import game.Item;
	
	import ui.IconEntity;	
	
	import FarmImage;
	import MineImage;
	import TrapperImage;
	import LumbermillImage;
	import QuarryImage;
	
	public class Improvement extends Entity 
	{
		public static var TYPE:int = Entity.IMPROVEMENT;
		public static var FARM:int = 1;		
		public static var TRAPPER:int = 2;
		public static var LUMBERMILL:int = 3;
		public static var MINE:int = 4;
		public static var QUARRY:int = 5;
				
		public static var onDoubleClick:String = "onImprovementDoubleClick";		
		
		public var icon:IconEntity = null;

		public function Improvement() : void
		{				
		}
		
		public static function getImprovementFromPos(xCoord:int, yCoord:int) : Improvement
		{
			var entities:Array = EntityManager.INSTANCE.getEntities();
			
			for(var i:int = 0; i < entities.length; i++)
			{
				var entity:Entity = Entity(entities[i]);
				
				if(entity.type == Entity.IMPROVEMENT)
				{
					if(entity.gameX == xCoord && 
					   entity.gameY == yCoord)
					{
						return Improvement(entity);
					}
				}
			}
			
			return null;
		}
		
		public static function getImageStatic(type:int) : BitmapData
		{
			var imageData:BitmapData = null;
			
			if(type == FARM)
				imageData = new FarmImage(0,0);
			else if(type == TRAPPER)
				imageData = new TrapperImage(0,0);
			else if(type == LUMBERMILL)
				imageData = new LumbermillImage(0,0);
			else if(type == MINE)
				imageData = new MineImage(0,0);			
			else if(type == QUARRY)
				imageData = new QuarryImage(0,0);
			else
				imageData = new FarmImage(0,0);		
				
			return imageData;
		}
		
		public static function getNameStatic(type:int) : String
		{
			switch(type)
			{
				case FARM:
					return "Farm";
				case TRAPPER:
					return "Trapper";
				case LUMBERMILL:
					return "Lumbermill";
				case MINE:
					return "Mine";
				case QUARRY:
					return "Quarry";
			}
			
			return "Unknown";			
		}
		
		public static function getCost(type:int) : int
		{
			return 100;
		}
		
		override public function getImage() : BitmapData
		{
			return getImageStatic(this.subType);
		}
		
		override public function initialize() : void
		{								
			this.image = new Bitmap(getImageStatic(this.subType));
			this.addChild(this.image);	
		}		
		
		override public function getName() : String
		{
			return getNameStatic(this.subType);
		}		
		
		override protected function mouseClick(e:Event):void
		{
			var pEvent:ParamEvent = new ParamEvent(Tile.onClick);
			pEvent.params = tile;

			Game.INSTANCE.dispatchEvent(pEvent);
		}

		override protected function mouseDoubleClick(e:Event):void
		{
			trace("Improvement - mouseDoubleClick");
			var pEvent:ParamEvent = new ParamEvent(onDoubleClick);
			pEvent.params = this;

			Game.INSTANCE.dispatchEvent(pEvent);
		}				
		
		public function getHarvestItems() : Array
		{
			var items:Array = new Array();
			
			switch(this.subType)
			{
				case FARM:
					items.push(Item.PLANTS);
					return items;
			}
			
			return items;			
		}
		
		public function getAvailableResource() : Array
		{
			var resources:Array = new Array();
			
			switch(this.subType)
			{
				case FARM:
					resources.push("Plants");
					return resources;
			}
			
			resources.push("None");
			return resources;
		}
		
		public function getProductionCost() : int
		{
			switch(type)
			{
				case FARM:
					return 100;
			}
			
			return Number.MAX_VALUE;
		}		

	}
	
}
