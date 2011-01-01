package ch.six4rty.utils
{
	public class FontObject
	{
		private var _fontName				:String;
		private var _fontURL				:String;
		private var _fontStyle				:String;
		
		
		public function FontObject( name:String, url:String, style:String ):void
		{
			_fontName						= name;
			_fontURL						= url;
			_fontStyle						= style;
		}	
		
		
		public function get fontName():String
		{
			return _fontName;
		}

		public function set fontName(value:String):void
		{
			_fontName = value;
		}

		public function get fontURL():String
		{
			return _fontURL;
		}

		public function set fontURL(value:String):void
		{
			_fontURL = value;
		}

		public function get fontStyle():String
		{
			return _fontStyle;
		}

		public function set fontStyle(value:String):void
		{
			_fontStyle = value;
		}


	}
}