package ui 
{
	
	import flash.display.MovieClip;	
	import flash.events.MouseEvent;
	import fl.text.TLFTextField;
	import flash.text.TextFormat;
	import flashx.textLayout.elements.TextFlow;
	import flashx.textLayout.formats.TextLayoutFormat;
	import flash.text.engine.TextLine;
		
	import game.entity.City;	
	import game.entity.Improvement;
	import game.Assignment;
	import flash.display.Sprite;
	
	public class ImprovementsUI extends MovieClip 
	{								
		public static var ICON_X_SPACER:int = 3;
		public static var ICON_X_START:int = 8;
		public static var ICON_Y_START:int = 55;
	
		public var city:City;
		
		private var iconImprovements:Array;
		private var improvementQueue:Array;
		
		private var newQueue:ImprovementQueue;
		
		private var queueLayer:Sprite;
		private var iconLayer:Sprite;
			
		public function ImprovementsUI() 
		{
			iconImprovements = new Array();	
			improvementQueue = new Array();
						
			queueLayer = new Sprite();
			iconLayer = new Sprite();			
			
			addChild(queueLayer);
			addChild(iconLayer);
		}
		
		public function showPanel() : void
		{			
			this.visible = true;
						
			removeIcons();
			setIcons();
			setAssignments();
			
			createQueue();
		}					
		
		private function setIcons() : void
		{
			for (var i:int = 0; i < city.improvements.length; i++)
			{
				var improvement:Improvement = Improvement(city.improvements[i]);								
				var iconEntity:IconEntity = new IconEntity();
				iconEntity.setEntity(improvement);
				iconEntity.width = 32;
				iconEntity.height = 32;
				iconEntity.x = ICON_X_START + ICON_X_SPACER + i * (iconEntity.width + ICON_X_SPACER);
				iconEntity.y = ICON_Y_START;
				iconEntity.anchorX = iconEntity.x;
				iconEntity.anchorY = iconEntity.y;
				iconEntity.addEventListener(MouseEvent.MOUSE_DOWN, mouseDown);
				iconEntity.addEventListener(MouseEvent.MOUSE_UP, mouseUp);												
				
				improvement.icon = iconEntity;

				iconImprovements.push(iconEntity);
				
				iconLayer.addChild(iconEntity);
			}			
		}
		
		private function setAssignments() : void
		{		
			improvementQueue.length = 0;
		
			for(var i:int = 0; i < city.assignments.length; i++)
			{							
				var assignment:Assignment = Assignment(city.assignments[i]);
				
				if(assignment.taskType == City.TASK_IMPROVEMENT)
				{				
					var improvement:Improvement = city.getImprovement(assignment.taskId);
																  
					if(improvement != null)
					{
						var queue:ImprovementQueue = new ImprovementQueue();
				
						queue.cityId = city.id;
						queue.setQueue(improvementQueue.length % 2 == 0);
						queue.improvement = improvement;
						queue.improvementName.text = improvement.getName();
						queue.resourceName.text = "Plants";
						queue.numCasteLabel.text = assignment.amount.toString();
						queue.workLevelLabel.text = "Relaxed";
						queue.casteLabel.text = City.getCasteName(assignment.caste);
						queue.yieldLabel.text = "100";
						queue.yieldLabel.text = "None";
						
						queue.x = ImprovementQueue.START_X;
						queue.y = ImprovementQueue.START_Y + (i * queue.height);
						
						lockIconEntity(improvement.icon, queue);
						improvementQueue.push(queue);
						queueLayer.addChild(queue);
					}
				}
			}
		}
		
		private function lockIconEntity(iconEntity:IconEntity, queue:ImprovementQueue) : void
		{
			iconEntity.x = queue.lightSquare.x + queue.x;
			iconEntity.y = queue.lightSquare.y + queue.y;
			iconEntity.removeEventListener(MouseEvent.MOUSE_UP, mouseUp);
			iconEntity.removeEventListener(MouseEvent.MOUSE_DOWN, mouseDown);			
		}
		
		private function mouseDown(e:MouseEvent) : void
		{
			trace("Mouse down");
			var iconEntity:IconEntity = IconEntity(e.target);
			iconEntity.startDrag();
		}
		
		private function mouseUp(e:MouseEvent) : void
		{
			trace("Mouse up");	
			e.stopPropagation();
			
			var iconEntity:IconEntity = IconEntity(e.target);			
			iconEntity.stopDrag();				
			
			if(newQueue.contains(iconEntity.dropTarget.parent))
			{
				trace("Assign a task!");
				lockIconEntity(iconEntity, newQueue);
				
				initQueue(Improvement(iconEntity.entity));
			}
			else
			{
				iconEntity.x = iconEntity.anchorX;
				iconEntity.y = iconEntity.anchorY;
			}
		}
		
		private function removeIcons():void
		{
			if(iconImprovements != null)
			{
				for (var i:int = 0; i < iconImprovements.length; i++)
				{
					//iconImprovements[i].removeEventListener(MouseEvent.CLICK, iconEntityClick);
					iconLayer.removeChild(iconImprovements[i]);
				}
	
				iconImprovements.length = 0;
			}
		}					
		
		private function createQueue() : void
		{			
			newQueue = new ImprovementQueue();
			newQueue.cityId = city.id;
			newQueue.x = ImprovementQueue.START_X;
			trace("newQueue height: " + newQueue.height);
			trace("improvementQueue.length: " + improvementQueue.length);
			newQueue.y = ImprovementQueue.START_Y + (improvementQueue.length * newQueue.height);
			newQueue.setNewQueue(improvementQueue.length % 2 == 0)								
			
			queueLayer.addChild(newQueue);
		}
		
		private function initQueue(improvement:Improvement) : void
		{
			newQueue.setImprovement(improvement);						
		}
		
		private function resourceNameClick(e:MouseEvent) : void
		{			

		}
	}
	
}

