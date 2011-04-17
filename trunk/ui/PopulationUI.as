package ui 
{	
	import flash.display.MovieClip;	
	
	import game.entity.City;	
	import fl.text.TLFTextField;
	
	public class PopulationUI extends Panel
	{				
		public static var POPULATION_PANEL:int = 1;
		public static var NUM_CASTES:int = 4;
		public static var CASTE_ICON_X:int = 251;
		public static var NOBLE_ICON_Y:int = 75;		
	
		public var city:City;
	
		public var noblesHeader:MovieClip;
		public var commonersHeader:MovieClip;
		public var soldiersHeader:MovieClip;
		public var slavesHeader:MovieClip;	
		
		public var noblesCaste:IconCaste;
		public var commonersCaste:IconCaste;
		public var soldiersCaste:IconCaste;
		public var slavesCaste:IconCaste;
		
		public var totalPopText:TLFTextField;
	
		public function PopulationUI() 
		{
		}
		
		override public function hidePanel() : void
		{
			this.visible = false;
		}
		
		override public function showPanel() : void
		{
			this.visible = true;					
			
			setCastes();
		}		
		
		private function setCastes() : void
		{			
			var totalPop:int = 0;
		
			//Start with nobles and iterate to slaves
			for(var i:int = (NUM_CASTES - 1); i >= 0; i--)
			{
				var numCaste:int = city.getCasteValue(i);
				totalPop += numCaste;
				
				setCasteIcon(i, numCaste);															
			}
			
			//Set Total Pop text
			totalPopText.text = UtilUI.FormatNum(totalPop);
		}
		
		private function setCasteIcon(casteTypeId:int, numCaste:int) : void
		{
			switch(casteTypeId)
			{
				case City.CASTE_NOBLES:
					noblesCaste.sizeText.text = numCaste.toString();
					break;
				case City.CASTE_COMMONERS:
					commonersCaste.sizeText.text = numCaste.toString();
					break;
				case City.CASTE_SOLDIERS:
					soldiersCaste.sizeText.text = numCaste.toString();
					break;
				case City.CASTE_SLAVES:
					slavesCaste.sizeText.text = numCaste.toString();
					break;
			}
		}
		
	}
	
}
