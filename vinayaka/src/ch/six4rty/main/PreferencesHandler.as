package ch.six4rty.main
{
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.filesystem.File;
	import flash.net.SharedObject;
	
	import mx.core.FlexGlobals;

	/**
	 * 
	 * @author Tiago
	 * 
	 */	
	public final class PreferencesHandler
	{
		private static var instance			:PreferencesHandler				= new PreferencesHandler();
		
		private var _type					:String;
		private var _sharedObject			:SharedObject;
		private var _fileReferenceHandler	:File;
		
		private var _sdkLocation			:String;
		
		public function PreferencesHandler()
		{
			if ( instance ) throw new Error( "Singleton can be only accessed through getInstance(); method" );
			
			_fileReferenceHandler			= new File();
			_sharedObject 					= SharedObject.getLocal( "vinayaka" );
		}
		
		/**
		 * 
		 * @return 
		 * 
		 */		
		public static function getInstance():PreferencesHandler
		{
			return instance;
		}
		
		public function initSO():void
		{
			FlexGlobals.topLevelApplication.sdkLoc.text = _sharedObject.data.sdkLoc;
			FlexGlobals.topLevelApplication.sysFontLoc.text = _sharedObject.data.fontLoc;
		}
		
		/**
		 * 
		 * @param evt
		 * 
		 */		
		public function prefSDKLocation( evt:MouseEvent = null ):void
		{
			_type							= "sdk";
			_fileReferenceHandler.addEventListener( Event.SELECT, onFolderSelect );
			_fileReferenceHandler.browseForDirectory( "Please select your Flex SDK's Location" );
		}
		
		/**
		 * 
		 * @param evt
		 * 
		 */		
		public function prefSysFontLocation( evt:MouseEvent = null ):void
		{
			_type							= "font";
			_fileReferenceHandler.addEventListener( Event.SELECT, onFolderSelect );
			_fileReferenceHandler.browseForDirectory( " Please select your System Font Folder" );
		}
		
		protected function onFolderSelect( evt:Event ):void
		{
			if ( _type == "sdk" )
			{
				FlexGlobals.topLevelApplication.sdkLoc.text = evt.target.nativePath;
				_sharedObject.data.sdkLoc = evt.target.nativePath;
				
				_sdkLocation = evt.target.nativePath;
			}
			else
			{
				FlexGlobals.topLevelApplication.sysFontLoc.text = evt.target.nativePath;
				_sharedObject.data.fontLoc = evt.target.nativePath;
			}
			
			_sharedObject.flush();
		}

		public function get sdkLocation():String
		{
			return _sdkLocation;
		}

		public function set sdkLocation(value:String):void
		{
			_sdkLocation = value;
		}

		
	}
}