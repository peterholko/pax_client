package 
{
	import flash.events.MouseEvent;	
	
	public class PanelController
	{
		public var main:Main;
				
		public function PanelController() : void
		{
		}
		
		protected function closePanel(e:MouseEvent) : void
		{
			//Hide Info Panel
			e.target.parent.visible = false;
		}	
	}
}