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
			
			MonsterDebugger.trace(this, "initapp");
			
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

		}
		
		protected function errorHandler( evt:LoaderEvent ):void
		{
			MonsterDebugger.trace(this, "Error Loading: " + evt.target + " - " + evt.text );
		}
		
		/**
		 * Handler responsible for browsing a single font file.
		 * 
		 */		
		public function chooseSingleFile():void
		{
			_fileType = "singleFile";
			_file.addEventListener( Event.SELECT, onFontSelect );
			_file.browse( [_fileFilter] );
		}
		
		/**
		 * Handler responsible for browsing a folder and collect all files in it.
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
				MonsterDebugger.trace(this, event.target.url, 0xff0000 );
				MonsterDebugger.trace(this, event.target, 0xff0000 );
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
		 * Returns the Unicode Array to be used for display aswell for the compilation.
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
			
			return _unicodeArray;
		}

		/**
		 * 
		 * Returns the wordlist (currently not in use)
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
			for ( var i:int = _fontArray.length; i < _fontQueue.content.length; i++ )
			{
				MonsterDebugger.trace(this, LoaderMax.getContent( _fontCollection.getItemAt(i).url )  );
				MonsterDebugger.trace(this, _fontCollection.getItemAt(i).url  );
				
				var _tFont:TFontCollection = TFontCollection.create( LoaderMax.getContent( _fontCollection.getItemAt(i).url ), _fontCollection.getItemAt(i).url ) ;
				
				var font:TFont 				= _tFont.getFont(_tFont.getFontCount() - 1);
				var name:String 			= font.getNameTable().getRecordString( ID.nameFullFontName );
				var style:String 			= font.getNameTable().getRecordString( ID.nameFontSubfamilyName );
				var copyright:String 		= font.getNameTable().getRecordString( ID.nameCopyrightNotice );
				var version:String			= font.getNameTable().getRecordString( ID.nameVersionString );
				
				var fontVO:FontObject = new FontObject( name, _fontCollection.getItemAt(i).url, _fontCollection.getItemAt(i).fileObject.nativePath, style, copyright, version );
				_fontArray[i] =  fontVO ;
				
				_fontCollection[i].name = name;
				_fontCollection.refresh();
			}
		}
		
		public function getFontInformation( e:IndexChangeEvent ):void
		{
			var infoString:String = "Font Name: " + _fontArray[e.newIndex].fontName + "\n" + 
									"Font Style: " + _fontArray[e.newIndex].fontStyle + "\n" + 
									"Font URL: " + _fontArray[e.newIndex].fontURL + "\n" + 
									"Font Version: " + _fontArray[e.newIndex].fontVersion + "\n\n" + 
									"Font Copyright: " + _fontArray[e.newIndex].fontCopyright;
			
			FlexGlobals.topLevelApplication.FontInfo.text = infoString;
		}
		
		public function get fontArray():Array
		{
			return _fontArray;
		}

		
	}
}