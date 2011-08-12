package ui 
{
	
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	import fl.text.TLFTextField;
	import game.Item;
	import game.map.Tile;
	import game.entity.Improvement;
	import game.Game;
	
	
	public class BuildSelector extends MovieClip 
	{		
		public static var ENTRY_Y:int = 40;
	
		public var confirmPopup:BuildSelectorConfirmPopup;
		public var closeButton:CloseButton;
		public var buildButton:MovieClip;
		public var cancelButton:MovieClip;
		
		public var coordinatesText:TLFTextField;
		public var tileNameText:TLFTextField;
		
		private var buildSelectorEntries:Array;
		private var selectedImprovement:int = -1;
		
		public function BuildSelector() 
		{
			buildSelectorEntries = new Array();
		}
		
		public function init() : void
		{								
			this.visible = false;
		
			buildButton.addEventListener(MouseEvent.CLICK, buildButtonClick);			
			cancelButton.addEventListener(MouseEvent.CLICK, cancelButtonClick);
			closeButton.addEventListener(MouseEvent.CLICK, closeButtonClick);					
			
			confirmPopup.buildButton.addEventListener(MouseEvent.CLICK, confirmPopupBuildClick);
			confirmPopup.cancelButton.addEventListener(MouseEvent.CLICK, confirmPopupCancelClick);
		}
		
		public function showPanel() : void
		{
			confirmPopup.visible = false;			
			this.visible = true;
		}

        public function hidePanel() : void
        {
            this.visible = false;
        }
		
		public function setTileInfo(tile:Tile) : void
		{
			coordinatesText.text = "(" + tile.gameX + "," + tile.gameY + ")";
			tileNameText.text = Tile.GetTileName(tile.type);
		}
		
		public function setImprovements(improvements:Array) : void
		{						
			removeEntries();
		
			for(var i:int = 0; i < improvements.length; i++)
			{
				var buildSelectorEntry:BuildSelectorEntry = new BuildSelectorEntry();
				
				buildSelectorEntry.setEntry(improvements[i]);
				buildSelectorEntry.x = 2;
				buildSelectorEntry.y = ENTRY_Y + ((buildSelectorEntry.height + 1) * i);						
				buildSelectorEntry.addEventListener(MouseEvent.CLICK, buildSelectorEntryClick);
				
				this.addChild(buildSelectorEntry);
				
				buildSelectorEntries.push(buildSelectorEntry);
			}
		}
		
		private function buildSelectorEntryClick(e:MouseEvent) : void
		{
			var buildSelectorEntry:BuildSelectorEntry = BuildSelectorEntry(e.target);
			
			selectedImprovement = buildSelectorEntry.improvementType;			
			showConfirmPopup(buildSelectorEntry.improvementType);			
		}
		
		private function showConfirmPopup(improvementType:int) : void
		{
			confirmPopup.parent.setChildIndex(confirmPopup, confirmPopup.parent.numChildren - 1);			
			
			confirmPopup.objectText.text = Improvement.getNameStatic(improvementType);
			confirmPopup.objectDetailText.text = Improvement.getNameStatic(improvementType);
			confirmPopup.costText.text = Improvement.getCost(improvementType).toString();			
			
			confirmPopup.visible = true;			
		}
		
		private function removeEntries() : void
		{
			for(var i:int = 0; i < buildSelectorEntries.length; i++)
			{
				if(this.contains(buildSelectorEntries[i]))
				{
					this.removeChild(buildSelectorEntries[i]);
				}
			}
		}
		
		private function confirmPopupBuildClick(e:MouseEvent) : void
		{
			var pEvent:ParamEvent = new ParamEvent(Game.cityQueueImprovementEvent);			
			pEvent.params = selectedImprovement;
			Game.INSTANCE.dispatchEvent(pEvent);						
		}
		
		private function confirmPopupCancelClick(e:MouseEvent) : void
		{
			
		}		
		
		private function buildButtonClick(e:MouseEvent) : void
		{
			confirmPopup.visible = true;
		}
		
		private function closeButtonClick(e:MouseEvent) : void
		{
			this.visible = false;
		}				
		
		private function cancelButtonClick(e:MouseEvent) : void
		{
			this.visible = false;
		}
	}
	
}
