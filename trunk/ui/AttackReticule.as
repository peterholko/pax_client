package ui 
{
	import flash.ui.Mouse;
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	
	public class AttackReticule extends MovieClip 
	{		
		private var state:Boolean;
	
		public function AttackReticule() 
		{
			state = false;			
			this.visible = false;
			this.mouseEnabled = false;
			this.mouseChildren = false;
		}
						
		public function show()
		{					
			this.visible = true;
			this.mouseEnabled = false;
			this.mouseChildren = false;
			this.startDrag(true);
			this.state = true;
			Mouse.hide();
		}
		
		public function hide()
		{
			this.state = false;
			this.visible = false;
			this.stopDrag();	
			Mouse.show();
		}
	}
}
