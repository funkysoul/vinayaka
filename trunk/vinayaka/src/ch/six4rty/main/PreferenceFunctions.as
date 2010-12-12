import flash.events.Event;
import flash.events.MouseEvent;
import flash.filesystem.File;
import flash.net.SharedObject;
import flash.text.TextField;

import mx.controls.Alert;
import mx.controls.Text;
import mx.core.FlexGlobals;

import nl.demonsters.debugger.MonsterDebugger;

private var _fileReference			:File			= new File();
private var _type					:String			= "";
private var _sdkEntry				:Boolean		= false;

private var _sharedObject			:SharedObject;

public function initSO():void
{
	_sharedObject = SharedObject.getLocal( "sharktail" );
	sdkLoc.text = _sharedObject.data.sdkLoc;
	sysFontLoc.text = _sharedObject.data.fontLoc;
	
	if ( sdkLoc.text != "" || sdkLoc.text != null )
	{
		_sdkEntry = true;
	}
}

private function prefBrowseSDK( e:MouseEvent ):void
{
	_type							= "sdk";
	_fileReference.addEventListener( Event.SELECT, onSelect );
	_fileReference.browseForDirectory("Select your SDK Directory");
}

private function prefBrowseSysFonts( e:MouseEvent ):void
{
	_type							= "fonts";
	_fileReference.addEventListener( Event.SELECT, onSelect );
	_fileReference.browseForDirectory("Select your Font Directory");
}

protected function onSelect( e:Event ):void
{
	if ( _type == "sdk" )
	{
		sdkLoc.text = e.target.nativePath;
	}
	else
	{
		sysFontLoc.text = e.target.nativePath;
	}
	
}

protected function checkPrefs( e:MouseEvent ):void
{
	( !_sdkEntry ) ? Alert.show( "Dude, choose the mxmlc.exe from your system" ) : closePanel();
	
}

protected function closePanel():void
{
	_sharedObject = SharedObject.getLocal( "sharktail" );
	_sharedObject.data.sdkLoc = sdkLoc.text;
	_sharedObject.data.fontLoc = sysFontLoc.text;
	_sharedObject.flush();
	
	FlexGlobals.topLevelApplication.currentState = "DefaultState";
}

