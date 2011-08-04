﻿package game
{
	import flash.display.BitmapData;

	public class Item 
	{
		public static var PLANTS:int = 1;
		
		public var id:int;
		public var entityId:int;
		public var type:int;
		public var value:int;

		public function Item() 
		{
		}
		
		public static function getNameByType(type:int) : String
		{
			switch(type)
			{
				case PLANTS:
					return "Plants";
			}
			
			return "None";
		}		
		
		public function getName() : String
		{
			return getNameByType(type);
		}
		
		public function getImage() : BitmapData
		{			
			trace("Item - type: " + type);
			switch(type)
			{
				case PLANTS:
					return new PlantImage;
			}
			
			return null;
		}		

	}
	
}