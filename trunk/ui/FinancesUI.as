package ui
{	
	import flash.display.MovieClip;
	
	public class FinancesUI extends MovieClip 
	{				
		public function FinancesUI() 
		{
			// constructor code
		}
		
		public function hidePanel() : void
		{
			this.visible = false;
		}
		
		public function showPanel() : void
		{
			this.visible = true;
		}		
	}
	
}
