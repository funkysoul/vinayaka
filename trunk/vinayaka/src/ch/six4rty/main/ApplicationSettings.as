package ch.six4rty.main
{
	import com.greensock.events.LoaderEvent;
	import com.greensock.loading.LoaderMax;
	import com.greensock.loading.XMLLoader;
	
	import flash.display.Loader;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.FileListEvent;
	import flash.filesystem.File;
	import flash.net.FileFilter;
	import flash.net.URLRequest;
	import flash.net.URLStream;
	
	import mx.collections.ArrayCollection;
	
	import nl.demonsters.debugger.MonsterDebugger;
	
	import org.sepy.fontreader.TFontCollection;

	public final class ApplicationSettings extends EventDispatcher
	{
		private static var instance				:ApplicationSettings		= new ApplicationSettings();
		
		private var _unicodeTable				:XML;
		private var _wordList					:XML;
		
		private var _unicodeAC					:ArrayCollection;
		private var _queue						:LoaderMax;
		
		private var _fileFilter					:FileFilter 				= new FileFilter( "Fonts", "*.ttf" );
		private var _fileType					:String;
		private var _file						:File						= new File();
		
		private var _fontCollection				:ArrayCollection			= new ArrayCollection();
		
		private var _tFont						:TFontCollection;
		private var _urlStream					:URLStream;
		private var _urlRequest					:URLRequest;
		private var _tempArray					:Array						= new Array();
		
		public function ApplicationSettings()
		{
			if ( instance ) throw new Error( "Singleton can be only accessed through getInstance(); method" );
		}
		
		public static function getInstance():ApplicationSettings
		{
			return instance;
		}
		
		public function initApplication():void
		{
			_queue		= new LoaderMax( { name:"queue", onProgress:progressHandler, onComplete:completeHandler, onError:errorHandler } );
			
			_queue.append( new XMLLoader( "_xml/unicodeTable.xml", {name:"unicodeTable" } ) );
			_queue.append( new XMLLoader( "_xml/wordList.xml", {name:"wordList" } ) );
			
			_queue.load();
		}
		
		protected function progressHandler( evt:LoaderEvent ):void
		{
			MonsterDebugger.trace(this, "Progress: " + evt.target.progress );
		}
		
		protected function completeHandler( evt:LoaderEvent ):void
		{
			_unicodeTable 	 = LoaderMax.getContent( "unicodeTable" );
			_wordList		 = LoaderMax.getContent( "wordList" );
			
			_unicodeAC		 = new ArrayCollection();
			
			dispatchEvent( new Event ( Event.COMPLETE, false, true ) );
		}
		
		protected function errorHandler( evt:LoaderEvent ):void
		{
			MonsterDebugger.trace(this, "Error Loading: " + evt.target + " - " + evt.text );
		}
		
		public function chooseSingleFile():void
		{
			_fileType = "singleFile";
			_file.addEventListener( Event.SELECT, onFontSelect );
			_file.browse( [_fileFilter] );
		}
		
		public function chooseFontFolder():void
		{
			_fileType = "folder";
			_file.addEventListener( Event.SELECT, onFontSelect );
			_file.browseForDirectory( "Select a folder containing Fonts" );
		}
		
		protected function onFontSelect(event:Event):void
		{
			_file.removeEventListener( Event.SELECT, onFontSelect );
			
			if ( _fileType == "singleFile" )
			{
				_fontCollection.addItem( event.target.url );
				handleFont( event.target.url );
			}
			else
			{
				var file:File = new File( event.target.nativePath );
				file.getDirectoryListingAsync();
				file.addEventListener(FileListEvent.DIRECTORY_LISTING, handleListing);
			}
		}
		
		protected function handleFont( url:String ):void
		{
			_urlStream = new URLStream();
			_urlStream.addEventListener(Event.COMPLETE, onFontLoaded);
			_urlRequest = new URLRequest( url );
			_urlStream.load( _urlRequest );
		}
		
		public function get unicodeTable():ArrayCollection
		{
			for each ( var item:XML in _unicodeTable.item )
			{
				_unicodeAC.addItem( item );
			}
			
			return _unicodeAC;
		}

		public function get wordList():XML
		{
			return _wordList;
		}

		public function get fontCollection():ArrayCollection
		{
			return _fontCollection;
		}
		
		protected function handleListing(event:FileListEvent):void
		{			
			_urlStream = new URLStream();
			//_urlStream.addEventListener(Event.COMPLETE, onFontLoaded);
			
			for each ( var item:File in event.files )
			{
				_fontCollection.addItem( {url:item.url, fileObject:item} );
				
				/*_urlRequest = new URLRequest( item.url );
				_urlStream.load( _urlRequest );*/
			}
			
			_fontCollection.source.forEach( onFontLoaded, null );
		}
		
		protected function onFontLoaded( item:*, index:int, array:Array):void
		{
			//MonsterDebugger.trace(this, item );
			_tFont = TFontCollection.create( URLStream( item.url ), item.url );
			_tempArray.push(_tFont);
			MonsterDebugger.trace(this, _tempArray );
		}
	}
}