package ch.six4rty.main
{
	import com.greensock.events.LoaderEvent;
	import com.greensock.loading.LoaderMax;
	import com.greensock.loading.XMLLoader;
	
	import flash.display.Loader;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	
	import mx.collections.ArrayCollection;
	
	import nl.demonsters.debugger.MonsterDebugger;

	public final class ApplicationSettings extends EventDispatcher
	{
		private static var instance				:ApplicationSettings		= new ApplicationSettings();
		
		private var _unicodeTable				:XML;
		private var _wordList					:XML;
		
		private var _unicodeAC					:ArrayCollection;
		private var _queue						:LoaderMax;
		
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

		
	}
}