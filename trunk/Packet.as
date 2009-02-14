package
{
	import flash.net.Socket;
	import flash.system.*;
	import flash.utils.Endian;
	import flash.utils.ByteArray;	
	
	public class Packet 
	{
		//Packet identifier
		public static var LOGIN:int = 1;
		public static var LOGOUT:int = 2;
		public static var CLOCKSYNC:int = 3;
		public static var CLIENTREADY:int = 4;
		public static var PLAYER_ID:int = 5;
		public static var MAP:int = 39;
		public static var PERCEPTION:int = 40;
		public static var BAD:int = 255;
		
		//Errors
		public static var ERR_BAD_LOGIN:int = 1;
		
		public function Packet() : void
		{
		}			
		
		public static function sendClockSync(socket:Socket) : void
		{
			socket.writeByte(CLOCKSYNC);
			socket.flush();			
		}
		
		public static function sendLogin(socket:Socket, account:String, password:String) : void
		{
			socket.writeByte(LOGIN);
			socket.writeUTF(account);		
			socket.writeUTF(password);		
			socket.flush();		
		}
		
		public static function sendClientReady(socket:Socket) : void
		{
			socket.writeByte(CLIENTREADY);
			socket.flush();
		}
		
		public static function readBad(byteArray:ByteArray) : String
		{
			var cmd:int = byteArray.readUnsignedByte();
			var error:int = byteArray.readUnsignedByte();
			var msg:String = "Command: " + Packet.getCmd(cmd) + " - Error: " + Packet.getError(error);
					
			return msg;
		}
		
		public static function readMap(byteArray:ByteArray) : Array
		{
			var coordX:int = byteArray.readUnsignedShort();
			var coordY:int = byteArray.readUnsignedShort();
			
			var numObjects:int = byteArray.readUnsignedShort();
			var array:Array = new Array();
			
			for(var i:int = 0; i < numObjects; i++)
			{			
				array.push(byteArray.readUnsignedByte());
			}
			
			var parameters = new Array();
			parameters.push(coordX);
			parameters.push(coordY);
			parameters.push(array);
			
			return parameters;
		}
		
		
		public static function getCmd(cmd:int) : String
		{
			var msg:String = "";
			
			switch(cmd)
			{
				case 1:
					msg = "Login";
					break;
				case 4:
					msg = "Bad";
					break;
				default:
					msg = "Unknown";
			}
			
			return msg;				
		}
		
		public static function getError(error:int) : String
		{
			var msg:String = "";
			
			switch(error)
			{
				case 255:
					msg = "Bad Login";
					break;
				default:
					msg = "Unknown";
			}
			
			return msg;
		}
	}
}
	