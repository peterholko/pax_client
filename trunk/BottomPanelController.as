package 
{
	import fl.controls.Button;
	import flash.events.MouseEvent;
	
	public class BottomPanelController 
	{
		public static var INSTANCE:BottomPanelController  = new BottomPanelController ();
		
		private static var ICON_X_OFFSET:int = 10;
		private static var ICON_X_SPACER:int = 5;
		
		public var tile:Tile;
		
		private var bottomPanel:BottomPanel;
		private var iconEntities/*Entity*/:Array;
		private var iconTile:IconTile;
		
		public function BottomPanelController() : void
		{	
			iconEntities = new Array();
		}
		
		public function initialize(main:Main) : void
		{
			bottomPanel = main.bottomPanel;
		}		
		
		public function setIcons() : void
		{
			removeIcons();
			setEntityIcons();
			setTileIcon();
		}
				
		private function setEntityIcons() : void
		{
			trace("BottomPanelController - setEntityIcons() - tile.entities.length: " + tile.entities.length);
			
			for (var i:int = 0; i < tile.entities.length; i++)
			{
				var iconEntity:IconEntity = new IconEntity();
				iconEntity.setEntity(tile.entities[i]);
				iconEntity.x = ICON_X_OFFSET + i * (iconEntity.width + ICON_X_SPACER);
				iconEntity.y = bottomPanel.height / 2 - iconEntity.height / 2;				
				iconEntity.addEventListener(MouseEvent.CLICK, iconEntityClick);				
				
				iconEntities.push(iconEntity);
				
				bottomPanel.addChild(iconEntity);
			}
		}
		
		private function setTileIcon() : void
		{
			iconTile = new IconTile();
			iconTile.setTile(tile);
			iconTile.x = ICON_X_OFFSET + tile.entities.length * (iconTile.width + ICON_X_SPACER);
			iconTile.y = bottomPanel.height / 2 - iconTile.height / 2;	
			iconTile.addEventListener(MouseEvent.CLICK, iconTileClick);
			
			bottomPanel.addChild(iconTile);
		}		
		
		private function removeIcons() : void
		{
			for (var i:int = 0; i < iconEntities.length; i++)
			{
				iconEntities[i].removeEventListener(MouseEvent.CLICK, iconEntityClick);
				bottomPanel.removeChild(iconEntities[i]);
			}
			
			iconEntities.length = 0;
			
			if (iconTile != null)
			{
				bottomPanel.removeChild(iconTile);
				iconTile = null;
			}
		}	
		
		private function iconEntityClick(e:MouseEvent) : void
		{
			var iconEntity:IconEntity = e.target as IconEntity;
			
			trace("BottomPanelController -- Game.INSTANCE.action: " + Game.INSTANCE.action);
			
			if (Game.INSTANCE.action == CommandPanelController.COMMAND_ATTACK)
			{
				Game.INSTANCE.sendAttack(iconEntity.entity.id);
				Game.INSTANCE.action = CommandPanelController.COMMAND_NONE;
			}
			else 
			{						
				CommandPanelController.INSTANCE.showPanel();
				CommandPanelController.INSTANCE.setEntityCommands(iconEntity.entity);
			}
		}
		
		private function iconTileClick(e:MouseEvent) : void
		{
			var iconTile:IconTile = e.target as IconTile;
			
			
			CommandPanelController.INSTANCE.showPanel();
			CommandPanelController.INSTANCE.setTileCommands(tile);
		}
	}
	
}