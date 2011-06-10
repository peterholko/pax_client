package ui 
{
	
	import flash.display.MovieClip;	
	import fl.text.TLFTextField;
	
	public class AssignPopUI extends MovieClip 
	{
		public var taskType:int;
		public var taskId:int;		
		public var caste:int;
		public var race:int;
		public var amount:int;
		
		public var casteNameText:TLFTextField;
		public var objectFullNameText:TLFTextField;
		public var objectNameLevelText:TLFTextField;
		public var popInputText:TLFTextField;
		public var hpText:TLFTextField;
		
		public var cancelButton:MovieClip;
		public var confirmButton:MovieClip;
		
		public function AssignPopUI() 
		{
		}
	}
	
}
