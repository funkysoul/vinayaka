package ch.six4rty.utils
{
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	
	import mx.core.FlexGlobals;

	public class StatusBarUpdater
	{
		private var _timer			:Timer;
		private var _iteration		:int;
		
		public function StatusBarUpdater()
		{
			_timer = new Timer( 20000, 0 );
			_timer.addEventListener( TimerEvent.TIMER, onTick );
			_timer.start();
		}
		
		protected function onTick(event:TimerEvent):void
		{
			_iteration++;
			
			switch ( _iteration )
			{
				case 1:
					FlexGlobals.topLevelApplication.status = "Thank your for using Vinayaka";
					break;
				case 2:
					FlexGlobals.topLevelApplication.status = "Bugs / Improvements?";
					break;
				case 3:
					FlexGlobals.topLevelApplication.status = "Thank your for using Vinayaka";
					break;
				case 4:
					FlexGlobals.topLevelApplication.status = "Thank your for using Vinayaka";
					break;
				case 5:
					_iteration = 0;
					break;
			}
			
		}
		
	}
}