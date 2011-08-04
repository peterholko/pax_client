package ui {
	
	import flash.display.MovieClip;
	import fl.text.TLFTextField;
	
	import net.packet.InfoTile;
	import net.packet.Resource;
	import game.map.Tile;
	import game.map.Map;
	import game.Item;
		
	public class LandDetailCard extends MovieClip {
		
		public var tileIndex:int;
		public var tileType:int;
		public var resources:Array;
		
		public var closeButton:CloseButton;
		public var typeText:TLFTextField;
		public var empireNameText:TLFTextField;
		public var coordinatesText:TLFTextField;
		
		public function LandDetailCard() 
		{
			resources = new Array();
		}
		
		public function showPanel() : void
		{
			this.parent.setChildIndex(this, this.parent.numChildren - 1);
		}
		
		public function setInfo(infoTile:InfoTile) : void
		{
			var coordX:String = Map.convertCoordX(infoTile.tileIndex).toString();
			var coordY:String = Map.convertCoordY(infoTile.tileIndex).toString();
			
			typeText.text = Tile.GetTileName(infoTile.tileType);
			coordinatesText.text = "(" + coordX + ", " + coordY + ")";															
			
			for(var i = 0; i < infoTile.resources.length; i++)
			{
				var resource:Resource = Resource(infoTile.resources[i]);
				var landDetailResource:LandDetailResource = new LandDetailResource();				
				
				landDetailResource.nameText.text = Item.getNameByType(resource.type);
				landDetailResource.quantityRegenText.text = UtilUI.FormatNum(resource.total) + 
															"(" + UtilUI.FormatNum(resource.regen_rate) + ")";
				landDetailResource.x = 11;
				landDetailResource.y = 255;
															
				resources.push(landDetailResource);															
				addChild(landDetailResource);
			}
		}
		
	}
	
}
