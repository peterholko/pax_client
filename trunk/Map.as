package
{
	import flash.display.MovieClip;
	
	public class Map extends MovieClip
	{
		public static const WIDTH:int = 50;
		public static const HEIGHT:int = 50;		
		
		private var tiles:Array;
		
		public function Map() : void
		{
			tiles = new Array();
		}
		
		public function setTiles(perceptionTiles:Array) : void
		{						
			var newTiles:Array = new Array();
		
			for(var i = 0; i < perceptionTiles.length; i++)
			{	
				var tileIndex:int = indexOfTile(perceptionTiles[i].tileIndex);
			
				if(tileIndex == -1)
				{
					var tile:Tile = new Tile();
					var tileX:int = (perceptionTiles[i].tileIndex % Map.WIDTH);
					var tileY:int = (perceptionTiles[i].tileIndex / Map.HEIGHT);
										
					tile.gameX = tileX;
					tile.gameY = tileY;
					tile.type =  perceptionTiles[i].tile;
					tile.index = perceptionTiles[i].tileIndex;
					tile.initialize();
					
					tile.x = tileX * Tile.WIDTH;
					tile.y = tileY * Tile.HEIGHT;
										
					addChild(tile);
				}				
			}
			
			this.tiles.concat(newTiles);
		}		
		
		private function indexOfTile(index:int) : int
		{
			for(var i = 0; i < tiles.length; i++)
			{
				if(index == tiles[i].index)
				{
					return i;
				}
			}
			return -1;
		}		
						
		public static function convertCoords(xCoord:int, yCoord:int, yHeight:int) : int
		{
			return ((yCoord * yHeight) + xCoord);
		}
	}
}