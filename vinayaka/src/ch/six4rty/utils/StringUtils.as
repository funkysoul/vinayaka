package ch.six4rty.utils
{
	import nl.demonsters.debugger.MonsterDebugger;

	public class StringUtils
	{
		/**
		 * An easy to use static function that strips out all whitespaces from any specific string.
		 * 
		 * 
		 * @param originalString:String
		 * @return String
		 * 
		 */		
		public static function StripSpaces( originalString:String ):String
		{
			var orig:Array = originalString.split( " " );
			return ( orig.join("") );
		}
		
		/**
		 * 
		 * @param originalString
		 * @return 
		 * 
		 */		
		public static function ReplaceBackslash( originalString:String ):String
		{
			var pattern:RegExp= /(\\)/g;
			var newStr:String = originalString.replace( pattern, "/" );
			return newStr;
		}
		
		/**
		 * 
		 * @param originalString
		 * @return 
		 * 
		 */		
		public static function RemoveLastSeparator( originalString:String ):String
		{
			return originalString.slice( 0, -2 );
		}
		
		/**
		 * 
		 * @return 
		 * 
		 */		
		public static function RemoveSpecialChar( originalString:String ):String
		{
			var pattern:RegExp = /[\[\\\^\$\.\|\?\*\+\(\)\{\}\,\-\_\[\]\.\s]/g; 
			var temp:String = originalString.replace( pattern, "" );
			MonsterDebugger.trace(StringUtils, temp, 0xff0000 );
			return temp;
		}
	}
}