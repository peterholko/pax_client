﻿package
{
	import fl.controls.Button;
	import fl.controls.TextInput;
	import flash.display.MovieClip;
	import flash.events.MouseEvent;	
	import flash.text.TextField;
	import flash.utils.getTimer;
	import flash.utils.Timer;
	import flash.events.Event;
	import flash.geom.Rectangle;
	import flash.events.KeyboardEvent;
	import flash.system.Security;
	import fl.text.TLFTextField;	
	
	import net.Connection;
	import game.Game;
	
	import ui.MainUI;
	import ui.CityUI;
	import ui.MoveReticule;
	import ui.AttackReticule;
	import ui.BattleUI;

	import ui.BuildSelector;
	
	public class Main extends MovieClip
	{
		public static var DEBUG:Boolean = true;
		public static var VERSION:String = "0.029";
		public static var STATUS_WAITING:int = 0;
		public static var STATUS_LOADING:int = 1;
		public static var STATUS_CONNECTING:int = 2;
		public static var STATUS_PLAYING:int = 3;
		
		//Stage objects
		
		public var mainUI:MainUI;
		public var cityUI:CityUI;
		public var battleUI:BattleUI;	
		public var buildSelector:BuildSelector;
		
		public var loginScreen:LoginScreen;
		public var loginErrorText:TLFTextField;
		
		public var moveReticule:MoveReticule;
		public var attackReticule:AttackReticule;		
		
		private var account:String;
		private var password:String;		
		
		private var connection:Connection;
				
		private var connectionMsg:String = "";
		private var clientStatus:int = STATUS_LOADING;
		
		public function Main() : void
		{
			Security.allowDomain("*");
			this.gotoAndStop("Login");
		}
		
		public function setupLoginFrame() : void
		{
			loginScreen.loginButton.addEventListener(MouseEvent.CLICK, loginHandler);			
			
			clientStatus = STATUS_WAITING;
		}
		
		public function setupGameFrame() : void
		{
			mainUI.init(this);
			cityUI.init();		
			battleUI.init();
			buildSelector.init();
									
			Game.INSTANCE.main = this;
			Game.INSTANCE.setLastLoopTime(connection.clockSyncStartTime);
			Game.INSTANCE.player.id = connection.playerId;			
		}
						
		private function loginHandler(event:MouseEvent) : void
		{
			if(clientStatus == STATUS_WAITING)
			{
				clientStatus = STATUS_CONNECTING;
				account = loginScreen.accountTextInput.text;
				password = loginScreen.passwordTextInput.text;
				loginScreen.loginButton.enabled = false;
			
				connection = Connection.INSTANCE;
				connection.initialize();
				connection.addEventListener(Connection.onConnectEvent, connectionComplete);
				connection.addEventListener(Connection.onIOErrorEvent, connectionIOError);
				connection.addEventListener(Connection.onSecurityErrorEvent, connectionSecurityError);
				connection.addEventListener(Connection.onCloseEvent, connectionCloseError);
				connection.addEventListener(Connection.onLoggedInEvent, connectionLoggedIn);
				connection.addEventListener(Connection.onClockSyncEvent, connectionClockSync);
				connection.addEventListener(Connection.onBadEvent, connectionBadEvent);
			
				connection.connect();
			}
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
		
		private function connectionBadEvent(e:Event) : void
		{
			connectionError("Bad Login");
		}
		
		private function connectionError(msg:String) : void
		{
			/*connection.removeEventListener(Connection.onConnectEvent, connectionComplete);
			connection.removeEventListener(Connection.onIOErrorEvent, connectionIOError);
			connection.removeEventListener(Connection.onSecurityErrorEvent, connectionSecurityError);
			connection.removeEventListener(Connection.onCloseEvent, connectionCloseError);
			connection.removeEventListener(Connection.onClockSyncEvent, connectionClockSync);*/
			
			clientStatus = STATUS_WAITING;			
			loginScreen.passwordTextInput.text = "";
			loginScreen.loginButton.enabled = true;		
			loginErrorText.text = msg;
			
			
			this.gotoAndStop("Login");
		}
		
		private function connectionLoggedIn(e:Event) : void
		{
			gotoAndStop("Game");
		}
				
		private function connectionClockSync(e:Event) : void
		{
			connection.doClientReady();
			Game.INSTANCE.startLoop();
			Game.INSTANCE.x = 0;
			Game.INSTANCE.y = 0;
			Game.INSTANCE.scrollRect = new Rectangle(0, 0, 920, 538);
						
			stage.addEventListener(KeyboardEvent.KEY_DOWN, Game.INSTANCE.keyDownEvent);
			stage.addEventListener(MouseEvent.CLICK, Game.INSTANCE.stageClick);
			addChildAt(Game.INSTANCE, 0);
		}		
	}
}
		