package ui 
{	
	import flash.display.MovieClip;
	import fl.text.TLFTextField;
	import flash.display.Shape;	
	import flash.text.TextFormat;
	import flashx.textLayout.formats.TextLayoutFormat;
	import flashx.textLayout.elements.TextFlow;
	import flash.text.AntiAliasType;
	
	public class DropDownList extends MovieClip 
	{				
		public static var BACKGROUND_COLOR:int = 0x3B3B3B;
		
		public var listTextFields:Array;
		
		private var bgRectangle:Shape;
	
		public function DropDownList() : void
		{
			listTextFields = new Array();
			bgRectangle = new Shape();
			
			addChild(bgRectangle);
		}
		
		public function setList(list:Array) : void
		{						
			var myFormat:TextLayoutFormat = new TextLayoutFormat();
			myFormat.color = 0xFFFFFF;
			myFormat.fontFamily = "Verdana";
			myFormat.fontSize = 10;			 

			for(var i = 0; i < list.length; i++)
			{
				var textFieldItem:TLFTextField = new TLFTextField();
				textFieldItem.text = list[i];
				textFieldItem.x = 0;
				textFieldItem.y = textFieldItem.textHeight * i + 1;
											
				var myTextFlow:TextFlow = textFieldItem.textFlow;
				myTextFlow.hostFormat = myFormat;
				myTextFlow.flowComposer.updateAllControllers();				
								
				addChild(textFieldItem);			
				
				listTextFields.push(textFieldItem);
			}
			
			setBackground(list.length);
		}
		
		private function setBackground(listLength:int) : void
		{
			bgRectangle.graphics.clear();
			bgRectangle.graphics.beginFill(BACKGROUND_COLOR);
			bgRectangle.graphics.drawRect(0,0, 58, 12*listLength);
			bgRectangle.graphics.endFill();
		}

	}
	
}
