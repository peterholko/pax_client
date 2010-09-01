package ui
{
	import flash.display.MovieClip;
	import flash.display.Bitmap;
	import flash.display.BitmapData;		
	import game.entity.Entity;
	import flash.events.MouseEvent;
	
	public class IconEntity extends MovieClip 
	{
		private static var REST:int = 0;
		private static var ACTIVATE:int = 1;		
		
		public var entity:Entity;
		protected var image:Bitmap = null;
		
		private var iconState:int = REST;		
		
		public function IconEntity()
		{
			addEventListener(MouseEvent.MOUSE_OUT, mouseOut);
			addEventListener(MouseEvent.MOUSE_OVER, mouseOver);
			addEventListener(MouseEvent.CLICK, mouseClick);		
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
			this.gotoAndStop("MouseOver");
		}
		
		private function mouseClick(e:MouseEvent): void
		{
			this.gotoAndStop("MouseClick");
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
			image.width = 34;
			image.height = 34;
			image.smoothing = true;
			image.x = 1;
			image.y = 1;
			
			addChild(image);			
		}	
	}
	
}
