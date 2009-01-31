package
{
	import flash.display.MovieClip;
	import flash.errors.*;
	import flash.events.*;
	import flash.net.Socket;
	import flash.system.*;
	import flash.utils.Endian;
	import flash.utils.ByteArray;
	import flash.events.MouseEvent;	
	import flash.utils.getTimer;
	import flash.utils.Timer;
	import flash.events.TimerEvent;
	
	public class Main extends MovieClip
	{
		public static var deltaTime:int = 50;			
		public var mSocket:Socket;
		
		private var startTime:Number;
		private var offsetTime:Number;
		private var serverTime:Number;
		private var lastLoopTime:Number;	
		private var account:String;
		private var password:String;
		
		private var keyDown:Boolean;
		private var characterList:Array;
		
		private var playerId:int;
		private var playerCharacter:Character;
		private var speed:int = 10;
		
		public function Main() : void
		{
			characterList = new Array();
			playerCharacter = new Character();
			//11EE8695487
			Login.addEventListener(MouseEvent.CLICK, loginHandler);
			//0 0 1 30 232 101 153 209
			//var num:uint = 232 << 24 | 101 << 16 | 153 << 8 | 209;
			//var num2:Number = 1 << 8 | 30;
			//num2 = num2 * (Math.pow(2,32) - 1);
			//var number:Number =  num2 + num;
			//trace(Number.MAX_VALUE);
			//trace("numbeR: " + num2);
		}
		
		private function loginHandler(event:MouseEvent) : void
		{
			account = "";
			account = Account.text;
			password = Password.text;
			
						
			gotoAndStop("Game");
			connect();
		}
		
		private function connect() : void
		{			
			mSocket = new Socket("localhost", 2345);
			//mSocket = new Socket("www.cowwit.com", 2345);
			trace("Hello World");
			mSocket.addEventListener(Event.CONNECT, connectHandler);
 			mSocket.addEventListener(Event.CLOSE, closeHandler);
			mSocket.addEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler);
			mSocket.addEventListener(SecurityErrorEvent.SECURITY_ERROR, securityErrorHandler);
			mSocket.addEventListener(ProgressEvent.SOCKET_DATA, socketDataHandler);
		}
		
		/*private function clickHandler(event:MouseEvent) : void
		{
			//trace("ChatBox: " + ChatBox.text);
			
			//var input:String = ChatBox.text;
			
			mSocket.writeByte(131);
			mSocket.writeByte(107);
			mSocket.writeUTF(input);
			mSocket.flush();			
			
			trace("flushed.");			
		}*/		
				
		private function closeHandler(event:Event):void {
			trace("closeHandler: " + event);
		}
	
		private function connectHandler(event:Event):void {
			trace("connectHandler: " + event);
			
			trace("Account: " + account);
			trace("Password: " + password);		
			
			startTime = getTimer();
			mSocket.writeByte(4);
			mSocket.flush();				
			
			//startTimer = new Timer(5000, 0);
			//startTimer.addEventListener("timer", ping);		
			//startTimer.start();			
		}
	
		private function ioErrorHandler(event:IOErrorEvent):void {
			trace("ioErrorHandler: " + event);
		}
	
		private function securityErrorHandler(event:SecurityErrorEvent):void {
			trace("securityErrorHandler: " + event);
		}
	
		private function socketDataHandler(event:ProgressEvent):void 
		{
			var time:Number = getTimer();
			var bArr:ByteArray = new ByteArray();
			
			//trace("Bytes Available: " + mSocket.bytesAvailable);
	
			mSocket.readBytes(bArr, 0, mSocket.bytesAvailable);
			
			var cmd:int = bArr.readUnsignedByte();
			
			if(cmd == 31)
			{
				playerId = bArr.readUnsignedByte();
				trace("Player Id: " + playerId);				
				trace("Logged in.");
				
				keyDown = false;
				stage.focus = this;
				stage.addEventListener(KeyboardEvent.KEY_DOWN,EventKeyDown);
				stage.addEventListener(KeyboardEvent.KEY_UP,EventKeyUp);					
				lastLoopTime = getTimer();
				this.addEventListener(Event.ENTER_FRAME, this.gameLoopHandler);		
			}
			else if(cmd == 4)
			{
				var endTime:Number = getTimer();
				var diffTime:Number = (endTime - startTime) / 2;
				
				var b7:int = bArr.readUnsignedByte();
				var b6:int = bArr.readUnsignedByte();
				var b5:int = bArr.readUnsignedByte();
				var b4:int = bArr.readUnsignedByte();
				var b3:int = bArr.readUnsignedByte();
				var b2:int = bArr.readUnsignedByte();
				var b1:int = bArr.readUnsignedByte();
				var b0:int = bArr.readUnsignedByte();
				
				//trace("Bytes " + b7 + " " + b6 + " " + b5 + " " + b4 + " " + b3 + " " + b2 + " " + b1 + " " + b0);
				
				var lowerInt:uint =  b3 << 24 | b2 << 16 | b1 << 8 | b0;
				var upperInt:Number = b5 << 8 | b4;
				upperInt = upperInt * Math.pow(2,32);
				serverTime = upperInt + lowerInt;		
				
				trace("Server Time ATM: " + (serverTime + diffTime));
				
				mSocket.writeByte(1);
				mSocket.writeUTF(account);		
				mSocket.writeUTF(password);		
				mSocket.flush();					
			}
			/*else if(cmd == 5)
			{
				var b7:int = bArr.readUnsignedByte();
				var b6:int = bArr.readUnsignedByte();
				var b5:int = bArr.readUnsignedByte();
				var b4:int = bArr.readUnsignedByte();
				var b3:int = bArr.readUnsignedByte();
				var b2:int = bArr.readUnsignedByte();
				var b1:int = bArr.readUnsignedByte();
				var b0:int = bArr.readUnsignedByte();
				
				//trace("Bytes " + b7 + " " + b6 + " " + b5 + " " + b4 + " " + b3 + " " + b2 + " " + b1 + " " + b0);
				
				var lowerInt:uint =  b3 << 24 | b2 << 16 | b1 << 8 | b0;
				var upperInt:Number = b5 << 8 | b4;
				upperInt = upperInt * Math.pow(2,32);
				var serverTime = upperInt + lowerInt;
				
				//trace("lowerInt: " + lowerInt);
				//trace("upperInt: " + upperInt);
				trace("End Time: " + getTimer());				
				var deltaTime:Number = (serverTime - clientTime);
				
				trace("RoundTripTime: " + deltaTime);				
				//keyDown = false;
				//stage.focus = this;
				//stage.addEventListener(KeyboardEvent.KEY_DOWN,EventKeyDown);
				//stage.addEventListener(KeyboardEvent.KEY_UP,EventKeyUp);					
				//lastLoopTime = getTimer();
				//this.addEventListener(Event.ENTER_FRAME, this.gameLoopHandler);			
			}	*/		
			else if(cmd == 40)
			{
				var numObjects:int = bArr.readUnsignedByte();
				
				removeAllCharacters();
				
				for(var i:int = 0; i < numObjects; i++)
				{
					var objectId:int =  bArr.readUnsignedShort();
					var xPos:int = bArr.readUnsignedShort();
					var yPos:int = bArr.readUnsignedShort();
					var action:int = bArr.readUnsignedShort();
					
					var newCharacter = new Character();
					newCharacter.objectId = objectId;
					newCharacter.xPos = xPos;
					newCharacter.yPos = yPos;		
					newCharacter.action = action;
										
					characterList.push(newCharacter);
					
					var time:Number = getTimer();
					trace("Packet @ Time: " + time + " X: " + xPos + " Y: " + yPos + "  -   Event: " + event);
				}
					
			}
		}
		
		private function removeAllCharacters() : void
		{
			for(var i = 0; i < characterList.length; i++)
			{
				this.removeChild(characterList[i]);
			}			
			
			characterList.length = 0;
		}
		
		public function gameLoopHandler(event:Event) : void
		{
			var time:Number = getTimer();
						
			if((time - this.lastLoopTime) >= Main.deltaTime)
			{
				this.lastLoopTime += Main.deltaTime;
				
				for(var i:int = 0; i < characterList.length; i++)
				{	
					if( (characterList[i].xPos * speed) != characterList[i].x || 
						(characterList[i].yPos * speed) != characterList[i].y)
					{
						characterList[i].x = characterList[i].xPos * speed;
						characterList[i].y = characterList[i].yPos * speed;
						this.addChild(characterList[i]);
					}
					else
					{					
						if(characterList[i].action == 1)
						{
							characterList[i].yPos--;
							characterList[i].y -= speed;
							trace("this.lastLoopTime: "  + this.lastLoopTime + " x: " + characterList[i].x + " y: " + characterList[i].y);
						}
						else if(characterList[i].action == 2)
						{
							characterList[i].xPos++;
							characterList[i].x += speed;
							trace("this.lastLoopTime: "  + this.lastLoopTime + " x: " + characterList[i].x + " y: " + characterList[i].y);
						}
						else if(characterList[i].action == 3)
						{
							characterList[i].yPos++;
							characterList[i].y += speed;
							trace("this.lastLoopTime: "  + this.lastLoopTime + " x: " + characterList[i].x + " y: " + characterList[i].y);
						}		
						else if(characterList[i].action == 4)
						{
							characterList[i].xPos--;
							characterList[i].x -= speed;
							trace("this.lastLoopTime: "  + this.lastLoopTime + " x: " + characterList[i].x + " y: " + characterList[i].y);
						}			
					}
				}
			}
		}
		
		public function EventKeyDown(event:KeyboardEvent):void
		{
			if(!keyDown)
			{
				if (event.keyCode == 87) //w
				{
					trace("Send Move North");
					mSocket.writeByte(3);
					mSocket.writeByte(0);		
					mSocket.flush();			
					keyDown = true;
				}
				else if (event.keyCode == 68) //d
				{
					trace("Send Move East");
					mSocket.writeByte(3);
					mSocket.writeByte(1);		
					mSocket.flush();			
					keyDown = true;
				}
				else if (event.keyCode == 83) //s
				{
					trace("Send Move South"); 
					mSocket.writeByte(3);
					mSocket.writeByte(2);		
					mSocket.flush();						 
					keyDown = true;
				}
				else if (event.keyCode == 65) //a
				{
					trace("Send Move West"); 
					mSocket.writeByte(3);
					mSocket.writeByte(3);		
					mSocket.flush();					 
					keyDown = true;
				}				
			}
		}

		public function EventKeyUp(event:KeyboardEvent):void
		{
			if (event.keyCode == 87 || event.keyCode == 68 || event.keyCode == 83 || event.keyCode == 65) //wdsa
			{
				trace("Send Stop Moving"); 
				mSocket.writeByte(3);
				mSocket.writeByte(255);		
				mSocket.flush();		
				keyDown = false;
			}
		}	
		
		/*public function ping(event:TimerEvent) : void
		{
			var date:Date = new Date();
			clientTime = date.getTime();
			clientTime = clientTime + diffTime;
			trace("Start Time: " + getTimer());			
			mSocket.writeByte(5);
			mSocket.flush();			
		}*/
		
	}
}
		