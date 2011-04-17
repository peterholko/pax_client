package ui 
{
	import flash.display.MovieClip;

	import game.entity.City;	
		
	public class ProductionUI extends MovieClip 
	{
		public var city:City;
		

		
				
		public function ProductionUI() 
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
