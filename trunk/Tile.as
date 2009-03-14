package
{
	import flash.display.Sprite;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.geom.Rectangle;
	import flash.geom.Point;		
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	public class Tile extends Sprite
	{
		public static var onClick:String = "onTileClick";
		
		public static const WIDTH:int = 32;
		public static const HEIGHT:int = 32;		
		
		private static var imageTiles:BitmapData = new TestTiles(0,0);	

		private var image:Bitmap;
		
		public var gameX:int;
		public var gameY:int;
		public var index:int;
		public var type:int;		
		
		public function Tile() : void
		{
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
					tileImageX = 32;
					tileImageY = 0;					
					break;
				case 2:
					tileImageX = 0;
					tileImageY = 32;						
					break;
				case 3:
					tileImageX = 32;
					tileImageY = 32;					
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
				
		private function mouseClick(e:Event) : void
		{
			trace("Tile - mouseClick");
			var coords:Object =  {x: this.gameX, y: this.gameY};
			
			var pEvent:ParamEvent = new ParamEvent(Tile.onClick);
			pEvent.params = coords
			
			Game.INSTANCE.dispatchEvent(pEvent);
		}
	}
}
