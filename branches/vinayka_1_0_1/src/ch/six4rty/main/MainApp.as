package ch.six4rty.main
{
	import ch.six4rty.utils.StatusBarUpdater;
	
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.NativeDragEvent;
	
	import mx.collections.ArrayCollection;
	import mx.controls.Alert;
	import mx.controls.ToolTip;
	import mx.core.FlexGlobals;
	import mx.core.IToolTip;
	import mx.managers.ToolTipManager;
	
	import nl.demonsters.debugger.MonsterDebugger;

	public class MainApp
	{
		[Bindable]
		public var appSettings				:ApplicationSettings		= ApplicationSettings.getInstance();
		
		[Bindable]
		public var coreClasses				:VinayakaCore				= VinayakaCore.getInstance();
				
		[Bindable]
		public var userSettings				:UserSettings				= UserSettings.getInstance();
		
		public var prefHandler				:PreferencesHandler			= PreferencesHandler.getInstance();
		public var stateHandler				:StateHandler				= StateHandler.getInstance();
		
		private var _statusBar				:StatusBarUpdater			= new StatusBarUpdater();
		private var tt						:IToolTip;
		
		
		public function MainApp()
		{
			MonsterDebugger.trace(this, prefHandler.sdkLocation );
			if ( prefHandler.sdkLocation == null )
			{
				FlexGlobals.topLevelApplication.currentState = "State_Preferences";
				Alert.show( "Please select the path to your Flex SDK where the bin folder is located", "Edit Settings", Alert.OK );
			}
		}
		
		public function displaytooltip( str:String ):void
		{
			tt = ToolTipManager.createToolTip( str, FlexGlobals.topLevelApplication.mouseX, FlexGlobals.topLevelApplication.mouseY );
			
		}
		
		public function hidetooltip():void
		{
			ToolTipManager.destroyToolTip( tt );
		}
		
		
	}
}