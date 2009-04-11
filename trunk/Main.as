package
{
	import flash.display.MovieClip;
	import flash.events.MouseEvent;	
	import flash.utils.getTimer;
	import flash.utils.Timer;
	import flash.events.Event;
	import flash.geom.Rectangle;
	import flash.events.KeyboardEvent;
	
	public class Main extends MovieClip
	{
		public static var DEBUG:Boolean = true;
		public static var VERSION:String = "0.025";
		
		private var account:String;
		private var password:String;
		
		private var connection:Connection;
		private var game:Game;
		
		public var armyPanel:MovieClip;
		public var cityPanel:MovieClip;		
		
		private var cityPanelController:CityPanelController;
		private var armyPanelController:ArmyPanelController;
		private var queueBuildingPanelController:QueueBuildingPanelController;
		private var createUnitPanelController:CreateUnitPanelController;
		
		private var connectionMsg:String = "";
		
		public function Main() : void
		{
			this.gotoAndStop("Login");
		}
		
		public function setupLoginFrame() : void
		{
			Version.text = "Version: " + VERSION;
			ConnectionStatus.text = connectionMsg;	
			Login.addEventListener(MouseEvent.CLICK, loginHandler);
		}
		
		public function setupGameFrame() : void
		{
			trace("armyPanel: " + armyPanel);
			armyPanelController = ArmyPanelController.INSTANCE;
			armyPanelController.main = this;
			armyPanelController.initialize();
			
			cityPanelController = CityPanelController.INSTANCE;
			cityPanelController.main = this;
			cityPanelController.initialize();
			
			queueBuildingPanelController = QueueBuildingPanelController.INSTANCE;
			queueBuildingPanelController.main = this;
			queueBuildingPanelController.initialize();
			
			createUnitPanelController = CreateUnitPanelController.INSTANCE;
			createUnitPanelController.main = this;
			createUnitPanelController.initialize();
						
			game = Game.INSTANCE;
			game.main = this;
			game.setLastLoopTime(connection.clockSyncStartTime);
			game.player.id = connection.playerId;			
		}
						
		private function loginHandler(event:MouseEvent) : void
		{
			account = Account.text;
			password = Password.text;
			
			connection = Connection.INSTANCE;
			connection.initialize();
			connection.addEventListener(Connection.onConnectEvent, connectionComplete);
			connection.addEventListener(Connection.onIOErrorEvent, connectionIOError);
			connection.addEventListener(Connection.onSecurityErrorEvent, connectionSecurityError);
			connection.addEventListener(Connection.onCloseEvent, connectionCloseError);
			connection.addEventListener(Connection.onLoggedInEvent, connectionLoggedIn);
			connection.addEventListener(Connection.onClockSyncEvent, connectionClockSync);
			
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
			
			connectionMsg = msg;
			
			gotoAndStop("Login");
		}
		
		private function connectionLoggedIn(e:Event) : void
		{
			gotoAndStop("Game");
		}
				
		private function connectionClockSync(e:Event) : void
		{
			connection.doClientReady();
			game.startLoop();
			game.x = 100;
			game.y = 0;
			game.scrollRect = new Rectangle(0, 0, 920, 538);
						
			stage.addEventListener(KeyboardEvent.KEY_DOWN,game.keyDownEvent);
			addChildAt(game, 0);
		}		
	}
}
		