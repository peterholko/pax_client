package ui {
	
	import flash.display.MovieClip;
	import fl.text.TLFTextField;
	import flash.display.Bitmap;
	import game.entity.Improvement;
	import flash.display.BitmapData;
	
	public class BuildSelectorEntry extends MovieClip 
	{
		public var improvementName:TLFTextField;
		public var improvementNameDetail:TLFTextField;					
		public var improvementType:int;		
		
		private var image:Bitmap;
				
		public function BuildSelectorItem() 
		{						
		}
		
		public function setEntry(_improvementType:int) : void
		{
			improvementType = _improvementType;
			improvementName.text = Improvement.getNameStatic(improvementType);
			improvementNameDetail.text = Improvement.getNameStatic(improvementType);			
			
			var bitmapData:BitmapData = Improvement.getImageStatic(improvementType);
			
			image = new Bitmap(bitmapData);
			
			image.x = 1;
			image.y = 1;
			
			addChild(image);	
		}
	}
	
}
