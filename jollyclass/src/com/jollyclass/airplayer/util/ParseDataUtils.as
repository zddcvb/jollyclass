package com.jollyclass.airplayer.util
{
	import com.jollyclass.airplayer.domain.InvokeDataInfo;
	/**
	 * 数据解析工具类
	 */
	public class ParseDataUtils
	{
		public function ParseDataUtils()
		{
		}
		/**
		 * 接收系统发送的数据，解析获得需要的信息，返回InvokeDataInfo
		 * my-customuri://result=" + resouceUri+”&status=0
		 * my-customuri://result=file:///storage/emulated/0/1/大声说爱_故事理解.swf&status=1
		 */
		public static function parseDataFromSystem(args:Array):InvokeDataInfo
		{
			var dataInfo:InvokeDataInfo=new InvokeDataInfo();
			var datas:String=args[0] as String;
			var resultIndex:int=datas.indexOf("result=");
			var statusIndex:int=datas.indexOf("status=");
			if(resultIndex!=-1&&statusIndex!=-1){
				var fullDatas:String = datas.substr(datas.indexOf("result"));
				var realDatas:Array = fullDatas.split("&");
				dataInfo.swfPath=realDatas[0].split("=")[1];
				dataInfo.accountInfoFlag=realDatas[1].split("=")[1];
				return dataInfo;
			}
			return null;
		}
	}
}