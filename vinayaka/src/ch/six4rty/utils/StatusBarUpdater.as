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
			_timer = new Timer( 8000, 0 );
			_timer.addEventListener( TimerEvent.TIMER, onTick );
			_timer.start();
			
			FlexGlobals.topLevelApplication.status = "Thank your for using Vinayaka";
		}
		
		protected function onTick(event:TimerEvent):void
		{
			_iteration++;
			
			switch ( _iteration )
			{
				case 1:
					FlexGlobals.topLevelApplication.status = "Bugs / Improvements? Check http://bugs.six4rty.ch";
					break;
				case 2:
					FlexGlobals.topLevelApplication.status = "Current Version 1.0.1";
					break;
				case 3:
					FlexGlobals.topLevelApplication.status = "Facts: Vinayaka is the alternate name of the Hindu God Ganesha";
					break;
				case 4:
					_iteration = 0;
					break;
			}
			
		}
		
	}
}