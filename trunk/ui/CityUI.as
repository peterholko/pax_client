package ui 
{
	
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
		
	public class CityUI extends MovieClip 
	{		
		public function CityUI() 
		{					
		}
		
		public function init() : void
		{
			this.visible = false;
		}
				
		public function showPanel() : void
		{
			this.visible = true;
		}		
		
		private function closeButtonClick(e:MouseEvent) : void
		{
			this.visible = false;
		}
	}
	
}
