package ch.six4rty.main
{
	import ch.six4rty.utils.StringUtils;
	import ch.six4rty.vo.FontObject;
	import ch.six4rty.vo.UnicodeObject;
	
	import flash.desktop.NativeProcess;
	import flash.desktop.NativeProcessStartupInfo;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.ProgressEvent;
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	import flash.net.FileReference;
	import flash.net.SharedObject;
	
	import mx.controls.Alert;
	import mx.core.FlexGlobals;
	import mx.events.CloseEvent;
	
	import nl.demonsters.debugger.MonsterDebugger;

	public final class VinayakaCore 
	{
		private static var instance			:VinayakaCore				= new VinayakaCore();
		
		public const OUTPUT_AS3				:String						= "as3";
		public const OUTPUT_SWC				:String						= "swc";
		public const OUTPUT_SWF				:String						= "swf";
		
		private var _preferences			:PreferencesHandler			= PreferencesHandler.getInstance();
		private var _appSettings			:ApplicationSettings		= ApplicationSettings.getInstance();
		
		private var _selectedOutput			:String;
		private var _selectedChars			:String						= "";
		private var _selectedSDKVer			:Boolean					= true;
		private var _asCode					:String;
		
		private var _commandPrompt			:String 					= "C:\\WINDOWS\\system32\\cmd.exe";
		private var _macCommandPrompt		:String						= "";
		private var _process				:NativeProcess;
		private var _nativeProcessStartupInfo					:NativeProcessStartupInfo;
			
		
		public function VinayakaCore():void
		{
			if ( instance ) throw new Error( "Singleton can be only accessed through getInstance(); method" );
		}
		
		
		public static function getInstance():VinayakaCore
		{
			return instance;
		}
		
		
		/**
		 * 
		 * @param str
		 * 
		 */		
		public function generateFontFile( str:String ):void
		{
			_selectedOutput = str;
			
			if ( FlexGlobals.topLevelApplication.flex3RB.selected || FlexGlobals.topLevelApplication.flex3RBSWF.selected )
			{
				_selectedSDKVer = false;
			}
			else
			{
				_selectedSDKVer = true;
			}
			
			var tempArray:Array = _appSettings.unicodeTable.filter( selectedOnly );
			if ( tempArray.length < 1 )
			{
				_selectedChars = "";
			}
			else
			{
				for each ( var item:UnicodeObject in tempArray )
				{
					_selectedChars += item.unicodeData + ", ";
				}
			}
			
			
			if ( FlexGlobals.topLevelApplication.ConvertedText.text != "" )
			{
				StringUtils.RemoveLastSeparator( _selectedChars );
				_selectedChars += FlexGlobals.topLevelApplication.ConvertedText.text;
			}
			
			if ( _selectedOutput != "as3" )
			{
				FlexGlobals.topLevelApplication.showProgressPanel();
				FlexGlobals.topLevelApplication._progressPopUp.updatePanel(20);
			}
			
			
			createASTemplate();
		}		
		
		protected function selectedOnly(item:UnicodeObject, idx:uint, arr:Array):Boolean 
		{
			return item.unicodeSelected
		}
		
		private function createASTemplate():void
		{
			if ( _selectedOutput != "as3" )
			{
				FlexGlobals.topLevelApplication._progressPopUp.updatePanel(40);
			}
		
			_asCode			= "package\n{\n\timport flash.display.Sprite;\n\timport flash.text.Font;\n\n\tpublic class Vinayaka extends Sprite\n\t{\n";
			
			for each ( var item:Object in _appSettings.fontArray )
			{
				_asCode += '\t\t[Embed(source="' + StringUtils.ReplaceBackslash( item.fontNativePath ) + '", fontFamily="' + item.fontName + '", ' +
					'fontStyle="' + item.fontStyle + '", fontWeight="' + item.fontWeight + '", embedAsCFF="'+ _selectedSDKVer +'", mimeType="application/x-font-truetype"' +  selectedChars  + ')]\n';
				_asCode += "\t\tprivate var " + StringUtils.StripSpaces(item.fontName) + ":Class;\n";
			}
			
			_asCode += '\n\t\tpublic function Vinayaka()\n\t\t{\n';
			
			for each ( var itemFont:Object in _appSettings.fontArray )
			{
				_asCode += '\t\t\tFont.registerFont(' +  StringUtils.StripSpaces(itemFont.fontName) + ');\n';
			}
			
			_asCode += '\n\t\t}\n\t}\n};';
			
			if ( _selectedOutput == "as3" )
			{
				createASFile();
			}
			else
			{
				saveTempFile();
			}
		}
		
		private function saveTempFile():void
		{
			FlexGlobals.topLevelApplication._progressPopUp.updatePanel(60);
			
			var file:File = File.desktopDirectory.resolvePath( "Vinayaka.as" );
			var fileStream:FileStream = new FileStream();
			
			fileStream.openAsync( file, FileMode.WRITE );
			fileStream.writeUTFBytes( _asCode );
			fileStream.addEventListener( Event.CLOSE, launchCompiler );
			fileStream.close();
		}
		
		private function deleteTempFile():void
		{
			var file:File = File.desktopDirectory.resolvePath( "Vinayaka.as" );
			file.deleteFile();
		}
		
		protected final function launchCompiler( e:Event ):void
		{
			FlexGlobals.topLevelApplication._progressPopUp.updatePanel(80);
			
			var compFile:File = new File( _preferences.sdkLocation );
			
			_process 	= new NativeProcess();
			_nativeProcessStartupInfo 	= new NativeProcessStartupInfo();
			_nativeProcessStartupInfo.executable = new File( _commandPrompt );
			_process.start(_nativeProcessStartupInfo);
			
			if ( _selectedOutput == "swf" )
			{
				var compileCommand:String = '"' + _preferences.sdkLocation + "\\bin\\mxmlc" + '" '+ File.desktopDirectory.resolvePath( 'Vinayaka.as' ).nativePath + ' -output ' + File.desktopDirectory.nativePath + '\\Vinayaka.swf -static-link-runtime-shared-libraries=true';
				
			}
			
			else
			{
				// to be done SWC creation
			}
			
			
			_process.addEventListener(ProgressEvent.STANDARD_OUTPUT_DATA, onOutputData);
			_process.standardInput.writeUTFBytes(compileCommand + "\n");
			
		}
		
		protected final function onOutputData(event:ProgressEvent):void
		{
			var op:String = _process.standardOutput.readUTFBytes(_process.standardOutput.bytesAvailable);
			
			if( op.match( "bytes" ) || op.match( "Bytes" ) || op.match( "Byte" ) )
			{
				FlexGlobals.topLevelApplication._progressPopUp.updatePanel( 100 );				
				FlexGlobals.topLevelApplication.currentState = "DefaultState";
				deleteTempFile();
			}
			
		}
		
		private function createASFile():void
		{
			var file:FileReference = new FileReference();
			file.save( _asCode, "Vinayaka_output.as" );
			Alert.show( "Do you want to preview the fonts?", "Display preview?", Alert.YES | Alert.NO, FlexGlobals.topLevelApplication.nativeWindow.stage as Sprite, onAlertClose );
		}	
		
		private function onAlertClose( event:CloseEvent ):void
		{
			switch ( event.detail )
			{
				case Alert.YES:
					createPreviewSWF();
					break;
				case Alert.NO:
					//
					break;
			}
		}
		
		
		private function createPreviewSWF():void
		{
			FlexGlobals.topLevelApplication.displayPreviewWindow();
			var previewHandler:PreviewHandler = new PreviewHandler( "as3" );
			FlexGlobals.topLevelApplication.updatePreviewProgress( 20 );
			
		}
		
		public function get generatedASCode():String
		{
			return _asCode;
		}
		
		public function get selectedChars():String
		{
			if ( _selectedChars == "" )
			{
				return "";
			}
			else
			{
				return ', unicodeRange="' +  _selectedChars  + '"';
			}
		}
		
	}
}