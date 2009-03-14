package
{
	import flash.display.Sprite;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.events.Event;
	import flash.events.MouseEvent;	
	
	import CityImage;
	
	public class City extends Entity
	{
		public static var onClick:String = "onCityClick";		
		
		public var id:int;
		public var playerId:int;
		public var state:int;
		public var xPos:int;
		public var yPos:int;
		
		public function City() : void
		{
		}
		
		override public function initialize() : void
		{
			var imageData:BitmapData = null;
			
			imageData = new CityImage(0,0);
			
			this.image = new Bitmap(imageData);
			this.addChild(this.image);	
			
			addEventListener(MouseEvent.CLICK, mouseClick);
		}
		
		override protected function mouseClick(e:Event) : void
		{
			trace("City - mouseClick");			
			var pEvent:ParamEvent = new ParamEvent(City.onClick);
			pEvent.params = this;
			
			Game.INSTANCE.dispatchEvent(pEvent);
		}
	}
}