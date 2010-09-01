package ui
{
	import flash.ui.Mouse;
	import flash.display.MovieClip;
	import flash.text.TextField;
	import fl.text.TLFTextField;
	import flash.display.DisplayObjectContainer;
	import flash.events.MouseEvent;
	import flash.display.DisplayObject;

	import Main;

	import game.Game;
	import game.map.Tile;
	import game.entity.Entity;
	import game.entity.Army;
	import game.entity.City;
	
	import net.Connection;
	import net.packet.InfoArmy;	
	import net.packet.InfoGenericArmy;
	import net.packet.InfoCity;
	import net.packet.InfoKingdom;
	import net.packet.InfoTile;
	
	public class MainUI extends MovieClip
	{
		private static var ICON_X_SPACER:int = 5;

		private static var COMMAND_NONE:int = 1;
		private static var COMMAND_MOVE:int = 2;
		private static var COMMAND_ATTACK:int = 3;

		private static var SELECTED_NONE:int = 0;
		private static var SELECTED_TILE:int = 1;
		private static var SELECTED_ENTITY:int = 2;

		public var main:Main;

		public var menuText:TextField;
		public var empireText:TextField;
		public var kingdomText:TextField;
		public var warfareText:TextField;
		public var arcaneText:TextField;
		public var civicsText:TextField;
		public var infoButton:ActionButton;
		public var moveButton:ActionButton;
		public var attackButton:ActionButton;
		public var claimButton:ActionButton;
		public var buildButton:ActionButton;
		public var tradeButton:ActionButton;	

		public var targetName:TLFTextField;
		public var empireKingdomName:TLFTextField;
		public var ratingLabel:TLFTextField;
		public var repLabel:TLFTextField;
		public var diffLabel:TLFTextField;
		public var ratingValue:TLFTextField;
		public var repValue:TLFTextField;
		public var diffValue:TLFTextField;
		public var hpAtkDefLabel:TLFTextField;
		public var hpAtkDefValue:TLFTextField;

		public var pwrWeaInfLabel:TLFTextField;
		public var pwrWeaInfValue:TLFTextField;
		public var loyHeaSecLabel:TLFTextField;

		public var upkeepLabel:TLFTextField;
		public var upkeepValue:TLFTextField;
		public var hpLabel:TLFTextField;
		public var hpValue:TLFTextField;

		public var mpLabel:TLFTextField;
		public var mpValue:TLFTextField;
		public var mtLabel:TLFTextField;
		public var mtValue:TLFTextField;
		
		public var goldText:TextField;
		
		public var iconTile:IconTile;

		private var selectedType:int;
		private var selectedTile:Tile;
		private var selectedEntity:Entity;
		private var iconEntities/*Entity*/:Array;
		private var command:int;
		
		

		public function MainUI()
		{
			selectedType = SELECTED_NONE;
			command = COMMAND_NONE;
		}	
		
		public function init(_main:Main)
		{			
			main = _main;
		
			hideTargetBar();
			hideActionButtons();

			infoButton.actionText.text = "Info";
			moveButton.actionText.text = "Move";
			attackButton.actionText.text = "Attack";
			claimButton.actionText.text = "Claim";
			
			//goldText.text = "123456789,9999";
			//trace(goldText.textFlow.computedFormat.fontFamily);

			infoButton.addEventListener(MouseEvent.CLICK, infoButtonClick);
			moveButton.addEventListener(MouseEvent.CLICK, moveButtonClick);
			attackButton.addEventListener(MouseEvent.CLICK, attackButtonClick);

			iconTile.visible = false;
			iconTile.addEventListener(MouseEvent.CLICK, iconTileClick);

			iconEntities = new Array();					
			
			Connection.INSTANCE.addEventListener(Connection.onInfoKingdomEvent, infoKingdomEvent);
			Connection.INSTANCE.addEventListener(Connection.onInfoArmyEvent, infoArmyEvent);
			Connection.INSTANCE.addEventListener(Connection.onInfoCityEvent, infoCityEvent);
			Connection.INSTANCE.addEventListener(Connection.onInfoTileEvent, infoTileEvent);
			Connection.INSTANCE.addEventListener(Connection.onInfoGenericArmy, infoGenericArmyEvent);
			Connection.INSTANCE.addEventListener(Connection.onInfoGenericArmy, infoGenericCityEvent);
		}

		public function isMoveCommand():Boolean
		{
			trace("command: " + command);
			return command == COMMAND_MOVE;
		}

		public function isAttackCommand():Boolean
		{
			return command == COMMAND_ATTACK;
		}

		public function resetCommand():void
		{
			command = COMMAND_NONE;
		}

		public function setSelectedTile(tile:Tile):void
		{
			selectedTile = tile;
			removeReticules();
			removeIcons();
			setTileIcon();
			setEntityIcons();
		}
		
		public function setTargetBar() : void
		{
			
		}

		private function setTileIcon():void
		{
			iconTile.visible = true;
			iconTile.setTile(selectedTile);
		}

		private function setEntityIcons():void
		{
			if (selectedTile != null)
			{
				var iconTileEdgeX:int = iconTile.x + iconTile.width;

				for (var i:int = 0; i < selectedTile.entities.length; i++)
				{
					var iconEntity:IconEntity = new IconEntity();
					iconEntity.setEntity(selectedTile.entities[i]);
					iconEntity.x = iconTileEdgeX + ICON_X_SPACER + i * (iconEntity.width + ICON_X_SPACER);
					iconEntity.y = iconTile.y;
					iconEntity.addEventListener(MouseEvent.CLICK, iconEntityClick);

					iconEntities.push(iconEntity);

					addChild(iconEntity);
				}
			}
		}
		
		private function removeReticules() : void
		{
			main.moveReticule.hide();
			main.attackReticule.hide();
		}
		
		private function removeIcons():void
		{
			if(iconEntities != null)
			{
				for (var i:int = 0; i < iconEntities.length; i++)
				{
					iconEntities[i].removeEventListener(MouseEvent.CLICK, iconEntityClick);
					removeChild(iconEntities[i]);
				}
	
				iconEntities.length = 0;
			}
		}

		private function iconTileClick(e:MouseEvent):void
		{
			var iconTile:IconTile = e.target as IconTile;
			
			hideActivateEntities();	
			
			iconTile.showActivate();
			
			selectedType = SELECTED_TILE;

			setActionBar();
		}

		private function iconEntityClick(e:MouseEvent):void
		{
			var iconEntity:IconEntity = e.target as IconEntity;
			
			hideActivateEntities()			
			iconTile.hideActivate();
			
			iconEntity.showActivate();
						
			selectedType = SELECTED_ENTITY;
			selectedEntity = iconEntity.entity;

			setActionBar();
		}
		
		private function hideActivateEntities() : void
		{
			if(iconEntities != null)
			{
				for (var i:int = 0; i < iconEntities.length; i++)
				{
					iconEntities[i].hideActivate();										
				}			
			}			
		}

		private function setActionBar():void
		{
			hideActionButtons();

			if (selectedType == SELECTED_TILE)
			{
				infoButton.visible = true;
			}
			else if (selectedType == SELECTED_ENTITY)
			{
				infoButton.visible = true;

				if (selectedEntity.type == Entity.ARMY)
				{
					if (selectedEntity.isPlayers())
					{
						moveButton.visible = true;
						attackButton.visible = true;
					}
				}
				else if (selectedEntity.type == Entity.CITY)
				{
					if (selectedEntity.isPlayers())
					{
						claimButton.visible = true;
					}
				}
			}

		}

		private function hideActionButtons():void
		{
			infoButton.visible = false;
			moveButton.visible = false;
			attackButton.visible = false;
			claimButton.visible = false;
		}

		private function hideTargetBar():void
		{
			targetName.visible = false;
			empireKingdomName.visible = false;
			ratingLabel.visible = false;
			repLabel.visible = false;
			diffLabel.visible = false;
			ratingValue.visible = false;
			repValue.visible = false;
			diffValue.visible = false;
			hpAtkDefLabel.visible = false;
			hpAtkDefValue.visible = false;

			pwrWeaInfLabel.visible = false;
			pwrWeaInfValue.visible = false;
			loyHeaSecLabel.visible = false;

			upkeepLabel.visible = false;
			upkeepValue.visible = false;
			hpLabel.visible = false;
			hpValue.visible = false;

			mpLabel.visible = false;
			mpValue.visible = false;
			mtLabel.visible = false;
			mtValue.visible = false;
		}

		private function infoButtonClick(e:MouseEvent):void
		{
			hideActivateActionButtons();
			infoButton.showActivate();
			
			if (selectedType == SELECTED_TILE)
			{
				var pEvent:ParamEvent = new ParamEvent(Tile.onDoubleClick);
				pEvent.params = selectedTile;

				Game.INSTANCE.dispatchEvent(pEvent);				
			}
			else if (selectedType == SELECTED_ENTITY)
			{
				if (selectedEntity.type == Entity.ARMY)
				{
					var pEvent:ParamEvent = new ParamEvent(Army.onDoubleClick);
					pEvent.params = Army(selectedEntity);

					Game.INSTANCE.dispatchEvent(pEvent);
				}
				else if (selectedEntity.type == Entity.CITY)
				{
					var pEvent:ParamEvent = new ParamEvent(City.onDoubleClick);
					pEvent.params = City(selectedEntity);

					Game.INSTANCE.dispatchEvent(pEvent);
				}
			}
		}

		private function moveButtonClick(e:MouseEvent):void
		{
			hideActivateActionButtons();
			moveButton.showActivate();
			
			Game.INSTANCE.selectedEntity = selectedEntity;
			command = COMMAND_MOVE;
			
			main.moveReticule.show();
		}

		private function attackButtonClick(e:MouseEvent):void
		{
			hideActivateActionButtons();
			attackButton.showActivate();
			
			Game.INSTANCE.selectedEntity = selectedEntity;
			command = COMMAND_ATTACK;
			
			//main.attackReticule.show();
		}
		
		private function claimButtonClick(e:MouseEvent) : void
		{
			hideActivateActionButtons();
			claimButton.showActivate();
			
			/*var pEvent:ParamEvent = new ParamEvent(City.onAddClaim);
			pEvent.params = City(selectedEntity);

			Game.INSTANCE.dispatchEvent(pEvent);*/
		}
		
		private function infoKingdomEvent(e:ParamEvent) : void
		{
			trace("MainUI - infoKingdomEvent");
			var infoKingdom:InfoKingdom = InfoKingdom(e.params);
			trace(infoKingdom.gold);			
			
			goldText.htmlText = infoKingdom.gold.toString();
			
			trace("goldText.htmlText: " + goldText.htmlText);
		}
		
		private function infoArmyEvent(e:ParamEvent) : void
		{
			trace("MainUI - infoArmy");
			var infoArmy:InfoArmy = InfoArmy(e.params);
			
			hideTargetBar();
			
			targetName.text = infoArmy.name;
			empireKingdomName.text = Game.INSTANCE.kingdom.name;
			ratingValue.text = "0";
			repValue.text = "Ally";
			diffValue.text = "Easy";
			hpAtkDefValue.text = "100\n1\n1";		
			
			showArmyTarget();
		}
		
		private function infoCityEvent(e:ParamEvent) : void
		{
			trace("MainUI - infoCity");
			var infoCity:InfoCity = InfoCity(e.params);
			
			hideTargetBar();
			
			targetName.text = infoCity.name;
			empireKingdomName.text = Game.INSTANCE.kingdom.name;
			pwrWeaInfValue.text = "0\n0\n0";
			
			showCityTarget();
		}
		
		private function infoTileEvent(e:ParamEvent) : void
		{
			trace("MainUI - infoTile");
			var infoTile:InfoTile = InfoTile(e.params);
			
			hideTargetBar();
			
			targetName.text = Tile.GetTileName(infoTile.tileType);
			
			showTileTarget();
		}
		
		private function infoGenericArmyEvent(e:ParamEvent) : void
		{
			trace("MainUI - infoGenericArmyEvent");
			var infoGenericArmy:InfoGenericArmy = InfoGenericArmy(e.params);
			
			hideTargetBar();
			
			targetName.text = infoGenericArmy.name;
			empireKingdomName.text = infoGenericArmy.kingdomName;
			ratingValue.text = "0";
			repValue.text = "Enemy";
			repValue.textColor = 0xFF0000;
			diffValue.text = "Easy";
			hpAtkDefValue.text = "100\n1\n1";	
			
			showArmyTarget();
		}
		
		private function infoGenericCityEvent(e:ParamEvent) : void
		{
			
		}
		
		private function showArmyTarget() : void
		{
			targetName.visible = true;
			empireKingdomName.visible = true;
			ratingLabel.visible = true;
			ratingValue.visible = true;
			repLabel.visible = true;
			repValue.visible = true;
			diffLabel.visible = true;
			diffValue.visible = true;
			hpAtkDefLabel.visible = true;
			hpAtkDefValue.visible = true;
		}
		
		private function showCityTarget() : void
		{
			targetName.visible = true;
			empireKingdomName.visible = true;
			pwrWeaInfLabel.visible = true;
			pwrWeaInfValue.visible = true;
			loyHeaSecLabel.visible = true;
		}
		
		private function showTileTarget() : void
		{
			targetName.visible = true;
		}
		
		private function hideActivateActionButtons() : void
		{
			infoButton.hideActivate();
			moveButton.hideActivate();
			attackButton.hideActivate();
			claimButton.hideActivate();
		}

	}

}