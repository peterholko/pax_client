package ui 
{
	import flash.display.MovieClip;
	import fl.text.TLFTextField;
	import flash.events.MouseEvent;
	
	import game.entity.Improvement;
	import game.entity.City;
	import game.Game;
	import game.Assignment;
	
	public class ImprovementQueue extends MovieClip 
	{		
		public static var START_X:int = 225;
		public static var START_Y:int = 21;
		
		public var improvement:Improvement;
		public var cityId:int;
		
		public var lightSquare:MovieClip;
		public var darkSquare:MovieClip;
		public var darkBackground:MovieClip;
		public var lightBackground:MovieClip;
		
		public var improvementName:TLFTextField;
		public var resourceName:TLFTextField;
		public var numCasteLabel:TLFTextField;
		public var workLevelLabel:TLFTextField;
		public var casteLabel:TLFTextField;
		public var yieldLabel:TLFTextField;		
		public var costLabel:TLFTextField;		
		public var submitCancelLabel:TLFTextField;
		
		private var resources:Array;
		private var workLevels:Array;
		private var castes:Array;
		
		private var resourcesDropDown:DropDownList;
		private var workLevelDropDown:DropDownList;
		private var casteDropDown:DropDownList;
		
		public function ImprovementQueue() : void
		{						
			resources = new Array();
			workLevels = new Array();
			castes = new Array();
			
			workLevels.push("Relaxed");
			workLevels.push("Normal");
			workLevels.push("Strenuous");
			
			castes.push("Slaves");
			castes.push("Soldiers");
			castes.push("Commoners");
			castes.push("Nobles");
		}
		
		public function setLight() : void
		{			
			lightSquare.visible = true;
			lightBackground.visible = false;
			darkSquare.visible = false;
			darkBackground.visible = true;
			
			
		}
		
		public function setDark() : void
		{
			lightSquare.visible = false;
			lightBackground.visible = true;
			darkSquare.visible = true;
			darkBackground.visible = false;	
		}			
		
		public function setNewQueue(light:Boolean) : void
		{
			if(light)
			{			
				setLight()				
			}
			else
			{
				setDark();
			}
			
			initTextFields();
		}
		
		public function setQueue(light:Boolean) : void
		{
			if(light)
			{			
				setLight()				
			}
			else
			{
				setDark();
			}
			
			submitCancelLabel.addEventListener(MouseEvent.CLICK, cancelClick);
		}
		
		private function initTextFields() : void
		{
			resourceName.mouseChildren = false;
			workLevelLabel.mouseChildren = false;
			casteLabel.mouseChildren = false;
			submitCancelLabel.mouseChildren = false;		
			
			hideTextFields();
		}		
		
		public function setImprovement(_improvement:Improvement) : void
		{
			improvement = _improvement;
			
			resources = improvement.getAvailableResources();
			
			improvementName.text = improvement.getName();
			resourceName.text = resources[0];
			numCasteLabel.text = "10";
			workLevelLabel.text = "Relaxed";
			casteLabel.text = "Slaves";
			yieldLabel.text = "Yield";
			costLabel.text = "Cost";			
			submitCancelLabel.text = "Submit";
			
			resourcesDropDown = new DropDownList();
			workLevelDropDown = new DropDownList();
			casteDropDown = new DropDownList();
			
			resourcesDropDown.x = resourceName.x;
			resourcesDropDown.y = resourceName.y + resourceName.height;	
			
			workLevelDropDown.x = workLevelLabel.x;
			workLevelDropDown.y = workLevelLabel.y + workLevelLabel.height;	

			casteDropDown.x = casteLabel.x;
			casteDropDown.y = casteLabel.y + casteLabel.height;	
			
			resourcesDropDown.setList(resources);
			workLevelDropDown.setList(workLevels);
			casteDropDown.setList(castes);			
						
			resourcesDropDown.visible = false;
			workLevelDropDown.visible = false;
			casteDropDown.visible = false;
			
			resourceName.addEventListener(MouseEvent.CLICK, resourceNameClick);
			workLevelLabel.addEventListener(MouseEvent.CLICK, workLevelLabelClick);
			casteLabel.addEventListener(MouseEvent.CLICK, casteLabelClick);
			submitCancelLabel.addEventListener(MouseEvent.CLICK, submitClick);						
			
			addDropDownListeners();
			
			addChild(resourcesDropDown);			
			addChild(workLevelDropDown);			
			addChild(casteDropDown);	
			
			showTextFields();
		}
		
		private function showTextFields() : void
		{
			resourceName.visible = true;
			improvementName.visible = true;
			numCasteLabel.visible = true;
			workLevelLabel.visible = true;
			casteLabel.visible = true;
			yieldLabel.visible = true;
			costLabel.visible = true;
			submitCancelLabel.visible = true;					
		}
		
		private function hideTextFields() : void
		{
			resourceName.visible = false;
			improvementName.visible = false;
			numCasteLabel.visible = false;
			workLevelLabel.visible = false;
			casteLabel.visible = false;
			yieldLabel.visible = false;
			costLabel.visible = false;
			submitCancelLabel.visible = false;						
		}		
				
		private function addDropDownListeners() : void
		{
			for(var i = 0; i < resourcesDropDown.listTextFields.length; i++)
			{
				var item:TLFTextField = TLFTextField(resourcesDropDown.listTextFields[i]);
				item.mouseChildren = false;
				
				item.addEventListener(MouseEvent.CLICK, resourceDropDownClick);
			}
			
			for(var i = 0; i < workLevelDropDown.listTextFields.length; i++)
			{
				var item:TLFTextField = TLFTextField(workLevelDropDown.listTextFields[i]);
				item.mouseChildren = false;
				
				item.addEventListener(MouseEvent.CLICK, workLevelDropDownClick);
			}
			
			for(var i = 0; i < casteDropDown.listTextFields.length; i++)
			{
				var item:TLFTextField = TLFTextField(casteDropDown.listTextFields[i]);
				item.mouseChildren = false;
				
				item.addEventListener(MouseEvent.CLICK, casteDropDownClick);
			}					
		}
		
		private function resourceNameClick(e:MouseEvent) : void
		{
			resourcesDropDown.visible = true;
			workLevelDropDown.visible = false;
			casteDropDown.visible = false;
		}
		
		private function resourceDropDownClick(e:MouseEvent) : void
		{
			trace(e.target.text);
			resourcesDropDown.visible = false;		
			resourceName.text = e.target.text;
		}
		
		private function workLevelLabelClick(e:MouseEvent) : void
		{
			resourcesDropDown.visible = false;
			workLevelDropDown.visible = true;
			casteDropDown.visible = false;
		}
		
		private function workLevelDropDownClick(e:MouseEvent) : void
		{
			trace(e.target.text);
			workLevelDropDown.visible = false;
			workLevelLabel.text = e.target.text;
		}		
		
		private function casteLabelClick(e:MouseEvent) : void
		{
			resourcesDropDown.visible = false;
			workLevelDropDown.visible = false;
			casteDropDown.visible = true;
		}		
		
		private function casteDropDownClick(e:MouseEvent) : void
		{
			trace(e.target.text);
			casteDropDown.visible = false;
			casteLabel.text = e.target.text;
		}		
		
		private function submitClick(e:MouseEvent) : void
		{
			var amount:Number = parseInt(numCasteLabel.text);
			
			if(!isNaN(amount))
			{			
				var assignment:Assignment = new Assignment();
				assignment.cityId = cityId;
				assignment.amount = amount;
				assignment.taskId = improvement.id;
				assignment.taskType = City.TASK_IMPROVEMENT;
				assignment.caste = City.getCasteId(casteLabel.text);
			
				var pEvent:ParamEvent = new ParamEvent(Game.assignTaskEvent);
				pEvent.params = assignment;

				Game.INSTANCE.dispatchEvent(pEvent);			
			}
		}
		
		private function cancelClick(e:MouseEvent) : void
		{
			
		}
	}
	
}
