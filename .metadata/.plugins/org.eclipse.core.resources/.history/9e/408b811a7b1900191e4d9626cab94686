package com.jollyclass.airplayer.constant
{
	/**
	 * 播放器错误信息汇总，通过发送错误码，判定错误的类型
	 */
	public class ErrorMsgNumber
	{
		/**
		 * jx01
		 */
		private static const PARSE_DATA_ERROR:String="系统app发送数据不符合规范";
		/**
		 * jx02
		 */
		private static const INOVKE_DATA_LENGTH_ERROR:String="系统app未发送数据给播放器！";
		/**
		 * jx03
		 */
		private static const FILE_NOT_EXITS:String="所需播放的课件不存在！";
		/**
		 * jx04
		 */
		private static const FILE_READ_ERROR:String="课件读取失败！";
		/**
		 * jx05
		 */
		private static const SWF_BYTE_LENGTH_ERROR:String="swf的字节长度太短，无法加载！";
		/**
		 * jx06
		 */
		private static const LOAD_SWF_ERROR:String="加载swf文件失败！";
		public function ErrorMsgNumber()
		{
		}
		public static function getErrorMsg(msgNum:String):String
		{
			var msg:String;
			switch(msgNum){
				case "ax01":
					msg=FILE_NOT_EXITS;
					break;
			}
			return msg;
		}
	}
}