package com.jollyclass.airplayer.constant
{
	/**
	 * 播放器错误信息汇总，通过发送错误码，判定错误的类型
	 * @author 邹丹丹
	 */
	public class ErrorMsgNumber
	{
		/**
		 * jx01:系统app发送数据不符合规范！
		 */
		public static const PARSE_DATA_ERROR:String="jx01";
		/**
		 * jx02:系统app未发送数据给播放器！
		 */
		public static const INOVKE_DATA_LENGTH_ERROR:String="jx02";
		/**
		 * jx03:所需播放的课件不存在，检查系统会否存在此文件！
		 */
		public static const FILE_NOT_EXITS:String="jx03";
		/**
		 * jx04:加载课件异常，可能file对象load时出现异常，不能正常load
		 */
		public static const FILE_READ_ERROR:String="jx04";
		/**
		 * jx05:swf容量长度太短，不符合标准，无法加载！
		 */
		public static const SWF_BYTE_LENGTH_ERROR:String="jx05";
		/**
		 * jx06:加载swf文件失败，可能是由于文件类型不对，不是标准的swf文件，也可能是由于swf课件下载不完整导致。
		 */
		public static const LOAD_SWF_ERROR:String="jx06";
		/**
		 * jx07:内存不足或者加载的文件太大，无法分配内存
		 */
		public static const MEMORY_ERROR:String="jx07";
		/**
		 * jx08:加载dialog.swf文件失败，请检查dialog文件是否正常。
		 */
		public static const DIALOG_LAODING_ERROR:String="jx08";
		/**
		 * jx09:加载error.swf文件失败，请检查error.swf文件是否正常。
		 */
		public static const ERROR_LOADING_FAILED:String="jx09";
		/**
		 * jx10:加载player.swf文件失败，请检查player.swf文件是否正常。
		 */
		public static const PLAYER_LOADING_FAILED:String="jx10";
		
		public function ErrorMsgNumber()
		{
		}
	}
}