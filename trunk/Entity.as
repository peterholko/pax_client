package
{
	import flash.display.Sprite;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.events.Event;
	import flash.events.MouseEvent;	
		
	public  class Entity extends Sprite
	{
		protected var image:Bitmap = null;
		
		public function Entity() : void
		{
			doubleClickEnabled = true;
			addEventListener(MouseEvent.DOUBLE_CLICK, mouseDoubleClick);
			addEventListener(MouseEvent.CLICK, mouseClick);
		}
		
		public function initialize() : void
		{
		}
		
		protected function mouseClick(e:Event) : void
		{
		}
		
		protected function mouseDoubleClick(e:Event) : void
		{
		}
	}
}