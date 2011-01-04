package ch.six4rty.main
{
	import ch.six4rty.utils.StringUtils;
	import ch.six4rty.vo.FontObject;
	import ch.six4rty.vo.UnicodeObject;
	
	import flash.desktop.NativeProcess;
	import flash.desktop.NativeProcessStartupInfo;
	import flash.events.Event;
	import flash.events.ProgressEvent;
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	import flash.net.FileReference;
	import flash.net.SharedObject;
	
	import mx.core.FlexGlobals;
	
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
		private var _asCode					:String;
		
		private var _commandPrompt			:String 					= "C:\\WINDOWS\\system32\\cmd.exe";
		private var _process				:NativeProcess;
		private var _NPInfo					:NativeProcessStartupInfo;
			
		
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
		public function GenerateFontFile( str:String ):void
		{
			
			
			_selectedOutput = str;
			var tempArray:Array = _appSettings.unicodeTable.filter( selectedOnly );
			for each ( var item:UnicodeObject in tempArray )
			{
				_selectedChars += item.unicodeData + ", ";
			}
			
			if ( FlexGlobals.topLevelApplication.ConvertedText.text != "" )
			{
				StringUtils.RemoveLastSeparator( _selectedChars );
				_selectedChars += FlexGlobals.topLevelApplication.ConvertedText.text;
			}
			FlexGlobals.topLevelApplication.showProgressPanel();
			FlexGlobals.topLevelApplication._progressPopUp.updatePanel(20);
			
			createASTemplate();
		}		
		
		protected function selectedOnly(item:UnicodeObject, idx:uint, arr:Array):Boolean 
		{
			return item.unicodeSelected
		}
		
		private function createASTemplate():void
		{
			FlexGlobals.topLevelApplication._progressPopUp.updatePanel(40);
			
			_asCode			= "package\n{\nimport flash.display.Sprite;\nimport flash.text.Font;\n\npublic class Vinayaka extends Sprite\n{\n";
			
			for each ( var item:FontObject in _appSettings.fontArray )
			{
				MonsterDebugger.trace(this, item, 0xff0000 );
				_asCode += '[Embed(source="' + StringUtils.ReplaceBackslash( item.fontNativePath ) + '", fontFamily="' + item.fontName + '", embedAsCFF="true", mimeType="application/x-font-truetype", unicodeRange="' +  _selectedChars  + '")]\n';
				_asCode += "private var " + StringUtils.StripSpaces(item.fontName) + ":Class;\n";
			}
			
			_asCode += 'public function Vinayaka()\n{\n';
			
			for each ( var itemFont:FontObject in _appSettings.fontArray )
			{
				_asCode += 'Font.registerFont(' +  StringUtils.StripSpaces(itemFont.fontName) + ');\n';
			}
			
			_asCode += '\n}\n}\n};';
			
			MonsterDebugger.trace(this, _asCode );
			
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
		
		protected final function launchCompiler( e:Event ):void
		{
			FlexGlobals.topLevelApplication._progressPopUp.updatePanel(80);
			
			MonsterDebugger.trace(this, "Launch Compiler" );
			
			var compFile:File = new File( _preferences.sdkLocation );
			
			_process 	= new NativeProcess();
			_NPInfo 	= new NativeProcessStartupInfo();
			_NPInfo.executable = new File( _commandPrompt );
			_process.start(_NPInfo);
			
			if ( _selectedOutput == "swf" )
			{
				var compileCommand:String = 'mxmlc ' + File.desktopDirectory.resolvePath( "Vinayaka.as" ).nativePath + " -output " + File.desktopDirectory.nativePath + "\\vinayaka.swf";
			}
			else
			{
				MonsterDebugger.trace(this, "create SWC" );
			}
			
			
			_process.addEventListener(ProgressEvent.STANDARD_OUTPUT_DATA, onOutputData);
			_process.standardInput.writeUTFBytes(compileCommand + "\n");
			
		}
		
		protected final function onOutputData(event:ProgressEvent):void
		{
			var op:String = _process.standardOutput.readUTFBytes(_process.standardOutput.bytesAvailable);
			
			// This is just some simple checking to find if the compilation is done. 
			MonsterDebugger.trace(this, op );
			if(op.match("Byte")||op.match("Bytes"))
			{
				FlexGlobals.topLevelApplication._progressPopUp.updatePanel(100);
				
				MonsterDebugger.trace(this, "DONE" );
				FlexGlobals.topLevelApplication.currentState = "DefaultState";
			}
			
		}
		
		private function createASFile():void
		{
			var file:FileReference = new FileReference();
			file.save( _asCode, "Vinayaka_output.as" );
		}		
	}
}