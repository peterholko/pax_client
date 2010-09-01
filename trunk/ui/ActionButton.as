package ui
{
	import flash.display.MovieClip;
	import flash.text.TextField;
	import flash.events.MouseEvent;	
		
	public class ActionButton extends MovieClip
	{
		private static var REST:int = 0;
		private static var ACTIVATE:int = 1;		
		
		public var actionText:TextField;
		
		private var iconState:int = REST;
		
		public function ActionButton() 
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
			trace("IconTile mouseOver");
			this.gotoAndStop("MouseOver");
		}
		
		private function mouseClick(e:MouseEvent): void
		{
			trace("IconTile mouseClick");
			this.gotoAndStop("MouseClick");
		}		
	}
	
}
