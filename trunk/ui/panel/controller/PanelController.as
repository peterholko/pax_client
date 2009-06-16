package ui.panel.controller
{
	import flash.display.MovieClip;
	import flash.events.FocusEvent;
	import flash.events.MouseEvent;	
	
	import ui.panel.view.Panel;
	
	public class PanelController
	{
		protected var panel:Panel;
		
		public function PanelController() : void
		{
		}
		
		public function initialize(main:Main) : void
		{			
			panel.visible = false;
			panel.addEventListener(MouseEvent.CLICK, mouseClick);
			panel.addEventListener(MouseEvent.MOUSE_DOWN, mouseDown);
			panel.addEventListener(MouseEvent.MOUSE_UP, mouseUp);	
			panel.closeButton.addEventListener(MouseEvent.CLICK, closePanel);
		}
		
		public function isVisible() : Boolean
		{
			if(panel != null)
				return panel.visible;
			else
				return false;
		}
		
		public function showPanel() : void
		{		
			panel.visible = true;				
			panel.parent.setChildIndex(panel, panel.parent.numChildren - 1);			
		}
				
		protected function mouseClick(e:MouseEvent) : void
		{	
				
		}
		
		protected function mouseDown(e:MouseEvent) : void 
		{
			panel.parent.setChildIndex(panel, panel.parent.numChildren - 1);
			panel.startDrag();
		}
		
		protected function mouseUp(e:MouseEvent) : void
		{
			panel.stopDrag();
		}		
				
		protected function closePanel(e:MouseEvent) : void
		{
			//Hide Info Panel
			panel.visible = false;
		}		
	}
}