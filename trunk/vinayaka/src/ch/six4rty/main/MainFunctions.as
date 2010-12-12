
import flash.display.NativeWindow;
import flash.display.NativeWindowInitOptions;
import flash.display.NativeWindowSystemChrome;
import flash.display.NativeWindowType;
import flash.display.Screen;
import flash.events.Event;
import flash.events.FileListEvent;
import flash.events.KeyboardEvent;
import flash.events.MouseEvent;
import flash.filesystem.File;
import flash.net.SharedObject;
import flash.net.URLLoader;
import flash.net.URLRequest;
import flash.net.URLVariables;
import flash.net.navigateToURL;
import flash.ui.Keyboard;

import mx.collections.ArrayCollection;
import mx.controls.Alert;
import mx.core.FlexGlobals;
import mx.core.WindowedApplication;
import mx.events.MenuEvent;

import nl.demonsters.debugger.MonsterDebugger;

import spark.components.WindowedApplication;

[Bindable]
private var _navigationXMLList			:XMLList;

[Bindable]
private var _sysfontList				:ArrayCollection;

[Bindable]
private var _fontList					:ArrayCollection;

[Bindable]
private var _unicodeList				:ArrayCollection;

private static const NAVIGATION_URL	:String		= "_xml/navigation.xml";
private static const UNICODE_TABLE	:String		= "_xml/unicodeTable.xml";


private function init():void
{
	MonsterDebugger.trace(this, "init" );
	this.addEventListener( KeyboardEvent.KEY_DOWN, onKeyDown );
		
	/*var nativeWinOptions:NativeWindowInitOptions = new NativeWindowInitOptions();
	nativeWinOptions.transparent = true;
	nativeWinOptions.systemChrome = NativeWindowSystemChrome.NONE;
	nativeWinOptions.type = NativeWindowType.UTILITY;
	
	var splashScreen:NativeWindow = new NativeWindow( nativeWinOptions );
	splashScreen.stage.align = "topLeft";
	splashScreen.stage.scaleMode = "noScale";
	splashScreen.x = ( Screen.mainScreen.visibleBounds.width - splashScreen.width ) / 2;
	splashScreen.y = ( Screen.mainScreen.visibleBounds.height - splashScreen.height ) / 2;
	
	splashScreen.activate();*/

	_fontList							= new ArrayCollection();
	_unicodeList						= new ArrayCollection();
	loadNavigationXML();
	loadUnicodeTable();
	
}

private function loadNavigationXML():void
{
	var _xmlLoader:URLLoader = new URLLoader();
	_xmlLoader.addEventListener( Event.COMPLETE, navigationXMLLoaded );
	_xmlLoader.load( new URLRequest( NAVIGATION_URL ) );
}

private function loadUnicodeTable():void
{
	MonsterDebugger.trace(this, "load unicode" );
	var _xmlLoader:URLLoader = new URLLoader();
	_xmlLoader.addEventListener( Event.COMPLETE, unicodeTableLoaded );
	_xmlLoader.load( new URLRequest( UNICODE_TABLE ) );
}

private function readSystemFonts():void
{
	_sharedObject = SharedObject.getLocal( "sharktail" );
		
	if ( _sharedObject.data.fontLoc == "" || _sharedObject.data.fontLoc == null )
	{
		this.currentState = "PreferencesState";
	}
	else
	{
		var _file:File = new File( _sharedObject.data.fontLoc );
		_file.getDirectoryListingAsync();
		_file.addEventListener(FileListEvent.DIRECTORY_LISTING, handleListing);
	}
}

protected function navigationXMLLoaded( e:Event ):void
{
	e.target.removeEventListener( Event.COMPLETE, navigationXMLLoaded );
	_navigationXMLList = XML( e.target.data ).menuitem;
	
	readSystemFonts();
}

protected function unicodeTableLoaded( e:Event ):void
{
	MonsterDebugger.trace(this, "unicode loaded" );
	e.target.removeEventListener( Event.COMPLETE, unicodeTableLoaded );
	var _unicodeTableXMLList:XMLList = XML( e.target.data )..item ;
	
	for each ( var item:XML in _unicodeTableXMLList )
	{
		_unicodeList.addItem( item );
	}
	
	MonsterDebugger.trace(this, _unicodeList );
}

protected function handleListing( e:FileListEvent ):void
{
	var _fileList:Array = e.files;
	_sysfontList = new ArrayCollection( _fileList.filter( ttfOnly ) );
}

protected function ttfOnly( item:*, index:int, array:Array ):Boolean
{
	
	return ( item.type == ".ttf" );
}

protected function onKeyDown ( e:KeyboardEvent ):void
{
	if ( e.keyCode == Keyboard.DELETE )
	{
		_fontList.removeItemAt( selectedFonts.selectedIndex );
	}
}

protected function singleFontPanel( e:MouseEvent ):void
{
	MonsterDebugger.trace(this, "display font panel" );
}

protected function naviHandler( e:MenuEvent ):void
{
	MonsterDebugger.trace(this, e.item.@dest );
	switch ( String ( e.item.@dest  ) )
	{
		case "paypal":
			navigateToURL( new URLRequest ( "https://www.paypal.com/cgi-bin/webscr?cmd=_donations&business=tiago%2edias%40bluewin%2ech&lc=CH&item_name=Support%20Vinayaka&item_number=vinayaka&currency_code=USD&bn=PP%2dDonationsBF%3abtn_donateCC_LG%2egif%3aNonHosted" ), "_blank" )
			break;
		case "aboutPanel":
			Alert.show( "This application has been created by Tiago Dias, a Senior Flash Developer working at Publicis Modem Zurich.", "About Vinayaka" );
			break;
		case "settingsPanel":
			FlexGlobals.topLevelApplication.currentState = "PreferencesState";
			break;
		
		case "help":
			navigateToURL( new URLRequest( "http://getsatisfaction.com/six4rty/products/six4rty_vinayaka" ), "_blank" );
	}
}