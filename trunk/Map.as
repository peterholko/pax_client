package
{
	import flash.display.MovieClip;
	
	public class Map extends MovieClip
	{
		public static var INSTANCE:Map = new Map();	
		public static const WIDTH:int = 50;
		public static const HEIGHT:int = 50;		
		
		private var tiles/*Tile*/:Array;
		
		public function Map() : void
		{			
			tiles = new Array();
		}
		
		public function setTiles(perceptionTiles:Array) : void
		{						
			var newTiles:Array = new Array();
		
			for(var i = 0; i < perceptionTiles.length; i++)
			{				
				if (tiles[perceptionTiles[i].tileIndex] == null)
				{
					var tile:Tile = new Tile();
					var tileX:int = (perceptionTiles[i].tileIndex % Map.WIDTH);
					var tileY:int = (perceptionTiles[i].tileIndex / Map.HEIGHT);
					
					trace("tileIndex: " + perceptionTiles[i].tileIndex + " tileX: " + tileX + " tileY: " + tileY);
										
					tile.gameX = tileX;
					tile.gameY = tileY;
					tile.type =  perceptionTiles[i].tile;
					tile.index = perceptionTiles[i].tileIndex;
					tile.initialize();
					
					tile.x = tileX * Tile.WIDTH;
					tile.y = tileY * Tile.HEIGHT;
										
					addChild(tile);			
					
					tiles[perceptionTiles[i].tileIndex] = tile;
				}
			}
		}
		
		public function addEntity(entity:Entity) : void
		{
			var tileIndex:int = Map.convertCoords(entity.gameX, entity.gameY);
			var tile:Tile = tiles[tileIndex];
			
			if (tile != null)
			{
				tile.addEntity(entity);
				entity.tile = tile;
			}
		}
		
		public function removeEntity(entity:Entity) : void
		{
			var tileIndex:int = Map.convertCoords(entity.gameX, entity.gameY);
			var tile:Tile = tiles[tileIndex];
			
			if (tile != null)
			{			
				tile.removeEntity(entity);
				entity.tile = null;
			}
		}			
						
		public static function convertCoords(xCoord:int, yCoord:int) : int
		{
			return ((yCoord * HEIGHT) + xCoord);
		}
	}
}