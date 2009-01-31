package
{
	import flash.display.Sprite;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	
	import CharacterImage;
	
	
	public class Character extends Sprite
	{
		public var objectId:int;
		public var action:int;
		public var xPos:int;
		public var yPos:int;
		
		private var image:Bitmap = null;
		
		public function Character() : void
		{
			var imageData:BitmapData = null;
			imageData = new CharacterImage(0,0);
			
			this.image = new Bitmap(imageData);
			this.addChild(this.image);	
		}
		
		/*public function setId(newId:int) : void
		{
			this.id = newId;
		}
		
		public function setX(newX:int) : void
		{
			this.x = newX;
		}
		
		public functio nsetY(newY:int) : void
		{
			this.y = newY;
		}*/
	}
}