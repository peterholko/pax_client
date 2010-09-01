package ui 
{	
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	
	public class CloseButton extends MovieClip 
	{		
		
		public function CloseButton() 
		{
			addEventListener(MouseEvent.MOUSE_OUT, mouseOut);
			addEventListener(MouseEvent.MOUSE_OVER, mouseOver);
			addEventListener(MouseEvent.MOUSE_DOWN, mouseDown);						
		}
		
		private function mouseOut(e:MouseEvent) : void
		{
			this.gotoAndStop("Rest");
		}
		
		private function mouseOver(e:MouseEvent) : void
		{
			this.gotoAndStop("MouseOver");
		}
		
		private function mouseDown(e:MouseEvent): void
		{
			this.gotoAndStop("MouseDown");
		}		
	}
	
}
