package game.entity
{
	import flash.display.Sprite;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.events.Event;
	import flash.events.MouseEvent;	
	
	import game.Game;
	import game.map.Tile;
		
	public class Entity extends Sprite
	{
		public static var ARMY:int = 1;
		public static var CITY:int = 2;
		public static var BUILDING:int = 3;
		public static var BATTLE:int = 4;
		public static var IMPROVEMENT:int = 5;
		
		public var id:int;
		public var playerId:int;
		public var state:int;
		public var gameX:int;
		public var gameY:int;	
		public var type:int;
		public var subType:int;
		public var tile:Tile;

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
		
		public function getName() : String
		{
			return "Entity";
		}
		
		public function update() : void
		{
			x = gameX * Tile.WIDTH;
			y = gameY * Tile.HEIGHT;				
		}
		
		public function getImage() : BitmapData
		{
			return image.bitmapData;
		}
		
		public function isPlayers() : Boolean
		{
			return playerId == Game.INSTANCE.player.id;
		}
		
		protected function mouseClick(e:Event) : void
		{
		}
		
		protected function mouseDoubleClick(e:Event) : void
		{
		}
	}
}