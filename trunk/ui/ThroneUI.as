package ui 
{	
	import flash.display.MovieClip;	
	
	public class ThroneUI extends Panel
	{				
		public static var THRONE_PANEL:int = 0;
	
		public function ThroneUI() 
		{
			// constructor code
		}
		
		override public function hidePanel() : void
		{
			this.visible = false;
		}
		
		override public function showPanel() : void
		{
			this.visible = true;
		}		
	}
	
}
