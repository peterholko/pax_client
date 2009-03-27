package
{
	import flash.display.Sprite;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.events.Event;
	import flash.events.MouseEvent;	
		
	public  class Entity extends Sprite
	{
		public static var ARMY:int = 1;
		public static var CITY:int = 2;
		
		public var id:int;
		public var playerId:int;
		public var state:int;
		public var xPos:int;
		public var yPos:int;		

		protected var image:Bitmap = null;	
	
		public function Entity() : void
		{
			doubleClickEnabled = true;
			addEventListener(MouseEvent.DOUBLE_CLICK, mouseDoubleClick);
			addEventListener(MouseEvent.CLICK, mouseClick);
		}
		
		public function initialize() : void
		{
		}
		
		public function update() : void
		{
			x = xPos * Tile.WIDTH;
			y = yPos * Tile.HEIGHT;				
		}
		
		protected function mouseClick(e:Event) : void
		{
		}
		
		protected function mouseDoubleClick(e:Event) : void
		{
		}
	}
}