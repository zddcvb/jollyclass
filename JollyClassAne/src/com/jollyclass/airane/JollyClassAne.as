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
		private static const SEND_ERROR_FUNCTION:String="sendErrorMsgFunction";
		private static const FAMILY_DATA_FUNCTION:String="familySendDataFunction";
		private static const TEACHING_DATA_FUNCTION:String="teachingSendDataFunction";
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
		public function sendBroadcast(isPlaying:Boolean):void
		{
			if (_context) 
			{
				_context.call(SEND_BROADCAST_FUNCTION,isPlaying);
			}
		}
		public function sendFamilyData(action:String,isPlaying:Boolean,isEnd:Boolean,familyMediaId:String,familyMaterialId:String,playTime:String,totalTime:String):void
		{
			if(_context)
			{
				_context.call(FAMILY_DATA_FUNCTION,action,isPlaying,isEnd,familyMediaId,familyMaterialId,playTime,totalTime);	
			}
		}
		public function sendTeachingData(action:String,isPlaying:Boolean,isEnd:Boolean,teachingResourceId:String,playTime:String,totalTime:String):void
		{
			if(_context)
			{
				_context.call(TEACHING_DATA_FUNCTION,action,isPlaying,isEnd,teachingResourceId,playTime,totalTime);	
			}
		}
		public function sendErrorMsg(error_msg:String):void
		{
			if(_context)
			{
				_context.call(SEND_ERROR_FUNCTION,error_msg);
			}
		}
	}
}