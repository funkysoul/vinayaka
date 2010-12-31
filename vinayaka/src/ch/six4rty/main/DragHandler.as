package ch.six4rty.main
{
	import flash.desktop.ClipboardFormats;
	import flash.events.NativeDragEvent;
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	
	import mx.collections.ArrayCollection;
	import mx.core.FlexGlobals;
	import mx.managers.DragManager;
	
	import nl.demonsters.debugger.MonsterDebugger;

	public final class DragHandler
	{
		private static var instance				:DragHandler				= new DragHandler();
		[Bindable] private var _fontCollection	:ArrayCollection			= new ArrayCollection();
		
		public function DragHandler()
		{
			if ( instance ) throw new Error( "Singleton can be only accessed through getInstance(); method" );
		}
		
		public static function getInstance():DragHandler
		{
			return instance;
		}
		
		public function onDragIn( evt:NativeDragEvent ):void
		{
			if ( evt.clipboard.hasFormat( ClipboardFormats.FILE_LIST_FORMAT ) )
			{
				var files:Array = evt.clipboard.getData( ClipboardFormats.FILE_LIST_FORMAT ) as Array;
				if ( files.length == 1 )
				{
					DragManager.acceptDragDrop( FlexGlobals.topLevelApplication.FontList );
				}
			}
		}
		
		public function onDragDrop( evt:NativeDragEvent ):void
		{
			var arr:Array 	= evt.clipboard.getData(ClipboardFormats.FILE_LIST_FORMAT) as Array;
			var f:File		= File( arr[ 0 ] );
			
			_fontCollection.addItem( f );
			
		}

		public function get fontCollection():ArrayCollection
		{
			return _fontCollection;
		}
		
		
	}
}