package ch.six4rty.main
{
	import flash.events.EventDispatcher;
	
	import mx.collections.ArrayCollection;
	import mx.core.FlexGlobals;
	
	import nl.demonsters.debugger.MonsterDebugger;

	public final class UserSettings extends EventDispatcher
	{
		private static var instance				:UserSettings		= new UserSettings();
		
		private var _unicodeListAC				:ArrayCollection	= new ArrayCollection(); 
		
		public function UserSettings()
		{
			if ( instance ) throw new Error( "Singleton can be only accessed through getInstance(); method" );
		}
		
		public static function getInstance():UserSettings
		{
			return instance;
		}
		
		
		//UNICODE HANDLING
		public function unicodeHandler():void
		{
			_unicodeListAC.addItem( FlexGlobals.topLevelApplication.charset.selectedItem );
		}

		public function get unicodeListAC():ArrayCollection
		{
			return _unicodeListAC;
		}		
	}
}