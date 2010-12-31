package ch.six4rty.main
{
	import nl.demonsters.debugger.MonsterDebugger;

	public final class VinayakaCore 
	{
		private static var instance				:VinayakaCore		= new VinayakaCore();
		
		private var _endProduct					:String;
		
		public function VinayakaCore():void
		{
			if ( instance ) throw new Error( "Singleton can be only accessed through getInstance(); method" );
		}
		
		public static function getInstance():VinayakaCore
		{
			return instance;
		}
		
		
		
		public function GenerateFontFile( str:String ):void
		{
			switch( str )
			{
				case "as3":
					//
					break;
				case "swf":
					//
					break;
				case "swc":
					//
					break;
			}
		}		
	}
}