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
		 */
		public static function sendData(isPlaying:Boolean):void
		{
			jollyClassAne.sendBroadcast(isPlaying)
		}
		/**
		 * 发送广播只android应用，自定义action
		 * @param data 需要发送的数据
		 * @param action 需要发送的广播
		 */
		public static  function sendDataFromAction(isPlaying:Boolean,action:String):void
		{
			jollyClassAne.customerBroadcast(isPlaying,action);
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
	}
}