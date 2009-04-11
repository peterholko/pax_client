package 
{
	import flash.display.MovieClip;
	import flash.events.MouseEvent;	
	
	public class PanelController
	{
		public var main:Main;
		
		protected var panel:MovieClip;
				
		public function PanelController() : void
		{
		}
		
		public function initialize() : void
		{
		}
		
		public function showPanel() : void
		{						
			panel.visible = true;
		}
		
		protected function closePanel(e:MouseEvent) : void
		{
			//Hide Info Panel
			e.target.parent.visible = false;
		}	
	}
}