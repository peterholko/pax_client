package ui {
	
	import flash.display.MovieClip;
	import fl.text.TLFTextField;
	
	import net.packet.InfoTile;
	import net.packet.Resource;
	import game.map.Tile;
	import game.map.Map;
	import game.Item;
	import game.entity.Improvement;
	import flash.events.MouseEvent;
		
	public class LandDetailCard extends MovieClip {
		
		public var tileIndex:int;
		public var tileType:int;
		public var resources:Array;
		
		public var closeButton:CloseButton;
		public var typeText:TLFTextField;
		public var empireNameText:TLFTextField;
		public var coordinatesText:TLFTextField;
		
		public var statsText:TLFTextField;
		public var upgradesText:TLFTextField;
		public var resourcesText:TLFTextField;
		
		public var landDetailImprovement:LandDetailImprovement;
		
		private var statsPanel:MovieClip;
		private var upgradesPanel:MovieClip;
		private var resourcesPanel:MovieClip;
		
		public function LandDetailCard() 
		{
			resources = new Array();					
		}
		
		public function init() : void
		{
			statsText.addEventListener(MouseEvent.CLICK, statsClick);
			upgradesText.addEventListener(MouseEvent.CLICK, upgradesClick);
			resourcesText.addEventListener(MouseEvent.CLICK, resourcesClick);			
			
			statsPanel = new MovieClip();
			upgradesPanel = new MovieClip();
			resourcesPanel = new MovieClip();
			
			addChild(statsPanel);
			addChild(upgradesPanel);
			addChild(resourcesPanel);			
		}
		
		public function showPanel() : void
		{
			this.parent.setChildIndex(this, this.parent.numChildren - 1);

			resourcesPanel.visible = false;
		}
		
		public function setInfo(infoTile:InfoTile) : void
		{
			var coordX:int = Map.convertCoordX(infoTile.tileIndex);
			var coordY:int = Map.convertCoordY(infoTile.tileIndex);
			
			typeText.text = Tile.GetTileName(infoTile.tileType);
			coordinatesText.text = "(" + coordX.toString() + ", " + coordY.toString() + ")";															
			
			for(var i = 0; i < infoTile.resources.length; i++)
			{
				var resource:Resource = Resource(infoTile.resources[i]);
				var landDetailResource:LandDetailResource = new LandDetailResource();				
				
				landDetailResource.nameText.text = Item.getNameByType(resource.type);
				landDetailResource.quantityText.text = UtilUI.FormatNum(resource.total);
				landDetailResource.regenText.text = "(" + UtilUI.FormatNum(resource.regen_rate) + ")";
				landDetailResource.x = 4;
				landDetailResource.y = 144;
															
				resources.push(landDetailResource);															
				resourcesPanel.addChild(landDetailResource);
			}
			
			var improvement:Improvement = Improvement.getImprovementFromPos(coordX, coordY);
			
			if(improvement != null)
			{
				landDetailImprovement.nameText.text = improvement.getName();
				landDetailImprovement.levelText.text = "";
				landDetailImprovement.hpText.text = "";
			}
		}
		
		private function statsClick(e:MouseEvent) : void
		{			
			
			landDetailImprovement.visible = true;
			resourcesPanel.visible = false;			
		}
		
		private function upgradesClick(e:MouseEvent) : void
		{
			
		}
		
		private function resourcesClick(e:MouseEvent) : void
		{
			landDetailImprovement.visible = false;						
			resourcesPanel.visible = true;
		}		
		
	}
	
}
