package com.jollyclass.airplayer.util
{
	import com.jollyclass.airplayer.domain.JollyClassDataInfo;
	import com.jollyclass.airplayer.domain.SwfInfo;
	
	import flash.display.MovieClip;
	import flash.sampler.Sample;
	import flash.utils.ByteArray;

	/**
	 * swf文件处理的工具类，用户获取swf文件的播放进度、播放时间、文件名称等
	 * @author 邹丹丹
	 */
	public class SwfInfoUtils
	{
		public function SwfInfoUtils()
		{
		}
		/**
		 * 获取影片剪辑的时长，并转换
		 * @param frames swf文件的帧数
		 * @return 返回一个字符串
		 */
		public static function getSwfTimeFormatter(frames:int):String
		{
			var tmp:Number=frames/24;
			var hours:String=Math.floor(tmp/3600)+"";
			var minutes:String=Math.floor(tmp/60)+"";
			var seconds:String=Math.floor(tmp%60)+"";
			var minutes_int:int=parseInt(minutes);
			var hours_int:int=parseInt(hours);
			if(parseInt(seconds)<10){
				seconds="0"+seconds;
			}
			if(minutes_int<10){
				minutes="0"+minutes_int;
			}
			if(hours_int<10){
				hours="0"+hours_int;
			}
			var total_time:String=hours+":"+minutes+":"+seconds;
			return total_time;
		}
		/**
		 * 获取swf文件的名称
		 * @param swfPath swf文件的绝对路径
		 * @return 返回一个swf文件的文件名称，不带后缀
		 */
		public static function getSwfName(swfPath:String):String
		{
			var fileName:String=swfPath.substr(swfPath.lastIndexOf("/")+1);
			return fileName.replace(".swf","");
		}
		/**
		 * 获取swf的文件信息
		 * @param dataInfo jollyclassDataInfo对象
		 * @param _mc swf文件对象
		 * @return SwfInfo对象
		 */
		public static function getSwfInfo(dataInfo:JollyClassDataInfo,_mc:MovieClip):SwfInfo
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
				exitInfo.family_material_id=dataInfo.family_material_id;
				exitInfo.family_media_id=dataInfo.family_media_id;
				exitInfo.teaching_resource_id=dataInfo.teaching_resource_id;
				//判断是否播放完成
				if((_mc.totalFrames-_mc.currentFrame)<=10){
					exitInfo.isEnd=true;
				}else{
					exitInfo.isEnd=false;
				}
			}
			return exitInfo;
		}
		/**
		 * 获取当前movieClip的播放进度
		 * @param _mc swf文件对象
		 * @return 获取swf文件当前的播放进度
		 */
		public static function getSwfProgressRate(_mc:MovieClip):int
		{
			return Math.round(Math.abs(_mc.currentFrame/_mc.totalFrames)*100);
		}
		
		public static function encodeGBK(str:String):String
		{
			var result:String="";
			var bytes:ByteArray=new ByteArray();
			bytes.writeMultiByte(str,"gbk");
			for(var i:int=0;i<bytes.length;i++){
				result+=escape(String.fromCharCode(bytes[i]));
			}
			return result;
		}
	}
}