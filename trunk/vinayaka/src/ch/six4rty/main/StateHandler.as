package ch.six4rty.main
{
	import flash.events.MouseEvent;
	
	import mx.core.FlexGlobals;
	
	import nl.demonsters.debugger.MonsterDebugger;

	public final class StateHandler
	{
		private static var instance			:StateHandler		= new StateHandler();
		private var _prefHandler			:PreferencesHandler = PreferencesHandler.getInstance();
		
		/**
		 * 
		 * 
		 */		
		public function StateHandler()
		{
			if ( instance ) throw new Error( "Singleton can be only accessed through getInstance(); method" );
		}
		
		/**
		 * 
		 * @return 
		 * 
		 */		
		public static function getInstance():StateHandler
		{
			return instance;
		}
		
		/**
		 * 
		 * @param evt
		 * 
		 */		
		public function stateChange( evt:MouseEvent ):void
		{			
			switch ( evt.currentTarget.id )
			{
				case "btnSelectFont":
					FlexGlobals.topLevelApplication.currentState = "DefaultState";
					break;
				case "btnSelectUnicode":
					FlexGlobals.topLevelApplication.currentState = "State_Unicode";
					break;
				case "btnSelectExtraChars":
					FlexGlobals.topLevelApplication.currentState = "State_ExtraChars";
					break;
				case "btnSelectGenerate":
					FlexGlobals.topLevelApplication.currentState = "State_Generation";
					break;
				case "btnSelectPrefs":
					FlexGlobals.topLevelApplication.currentState = "State_Preferences";
					_prefHandler.initSO();
					break;
			}
		}
	}
}