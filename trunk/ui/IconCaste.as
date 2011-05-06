package ui 
{
	import flash.display.MovieClip;
	import fl.text.TLFTextField;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	
	import game.Population;

	
	public class IconCaste extends MovieClip 
	{		
		public var raceText:TLFTextField;
		public var sizeText:TLFTextField;
		
		public var caste:int;
		public var race:int;
		public var size:int;
		
		protected var image:Bitmap = null;		
		
		public function IconCaste() 
		{			
			this.mouseChildren = false;
		}
		
		public function setCasteRace(caste:int, race:int, size:int) : void
		{			
			this.caste = caste;
			this.race = race;
			this.size = size;
		
			raceText.text = Population.getRaceName(race) + " " + Population.getCasteName(caste);	
			sizeText.text = UtilUI.FormatNum(size);
			
			var iconBitmapData:BitmapData = Population.getImage(race);
			
			image = new Bitmap(iconBitmapData);
			image.x = 2;
			image.y = 2;
			
			addChild(image);	
						
		}
		
		
		
	}
	
}
