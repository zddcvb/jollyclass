package com.jollyclass.airplayer.util
{
	/**
	 * 处理logger日志
	 */
	public class LoggerUtils
	{
		/**
		 * 设置需要为哪个类打印日志
		 */
		private var className:String;
		
		public function LoggerUtils(className:String)
		{
			this.className=className;	
		}
		/**
		 * 日常信息级别的打印-info
		 * functionName：设置哪个函数的日志信息
		 */
		public function info(msg:String,functionName:String):void
		{
			writeFile(msg,functionName,"info");
		}
		/**
		 * 异常信息级别的打印-error
		 */
		public function error(msg:String,functionName:String):void
		{
			writeFile(msg,functionName,"error");
		}
		private function writeFile(msg:String,functionName:String,loggerLevel:String):void
		{
			var now_time:String=getNowTime();
			var data:String=now_time+" "+className+" "+functionName+" "+loggerLevel+":"+msg;
			trace(data);
			//var fileUtils:FileUtils=new FileUtils();
			//fileUtils.writeDataToAppDictory(data+"\n",now_time.split(" ")[0]);
		}
		private function getNowTime():String
		{
			var date_time:Date=new Date();
			var year:Number=date_time.fullYear;
			var month:Number=date_time.month;
			var date:Number=date_time.date;
			var hour:Number=date_time.hours;
			var minute:Number=date_time.minutes;
			var second:Number=date_time.seconds;
			var time:String=year+"-"+(month+1)+"-"+date+" "+hour+":"+minute+":"+second;
			return time;
		}
	}
}