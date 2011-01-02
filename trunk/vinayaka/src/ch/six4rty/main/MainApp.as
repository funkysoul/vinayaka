package ch.six4rty.main
{
	import ch.six4rty.utils.StatusBarUpdater;
	
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.NativeDragEvent;
	
	import mx.collections.ArrayCollection;
	import mx.controls.ToolTip;
	import mx.core.FlexGlobals;
	import mx.core.IToolTip;
	import mx.managers.ToolTipManager;

	public class MainApp
	{
		[Bindable]
		public var appSettings				:ApplicationSettings		= ApplicationSettings.getInstance();
		
		[Bindable]
		public var coreClasses				:VinayakaCore				= VinayakaCore.getInstance();
				
		[Bindable]
		public var userSettings				:UserSettings				= UserSettings.getInstance();
		
		[Bindable] 
		public var dragHandler				:DragHandler				= DragHandler.getInstance();
		
		public var prefHandler				:PreferencesHandler			= PreferencesHandler.getInstance();
		public var stateHandler				:StateHandler				= StateHandler.getInstance();
		
		private var _statusBar				:StatusBarUpdater			= new StatusBarUpdater();
		private var tt						:IToolTip;
		
		
		public function MainApp()
		{
			
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