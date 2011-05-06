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
	import game.Building;
	import game.QueueEntry;
	import game.Assignment;
		
	public class CityUI extends MovieClip 
	{		
		public var ICON_SPACER:int = 3;
		
		public var IMPROVEMENTS_INFO_Y_TOP:int = 142;
		public var IMPROVEMENTS_INFO_Y_BOTTOM:int = 333;
		public var INFRASTRUCTURE_INFO_Y_TOP:int = 160;
		public var INFRASTRUCTURE_INFO_Y_BOTTOM:int = 351;	
		
		public var BUILDINGS_START_X:int = 3;
		public var BUILDINGS_START_Y:int = 145;
		
		public var IMPROVEMENTS_START_X:int = 3;
		public var IMPROVEMENTS_START_Y:int = 163;		
		
		public var BUILDINGS_INFO:String = "buildings";
		public var IMPROVEMENTS_INFO:String = "improvements";
		public var INFRASTRUCTURE_INFO:String = "infrastructure";
				
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
		
		public var queueMarketUI:QueueMarketUI;
	
		public var totalPopText:TLFTextField;
		public var cityNameText:TLFTextField;
		public var empireKingdomNameText:TLFTextField;
		
		private var city:City;
		
		private var improvementIcons:Array;
		private var buildingsIcons:Array;
		
		private var previousPanel:Panel = null;
		private var activatedPanel:Panel = null;		
		private var activatedInfoColumn:String = null;		
	
		public function CityUI() 
		{			
			improvementIcons = new Array();
			buildingsIcons = new Array();			
			
			this.addEventListener(MouseEvent.CLICK, mouseClick);
			this.addEventListener(MouseEvent.MOUSE_DOWN, mouseDown);
			this.addEventListener(MouseEvent.MOUSE_UP, mouseUp);	
			
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
			
			trace(populationUI);
			populationUI.city = city;
			populationUI.cityUI = this;
						
			productionUI.city = city;
			productionUI.cityUI = this;
			
			queueMarketUI.city = city;
		}
						
		public function showPanel() : void
		{			
			this.parent.setChildIndex(this, this.parent.numChildren - 1);	
		
			if(this.visible)
			{
				previousPanel.hidePanel();
				activatedPanel.showPanel();
				showActivatedInfoPanel();								
			}
			else
			{
				this.visible = true;				
				hidePanels();
				previousPanel = throneUI;
				activatedPanel = throneUI;
				throneUI.showPanel();
				activatedInfoColumn = BUILDINGS_INFO;
				showActivatedInfoPanel();
			}																					
		
			totalPopText.text = UtilUI.FormatNum(city.getTotalPop());
			cityNameText.text = city.cityName;
			empireKingdomNameText.text = Game.INSTANCE.kingdom.name;			
		}		
		
		public function getCityId() : int
		{
			return city.id;
		}
		
		public function checkPopulationDropTarget(popDropTarget:DisplayObject, caste:int) : void
		{
			for(var i:int = 0; i < buildingsIcons.length; i++)
			{
				var iconBuilding:IconBuilding = IconBuilding(buildingsIcons[i]);
				
				if(iconBuilding.contains(popDropTarget))
				{
					//showAssignPopulation(iconBuilding.building, caste);					
					break;
				}
			}
			
			for(var i:int = 0; i < improvementIcons.length; i++)
			{
				var iconEntity:IconEntity = IconEntity(improvementIcons[i]);
				
				trace("popDropTarget: " + popDropTarget);
				if(iconEntity.contains(popDropTarget))
				{
					//assignTaskImprovement(Improvement(iconEntity.entity), caste);
					break;
				}
			}
		}
				
		private function assignTaskBuilding(building:Building, caste:int): void
		{
			var assignment:Assignment = new Assignment()
			
			assignment.cityId = city.id;
			assignment.caste = caste;
			//assignment.amount = amount;
			assignment.taskId = building.id;
			assignment.taskType = Assignment.TASK_CONSTRUCTION;
		
			var pEvent:ParamEvent = new ParamEvent(Game.assignTaskEvent);
			pEvent.params = assignment;
				
			Game.INSTANCE.dispatchEvent(pEvent);						
		}
		
		private function assignTaskImprovement(improvement:Improvement, caste:int, amount:int) : void
		{
			
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
			previousPanel = activatedPanel;										
			activatedPanel = productionUI;
						
			Game.INSTANCE.requestInfo(MapObjectType.CITY, city.id);
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
			
			//Setup building icons
			setBuildingIcons();
			activatedInfoColumn = BUILDINGS_INFO;
		}
		
		private function improvementsInfoClick(e:MouseEvent) : void
		{
			//Handle UI navigation
			clearInfoColumn();
			topImprovementsInfo();
			bottomInfrastructureInfo();
			
			//Setup improvement icons
			setImprovementIcons();
			activatedInfoColumn = IMPROVEMENTS_INFO;
		}
		
		private function infrastructureInfoClick(e:MouseEvent) : void
		{
			clearInfoColumn();
			topImprovementsInfo();
			topInfrastructureInfo();
			
			activatedInfoColumn = INFRASTRUCTURE_INFO;
		}		
		
		private function setImprovementIcons() : void
		{
			for (var i:int = 0; i < city.improvements.length; i++)
			{
				var improvement:Improvement = Improvement(city.improvements[i]);								
				var iconEntity:IconEntity = new IconEntity();
				iconEntity.setEntity(improvement);
				iconEntity.copyImage(36, 36);
				iconEntity.x = IMPROVEMENTS_START_X + ICON_SPACER + i * (iconEntity.width + ICON_SPACER);
				iconEntity.y = IMPROVEMENTS_START_Y;
				iconEntity.anchorX = iconEntity.x;
				iconEntity.anchorY = iconEntity.y;
				//iconEntity.addEventListener(MouseEvent.MOUSE_DOWN, mouseDown);
				//iconEntity.addEventListener(MouseEvent.MOUSE_UP, mouseUp);												
				
				improvement.icon = iconEntity;
				improvementIcons.push(iconEntity);
				
				addChild(iconEntity);
			}			
		}	
		
		private function setBuildingIcons() : void
		{
			for(var i:int = 0; i < city.buildings.length; i++)
			{
				var building:Building = Building(city.buildings[i]);
				var iconBuilding:IconBuilding = new IconBuilding();
				iconBuilding.setBuilding(building)
				iconBuilding.x = BUILDINGS_START_X + ICON_SPACER + i * (iconBuilding.width + ICON_SPACER);
				iconBuilding.y = BUILDINGS_START_Y;
				iconBuilding.anchorX = iconBuilding.x;
				iconBuilding.anchorY = iconBuilding.y;		
				
				buildingsIcons.push(iconBuilding);
				
				addChild(iconBuilding);
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
		
		private function removeBuildingIcons() : void
		{
			if(buildingsIcons != null)
			{
				for (var i:int = 0; i < buildingsIcons.length; i++)
				{					
					if(this.contains(buildingsIcons[i]))
						this.removeChild(buildingsIcons[i]);
				}
	
				buildingsIcons.length = 0;
			}
		}				
		
		private function clearInfoColumn() : void
		{
			removeImprovementIcons();
			removeBuildingIcons();
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
		
		private function showActivatedInfoPanel() : void
		{
			switch(activatedInfoColumn)
			{
				case BUILDINGS_INFO:
					clearInfoColumn();
					bottomImprovementsInfo();
					bottomInfrastructureInfo();
					
					//Setup building icons
					setBuildingIcons();
					activatedInfoColumn = BUILDINGS_INFO;
					break;
				case INFRASTRUCTURE_INFO:
					//Handle UI navigation
					clearInfoColumn();
					topImprovementsInfo();
					bottomInfrastructureInfo();
					
					//Setup improvement icons
					setImprovementIcons();
					activatedInfoColumn = IMPROVEMENTS_INFO;		
					break;
			}
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
		
		private function mouseClick(e:MouseEvent) : void
		{
			this.parent.setChildIndex(this, this.parent.numChildren - 1);	
			e.stopImmediatePropagation();
		}
		
		private function mouseDown(e:MouseEvent) : void
		{	
			this.parent.setChildIndex(this, this.parent.numChildren - 1);	
			startDrag();			
			e.stopImmediatePropagation();
		}		
		
		private function mouseUp(e:MouseEvent) : void
		{
			trace("MouseUp: " + parent);			
			stopDrag();
			e.stopImmediatePropagation();
		}				
	}
	
}
