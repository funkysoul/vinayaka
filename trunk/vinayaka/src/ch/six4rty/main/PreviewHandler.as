package ch.six4rty.main
{
	import ch.six4rty.utils.StringUtils;
	import ch.six4rty.vo.UnicodeObject;
	
	import flash.desktop.NativeProcess;
	import flash.desktop.NativeProcessStartupInfo;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.ProgressEvent;
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	import flash.text.TextField;
	import flash.text.TextFormat;
	
	import mx.controls.Text;
	import mx.core.FlexGlobals;
	
	import nl.demonsters.debugger.MonsterDebugger;
	
	public class PreviewHandler extends Sprite
	{
		private var _vinayakaCore								:VinayakaCore				= VinayakaCore.getInstance();
		private var _preferences								:PreferencesHandler			= PreferencesHandler.getInstance();
		private var _appSettings								:ApplicationSettings		= ApplicationSettings.getInstance();
		private var _selectedChars								:String						= "";
		private var _selectedSDKVer								:Boolean					= true;
		private var _asCode										:String;
		
		private var _commandPrompt								:String 					= "C:\\WINDOWS\\system32\\cmd.exe";
		private var _macCommandPrompt							:String						= "";
		private var _process									:NativeProcess;
		private var _nativeProcessStartupInfo					:NativeProcessStartupInfo;

		public function PreviewHandler( str:String )
		{
			if ( str == "as3" )
			{
				generateFontFile();
			}
			else
			{
				generateFontFile();
			}
			
		}
		
		protected function generateFontFile():void
		{			
			FlexGlobals.topLevelApplication.updatePreviewProgress( 30 );
			
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
						
			createASTemplate();
		}		
		
		protected function selectedOnly(item:UnicodeObject, idx:uint, arr:Array):Boolean 
		{
			return item.unicodeSelected
		}
		
		private function createASTemplate():void
		{
			
			FlexGlobals.topLevelApplication.updatePreviewProgress( 50 );
			
			_asCode			= "package\n{\n\timport flash.display.Sprite;\n\t;import flash.text.TextFieldAutoSize;\n\timport flash.text.Font;\n\timport flash.text.TextField;\n\timport flash.text.TextFormat;\n\n\tpublic class Vinayaka_preview extends Sprite\n\t{\n";
			
			for each ( var item:Object in _appSettings.fontArray )
			{
				MonsterDebugger.trace(this, item, 0xff0000 );
				_asCode += '\t\t[Embed(source="' + StringUtils.ReplaceBackslash( item.fontNativePath ) + '", fontFamily="' + item.fontName + '", ' +
					'fontStyle="' + item.fontStyle + '", fontWeight="' + item.fontWeight + '", embedAsCFF="'+ _selectedSDKVer +'", mimeType="application/x-font-truetype"' +  selectedChars  + ')]\n';
				_asCode += "\t\tprivate var " + StringUtils.StripSpaces(item.fontName) + ":Class;\n";
			}
			
			_asCode += '\n\t\tpublic function Vinayaka_preview()\n\t\t{\n';
			
			for each ( var itemFont:Object in _appSettings.fontArray )
			{
				_asCode += '\t\t\tFont.registerFont(' +  StringUtils.StripSpaces(itemFont.fontName) + ');\n';
			}
			_asCode += '\t\tcreateTextFields();';
			_asCode += '\n\t\t}\n';
			
			//NEW function 
			_asCode += '\n\tprivate function createTextFields():void\n\t\t{';
			
			for ( var i:int = 0; i< _appSettings.fontArray.length; i++ )
			{
				_asCode += '\t\t\tvar tFormat' + i + ':TextFormat = new TextFormat();\n\t' +
					'tFormat' + i + '.font = "' + _appSettings.fontArray[i].fontName + '";\n\t' +
					'tFormat' + i + '.color = 0x000000;\n\t' +
					'tFormat' + i + '.size = 18;\n\t';
				
				_asCode += '\t\t\tvar tField' + i + ':TextField = new TextField();\n\t' +
					'tField' + i + '.autoSize = TextFieldAutoSize.LEFT;\n\t' + 
					'tField' + i + '.defaultTextFormat = tFormat' + i + ';\n\t' + 
					'tField' + i + '.width = ' + 450 + ';\n\t' + 
					'tField' + i + '.text = "' +_appSettings.fontArray[i].fontName + '";\n\t' +
					'addChild(tField' + i + ');\n\t' +
					'tField' + i + '.y = ' + i * 30 + ';\n\t';
			}
			
			//FINAL
			_asCode += '\n\t}\n}};';
			
			MonsterDebugger.trace(this, _asCode );
			
			saveTempFile();
		}
		
		private function saveTempFile():void
		{			
			FlexGlobals.topLevelApplication.updatePreviewProgress( 70 );
			
			var file:File = File.desktopDirectory.resolvePath( "Vinayaka_preview.as" );
			var fileStream:FileStream = new FileStream();
			
			fileStream.openAsync( file, FileMode.WRITE );
			fileStream.writeUTFBytes( _asCode );
			fileStream.addEventListener( Event.CLOSE, launchCompiler );
			fileStream.close();
		}
		
		private function deleteTempFile():void
		{
			var file:File = File.desktopDirectory.resolvePath( "Vinayaka_preview.as" );
			file.deleteFile();
		}
		
		protected final function launchCompiler( e:Event ):void
		{	
			FlexGlobals.topLevelApplication.updatePreviewProgress( 80 );
			
			MonsterDebugger.trace(this, "Launch Compiler" );
			
			var compFile:File = new File( _preferences.sdkLocation );
			
			_process 	= new NativeProcess();
			_nativeProcessStartupInfo 	= new NativeProcessStartupInfo();
			_nativeProcessStartupInfo.executable = new File( _commandPrompt );
			_process.start(_nativeProcessStartupInfo);
			
			MonsterDebugger.trace(this, _preferences.sdkLocation );
			var compileCommand:String = '"' + _preferences.sdkLocation + "\\bin\\mxmlc" + '" '+ File.desktopDirectory.resolvePath( 'Vinayaka_preview.as' ).nativePath + ' -output ' + File.desktopDirectory.nativePath + '\\Vinayaka_preview.swf -static-link-runtime-shared-libraries=true';
				
			_process.addEventListener(ProgressEvent.STANDARD_OUTPUT_DATA, onOutputData);
			_process.standardInput.writeUTFBytes(compileCommand + "\n");
			
		}
		
		protected final function onOutputData(event:ProgressEvent):void
		{
			var op:String = _process.standardOutput.readUTFBytes(_process.standardOutput.bytesAvailable);
			
			MonsterDebugger.trace(this, op );
			if( op.match( "bytes" ) || op.match( "Bytes" ) || op.match( "Byte" ) )
			{
				FlexGlobals.topLevelApplication.updatePreviewProgress( 100 );
				deleteTempFile();
			}
			
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