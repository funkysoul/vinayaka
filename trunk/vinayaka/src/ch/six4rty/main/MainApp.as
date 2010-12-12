package ch.six4rty.main
{
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
		public var prefHandler				:PreferencesHandler			= PreferencesHandler.getInstance();
		public var stateHandler				:StateHandler				= StateHandler.getInstance();
		
		[Bindable] 
		public var dragHandler				:DragHandler				= DragHandler.getInstance();
		
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
		
		public function generateProduct( str:String ):void
		{
			switch ( str )
			{
				case "as3":
					VinayakaCore.GenerateAS3();
					break;
				case "swc":
					VinayakaCore.GenerateSWC();
					break;
				case "swf":
					VinayakaCore.GenerateSWF();
					break;
			}
		}
	}
}