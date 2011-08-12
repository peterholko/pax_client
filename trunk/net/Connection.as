package net
{
	import flash.errors.*;
	import flash.net.Socket;
	import flash.system.*;
	import flash.utils.Endian;
	import flash.utils.ByteArray;
	import flash.events.*
	import flash.utils.getTimer;
	
	import net.packet.*;
	
	public class Connection extends EventDispatcher
	{
		public static var INSTANCE:Connection = new Connection();
		
		//public static var HOST:String = "localhost";
		public static var HOST:String = "www.empiresrising.com";		
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
		public static var onInfoKingdomEvent:String = "onInfoKingdomEvent";
		public static var onInfoArmyEvent:String = "onInfoArmyEvent";
		public static var onInfoCityEvent:String = "onInfoCityEvent";
		public static var onInfoTileEvent:String = "onInfoTileEvent";
		public static var onInfoUnitQueueEvent:String = "onInfoUnitQueueEvent";
		public static var onInfoGenericArmy:String = "onInfoGenericArmyEvent";
		public static var onBattleInfoEvent:String = "onBattleInfoEvent";
		public static var onBattleAddArmyEvent:String = "onBattleAddArmyEvent";
		public static var onBattleDamageEvent:String = "onBattleDamageEvent";				
		
		public static var onSendMoveArmy:String = "onSendMoveArmy";
		public static var onSendAttackTarget:String = "onSendAttackTarget";
		public static var onSendRequestInfo:String = "onSendRequestInfo";
		public static var onSendCityQueueUnit:String = "onSendCityQueueUnit";
		public static var onSendCityQueueBuilding:String = "onSendCityQueueBuilding";
		public static var onSendCityQueueImprovement:String = "onSendCityQueueImprovement";		
		public static var onSendCityQueueItem:String = "onSendCityQueueItem";
		public static var onSendTransferUnit:String = "onSendTransferUnit";
		public static var onSendBattleTarget:String = "onSendBattleTarget";
		public static var onSendAddClaim:String = "onSendAddClaim";
		public static var onSendAssignTask:String = "onSendAssignTask";
		public static var onSendTransferItem:String = "onSendTransferItem";
		
		public static var onSuccessAddClaim:String = "onSuccessAddClaim";
		public static var onSuccessAssignTask:String = "onSuccessAssignTask";
        public static var onSuccessCityQueueImprovement:String = "onSuccessCityQueueImprovement";
				
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
			trace("Connection - doLogin");
			Packet.sendLogin(socket, account, password);
		}
		
		public function doClientReady() : void
		{
			Packet.sendClientReady(socket);
		}
				
		private function addEventListeners() : void
		{
			addEventListener(onSendMoveArmy, sendMoveArmy);
			addEventListener(onSendAttackTarget, sendAttackTarget);
			addEventListener(onSendRequestInfo, sendRequestInfo);
			addEventListener(onSendCityQueueUnit, sendCityQueueUnit);
			addEventListener(onSendCityQueueBuilding, sendCityQueueBuilding);
			addEventListener(onSendCityQueueImprovement, sendCityQueueImprovement);			
			addEventListener(onSendCityQueueItem, sendCityQueueItem);
			addEventListener(onSendTransferUnit, sendTransferUnit);
			addEventListener(onSendBattleTarget, sendBattleTarget);
			addEventListener(onSendAddClaim, sendAddClaim);
			addEventListener(onSendAssignTask, sendAssignTask);
			addEventListener(onSendTransferItem, sendTransferItem);			
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
			trace("securityErrorEvent.txt: " + event.text);
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
					trace("Connection - cmd: " + cmd);
					
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
						//TODO Use the time sent by the server
						var high:int = bArr.readInt();
						var low:int = bArr.readInt();
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
					else if(cmd == Packet.INFO_KINGDOM)
					{
						trace("Connection - info_kingdom");
						pEvent = new ParamEvent(Connection.onInfoKingdomEvent);
						pEvent.params = Packet.readInfoKingdom(bArr);
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
					else if (cmd == Packet.INFO_TILE)
					{
						trace("Connection - info_tile");
						pEvent = new ParamEvent(Connection.onInfoTileEvent);
						pEvent.params = Packet.readInfoTile(bArr);
						dispatchEvent(pEvent);							
					}
					else if (cmd == Packet.INFO_GENERIC_ARMY)
					{
						trace("Connection - info_generic_army");
						pEvent = new ParamEvent(Connection.onInfoGenericArmy);
						pEvent.params = Packet.readInfoGenericArmy(bArr);
						dispatchEvent(pEvent);							
					}
					else if (cmd == Packet.BATTLE_INFO)
					{
						trace("Connection - battle_info");
						pEvent = new ParamEvent(Connection.onBattleInfoEvent);
						pEvent.params = Packet.readBattleInfo(bArr);
						dispatchEvent(pEvent);
					}
					else if (cmd == Packet.BATTLE_ADD_ARMY)
					{
						trace("Connection - battle_add_army");
						pEvent = new ParamEvent(Connection.onBattleAddArmyEvent);
						pEvent.params = Packet.readBattleAddArmy(bArr);
						dispatchEvent(pEvent);
					}
					else if (cmd == Packet.BATTLE_DAMAGE)
					{
						trace("Connection - battle_damage");
						pEvent = new ParamEvent(Connection.onBattleDamageEvent);
						pEvent.params = Packet.readBattleDamage(bArr);
						dispatchEvent(pEvent);
					}
					else if(cmd == Packet.SUCCESS)
					{
						trace("Connection - success");
						var success:Success = Packet.readSuccess(bArr);
						
						if(success.type == Packet.ADD_CLAIM)
						{
							pEvent = new ParamEvent(onSuccessAddClaim);
							pEvent.params = success.id;
						}	
						else if(success.type == Packet.ASSIGN_TASK)
						{
							pEvent = new ParamEvent(onSuccessAssignTask);
							pEvent.params = success.id;
						}
                        else if(success.type == Packet.CITY_QUEUE_IMPROVEMENT)
                        {
                            pEvent = new ParamEvent(onSuccessCityQueueImprovement)
                            pEvent.params = success.id;
                        }
						
						dispatchEvent(pEvent);												
					}
					else if(cmd == Packet.BAD)
					{
						serverErrorMsg = Packet.readBad(bArr);
						trace("Connection - server error msg: " + serverErrorMsg);
						dispatchEvent(new Event(Connection.onBadEvent));
					}
					else
					{
						trace("Connection - Packet not recognized!");
					}
				}
			} 
			catch(error:IOError)
			{
				trace(error.getStackTrace());
				trace("Connection - connect - IOError exception.");
			}
			catch(error:EOFError)
			{
				trace(error.getStackTrace());
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
		
		private function sendCityQueueBuilding(e:ParamEvent) : void
		{
			trace("Connection - sendCityQueueBuilding");
			var cityQueueBuilding:CityQueueBuilding = e.params;
			Packet.sendCityQueueBuilding(socket, cityQueueBuilding);
		}		
		
		private function sendCityQueueImprovement(e:ParamEvent) : void
		{
			trace("Connection - onSendCityQueueImprovement");
			var cityQueueImprovement:CityQueueImprovement = e.params;
			Packet.sendCityQueueImprovement(socket, cityQueueImprovement);										
		}		
		
		private function sendCityQueueItem(e:ParamEvent) : void
		{
			trace("Connection - sendCityQueueItem");
			var cityQueueItem:CityQueueItem = e.params;
			Packet.sendCityQueueItem(socket, cityQueueItem);
		}				
		
		private function sendTransferUnit(e:ParamEvent) : void
		{
			trace("Connection - sendTransferUnit");
			var transferUnit:TransferUnit = e.params;
			Packet.sendTransferUnit(socket, transferUnit);
		}	
		
		private function sendBattleTarget(e:ParamEvent) : void
		{
			trace("Connection - sendBattleTarget");
			var battleTarget:BattleTarget = e.params;			
			Packet.sendBattleTarget(socket, battleTarget);
		}
		
		private function sendAddClaim(e:ParamEvent) : void
		{
			trace("Connection - sendAddClaim");
			var addClaim:AddClaim = e.params;
			Packet.sendAddClaim(socket, addClaim);
		}	
		
		private function sendAssignTask(e:ParamEvent) : void
		{
			trace("Connection - sendAssignTask");
			var assignTask:AssignTask = e.params;
			Packet.sendAssignTask(socket, assignTask);
		}
		
		private function sendTransferItem(e:ParamEvent) : void
		{
			trace("Connection - sendTransferItem");
			var transferItem:TransferItem = e.params;
			Packet.sendTransferItem(socket, transferItem);			
		}
	}
}
		
