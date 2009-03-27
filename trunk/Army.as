package
{
	import flash.display.Sprite;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.events.Event;
	import flash.events.MouseEvent;	
	import flash.filters.GlowFilter;
	
	import ArmyImage;
	import EnemyImage;	
	
	public class Army extends Entity
	{
		public static var TYPE:int = Entity.ARMY;
		public static var onClick:String = "onArmyClick";
		public static var onDoubleClick:String = "onArmyDoubleClick";
				
		private var border:GlowFilter = null;

		public function Army() : void
		{
			this.border = new GlowFilter(0x27F80B, 0);
			this.border.alpha = 0;
			this.filters = [this.border];
		}
		
		override public function initialize() : void
		{
			var imageData:BitmapData = null;
			
			if(playerId == Game.INSTANCE.player.id)
				imageData = new ArmyImage(0,0);
			else
				imageData = new EnemyImage(0,0);
			
			this.image = new Bitmap(imageData);
			this.addChild(this.image);	
		}
		
		public function showBorder() : void
		{
			this.border.alpha = 1;
			this.filters = [this.border];
		}
		
		public function hideBorder() : void
		{
			this.border.alpha = 0;
			this.filters = [this.border];
		}		
		
		override protected function mouseClick(e:Event) : void
		{
			trace("Army - mouseClick");			
			var pEvent:ParamEvent = new ParamEvent(Army.onClick);
			pEvent.params = this;
						
			Game.INSTANCE.dispatchEvent(pEvent);
		}
		
		override protected function mouseDoubleClick(e:Event) : void
		{
			trace("Army - mouseDoubleClick");
			var pEvent:ParamEvent = new ParamEvent(Army.onDoubleClick);
			pEvent.params = this;
						
			Game.INSTANCE.dispatchEvent(pEvent);
		}
	}
}