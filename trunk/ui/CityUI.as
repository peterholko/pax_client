package ui 
{
	import flash.utils.getQualifiedClassName	
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	import flash.display.Bitmap;
	import flash.display.DisplayObject;
	import game.entity.City;
		
	public class CityUI extends MovieClip 
	{		
		public static var CONTROL_BAR_X_BOTTOM:int = 249;
		public static var CONTROL_BAR_Y_BOTTOM:int = 322;
		public static var CONTROL_BAR_X_TOP:int = 249;
		public static var CONTROL_BAR_Y_TOP:int = 62;
		
		public var closeButton:MovieClip;					
		
		public var rulerMessageLayer:MovieClip;		
		public var militaryLayer:MovieClip;
		public var inventoryLayer:MovieClip;
		public var tradeLayer:MovieClip;
		public var buildingsLayer:MovieClip;
		public var improvementsLayer:ImprovementsUI;
		public var logLayer:MovieClip;
		public var closedLayer:MovieClip;
		public var controlBarLayer:ControlBarLayer;
		
		private var city:City;
	
		public function CityUI() 
		{
			closeButton.addEventListener(MouseEvent.CLICK, closeButtonClick);			
		}
		
		public function init() : void
		{
			this.visible = false;	
			
			controlBarLayer.militaryText.addEventListener(MouseEvent.CLICK, militaryTextClick);
			controlBarLayer.improvementsText.addEventListener(MouseEvent.CLICK, improvementsTextClick);
			controlBarLayer.buildingsText.addEventListener(MouseEvent.CLICK, buildingsTextClick);
			controlBarLayer.tradeText.addEventListener(MouseEvent.CLICK, tradeTextClick);
			controlBarLayer.inventoryText.addEventListener(MouseEvent.CLICK, inventoryTextClick);
			controlBarLayer.logText.addEventListener(MouseEvent.CLICK, logTextClick);			
			
			
		}
		
		public function setCity(_city:City) : void
		{
			city = _city;
			improvementsLayer.city = _city;
		}
						
		public function showPanel() : void
		{
			this.visible = true;
			hideLayers();
			
			closedLayer.visible = true;											
			controlBarLayer.visible = true;
			setControlBarBottom();
		}		
		
		private function militaryTextClick(e:MouseEvent) : void
		{
			hideLayers();
			setControlBarTop();					
			militaryLayer.visible = true;
		}
		
		private function improvementsTextClick(e:MouseEvent) : void
		{
			hideLayers();
			setControlBarTop();					
			
			improvementsLayer.showPanel();			
		}
		
		private function buildingsTextClick(e:MouseEvent) : void
		{
			hideLayers();
			setControlBarTop();					
			buildingsLayer.visible = true;
		}
		
		private function tradeTextClick(e:MouseEvent) : void
		{
			hideLayers();
			setControlBarTop();					
			tradeLayer.visible = true;
		}
		
		private function inventoryTextClick(e:MouseEvent) : void
		{
			hideLayers();
			setControlBarTop();					
			inventoryLayer.visible = true;
		}
		
		private function logTextClick(e:MouseEvent) : void
		{
			hideLayers();
			setControlBarTop();					
			logLayer.visible = true;
		}				
		
		private function closeButtonClick(e:MouseEvent) : void
		{
			this.visible = false;
		}
		
		private function hideLayers() : void
		{
			rulerMessageLayer.visible = false;				
			militaryLayer.visible = false;
			inventoryLayer.visible = false;
			tradeLayer.visible = false;
			buildingsLayer.visible = false;
			improvementsLayer.visible = false;
			logLayer.visible = false;
			closedLayer.visible = false;
		}
		
		private function setControlBarBottom() : void
		{
			controlBarLayer.x = CONTROL_BAR_X_BOTTOM;
			controlBarLayer.y = CONTROL_BAR_Y_BOTTOM;				
		}
		
		private function setControlBarTop() : void 
		{
			controlBarLayer.x = CONTROL_BAR_X_TOP;
			controlBarLayer.y = CONTROL_BAR_Y_TOP;				
		}
	}
	
}
