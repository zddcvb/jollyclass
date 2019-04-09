package com.jollyclass.airplayer.util
{
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	/**
	 * 文件读写功能
	 * @author 邹丹丹
	 */
	public class FileUtils
	{
		private static var logger:LoggerUtils=new LoggerUtils("com.jollyclass.airplayer.util.FileUtils");
		public function FileUtils()
		{
		}
		/**
		 * 将数据写入固定的目录当中，即写入到sd卡中的目录jollyclass_air_player中的log+当天日期.txt中
		 * @param data：需要写入的字符串信息
		 * @param dateTime 日志当天的日期信息
		 */
		public  function writeDataToAppDictory(data:String,dateTime:String):void
		{
			var fs:FileStream=null;
			try
			{
				var logParentFilePath:String="file:///storage/emulated/0/jollyclass_air_player/log"+dateTime+".txt";
				var file:File=new File(logParentFilePath);
				 fs=new FileStream();
				fs.openAsync(file,FileMode.APPEND);
				fs.addEventListener(Event.COMPLETE,onCompleteHandler);
				fs.addEventListener(IOErrorEvent.IO_ERROR,onErrorHandler);
				fs.writeUTFBytes(data);
				fs.close();
			} 
			catch(error:Error) 
			{
				error.getStackTrace();
				//logger.error(error.getStackTrace(),"writeDataToAppDictory");
			}
		}
		
		protected function onCompleteHandler(event:Event):void
		{	
			//logger.info("文件读取成功","onCompleteHandler");
		}
		
		protected function onErrorHandler(event:IOErrorEvent):void
		{
			//logger.error("文件读取失败","writeDataToAppDictory");
		}
	}
}