package ch.six4rty.main
{
	import flash.desktop.NativeProcess;
	import flash.desktop.NativeProcessStartupInfo;
	import flash.events.Event;
	import flash.events.ProgressEvent;
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
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
		
		private var _selectedOutput			:String;
		private var _asCode					:String;
		
		private var _commandPrompt			:String 					= "C:\\WINDOWS\\system32\\cmd.exe";
		private var _process				:NativeProcess;
		private var _NPInfo					:NativeProcessStartupInfo;
			
		/**
		 * 
		 * 
		 */		
		public function VinayakaCore():void
		{
			if ( instance ) throw new Error( "Singleton can be only accessed through getInstance(); method" );
		}
		
		/**
		 * 
		 * @return 
		 * 
		 */		
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
			createASTemplate();
		}		
		
		private function createASTemplate():void
		{
			_asCode			= "package\n{\nimport flash.display.Sprite;\nimport flash.text.Font;\n\npublic class Vinayaka extends Sprite\n{\n";
			
			/*for each ( var item:* in _selectedFonts )
			{
				_asCode += '[Embed(source="' + StringUtils.ReplaceBackslash( item.nativePath ) + '", fontFamily="' + fontName + '", embedAsCFF="' + true + '", mimeType="application/x-font-truetype", unicodeRange="' + _selectedChars + '")]\n';
				_asCode += "private var " + StringUtils.StripSpaces(fontName) + ":Class;\n";
			}
			
			_asCode += 'public function Vinayaka()\n{\n';
			
			for each ( var itemFont:* in _selectedFonts )
			{
				_asCode += 'Font.registerFont(' +  StringUtils.StripSpaces(fontName) + ');\n';
			}
			
			_asCode += '\n}\n}\n};';*/
			
			MonsterDebugger.trace(this, _asCode );
			
			if ( _selectedOutput == "as3" )
			{
				saveASFile();
			}
			else
			{
				saveTempFile();
			}
		}
		
		private function saveTempFile():void
		{
			var file:File = File.desktopDirectory.resolvePath( "Vinayaka.as" );
			var fileStream:FileStream = new FileStream();
			
			fileStream.openAsync( file, FileMode.WRITE );
			fileStream.writeUTFBytes( _asCode );
			fileStream.addEventListener( Event.CLOSE, launchCompiler );
			fileStream.close();
		}
		
		protected final function saveASFile():void
		{
			//TO BE DONE
		}
		
		protected final function launchCompiler( e:Event ):void
		{
			MonsterDebugger.trace(this, "Launch Compiler" );
			
			var compFile:File = new File( _preferences.sdkLocation );
			
			_process 	= new NativeProcess();
			_NPInfo 	= new NativeProcessStartupInfo();
			_NPInfo.executable = new File( _commandPrompt );
			_process.start(_NPInfo);
			
			var compileCommand:String = 'mxmlc ' + File.desktopDirectory.resolvePath( "vinayaka.as" ).nativePath + " -output " + File.desktopDirectory.nativePath + "\\vinayaka.swf";
			// Wait for the response
			_process.addEventListener(ProgressEvent.STANDARD_OUTPUT_DATA, onOutputData);
			_process.standardInput.writeUTFBytes(compileCommand + "\n");
			
		}
		
		protected function onOutputData(event:ProgressEvent):void
		{
			var op:String = _process.standardOutput.readUTFBytes(_process.standardOutput.bytesAvailable);
			// This is just some simple checking to find if the compilation is done. 
			MonsterDebugger.trace(this, op );
			if(op.match("Byte")||op.match("Bytes"))
			{
				MonsterDebugger.trace(this, "DONE" );
				FlexGlobals.topLevelApplication.currentState = "DefaultState";
			}
			
		}
		
		
		private function createSWFFile():void
		{
			// TODO Auto Generated method stub
		}
		
		private function createASFile():void
		{
			
		}
		
		private function createSWCFile():void
		{
			
		}
		
	}
}