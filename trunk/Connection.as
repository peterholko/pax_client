package
{
	import flash.errors.*;
	import flash.net.Socket;
	import flash.system.*;
	import flash.utils.Endian;
	import flash.utils.ByteArray;
	import flash.events.*
	import flash.utils.getTimer;
	
	public class Connection extends EventDispatcher
	{
		public static var HOST:String = "localhost";
		//public static var HOST:String = "www.cowwit.com";		
		public static var PORT:int = 2345
				
		//Events
		public static var onConnectEvent:String = "onConnectEvent";
		public static var onCloseEvent:String = "onCloseEvent";
		public static var onIOErrorEvent:String = "onIOErrorEvent";
		public static var onSecurityErrorEvent:String = "onSecurityEvent";
		public static var onLoggedInEvent:String = "onLoggedInEvent";
		public static var onClockSyncEvent:String = "onClockSyncEvent";
		public static var onBadEvent:String = "onBadEvent";
		public static var onMapEvent:String = "onMapEvent";
		public static var onPerceptionEvent:String = "onPerceptionEvent";
		
		public var clockSyncStartTime:Number = 0;
		public var clockSyncEndTime:Number = 0;
		public var serverErrorMsg:String;
		public var parameters:Array;
				
		private var socket:Socket;
		
		public function Connection() : void
		{
		}
		
		public function connect() : void
		{			
			socket = new Socket();
			socket.addEventListener(Event.CONNECT, connectHandler);
 			socket.addEventListener(Event.CLOSE, closeHandler);
			socket.addEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler);
			socket.addEventListener(SecurityErrorEvent.SECURITY_ERROR, securityErrorHandler);
			socket.addEventListener(ProgressEvent.SOCKET_DATA, socketDataHandler);
			
			socket.connect(Connection.HOST, Connection.PORT);
		}
		
		public function doLogin(account:String, password:String) : void
		{
			Packet.sendLogin(socket, account, password);
		}
		
		public function doClientReady() : void
		{
			Packet.sendClientReady(socket);
		}
		
		private function closeHandler(event:Event):void {
			trace("closeHandler: " + event);
			dispatchEvent(new Event(Connection.onCloseEvent));	
		}
	
		private function connectHandler(event:Event):void {
			trace("connectHandler: " + event);
			dispatchEvent(new Event(Connection.onConnectEvent));			
		}
	
		private function ioErrorHandler(event:IOErrorEvent):void {
			trace("ioErrorHandler: " + event);
			dispatchEvent(new Event(Connection.onIOErrorEvent));	
		}
	
		private function securityErrorHandler(event:SecurityErrorEvent):void {
			trace("securityErrorHandler: " + event);
			dispatchEvent(new Event(Connection.onSecurityErrorEvent));	
		}
	
		private function socketDataHandler(event:ProgressEvent):void 
		{
			var bArr:ByteArray = new ByteArray();
				
			socket.readBytes(bArr, 0, socket.bytesAvailable);
			
			var cmd:int = bArr.readUnsignedByte();
			
			if(cmd == Packet.PLAYER_ID)
			{
				var playerId = bArr.readUnsignedByte();
				trace("Connection - player Id: " + playerId);		
				clockSyncStartTime = getTimer();
				Packet.sendClockSync(socket);
				dispatchEvent(new Event(Connection.onLoggedInEvent));
			}			
			else if(cmd == Packet.CLOCKSYNC)
			{		
				trace("Connection - clock sync");
				clockSyncEndTime = getTimer();
				dispatchEvent(new Event(Connection.onClockSyncEvent));
			}
			else if(cmd == Packet.MAP)
			{
				trace("Connection - map");
				parameters = Packet.readMap(bArr);
				dispatchEvent(new Event(Connection.onMapEvent));
			}
			else if(cmd == Packet.PERCEPTION)
			{				
				var numObjects:int = bArr.readUnsignedByte();
				var characterList:Array = new Array();
								
				for(var i:int = 0; i < numObjects; i++)
				{
					var objectId:int =  bArr.readUnsignedShort();
					var xPos:int = bArr.readUnsignedShort();
					var yPos:int = bArr.readUnsignedShort();
					var action:int = bArr.readUnsignedShort();
					
					var character:Character = new Character();
					character.objectId = objectId;
					character.xPos = xPos;
					character.yPos = yPos;		
					character.action = action;
										
					characterList.push(character);
				}			
				
				parameters[0] = characterList;
				dispatchEvent(new Event(Connection.onPerceptionEvent));
			}
			else if(cmd == Packet.BAD)
			{
				serverErrorMsg = Packet.readBad(bArr);
				dispatchEvent(new Event(Connection.onBadEvent));
			}
		}
	}
}
		