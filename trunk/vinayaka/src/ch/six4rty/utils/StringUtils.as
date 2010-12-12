package ch.six4rty.utils
{
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
		
		public static function ReplaceBackslash( originalString:String ):String
		{
			var pattern:RegExp= /(\\)/g;
			var newStr:String = originalString.replace( pattern, "/" );
			return newStr;
		}
	}
}