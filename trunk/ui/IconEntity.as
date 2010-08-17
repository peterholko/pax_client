package ui
{
	import flash.display.MovieClip;
	import flash.display.Bitmap;
	import flash.display.BitmapData;		
	import game.entity.Entity;
	
	public class IconEntity extends MovieClip 
	{
		public var entity:Entity;
		protected var image:Bitmap = null;
		
		public function IconEntity()
		{
			// constructor code
		}
		
		public function setEntity(entity:Entity) : void
		{
			this.entity = entity;
			
			copyImage();
		}
		
		private function copyImage() : void
		{
			var entityImage:Bitmap = entity.getImage();
			var iconBitmapData:BitmapData = entityImage.bitmapData;	
			
			image = new Bitmap(iconBitmapData);
			image.width = 32;
			image.height = 32;
			image.smoothing = true;
			image.x = 2;
			image.y = 2;
			
			addChild(image);			
		}	
	}
	
}
