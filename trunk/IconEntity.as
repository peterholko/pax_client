package 
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;	
	import flash.display.Sprite;
	
	public class IconEntity extends Sprite
	{
		public var entity:Entity;	
		
		protected var image:Bitmap = null;

		public function IconEntity() : void
		{
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
			addChild(image);			
		}
	}
	
}