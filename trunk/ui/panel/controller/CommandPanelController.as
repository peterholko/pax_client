package ui.panel.controller
{
	import fl.lang.Locale;
	import fl.controls.Button;
	import flash.display.Shape;
	import flash.events.MouseEvent;	
	
	import game.Game;
	import game.map.Tile;
	import game.entity.Entity;
	import game.entity.Army;
	import game.entity.City;
	
	public class CommandPanelController 
	{
		public static var INSTANCE:CommandPanelController  = new CommandPanelController();
		
		public static var BGWIDTH:int = 120;
		public static var BGCOLOR:uint = 0x606060;
		public static var BORDERCOLOR:uint = 0x333333;
		public static var BORDERSIZE:uint = 4;
		public static var CORNERRADIUS:uint = 3;		
		
		public static var DEFAULT_Y_BORDER:int = 6;
		public static var HEIGHT_PER_BUTTON:int = 25;
		public static var BUTTON_X:int = 9;
		public static var BUTTON_Y:int = 4;
		
		public static var TILE:int = 1;
		public static var ARMY:int = 2;
		public static var CITY:int = 3;
		
		public static var COMMAND_NONE:int = 1;
		public static var COMMAND_MOVE:int = 2;
		public static var COMMAND_ATTACK:int = 3;		
					
		private var commandPanel:CommandPanel;
		private var buttons/*Button*/:Array;	
		
		private var entity:Entity = null;
		private var tile:Tile = null;
		
		private var commandType:int; 
		
		private var initialX:int;
		private var initialY:int;
		
		private var panelShape:Shape;
		
		public function CommandPanelController() : void
		{
			buttons = new Array();
		}
		
		public function initialize(main:Main) : void
		{
			commandPanel = main.commandPanel;
			commandPanel.visible = false;
			
			initialX = commandPanel.x;
			initialY = commandPanel.y;
						
			for (var i:int = 0; i < commandPanel.numChildren; i++)
			{
				if (commandPanel.getChildAt(i) is Shape)
				{
					panelShape = Shape(commandPanel.getChildAt(i));
					break;
				}
			}			
		}
		
		public function showPanel() : void
		{
			commandPanel.visible = true;
		}
		
		public function hidePanel() : void
		{
			commandPanel.visible = false;
		}
		
		public function setTileCommands(tile:Tile) : void
		{
			this.entity = null;
			this.tile = tile;
			
			commandType = TILE;
			
			removeButtons();

			createDetailsButton();
			
			setCommandPanelHeight();
			setCommandPanelPosition();
			setButtonPositions();				
		}		
		
		public function setEntityCommands(entity:Entity) : void
		{	
			this.entity = entity;
			this.tile = null;
			
			removeButtons();		
			
			if (entity.type == Entity.ARMY)
			{
				commandType = ARMY;
				
				if (entity.isPlayers())
				{
					createMoveButton();	
					createAttackButton();			
				}
			}
			else if(entity.type == Entity.CITY)
			{
				commandType = CITY;
			}

			createDetailsButton();
				
			setCommandPanelHeight();
			setCommandPanelPosition();
			setButtonPositions();				
		}
				
		private function createMoveButton() : void
		{
			var moveButton:Button = new Button();
			moveButton.label = Locale.loadString("IDS_MOVE");
			moveButton.addEventListener(MouseEvent.CLICK, moveClick);
			
			buttons.push(moveButton);
		}
		
		private function createAttackButton() : void
		{
			var attackButton:Button = new Button();
			attackButton.label = Locale.loadString("IDS_ATTACK");
			attackButton.addEventListener(MouseEvent.CLICK, attackClick);			
			
			buttons.push(attackButton);
		}
		
		private function createDetailsButton() : void
		{
			var detailsButton:Button = new Button();
			detailsButton.addEventListener(MouseEvent.CLICK, detailsClick);
			detailsButton.label = Locale.loadString("IDS_DETAILS");
			
			buttons.push(detailsButton);
		}	
		
		private function setCommandPanelPosition() : void
		{
			var defaultHeight:int = DEFAULT_Y_BORDER + HEIGHT_PER_BUTTON;
			var offsetY:int = defaultHeight - commandPanel.height;
						
			commandPanel.y = initialY + offsetY;
		}
		
		private function setCommandPanelHeight() : void
		{
			var numButtons:int = buttons.length;
			var newHeight:int = DEFAULT_Y_BORDER + numButtons * HEIGHT_PER_BUTTON;		
			
			//Redraw the panel background
			panelShape.graphics.clear();
            panelShape.graphics.beginFill(BGCOLOR);
            panelShape.graphics.lineStyle(BORDERSIZE, BORDERCOLOR);
            panelShape.graphics.drawRoundRect(0, 0, BGWIDTH, newHeight, CORNERRADIUS);
            panelShape.graphics.endFill();			
		}
		
		private function setButtonPositions() : void
		{
			for (var i:int = 0; i < buttons.length; i++)
			{
				buttons[i].x = BUTTON_X;
				buttons[i].y = BUTTON_Y + HEIGHT_PER_BUTTON * i;
				
				commandPanel.addChild(buttons[i]);
			}
		}
		
		private function removeButtons() : void
		{
			for (var i:int = 0; i < buttons.length; i++)
			{
				commandPanel.removeChild(buttons[i]);
			}
			
			buttons.length = 0;
		}
		
		private function moveClick(e:MouseEvent) : void
		{			
			trace("CommandPanelController - moveClick");
			Game.INSTANCE.selectedEntity = entity;
			Game.INSTANCE.action = COMMAND_MOVE;
		}
		
		private function attackClick(e:MouseEvent) : void
		{
			trace("CommandPanelController - attackClick");
			Game.INSTANCE.selectedEntity = entity;
			Game.INSTANCE.action = COMMAND_ATTACK;
		}
		
		private function detailsClick(e:MouseEvent) : void
		{
			trace("CommandPanel detailsClick");
			if (commandType == ARMY)
			{
				var pEvent:ParamEvent = new ParamEvent(Army.onDoubleClick);
				pEvent.params = Army(entity);
							
				Game.INSTANCE.dispatchEvent(pEvent);
			}
			else if (commandType == CITY)
			{
				var pEvent:ParamEvent = new ParamEvent(City.onDoubleClick);
				pEvent.params = City(entity);
							
				Game.INSTANCE.dispatchEvent(pEvent);				
			}
		}		
		
	}
	
}