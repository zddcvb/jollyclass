package com.jollyclass.airplayer.util
{
	import com.jollyclass.airane.JollyClassAne;
	/**
	 * 处理外部扩展ane的工具类
	 * @author 邹丹丹
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
		 * 
		 */		
		public static function sendData(isPlaying:Boolean):void
		{
			jollyClassAne.sendBroadcast(isPlaying)
		}
		/**
		 * 发送广播只android应用，自定义action，教学端
		 * @param isPlaying swf是否播放
		 * @param action 需要发送的广播
		 * @param isEnd swf播放完成
		 * @param teachingResourceId swf的id
		 * @param playTime swf当前播放的时长
		 * @param totalTime swf的总时长
		 */
		public static  function sendTeachingData(action:String,isPlaying:Boolean,isEnd:Boolean,teachingResourceId:String,playTime:String,totalTime:String):void
		{
			jollyClassAne.sendTeachingData(action,isPlaying,isEnd,teachingResourceId,playTime,totalTime);
		}
		/**
		 * 发送广播只android应用，自定义action，家庭端
		 * @param isPlaying swf是否播放
		 * @param action 需要发送的广播
		 * @param isEnd swf播放完成
		 * @param familyMediaId 家庭端媒资的id
		 * @param familyMaterialId 家庭端素材id
		 * @param playTime swf当前播放的时长
		 * @param totalTime swf的总时长
		 */
		public static  function sendFamilyData(action:String,isPlaying:Boolean,isEnd:Boolean,familyMediaId:String,familyMaterialId:String,playTime:String,totalTime:String):void
		{
			jollyClassAne.sendFamilyData(action,isPlaying,isEnd,familyMediaId,familyMaterialId,playTime,totalTime);
		}
		
		/**
		 * 显示toast信息,易LENGTH_LONG的时间显示
		 * @param msg 显示信息
		 */
		public static function showLongToast(msg:String):void
		{
			jollyClassAne.showLongToast(msg);
		}
		/**
		 * 显示toast信息,易LENGTH_SHORT的时间显示
		 * @param msg 显示信息
		 */
		public static function showShortToast(msg:String):void
		{
			jollyClassAne.showShortToast(msg);
		}
		/**
		 * 打开系统apk应用
		 * @param packageName 包名
		 * @param className 类名
		 */
		public static function openApk(packageName:String,className:String):void
		{
			jollyClassAne.openApk(packageName,className);
		}
		/**
		 * 上报错误信息至系统app
		 * @param msg 错误信息
		 */
		public static function sendErrorMsg(error_msg:String):void
		{
			jollyClassAne.sendErrorMsg(error_msg);
		}
	}
}