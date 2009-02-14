package
{
	import flash.display.MovieClip;
	import flash.events.MouseEvent;	
	import flash.utils.getTimer;
	import flash.utils.Timer;
	import flash.events.Event;
	
	public class Main extends MovieClip
	{
		public static var DEBUG:Boolean = true;
		public static var VERSION:String = "0.020";
		
		private var account:String;
		private var password:String;
		
		private var connection:Connection;
		private var game:Game;
		
		public function Main() : void
		{
			setupLoginFrame();
		}
		
		private function setupLoginFrame() : void
		{
			Version.text = "Version: " + VERSION;
			Login.addEventListener(MouseEvent.CLICK, loginHandler);
		}
				
		private function loginHandler(event:MouseEvent) : void
		{
			account = Account.text;
			password = Password.text;
			
			connection = new Connection();
			connection.addEventListener(Connection.onConnectEvent, connectionComplete);
			connection.addEventListener(Connection.onIOErrorEvent, connectionIOError);
			connection.addEventListener(Connection.onSecurityErrorEvent, connectionSecurityError);
			connection.addEventListener(Connection.onCloseEvent, connectionCloseError);
			connection.addEventListener(Connection.onLoggedInEvent, connectionLoggedIn);
			connection.addEventListener(Connection.onClockSyncEvent, connectionClockSync);
			connection.addEventListener(Connection.onMapEvent, connectionMap);
			connection.addEventListener(Connection.onPerceptionEvent, connectionPerception);
			
			connection.connect();
		}		
		
		private function connectionComplete(e:Event) : void
		{
			connection.doLogin(account, password);
		}	
		
		private function connectionIOError(e:Event) : void
		{
			connectionError("IO connection error.");
		}

		private function connectionSecurityError(e:Event) : void
		{
			connectionError("Security connection error.");
		}
		
		private function connectionCloseError(e:Event) : void
		{
			connectionError("Connection closed.");
		}	
		
		private function connectionError(msg:String) : void
		{
			connection.removeEventListener(Connection.onConnectEvent, connectionComplete);
			connection.removeEventListener(Connection.onIOErrorEvent, connectionIOError);
			connection.removeEventListener(Connection.onSecurityErrorEvent, connectionSecurityError);
			connection.removeEventListener(Connection.onCloseEvent, connectionCloseError);
			connection.removeEventListener(Connection.onClockSyncEvent, connectionClockSync);
					
			gotoAndStop("Login");
			setupLoginFrame();
			ConnectionStatus.text = msg;	
		}
		
		private function connectionLoggedIn(e:Event) : void
		{
			gotoAndStop("Game");
			game = new Game();
			game.setLastLoopTime(connection.clockSyncStartTime);
		}
		
		private function connectionClockSync(e:Event) : void
		{
			connection.doClientReady();
			game.startLoop();
			addChild(game);
		}
		
		private function connectionMap(e:Event) : void
		{
			var xCoord:int = connection.parameters[0];
			var yCoord:int = connection.parameters[1];
			var mapData:Array = connection.parameters[2];
			game.addMapData(xCoord, yCoord, mapData);
		}
		
		private function connectionPerception(e:Event) : void
		{
			var perceptionData:Array = connection.parameters[0];
			game.addPerceptionData(perceptionData);
		}
	}
}
		