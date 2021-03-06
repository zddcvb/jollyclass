package com.jollyclass.airplayer.util
{
	import com.jollyclass.airane.JollyClassAne;
	/**
	 * 处理外部扩展ane的工具类
	 */
	public class AneUtils
	{
		private static var jollyClassAne:JollyClassAne=new JollyClassAne(); 
		public function AneUtils()
		{
		}
		/**
		 * 发送广播数据至android应用，固定的action：android.intent.action.AIR_DATA
		 * @param isPlaying 当前swf是否播放
		 */
		public static function sendData(isPlaying:Boolean):void
		{
			jollyClassAne.sendBroadcast(isPlaying)
		}
		/**
		 * 发送广播只android应用，自定义action
		 * @param isPlaying swf是否播放
		 * @param action 需要发送的广播
		 * @param resourceName swf的名称
		 * @param playTime swf当前播放的时长
		 * @param totalTime swf的总时长
		 */
		public static  function sendDataFromAction(isPlaying:Boolean,action:String,resourceName:String,playTime:String,totalTime:String,isPlayFinished:Boolean):void
		{
			jollyClassAne.customerBroadcast(isPlaying,action,resourceName,playTime,totalTime,isPlayFinished);
		}
		/**
		 * 显示toast信息,易LENGTH_LONG的时间显示
		 */
		public static function showLongToast(msg:String):void
		{
			jollyClassAne.showLongToast(msg);
		}
		/**
		 * 显示toast信息,易LENGTH_SHORT的时间显示
		 */
		public static function showShortToast(msg:String):void
		{
			jollyClassAne.showShortToast(msg);
		}
		/**
		 * 打开系统apk应用
		 * 
		 */
		public static function openApk(packageName:String,className:String):void
		{
			jollyClassAne.openApk(packageName,className);
		}
		/**
		 * 上报错误信息至系统app
		 */
		public static function sendErrorMsg(error_msg:String):void
		{
			jollyClassAne.sendErrorMsg(error_msg);
		}
	}
}