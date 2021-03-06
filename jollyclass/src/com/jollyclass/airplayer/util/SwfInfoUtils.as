package com.jollyclass.airplayer.util
{
	import com.jollyclass.airplayer.domain.SwfInfo;
	import com.jollyclass.airplayer.domain.InvokeDataInfo;
	
	import flash.net.dns.AAAARecord;
	
	import mx.core.IAssetLayoutFeatures;
	import flash.display.MovieClip;

	public class SwfInfoUtils
	{
		public function SwfInfoUtils()
		{
		}
		/**
		 * 获取影片剪辑的时长，并转换
		 */
		public static function getSwfTimeFormatter(frames:int):String
		{
			var tmp:Number=Math.round(frames/24);
			var minutes:String=Math.round(tmp/60)+"";
			var seconds:String=Math.round(tmp%60)+"";
			if(parseInt(minutes)<10){
				minutes="0"+minutes;
			}
			if(parseInt(seconds)<10){
				seconds="0"+seconds;
			}
			var total_time:String=minutes+":"+seconds;
			return total_time;
		}
		/**
		 * 获取swf文件的名称
		 */
		public static function getSwfName(swfPath:String):String
		{
			var fileName:String=swfPath.substr(swfPath.lastIndexOf("/")+1);
			return fileName.replace(".swf","");
		}
		/**
		 * 获取swf的文件信息
		 */
		public static function getSwfInfo(dataInfo:InvokeDataInfo,_mc:MovieClip):SwfInfo
		{
			//获取文件名称：
			var exitInfo:SwfInfo=new SwfInfo();
			exitInfo.isPlaying=false;
			if(dataInfo!=null){
				exitInfo.resource_name=SwfInfoUtils.getSwfName(dataInfo.swfPath);
				//获取总时长
				var total_time:String=SwfInfoUtils.getSwfTimeFormatter(_mc.totalFrames);
				var play_time:String=SwfInfoUtils.getSwfTimeFormatter(_mc.currentFrame);
				exitInfo.play_time=play_time;
				exitInfo.total_time=total_time;
				//判断是否播放完成
				if((_mc.totalFrames-_mc.currentFrame)<=10){
					exitInfo.isPlayFinished=true;
				}else{
					exitInfo.isPlayFinished=false;
				}
			}
			return exitInfo;
		}
	}
}