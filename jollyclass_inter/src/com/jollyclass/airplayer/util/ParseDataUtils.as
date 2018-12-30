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
		 */
		public static function parseDataFromSystem(args:Array):InvokeDataInfo
		{
			var dataInfo:InvokeDataInfo=new InvokeDataInfo();
			if (args.length>0) 
			{
				var datas:String=args[0] as String;
				var fullDatas:String = datas.split("=")[1];
				var realDatas:Array = fullDatas.split("&");
				dataInfo.swfPath=realDatas[0];
				dataInfo.accountInfoFlag=realDatas[1];
				return dataInfo;
			}
			
			return null;
		}
	}
}