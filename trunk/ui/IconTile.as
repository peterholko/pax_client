package ui
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;	
	import flash.display.Sprite;
	
	import game.map.Tile;
	
	public class IconTile extends Sprite
	{
		public var tile:Tile;	
		
		protected var image:Bitmap = null;

		public function IconEntity() : void
		{
		}
		
		public function setTile(tile:Tile) : void
		{
			this.tile = tile;
			
			copyImage();
		}
		
		private function copyImage() : void
		{
			var tileImage:Bitmap = tile.getImage();
			var iconBitmapData:BitmapData = tileImage.bitmapData;			
			
			image = new Bitmap(iconBitmapData);
			addChild(image);			
		}
	}
	
}