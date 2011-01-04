package ch.six4rty.main
{
	import ch.six4rty.vo.FontObject;
	import ch.six4rty.vo.UnicodeObject;
	
	import com.greensock.events.LoaderEvent;
	import com.greensock.loading.DataLoader;
	import com.greensock.loading.LoaderMax;
	import com.greensock.loading.XMLLoader;
	
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.FileListEvent;
	import flash.filesystem.File;
	import flash.net.FileFilter;
	
	import mx.collections.ArrayCollection;
	import mx.core.FlexGlobals;
	import mx.events.CollectionEvent;
	import mx.utils.ObjectUtil;
	
	import nl.demonsters.debugger.MonsterDebugger;
	
	import org.sepy.fontreader.TFont;
	import org.sepy.fontreader.TFontCollection;
	import org.sepy.fontreader.table.ID;
	
	import spark.events.IndexChangeEvent;

	public class ApplicationSettings extends EventDispatcher
	{
		private static var instance				:ApplicationSettings		= new ApplicationSettings();
		
		private var _unicodeTable				:XML;
		
		private var _wordList					:XML;
		
		private var _unicodeArray				:Array;
		private var _queue						:LoaderMax;
		
		private var _fileFilter					:FileFilter 				= new FileFilter( "Fonts", "*.ttf" );
		private var _fileType					:String;
		private var _file						:File						= new File();
		
		private var _fontCollection				:ArrayCollection			= new ArrayCollection();
		
		private var _tFont						:TFontCollection;
		private var _fontQueue					:LoaderMax;
		private var _fontArray					:Array						= new Array();
		
		public function ApplicationSettings()
		{
			if ( instance ) throw new Error( "Singleton can be only accessed through getInstance(); method" );
		}
		
		/**
		 * 
		 * @return 
		 * 
		 */		
		public static function getInstance():ApplicationSettings
		{
			return instance;
		}
		
		public function initApplication():void
		{
			_fontQueue	= new LoaderMax( { name:"fontqeue", onComplete:fontsLoaded } );
			_queue		= new LoaderMax( { name:"queue", onProgress:progressHandler, onComplete:completeHandler, onError:errorHandler } );
			
			_queue.append( new XMLLoader( "_xml/SimpleUnicodeTable.xml", {name:"unicodeTable" } ) );
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
			
			_unicodeArray	 = new Array();
			
			
			
			dispatchEvent( new Event ( Event.COMPLETE, false, true ) );
			
			//FlexGlobals.topLevelApplication.unicodeAC.dispatchEvent( new CollectionEvent( CollectionEvent.COLLECTION_CHANGE ) );
		}
		
		protected function errorHandler( evt:LoaderEvent ):void
		{
			MonsterDebugger.trace(this, "Error Loading: " + evt.target + " - " + evt.text );
		}
		
		/**
		 * 
		 * 
		 */		
		public function chooseSingleFile():void
		{
			_fileType = "singleFile";
			_file.addEventListener( Event.SELECT, onFontSelect );
			_file.browse( [_fileFilter] );
		}
		
		/**
		 * 
		 * 
		 */		
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
				_fontCollection.addItem( {url:event.target.url, fileObject:event.target, name:"loading..."} );
				_fontQueue.append( new DataLoader( event.target.url, { name:event.target.url, format:"binary", estimatedBytes:File(event.target).size } ) );
				_fontQueue.load( true );
			}
			else
			{
				var file:File = new File( event.target.nativePath );
				file.getDirectoryListingAsync();
				file.addEventListener(FileListEvent.DIRECTORY_LISTING, handleListing);
			}
		}
		
		/**
		 * 
		 * @return 
		 * 
		 */		

		public function get unicodeTable():Array
		{
			for each ( var item:XML in _unicodeTable.item )
			{
				var unicodeObj:UnicodeObject = new UnicodeObject( item.label, item.data, false );
				_unicodeArray.push( unicodeObj );
			}
			
			MonsterDebugger.trace(this, _unicodeArray );
			
			return _unicodeArray;
		}

		/**
		 * 
		 * @return 
		 * 
		 */		
		public function get wordList():XML
		{
			return _wordList;
		}

		/**
		 * 
		 * @return 
		 * 
		 */		
		public function get fontCollection():ArrayCollection
		{
			return _fontCollection;
		}
		
		protected function handleListing(event:FileListEvent):void
		{			
			for each ( var item:File in event.files )
			{
				_fontCollection.addItem( {url:item.url, fileObject:item, name:"loading..."} );
				_fontQueue.append( new DataLoader( item.url, { name:item.url, format:"binary", estimatedBytes:item.size } ) );
			}
			_fontQueue.load( true );
		}
		
		protected function fontsLoaded( event:LoaderEvent ):void
		{
			
			var i:int = 0;
			
			for each ( var item:* in event.target.content )
			{
				var _tFont:TFontCollection = TFontCollection.create( LoaderMax.getContent( _fontCollection.getItemAt(i).url ), _fontCollection.getItemAt(i).url ) ;
				
				var font:TFont = _tFont.getFont(_tFont.getFontCount() - 1);
				var name:String = font.getNameTable().getRecordString(ID.nameFullFontName);
				var style:String = font.getNameTable().getRecordString( ID.nameFontSubfamilyName );
				
				MonsterDebugger.trace(this, _fontCollection.getItemAt(i), 0x00ff00 );
				
				var fontVO:FontObject = new FontObject( name, _fontCollection.getItemAt(i).url, _fontCollection.getItemAt(i).fileObject.nativePath, style );
				_fontArray.push( fontVO );
				
				_fontCollection[i].name = name;
				_fontCollection.refresh();
				
				i++;
			}
		}
		
		public function get fontArray():Array
		{
			return _fontArray;
		}

		
	}
}