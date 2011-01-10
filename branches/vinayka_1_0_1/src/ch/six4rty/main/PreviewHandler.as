package ch.six4rty.main
{
	import flash.display.Sprite;
	
	public class PreviewHandler extends Sprite
	{
		private var _vinayakaCore				:VinayakaCore			= VinayakaCore.getInstance();
		
		private var _generatedCode				:String;
		
		public function PreviewHandler()
		{
			_generatedCode						= _vinayakaCore.generatedASCode;
			
		}
	}
}