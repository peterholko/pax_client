﻿package game.map
{
	import flash.display.Sprite;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.geom.Rectangle;
	import flash.geom.Point;		
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import game.Game;
	import game.entity.Entity;
	
	public class Tile extends Sprite
	{
		public static var onClick:String = "onTileClick";
		
		public static const WIDTH:int = 48;
		public static const HEIGHT:int = 48;		
		
		private static var imageTiles:BitmapData = new TestTiles(0,0);	
		
		public var gameX:int;
		public var gameY:int;
		public var index:int;
		public var type:int;	
		
		private var image:Bitmap;
		public var entities/*Entity*/:Array;		
		
		public function Tile() : void
		{
			entities = new Array();
		}
		
		public function initialize() : void
		{			
			var tileImageX:int;
			var tileImageY:int;
			
			switch(type)
			{
				case 0:
					tileImageX = 0;
					tileImageY = 0;
					break;
				case 1:
					tileImageX = WIDTH;
					tileImageY = 0;					
					break;
				case 2:
					tileImageX = 0;
					tileImageY = HEIGHT;						
					break;
				case 3:
					tileImageX = WIDTH;
					tileImageY = HEIGHT;					
					break;					
				default:
					tileImageX = 0;
					tileImageY = 0;					
			}
			
			var imageData:BitmapData = null;
			imageData = new BitmapData(Tile.WIDTH, Tile.HEIGHT, false);			
						
			var rect:Rectangle = new Rectangle(tileImageX, tileImageY, Tile.WIDTH, Tile.HEIGHT);
			var pt:Point = new Point(0, 0);
			imageData.copyPixels(imageTiles, rect, pt, null, null, true);			
			
			image = new Bitmap(imageData);		
			image.x = 0;
			image.y = 0;
			
			addChild(image);
			addEventListener(MouseEvent.CLICK, mouseClick);
		}
		
		public function addEntity(entity:Entity) : void
		{
			var foundEntity:Boolean = false;
			
			for (var i:int = 0; i < entities.length; i++)
			{
				if (entities[i].id == entity.id)
				{
					foundEntity = true;
					break;
				}
			}
			
			if (!foundEntity)
			{
				entities.push(entity);
			}
		}
		
		public function removeEntity(entity:Entity) : void
		{
			for (var i:int = 0; i < entities.length; i++)
			{
				if (entities[i].id == entity.id)
				{
					entities.splice(i, 1);
					break;
				}
			}			
		}
		
		public function getImage() : Bitmap
		{
			return image;
		}
				
		private function mouseClick(e:Event) : void
		{
			trace("Tile - mouseClick");
			
			var pEvent:ParamEvent = new ParamEvent(Tile.onClick);
			pEvent.params = this;
						
			Game.INSTANCE.dispatchEvent(pEvent);
		}
	}
}