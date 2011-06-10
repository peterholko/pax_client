package ui 
{	
	import flash.display.MovieClip;	
	import flash.display.Bitmap;
	import flash.display.BitmapData;	
	import fl.text.TLFTextField;
	import flash.events.MouseEvent;	

	import game.entity.City;	
	import game.Population;
	
	import ui.events.PopulationHeaderOpenCloseEvent;	
	import ui.events.CityUIEvents;
	import flash.display.Sprite;
	
	public class PopulationUI extends Panel
	{				
		public static var POPULATION_PANEL:int = 1;
		public static var NUM_CASTES:int = 4;
		public static var CASTE_ICON_X:int = 250;
		public static var CASTE_ICON_Y:int = 75;		
		public static var CASTE_ICON_SPACER:int = 30;		
		public static var MAX_PAGE_Y:int = 233;
		public static var HEADER_SPACER:int = 15;
	
		public var city:City;
		public var cityUI:CityUI;
	
		public var noblesHeader:NoblesHeader;
		public var commonersHeader:CommonersHeader;
		public var soldiersHeader:SoldiersHeader;
		public var slavesHeader:SlavesHeader;
				
		public var totalPopText:TLFTextField;
		public var pageNumText:TLFTextField;
		
		public var leftArrowSmall:MovieClip;
		public var rightArrowSmall:MovieClip;
		
		private var iconCasteList:Array;
		private var iconCastePages:Array;
				
		private var currentPageNum:int;
		private var currentPage:Sprite;
		private var currentY:int;
		
		private var humanIcon:MovieClip;
		private var elfIcon:MovieClip;
		private var dwarfIcon:MovieClip;
		private var goblinIcon:MovieClip;
		
		private var selectedCasteType:int;
		private var selectedRaceType:int;
	
		public function PopulationUI() 
		{							
			noblesHeader = new NoblesHeader();
			commonersHeader = new CommonersHeader();
			soldiersHeader = new SoldiersHeader();
			slavesHeader = new SlavesHeader();		
			
			noblesHeader.setOpenState();
			commonersHeader.setOpenState();
			soldiersHeader.setOpenState();
			slavesHeader.setOpenState();			
		
			noblesHeader.caste = Population.CASTE_NOBLES;
			commonersHeader.caste = Population.CASTE_COMMONERS;
			soldiersHeader.caste = Population.CASTE_SOLDIERS;
			slavesHeader.caste = Population.CASTE_SLAVES;		
		
			iconCasteList = new Array();
			iconCastePages = new Array();
		
			humanIcon = createRaceIcon(Population.RACE_HUMAN);
			elfIcon = createRaceIcon(Population.RACE_ELF);
			dwarfIcon = createRaceIcon(Population.RACE_DWARF);
			goblinIcon = createRaceIcon(Population.RACE_GOBLIN);
			
			leftArrowSmall.addEventListener(MouseEvent.CLICK, leftArrowClick);
			rightArrowSmall.addEventListener(MouseEvent.CLICK, rightArrowClick);
			
			CityUIEventDispatcher.INSTANCE.addEventListener(CityUIEvents.PopOpenCloseEvent, popOpenCloseEvent);
		}
		
		override public function hidePanel() : void
		{
			this.visible = false;
		}
		
		override public function showPanel() : void
		{
			this.visible = true;	
			
			currentPageNum = 1;
			
			setCastes();
			displayCasteRaceIcons();
			showSelectedPage();
		}				
		
		private function setCastes() : void
		{			
			var totalPop:int = 0;
			iconCasteList = new Array();
		
			//Start with nobles and iterate to slaves
			for(var i:int = (NUM_CASTES - 1); i >= 0; i--)
			{
				var populationList:Array = city.getPopulation(i);
																																				
				setCasteRaceIcons(i, populationList);
			}					
			
			//Set Total Pop text
			//totalPopText.text = UtilUI.FormatNum(totalPop);
		}
		
		private function setCasteRaceIcons(caste:int, populationList:Array) : void
		{								
			for(var i:int = 0; i < populationList.length; i++)
			{
				var population:Population = Population(populationList[i]);
				var iconCaste:IconCaste = new IconCaste();
								
				iconCaste.setCasteRace(population.caste, population.race, population.value);				
				iconCaste.addEventListener(MouseEvent.MOUSE_DOWN, iconCasteMouseDown);
				
				iconCasteList.push(iconCaste);
				
				setInitialHeaderState(caste);
			}
			
		}
		
		private function displayCasteRaceIcons() : void
		{			
			removePages();
			iconCastePages = new Array();
		
			//To create first page
			currentY = MAX_PAGE_Y;			
			
			pageAddChild(noblesHeader, HEADER_SPACER);
				
			for(var i:int = (NUM_CASTES - 1); i >= 0; i--)
			{						
				if(i == Population.CASTE_COMMONERS)
				{
					pageAddChild(commonersHeader, HEADER_SPACER);					
				}
				else if(i == Population.CASTE_SOLDIERS)
				{
					pageAddChild(soldiersHeader, HEADER_SPACER);	
				}
				else if(i == Population.CASTE_SLAVES)
				{
					pageAddChild(slavesHeader, HEADER_SPACER);	
				}
										
				for(var j:int = 0; j < iconCasteList.length; j++)
				{
					var iconCaste:IconCaste = IconCaste(iconCasteList[j]);																
								
					if(iconCaste.caste == i)
					{
						if(noblesHeader.state && (iconCaste.caste == Population.CASTE_NOBLES))
						{
							pageAddChild(iconCaste, CASTE_ICON_SPACER);								
						}
						else if(commonersHeader.state && (iconCaste.caste == Population.CASTE_COMMONERS))
						{
							pageAddChild(iconCaste, CASTE_ICON_SPACER);			
						}
						else if(soldiersHeader.state && (iconCaste.caste == Population.CASTE_SOLDIERS))
						{
							pageAddChild(iconCaste, CASTE_ICON_SPACER);	
						}
						else if(slavesHeader.state && (iconCaste.caste == Population.CASTE_SLAVES))
						{
							pageAddChild(iconCaste, CASTE_ICON_SPACER);	
						}	
					}
				}			
			}							
		}
		
		private function setInitialHeaderState(caste:int) : void
		{
			switch(caste)
			{
				case Population.CASTE_NOBLES:
					noblesHeader.setCloseState();
					break;
				case Population.CASTE_COMMONERS:
					commonersHeader.setCloseState();
					break;
				case Population.CASTE_SOLDIERS:
					soldiersHeader.setCloseState();
					break;
				case Population.CASTE_SLAVES:
					slavesHeader.setCloseState();
					break;
			}
		}
		
		private function pageAddChild(displayObject:MovieClip, increaseY:int) : void
		{
			trace("CurrentY: " + currentY + " increaseY: " + increaseY);
			if((currentY + increaseY) > MAX_PAGE_Y)
			{
				createPage();									
				currentY = 0;
			}

			displayObject.visible = true;
			displayObject.x = 0;
			displayObject.y = currentY;
			
			currentPage.addChild(displayObject);		
			
			currentY = currentY + increaseY;
		}
				
		private function createPage() : void
		{
			var page:Sprite = new Sprite();
			
			page.x = 250;
			page.y = 60;
			page.visible = false;
			
			addChild(page);			
			iconCastePages.push(page);	
			
			currentPage = page;
		}
		
		private function showSelectedPage() : void
		{
			for(var i:int = 0; i < iconCastePages.length; i++)
			{
				var oldPage:Sprite = Sprite(iconCastePages[i]);
				oldPage.visible = false;
			}
			
			var page:Sprite = Sprite(iconCastePages[currentPageNum - 1]);
			page.visible = true;
			
			var maxPages:int = iconCastePages.length;
			pageNumText.text = currentPageNum.toString() + "/" + maxPages.toString();
		}
		
		private function removePages() : void
		{
			for(var i:int = 0; i < iconCastePages.length; i++)
			{
				var page:Sprite = Sprite(iconCastePages[i]);
				
				while(page.numChildren > 0)
				{
					page.removeChildAt(0);
				}
				
				removeChild(page);
			}
		}
		
		private function leftArrowClick(e:MouseEvent) : void
		{
			if(currentPageNum > 1)
			{
				currentPageNum--;
				showSelectedPage();
			}
		}
		
		private function rightArrowClick(e:MouseEvent) : void
		{
			if(currentPageNum < iconCastePages.length)
			{
				currentPageNum++;
				showSelectedPage();
			}
		}			
			
		private function popOpenCloseEvent(e:PopulationHeaderOpenCloseEvent) : void
		{						
			trace("popOpenCloseEvent");
			displayCasteRaceIcons();
			showSelectedPage();
		}
		
		private function iconCasteMouseDown(e:MouseEvent) : void
		{
			this.parent.setChildIndex(this, this.parent.numChildren - 1);			
			e.stopPropagation();	
			
			var iconCaste:IconCaste = IconCaste(e.currentTarget);									
			var raceIcon:MovieClip = getRaceIcon(iconCaste.race);
			
			UtilUI.bringForward(raceIcon);
			raceIcon.visible = true;
												
			raceIcon.x = e.localX + iconCaste.x + iconCaste.parent.x - raceIcon.width / 2;
			raceIcon.y = e.localY + iconCaste.y + iconCaste.parent.y - raceIcon.height / 2;
			raceIcon.startDrag()								
			
			selectedCasteType = iconCaste.caste;
			selectedRaceType = iconCaste.race;
		}
		
		private function getRaceIcon(race:int) : MovieClip
		{
			switch(race)
			{
				case Population.RACE_HUMAN:					
					return humanIcon;
				case Population.RACE_ELF:
					return elfIcon;
				case Population.RACE_DWARF:
					return dwarfIcon;
				case Population.RACE_GOBLIN:
					return goblinIcon;
			}
			
			return null;
		}
		
		private function raceIconMouseUp(e:MouseEvent) : void
		{
			trace("raceIconMouseUp");
			var raceIcon:MovieClip = MovieClip(e.currentTarget);
			
			raceIcon.stopDrag();
			raceIcon.visible = false;
						
			cityUI.checkPopulationDropTarget(raceIcon.dropTarget, selectedCasteType, selectedRaceType);
		}
		
		private function createRaceIcon(race:int) : MovieClip
		{			
			var iconBitmapData:BitmapData = Population.getImage(race);
			var iconBitmap:Bitmap = new Bitmap(iconBitmapData);			
			var raceIcon = new MovieClip();
			
			raceIcon.addChild(iconBitmap);				
			raceIcon.visible = false;
			raceIcon.addEventListener(MouseEvent.MOUSE_UP, raceIconMouseUp);
			
			addChild(raceIcon);
			
			return raceIcon;
		}
		
	}
	
}
