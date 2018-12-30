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
		 * 发送广播数据至android应用
		 */
		public static function sendData(data:String):void
		{
			jollyClassAne.sendBroadcast(data);
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