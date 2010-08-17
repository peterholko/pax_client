package ui
{
	import flash.display.MovieClip;
	import flash.display.Bitmap;
	import flash.display.BitmapData;		
	import game.map.Tile;
	
	public class IconTile extends MovieClip 
	{
		public var tile:Tile;
		protected var image:Bitmap = null;
		
		public function IconTile()
		{
			// constructor code
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
			image.width = 32;
			image.height = 32;
			image.x = 2;
			image.y = 2;
			
			addChild(image);			
		}		
	}
	
}
