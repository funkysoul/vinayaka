package ch.six4rty.main
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	
	import mx.collections.ArrayCollection;
	import mx.core.FlexGlobals;
	
	import nl.demonsters.debugger.MonsterDebugger;
	
	import spark.components.TextArea;
	import spark.events.TextOperationEvent;

	public final class UserSettings extends EventDispatcher
	{
		private static var instance				:UserSettings		= new UserSettings();
		
		private var _unicodeListAC				:ArrayCollection	= new ArrayCollection(); 
		
		private var _charArray					:Array				= new Array();
		private var _glyphCount					:int;
		
		/**
		 * 
		 * 
		 */		
		public function UserSettings()
		{
			if ( instance ) throw new Error( "Singleton can be only accessed through getInstance(); method" );
		}
		
		/**
		 * 
		 * @return 
		 * 
		 */		
		public static function getInstance():UserSettings
		{			
			return instance;
		}
		
		/**
		 * 
		 * @param event
		 * 
		 */		
		public function inputTextHandler( event:TextOperationEvent ):void
		{
			FlexGlobals.topLevelApplication.ConvertedText.text = convertTextToUnicode();
			FlexGlobals.topLevelApplication.GlyphCount.text = glyphCount;
		}
		
		/**
		 * 
		 * @return 
		 * 
		 */		
		protected function convertTextToUnicode():String
		{				
			_charArray = [];
			
			for ( var i:int = 0; i < FlexGlobals.topLevelApplication.NormalText.text.length; i++ )
			{
				if ( FlexGlobals.topLevelApplication.NormalText.text.charCodeAt( i ).toString(16).length < 3 )
				{
					_charArray.push( "U+00" + FlexGlobals.topLevelApplication.NormalText.text.charCodeAt( i ).toString(16) );
				}
				else
				{
					_charArray.push( "U+0" + FlexGlobals.topLevelApplication.NormalText.text.charCodeAt( i ).toString(16) );
				}
			}
						
			return removeDuplicates( _charArray ).toString();
		}
		
		/**
		 * 
		 * @param inArray
		 * @return 
		 * 
		 */		
		protected static function removeDuplicates(inArray:Array):Array 
		{
			return inArray.filter(_removeDuplicatesFilter);
		}
		
		/**
		 * 
		 * @param e
		 * @param i
		 * @param inArray
		 * @return 
		 * 
		 */		
		protected static function _removeDuplicatesFilter(e:*, i:int, inArray:Array):Boolean 
		{
			return (i == 0) ? true : inArray.lastIndexOf(e, i - 1) == -1;
		}
		
		/**
		 * 
		 * @return 
		 * 
		 */		
		public function get unicodeListAC():ArrayCollection
		{
			return _unicodeListAC;
		}		

		
		public function get glyphCount():int
		{
			_glyphCount = String(FlexGlobals.topLevelApplication.ConvertedText.text).split(",").length - 1;
			return _glyphCount;
		}

	}
}