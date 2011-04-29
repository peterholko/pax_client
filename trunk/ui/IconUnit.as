package ui
{
	import flash.display.MovieClip;
	import flash.display.Bitmap;
	import flash.display.BitmapData;		
	import flash.events.MouseEvent;
	
	import game.Game;
	import game.unit.Unit;
	import game.unit.events.UnitEvent;
	import game.entity.Army;
		
	public class IconUnit extends MovieClip 
	{
		private static var REST:int = 0;
		private static var ACTIVATE:int = 1;		
		
		public var stackSize:MovieClip;
		
		public var unit:Unit;
		public var anchorX:int;
		public var anchorY:int;		
		
		protected var image:Bitmap = null;
		
		public function IconUnit()
		{	
			this.mouseChildren = false;
			stackSize.mouseChildren = false;
			stackSize.mouseEnabled = false;
		}
				
		public function setUnit(unit:Unit) : void
		{
			this.unit = unit
			
			var iconBitmapData:BitmapData = Unit.getImage(unit.type);
			
			image = new Bitmap(iconBitmapData);
			image.x = 0;
			image.y = 0;
			
			addChild(image);		
			
			updateStackSize();
		}
		
		public function updateStackSize() : void
		{
			stackSize.sizeText.text = UtilUI.FormatNum(unit.size);
		}
				
		
		/*				var fullSizeImage:BitmapData = createImage(type);
				var croppedImage:BitmapData = new BitmapData(34,34);
				
				croppedImage.copyPixels(fullSizeImage, new Rectangle(7,7,34,34), new Point());
				
				trace("croppedImage: " + croppedImage.width + " " + croppedImage.height);
				
				addChild(new Bitmap(croppedImage));
				
				image = new Bitmap(croppedImage);		
				
				trace("image: " + image.width + " " + image.height);*/
	}
	
}
