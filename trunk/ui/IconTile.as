package ui
{
	import flash.display.MovieClip;
	import flash.display.Bitmap;
	import flash.display.BitmapData;		
	import game.map.Tile;
	import flash.events.MouseEvent;
	
	public class IconTile extends MovieClip 
	{
		private static var REST:int = 0;
		private static var ACTIVATE:int = 1;
		
		public var tile:Tile;	
		
		protected var image:Bitmap = null;
		
		private var iconState:int = REST;
		
		public function IconTile()
		{
			addEventListener(MouseEvent.MOUSE_OUT, mouseOut);
			addEventListener(MouseEvent.MOUSE_OVER, mouseOver);
			addEventListener(MouseEvent.CLICK, mouseClick);			
		}
		
		public function setTile(tile:Tile) : void
		{
			this.tile = tile;
			copyImage();
		}		
		
		public function showActivate() : void
		{
			iconState = ACTIVATE;
			this.gotoAndStop("Activate");
		}
		
		public function hideActivate() : void
		{
			iconState = REST;
			this.gotoAndStop("Rest");
		}
		
		private function mouseOut(e:MouseEvent) : void
		{
			if(iconState == REST)
				this.gotoAndStop("Rest");
			else
				this.gotoAndStop("Activate");
		}
		
		private function mouseOver(e:MouseEvent) : void
		{
			trace("IconTile mouseOver");
			this.gotoAndStop("MouseOver");
		}
		
		private function mouseClick(e:MouseEvent): void
		{
			trace("IconTile mouseClick");
			this.gotoAndStop("MouseClick");
		}
				
		private function copyImage() : void
		{
			var tileImage:Bitmap = tile.getImage();
			var iconBitmapData:BitmapData = tileImage.bitmapData;			
			
			image = new Bitmap(iconBitmapData);
			image.width = 48;
			image.height = 48;
			image.x = 0;
			image.y = 0;
			
			addChild(image);			
		}		
	}
	
}
