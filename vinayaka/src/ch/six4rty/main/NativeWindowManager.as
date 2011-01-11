package ch.six4rty.main
{
	import flash.display.DisplayObject;
	import flash.display.NativeWindow;
	import flash.display.NativeWindowInitOptions;
	import flash.display.NativeWindowType;
	import flash.events.MouseEvent;
	
	import mx.controls.Label;
	import mx.core.UIComponent;
	import mx.states.AddChild;
	
	import spark.components.Application;
	import spark.components.Button;
	import spark.components.ComboBox;
	import spark.effects.AddAction;

	public class NativeWindowManager extends UIComponent
	{
		private static var cBox:ComboBox;
		private static var win:NativeWindow;
		private static var opts:NativeWindowInitOptions;
		
		public static function DisplayPreviewWindow():void
		{
			var arr:Array = [NativeWindowType.NORMAL, NativeWindowType.UTILITY];
			
			var lbl:Label = new Label();
			lbl.text = "type:";
			
			cBox = new ComboBox();
			cBox.dataProvider = arr;
			
			var btn:Button = new Button();
			btn.label = "Launch Window";
			btn.addEventListener( MouseEvent.CLICK, btn_click );
			NativeWindowManager.addChild( btn );
			
		}
		
		protected static function btn_click(event:MouseEvent):void
		{
			opts = new NativeWindowInitOptions();
			opts.type = cBox.selectedItem.toString();
			
			win = new NativeWindow(opts);
			win.title = opts.type;
			win.width = 320;
			win.height = 200;
			win.activate();
		}
		
	}
}