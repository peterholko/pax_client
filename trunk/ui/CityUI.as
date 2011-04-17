package ui 
{
	import flash.utils.getQualifiedClassName	
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	import flash.display.Bitmap;
	import flash.display.DisplayObject;
	import flash.text.TextField;
	import fl.text.TLFTextField;
	
	import game.entity.City;
	import game.entity.Improvement;
	import game.Game;
	import game.map.MapObjectType;
		
	public class CityUI extends MovieClip 
	{		
		public var ICON_SPACER:int = 3;
		
		public var IMPROVEMENTS_INFO_Y_TOP:int = 142;
		public var IMPROVEMENTS_INFO_Y_BOTTOM:int = 333;
		public var INFRASTRUCTURE_INFO_Y_TOP:int = 160;
		public var INFRASTRUCTURE_INFO_Y_BOTTOM:int = 351;	
		
		public var IMPROVEMENTS_START_X:int = 3;
		public var IMPROVEMENTS_START_Y:int = 163;			
		
		public var closeButton:MovieClip;					
			
		public var inventoryUI:InventoryUI;
		public var productionUI:ProductionUI;
		public var trainingUI:TrainingUI;
		public var financesUI:FinancesUI;
		public var populationUI:PopulationUI;
		public var throneUI:ThroneUI;	
				
		public var throneText:TLFTextField;
		public var populationText:TLFTextField;
		public var financesText:TLFTextField;
		public var trainingText:TLFTextField;
		public var productionText:TLFTextField;
		public var inventoryText:TLFTextField;		
		
		public var buildingsInfo:MovieClip;
		public var improvementsInfo:MovieClip;
		public var infrastructureInfo:MovieClip;
		
		public var queueColumn:QueueColumn;
	
		public var totalPopText:TLFTextField;
		public var cityNameText:TLFTextField;
		public var empireKingdomNameText:TLFTextField;
		
		private var city:City;
		
		private var improvementIcons:Array;
		private var previousPanel:Panel = null;
		private var activatedPanel:Panel = null;
	
		public function CityUI() 
		{
			improvementIcons = new Array();
			
			closeButton.addEventListener(MouseEvent.CLICK, closeButtonClick);			
		}
		
		public function init() : void
		{
			this.visible = false;	
			
			throneText.addEventListener(MouseEvent.CLICK, throneTextClick);
			populationText.addEventListener(MouseEvent.CLICK, populationTextClick);
			financesText.addEventListener(MouseEvent.CLICK, financesTextClick);
			trainingText.addEventListener(MouseEvent.CLICK, trainingTextClick);
			productionText.addEventListener(MouseEvent.CLICK, productionTextClick);
			inventoryText.addEventListener(MouseEvent.CLICK, inventoryTextClick);
			
			buildingsInfo.addEventListener(MouseEvent.CLICK, buildingsInfoClick);
			improvementsInfo.addEventListener(MouseEvent.CLICK, improvementsInfoClick);
			infrastructureInfo.addEventListener(MouseEvent.CLICK, infrastructureInfoClick);
		}
		
		public function setCity(city:City) : void
		{
			this.city = city;
			inventoryUI.city = city;
			inventoryUI.cityUI = this;
			populationUI.city = city;
		}
						
		public function showPanel() : void
		{			
			if(this.visible)
			{
				previousPanel.hidePanel();
				activatedPanel.showPanel();
			}
			else
			{
				this.visible = true;				
				hidePanels();
				previousPanel = throneUI;
				activatedPanel = throneUI;
				throneUI.showPanel();
			}																					
		
			totalPopText.text = UtilUI.FormatNum(city.getTotalPop());
			cityNameText.text = city.cityName;
			empireKingdomNameText.text = Game.INSTANCE.kingdom.name;			
		}		
		
		private function throneTextClick(e:MouseEvent) : void
		{			
			previousPanel = activatedPanel;
			activatedPanel = throneUI;
			
			Game.INSTANCE.requestInfo(MapObjectType.CITY, city.id);
		}
		
		private function populationTextClick(e:MouseEvent) : void
		{
			previousPanel = activatedPanel;			
			activatedPanel = populationUI;
			
			Game.INSTANCE.requestInfo(MapObjectType.CITY, city.id);
		}
		
		private function financesTextClick(e:MouseEvent) : void
		{
			activatedPanel.hidePanel();		
			financesUI.showPanel();
		}
		
		private function trainingTextClick(e:MouseEvent) : void
		{
			activatedPanel.hidePanel();		
			trainingUI.showPanel();
		}
		
		private function productionTextClick(e:MouseEvent) : void
		{
			activatedPanel.hidePanel();		
			productionUI.showPanel();
		}
		
		private function inventoryTextClick(e:MouseEvent) : void
		{
			previousPanel = activatedPanel;										
			activatedPanel = inventoryUI;
			
			Game.INSTANCE.requestInfo(MapObjectType.CITY, city.id);
		}				
		
		private function buildingsInfoClick(e:MouseEvent) : void
		{
			clearInfoColumn();
			bottomImprovementsInfo();
			bottomInfrastructureInfo();
		}
		
		private function improvementsInfoClick(e:MouseEvent) : void
		{
			//Handle UI navigation
			clearInfoColumn();
			topImprovementsInfo();
			bottomInfrastructureInfo();
			
			//Setup improvement icons
			setImprovementIcons();
		}
		
		private function infrastructureInfoClick(e:MouseEvent) : void
		{
			clearInfoColumn();
			topImprovementsInfo();
			topInfrastructureInfo();
		}		
		
		private function setImprovementIcons() : void
		{
			for (var i:int = 0; i < city.improvements.length; i++)
			{
				var improvement:Improvement = Improvement(city.improvements[i]);								
				var iconEntity:IconEntity = new IconEntity();
				iconEntity.setEntity(improvement);
				iconEntity.copyImage(32, 32);
				//iconEntity.width = 48;
				//iconEntity.height = 48;
				iconEntity.x = IMPROVEMENTS_START_X + ICON_SPACER + i * (iconEntity.width + ICON_SPACER);
				iconEntity.y = IMPROVEMENTS_START_Y;
				iconEntity.anchorX = iconEntity.x;
				iconEntity.anchorY = iconEntity.y;
				//iconEntity.addEventListener(MouseEvent.MOUSE_DOWN, mouseDown);
				//iconEntity.addEventListener(MouseEvent.MOUSE_UP, mouseUp);												
				
				improvement.icon = iconEntity;
				improvementIcons.push(iconEntity);
				
				this.addChild(iconEntity);
			}			
		}	
		
		private function removeImprovementIcons():void
		{
			if(improvementIcons != null)
			{
				for (var i:int = 0; i < improvementIcons.length; i++)
				{					
					if(this.contains(improvementIcons[i]))
						this.removeChild(improvementIcons[i]);
				}
	
				improvementIcons.length = 0;
			}
		}			
		
		
		private function clearInfoColumn() : void
		{
			removeImprovementIcons();
		}
		
		private function topImprovementsInfo() : void
		{
			improvementsInfo.y = IMPROVEMENTS_INFO_Y_TOP;
		}
		
		private function bottomImprovementsInfo() : void
		{
			improvementsInfo.y = IMPROVEMENTS_INFO_Y_BOTTOM;
		}
		
		private function topInfrastructureInfo() : void
		{
			infrastructureInfo.y = INFRASTRUCTURE_INFO_Y_TOP;
		}
		
		private function bottomInfrastructureInfo() : void
		{
			infrastructureInfo.y = INFRASTRUCTURE_INFO_Y_BOTTOM;
		}			
		
		private function closeButtonClick(e:MouseEvent) : void
		{
			this.visible = false;
		}
		
		private function hidePanels() : void
		{
			inventoryUI.hidePanel();
			productionUI.hidePanel();
			trainingUI.hidePanel();
			financesUI.hidePanel();
			populationUI.hidePanel();
			throneUI.hidePanel();
		}
	}
	
}
