package game.map 
{
	import flash.display.Sprite;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import game.Game;
		
	public class MapBattle extends Sprite
	{
		public static var onDoubleClick:String = "onMapBattleDoubleClick";
		
		public var battleId:int;
		public var gameX:int;
		public var gameY:int;
		public var tile:Tile;
		
		protected var image:Bitmap = null;	
		
		public function MapBattle() 
		{
		}
		
		public function initialize() : void
		{
			var imageData:BitmapData = null;
			
			imageData = new BattleImage(0,0);
			
			image = new Bitmap(imageData);
			addChild(image);	
			
			doubleClickEnabled = true;
			addEventListener(MouseEvent.DOUBLE_CLICK, mouseDoubleClick);
			addEventListener(MouseEvent.CLICK, mouseClick);			
		}		
		
		public function update() : void
		{
			x = gameX * Tile.WIDTH;
			y = gameY * Tile.HEIGHT;				
		}		
		
		protected function mouseClick(e:Event) : void
		{
			trace("MapBattle - mouseClick")
			
			var pEvent:ParamEvent = new ParamEvent(Tile.onClick);
			pEvent.params = tile;
						
			Game.INSTANCE.dispatchEvent(pEvent);			
		}
		
		protected function mouseDoubleClick(e:Event) : void
		{
			trace("MapBattle - mouseDoubleClick");
			var pEvent:ParamEvent = new ParamEvent(MapBattle.onDoubleClick);
			pEvent.params = this;
						
			Game.INSTANCE.dispatchEvent(pEvent);
		}
	}
	
}