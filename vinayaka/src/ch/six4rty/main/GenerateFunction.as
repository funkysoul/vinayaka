
import ch.six4rty.utils.StringUtils;

import flash.desktop.NativeProcess;
import flash.desktop.NativeProcessStartupInfo;
import flash.events.Event;
import flash.events.MouseEvent;
import flash.events.NativeProcessExitEvent;
import flash.events.ProgressEvent;
import flash.filesystem.File;
import flash.filesystem.FileMode;
import flash.filesystem.FileStream;
import flash.net.SharedObject;
import flash.net.URLRequest;
import flash.net.URLStream;
import flash.utils.ByteArray;

import mx.core.FlexGlobals;
import mx.core.Window;

import nl.demonsters.debugger.MonsterDebugger;

import org.sepy.fontreader.TFont;
import org.sepy.fontreader.TFontCollection;
import org.sepy.fontreader.table.ID;

private var _selectedFonts				:Array;
private var _selectedChars				:String;

private var _urlStream					:URLStream;
private var _urlRequest					:URLRequest;
private var _tFont						:TFontCollection;
private var _collection					:Array				= new Array();

private var _asCode						:String;
private var _commandPrompt				:String = "C:\\WINDOWS\\system32\\cmd.exe";
private var _process					:NativeProcess;
private var _NPInfo						:NativeProcessStartupInfo;
private var _processBuffer				:ByteArray = new ByteArray();


private function generateASTemplate( e:MouseEvent = null ):void
{
	MonsterDebugger.trace(this, "Generate AS Template" );
	changeProgressMessage( "Collecting Data", 10 );
	
	_selectedFonts = _fontList.toArray();
	_selectedChars = _unicodeList[ charset.selectedIndex ].data.toString();
	
	if ( extraChars.text != null || extraChars.text != "" )
	{
		_selectedChars = _selectedChars /*+ ", " + extraChars.text*/;
	}
	
	MonsterDebugger.trace(this, _selectedFonts );
	MonsterDebugger.trace(this, _selectedChars );
	
	_asCode			= "package\n{\nimport flash.display.Sprite;\nimport flash.text.Font;\n\npublic class Vinayaka extends Sprite\n{\n";
	
	collectData();
}

private function collectData():void
{
	MonsterDebugger.trace(this, "Collect Data" );
	changeProgressMessage( "Using some Dragon Fire", 30 );
	
	_urlStream = new URLStream();
	_urlStream.addEventListener(Event.COMPLETE, onFontLoaded);
	
	for each ( var itemF:* in _selectedFonts )
	{
		_urlRequest = new URLRequest( itemF.url );
		_urlStream.load( _urlRequest );
	}
	
}

private function onFontLoaded( e:Event ):void
{
	MonsterDebugger.trace(this, "READ FONT SEPY" );
	changeProgressMessage( "Thanks SEPY", 50 );
	
	//_tFont				= TFontCollection.create( URLStream( e.target ), _urlRequest.url.toString() );
	
	var font:TFont = _tFont.getFont(_tFont.getFontCount() - 1);
	var name:String = font.getNameTable().getRecordString(ID.nameFullFontName);
	
	generateAS( name );
}

protected final function generateAS( fontName:String ):void
{
	MonsterDebugger.trace(this, "Generate AS Code" );
	changeProgressMessage( "Thanks SEPY", 60 );
	for each ( var item:* in _selectedFonts )
	{
		_asCode += '[Embed(source="' + StringUtils.ReplaceBackslash( item.nativePath ) + '", fontFamily="' + fontName + '", embedAsCFF="' + /*flex4sdk.selected*/true + '", mimeType="application/x-font-truetype", unicodeRange="' + _selectedChars + '")]\n';
		_asCode += "private var " + StringUtils.StripSpaces(fontName) + ":Class;\n";
	}
	
	_asCode += 'public function SharkTail()\n{\n';
	
	for each ( var itemFont:* in _selectedFonts )
	{
		_asCode += 'Font.registerFont(' +  StringUtils.StripSpaces(fontName) + ');\n';
	}
	
	_asCode += '\n}\n}\n};';
	
	MonsterDebugger.trace(this, _asCode );
	
	saveTempFile();
}

protected final function saveTempFile():void
{
	MonsterDebugger.trace(this, "SaveTempFile" );
	changeProgressMessage( "Getting out the Dwarfs", 70 );
	
	var file:File = File.desktopDirectory.resolvePath( "Vinayaka.as" );
	var fileStream:FileStream = new FileStream();
	fileStream.openAsync( file, FileMode.WRITE );
	fileStream.writeUTFBytes( _asCode );
	fileStream.addEventListener( Event.CLOSE, fileSaved );
	fileStream.close();
}

private function fileSaved( e:Event ):void
{
	MonsterDebugger.trace(this, "File has been saved" );
	//Launch MXMLC Compiler
	launchCompiler();
}


protected final function launchCompiler():void
{
	MonsterDebugger.trace(this, "Launch Compiler" );
	changeProgressMessage( "Witch is getting all her Power", 90 );

	_sharedObject = SharedObject.getLocal( "sharktail" );
	var compFile:File = new File( _sharedObject.data.sdkLoc );
	
	
	_process 	= new NativeProcess();
	_NPInfo 	= new NativeProcessStartupInfo();
	_NPInfo.executable = new File(_commandPrompt);
	_process.start(_NPInfo);
	
	var compileCommand:String = 'mxmlc ' + File.desktopDirectory.resolvePath( "vinayaka.as" ).nativePath + " -output " + File.desktopDirectory.nativePath + "\\vinayaka.swf";
	// Wait for the response
	_process.addEventListener(ProgressEvent.STANDARD_OUTPUT_DATA, onOutputData);
	_process.standardInput.writeUTFBytes(compileCommand + "\n");
		
}

protected final function allDone():void
{
	changeProgressMessage( "The Magic is Done, have a look at yourself", 100 );
}

private function changeProgressMessage( str:String, val:Number ):void
{
	progBar.label = str;
	progBar.setProgress( val, 100 );
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

