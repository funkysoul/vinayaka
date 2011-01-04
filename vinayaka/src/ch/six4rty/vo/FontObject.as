package ch.six4rty.vo
{
	public class FontObject
	{
		private var _fontName				:String;
		private var _fontURL				:String;
		private var _fontNativePath			:String;
		private var _fontStyle				:String;
		
		
		/**
		 * 
		 * @param name
		 * @param url
		 * @param style
		 * 
		 */		
		public function FontObject( name:String, url:String, nativePath:String, style:String ):void
		{
			_fontName						= name;
			_fontURL						= url;
			_fontNativePath					= nativePath
			_fontStyle						= style;
		}	
		
		/**
		 * 
		 * @return 
		 * 
		 */		
		public function get fontName():String
		{
			return _fontName;
		}

		/**
		 * 
		 * @param value
		 * 
		 */		
		public function set fontName(value:String):void
		{
			_fontName = value;
		}

		/**
		 * 
		 * @return 
		 * 
		 */		
		public function get fontURL():String
		{
			return _fontURL;
		}

		/**
		 * 
		 * @param value
		 * 
		 */		
		public function set fontURL(value:String):void
		{
			_fontURL = value;
		}

		/**
		 * 
		 * @return 
		 * 
		 */		
		public function get fontStyle():String
		{
			return _fontStyle;
		}

		/**
		 * 
		 * @param value
		 * 
		 */		
		public function set fontStyle(value:String):void
		{
			_fontStyle = value;
		}
		
		/**
		 * 
		 * @return 
		 * 
		 */		
		public function get fontNativePath():String
		{
			return _fontNativePath;
		}
		
		/**
		 * 
		 * @param value
		 * 
		 */		
		public function set fontNativePath(value:String):void
		{
			_fontNativePath = value;
		}


	}
}