package ui 
{
	
	import flash.display.MovieClip;
	import fl.text.TLFTextField;
	
	public class QueuePopUp extends MovieClip 
	{				
		public var itemType:int;
		public var itemSize:int;
	
		public var entryNameText:TLFTextField;
		public var typeText:TLFTextField;
		public var quantityText:TLFTextField;
		public var qualityText:TLFTextField;
		public var sourceNameText:TLFTextField;
		public var remainingTimeText:TLFTextField;
		
		public var cancelButton:MovieClip;
		public var confirmButton:MovieClip;		
	
		public function QueuePopUp() 
		{
		}
	}
	
}
