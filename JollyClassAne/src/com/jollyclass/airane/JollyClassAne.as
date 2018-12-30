package com.jollyclass.airane
{
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	import flash.external.ExtensionContext;
	
	public class JollyClassAne extends EventDispatcher
	{
		private var _context:ExtensionContext;
		private static const EXTENSION_ID:String="com.jollyclass.ane";
		private static const SHOW_LONG_TOAST:String="toastLongFunction";
		private static const SHOW_SHORT_TOAST:String="toastShortFunction";
		private static const OPEN_APK:String="openApkFunction";
		private static const SEND_BROADCAST_FUNCTION:String="sendBroadcastDataFunction";
		public function JollyClassAne(target:IEventDispatcher=null)
		{
			_context=ExtensionContext.createExtensionContext(EXTENSION_ID,"");
		}
		public function showLongToast(msg:String):void{
			if (_context) 
			{
				_context.call(SHOW_LONG_TOAST,msg);	
			}
		}
		public function showShortToast(msg:String):void
		{
			if (_context) 
			{
				_context.call(SHOW_SHORT_TOAST,msg);	
			}
		}
		public  function openApk(packageName:String,className:String):void
		{
			if (_context) 
			{
				_context.call(OPEN_APK,packageName,className);
			}
		}
		public function sendBroadcast(data:String):void
		{
			if (_context) 
			{
				_context.call(SEND_BROADCAST_FUNCTION,data);
			}
		}
	}
}