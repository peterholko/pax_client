package ui
{
	import flash.display.MovieClip;
	import flash.events.MouseEvent;

	import ui.events.PopulationHeaderOpenCloseEvent;
	import ui.events.CityUIEvents;
	
	public class PopulationHeader extends MovieClip
	{
		public var openButton:MovieClip;
		public var closeButton:MovieClip;
		public var caste:int;
		public var state:int;
		
		public function PopulationHeader() 
		{
			openButton.addEventListener(MouseEvent.CLICK, openButtonClick);
			closeButton.addEventListener(MouseEvent.CLICK, closeButtonClick);						
		}
		
		public function setOpenState() : void
		{
			openButton.visible = true;
			closeButton.visible = false;
			state = 0;
		}
		
		public function setCloseState() : void
		{
			openButton.visible = false;
			closeButton.visible = true;			
			state = 1;
		}
		
		public function openButtonClick(e:MouseEvent) : void
		{
			trace("PopulationHeader openButtonClick");
			e.stopImmediatePropagation();
			
			setCloseState();
			
			var openEvent:PopulationHeaderOpenCloseEvent = new PopulationHeaderOpenCloseEvent(CityUIEvents.PopOpenCloseEvent);
			openEvent.caste = caste;						
						
			CityUIEventDispatcher.INSTANCE.dispatchEvent(openEvent);
		}
		
		public function closeButtonClick(e:MouseEvent) : void
		{
			trace("PopulationHeader closeButtonClick");
			e.stopImmediatePropagation();			
			
			setOpenState();
			
			var closeEvent:PopulationHeaderOpenCloseEvent = new PopulationHeaderOpenCloseEvent(CityUIEvents.PopOpenCloseEvent);
			closeEvent.caste = caste;		
						
			CityUIEventDispatcher.INSTANCE.dispatchEvent(closeEvent);
		}
		

	}
	
}
