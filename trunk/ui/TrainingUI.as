package ui 
{	
	import flash.display.MovieClip;
	
	public class TrainingUI extends MovieClip 
	{				
		public function TrainingUI() 
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
