package com.jollyclass.airplayer.util
{
	import com.jollyclass.airplayer.constant.MessageConst;
	
	import flash.desktop.NativeApplication;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.filesystem.File;
	import flash.utils.ByteArray;

	public class FileUtils
	{
		private static var logger:LoggerUtils=new LoggerUtils("com.jollyclass.airplayer.util.FileUtils");
		public  static var fileData:ByteArray;
		public function FileUtils()
		{
		}
		public static function readFile(filePath:String):void
		{
			if (filePath!=null) 
			{
				var file:File=new File(filePath);
				file.addEventListener(Event.COMPLETE,onFileCompleteHandler);
				file.addEventListener(IOErrorEvent.IO_ERROR,onFileErrorHandler);
				file.load();
			}
		}
		
		protected static function onFileErrorHandler(event:IOErrorEvent):void
		{
			logger.info("file don't exit","onFileErrorHandler");
			AneUtils.sendData(MessageConst.READ_FILE_ERROR);
			NativeApplication.nativeApplication.exit(0);
		}
		
		protected static function onFileCompleteHandler(event:Event):void
		{
			logger.info("onFileCompleteHandler","onFileCompleteHandler");
			fileData=event.currentTarget.data;	
			AneUtils.showToast("fileData"+fileData.toString());
		}
	}
}