package game.entity
{
	import flash.display.Sprite;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import game.Game;
	import game.map.Tile;
	import ui.IconEntity;	
	
	import FarmImage;
	
	public class Improvement extends Entity 
	{
		public static var TYPE:int = Entity.IMPROVEMENT;
		public static var FARM:int = 0;		
				
		public static var onDoubleClick:String = "onImprovementDoubleClick";		
		
		public var icon:IconEntity = null;

		public function Improvement() : void
		{				
		}
		
		override public function initialize() : void
		{
			var imageData:BitmapData = null;
			
			if(this.subType == FARM)
				imageData = new FarmImage(0,0);
			else
				imageData = new FarmImage(0,0);
			
			this.image = new Bitmap(imageData);
			this.addChild(this.image);	
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
		
		public function getName() : String
		{
			switch(this.subType)
			{
				case FARM:
					return "Farm";
			}
			
			return "Unknown";
		}
		
		public function getAvailableResources() : Array
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

	}
	
}
