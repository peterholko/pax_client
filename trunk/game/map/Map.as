package game.map
{
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.utils.Dictionary;
	
	import game.entity.Entity;
	
	import net.packet.MapTile;
	import net.packet.MapObject;
	
	public class Map extends MovieClip
	{
		public static var INSTANCE:Map = new Map();	
		public static const WIDTH:int = 50;
		public static const HEIGHT:int = 50;	
				
		private var tiles/*Tile*/:Array;
		private var entities:Dictionary;
		private var battles:Dictionary;
		
		private var unexploredLayer:Sprite;
		private var tileLayer:Sprite;
		private var entityLayer:Sprite;
		private var battleLayer:Sprite;
		
		public function Map() : void
		{			
			tiles = new Array();
			entities = new Dictionary();
			battles = new Dictionary();
			
			unexploredLayer = new Sprite();
			//unexploredLayer.addEventListener(MouseEvent.CLICK, unexploredClick);
			
			tileLayer = new Sprite();			
			entityLayer = new Sprite();
			battleLayer = new Sprite();
			
			addChild(unexploredLayer);
			addChild(tileLayer);
			addChild(entityLayer);
			addChild(battleLayer);
		}
		
		public function setTiles(mapTiles/*MapTiles*/:Array) : void
		{								
			for(var i = 0; i < mapTiles.length; i++)
			{				
				var mapTile:MapTile = mapTiles[i];
				
				if (tiles[mapTile.index] == null)
				{
					var tile:Tile = new Tile();
					var tileX:int = (mapTile.index % Map.WIDTH);
					var tileY:int = (mapTile.index / Map.HEIGHT);
					
					trace("tileIndex: " + mapTile.index + " tileX: " + tileX + " tileY: " + tileY);
										
					tile.gameX = tileX;
					tile.gameY = tileY;
					tile.type =  mapTile.tile;
					tile.index = mapTile.index;
					tile.initialize();
					
					tile.x = tileX * Tile.WIDTH;
					tile.y = tileY * Tile.HEIGHT;
										
					tileLayer.addChild(tile);			
					
					tiles[mapTile.index] = tile;
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
			
			entities[entity.id] = entity;
			entityLayer.addChild(entity);
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
			entities[entity.id] = null;
			entityLayer.removeChild(entity);
		}			
		
		public function addBattle(mapObject:MapObject) : void
		{
			var tileIndex:int = Map.convertCoords(mapObject.x, mapObject.y);
			var tile:Tile = tiles[tileIndex];			
			var mapBattle:MapBattle = new MapBattle();
			
			mapBattle.battleId = mapObject.id;
			mapBattle.gameX = mapObject.x;
			mapBattle.gameY = mapObject.y;
			mapBattle.initialize();
			mapBattle.update()
			mapBattle.tile = tile;
						
			battleLayer.addChild(mapBattle);
			battles[mapBattle.battleId] = mapBattle;
		}
			
		public function removeBattle(mapObject:MapObject) : void
		{
			if (battles[mapObject.id] != null)
			{
				var mapBattle:MapBattle = battles[mapObject.id];
				
				if (battleLayer.contains(mapBattle))
					battleLayer.removeChild(mapBattle);
			}
		}
		
		public static function convertCoords(xCoord:int, yCoord:int) : int
		{
			return ((yCoord * HEIGHT) + xCoord);
		}
		
		private function unexploredClick(e:MouseEvent) : void
		{
			trace("unexploredClick");
		}
	}
}