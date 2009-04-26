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
		public static var INSTANCE:Connection = new Connection();
		
		//public static var HOST:String = "localhost";
		public static var HOST:String = "www.cowwit.com";		
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
		public static var onInfoArmyEvent:String = "onInfoArmyEvent";
		public static var onInfoCityEvent:String = "onInfoCityEvent";
		public static var onInfoUnitQueueEvent:String = "onInfoUnitQueueEvent";
		
		public static var onSendMoveArmy:String = "onSendMoveArmy";
		public static var onSendAttackTarget:String = "onSendAttackTarget";
		public static var onSendRequestInfo:String = "onSendRequestInfo";
		public static var onSendCityQueueUnit:String = "onSendCityQueueUnit";
		public static var onSendTransferUnit:String = "onSendTransferUnit";
				
		public var clockSyncStartTime:Number = 0;
		public var clockSyncEndTime:Number = 0;
		public var playerId:Number;
		public var serverErrorMsg:String;
				
		private var socket:Socket;
		
		public function Connection() : void
		{
		}
		
		public function initialize() : void
		{
			addEventListeners();
		}
				
		public function connect() : void
		{			
			socket = new Socket();
			socket.addEventListener(Event.CONNECT, connectHandler);
 			socket.addEventListener(Event.CLOSE, closeHandler);
			socket.addEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler);
			socket.addEventListener(SecurityErrorEvent.SECURITY_ERROR, securityErrorHandler);
			socket.addEventListener(ProgressEvent.SOCKET_DATA, socketDataHandler);
			
			try
			{
				socket.connect(Connection.HOST, Connection.PORT);
			}
			catch(error:IOError)
			{
				trace("Connection - connect - IOError exception.");
			}
			catch(error:SecurityError)
			{
				trace("Connection - connect - Security exception.");
			}
		}
		
		public function doLogin(account:String, password:String) : void
		{
			Packet.sendLogin(socket, account, password);
		}
		
		public function doClientReady() : void
		{
			Packet.sendClientReady(socket);
		}
				
		private function addEventListeners() : void
		{
			addEventListener(Connection.onSendMoveArmy, sendMoveArmy);
			addEventListener(Connection.onSendAttackTarget, sendAttackTarget);
			addEventListener(Connection.onSendRequestInfo, sendRequestInfo);
			addEventListener(Connection.onSendCityQueueUnit, sendCityQueueUnit);
			addEventListener(Connection.onSendTransferUnit, sendTransferUnit);
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
			var pEvent:ParamEvent;
			var bArr:ByteArray = new ByteArray();
			var socketByteAvailable:int = socket.bytesAvailable;
			trace("Socket Bytes Available: " + socket.bytesAvailable);
						
			try
			{
				socket.readBytes(bArr, 0, socket.bytesAvailable);
				
				trace("bArr.position: " + bArr.position + " socket.bytesAvailable: " + socket.bytesAvailable); 
				while (bArr.position != socketByteAvailable)
				{
					var cmd:int = bArr.readUnsignedByte();
					
					if(cmd == Packet.PLAYER_ID)
					{
						playerId = bArr.readInt();
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
					else if(cmd == Packet.EXPLORED_MAP)
					{
						trace("Connection - initial explored map");
						pEvent = new ParamEvent(Connection.onMapEvent);
						pEvent.params = Packet.readExploredMap(bArr);
						dispatchEvent(pEvent);
					}
					else if(cmd == Packet.PERCEPTION)
					{				
						trace("Connection - perception");
						pEvent = new ParamEvent(Connection.onPerceptionEvent);
						pEvent.params = Packet.readPerception(bArr);
						dispatchEvent(pEvent);
					}
					else if(cmd == Packet.INFO_ARMY)
					{
						trace("Connection - info_army");
						pEvent = new ParamEvent(Connection.onInfoArmyEvent);
						pEvent.params = Packet.readInfoArmy(bArr);
						dispatchEvent(pEvent);
					}
					else if (cmd == Packet.INFO_CITY)
					{
						trace("Connection - info_city");
						pEvent = new ParamEvent(Connection.onInfoCityEvent);
						pEvent.params = Packet.readInfoCity(bArr);
						dispatchEvent(pEvent);					
					}
					else if(cmd == Packet.BAD)
					{
						serverErrorMsg = Packet.readBad(bArr);
						dispatchEvent(new Event(Connection.onBadEvent));
					}
				}
			} 
			catch(error:IOError)
			{
				trace("Connection - connect - IOError exception.");
			}
			catch(error:EOFError)
			{
				trace("Connection - connect - EOFError exception.");
			}
		}
		
		private function sendMoveArmy(e:ParamEvent) : void
		{
			trace("Connection - sendMoveArmy");
			Packet.sendMove(socket, e.params.id, e.params.x, e.params.y);
		}
		
		private function sendAttackTarget(e:ParamEvent) : void
		{
			trace("Connection - sendAttackTarget");
			Packet.sendAttack(socket, e.params.id, e.params.targetId);
		}
		
		private function sendRequestInfo(e:ParamEvent) : void
		{
			trace("Connection - sendRequestInfo");
			Packet.sendRequestInfo(socket, e.params.type, e.params.targetId);
		}
		
		private function sendCityQueueUnit(e:ParamEvent) : void
		{
			trace("Connection - sendCityQueueUnit");
			Packet.sendCityQueueUnit(socket, e.params.cityId, e.params.unitType, e.params.unitSize);
		}
		
		private function sendTransferUnit(e:ParamEvent) : void
		{
			trace("Connection - sendTransferUnit");
			Packet.sendTransferUnit(socket, e.params.unitId, e.params.sourceId, e.params.sourceType, e.params.targetId, e.params.targetType);
		}		
	}
}
		