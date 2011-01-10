package ch.six4rty.vo
{
	public class UnicodeObject
	{
		private var _unicodeLabel				:String;
		private var _unicodeData				:String;
		private var _unicodeSelected			:Boolean;
		
		public function UnicodeObject(label:String, data:String, selected:Boolean)
		{
			super();
			
			_unicodeLabel = label;
			_unicodeData = data;
			_unicodeSelected = selected;
		}

		public function get unicodeLabel():String
		{
			return _unicodeLabel;
		}

		public function set unicodeLabel(value:String):void
		{
			_unicodeLabel = value;
		}

		public function get unicodeData():String
		{
			return _unicodeData;
		}

		public function set unicodeData(value:String):void
		{
			_unicodeData = value;
		}

		public function get unicodeSelected():Boolean
		{
			return _unicodeSelected;
		}

		public function set unicodeSelected(value:Boolean):void
		{
			_unicodeSelected = value;
		}


	}
}