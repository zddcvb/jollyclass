package com.jollyclass.airplayer.util
{
	import com.jollyclass.airplayer.domain.DataInfo;
	import com.jollyclass.airplayer.domain.InvokeDataInfo;
	import com.jollyclass.airplayer.domain.JollyClassDataInfo;
	
	import flash.media.Camera;

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
		/**
		 * 解析数据
		 * my-customuri://result=" + resouceUri+”&status=0&classType=0
		 * classType=0：教学端
		 * classType=1：家庭端
		 */
		public static function parseDataFor2Platform(args:Array):DataInfo
		{
			var dataInfo:DataInfo=new DataInfo();
			var datas:String=args[0] as String;
			var resultIndex:int=datas.indexOf("result=");
			var statusIndex:int=datas.indexOf("status=");
			var classTypeIndex:int=datas.indexOf("classType=");
			if(resultIndex!=-1&&statusIndex!=-1&&classTypeIndex!=-1)
			{
				var fullDatas:String = datas.substr(datas.indexOf("result"));
				var realDatas:Array = fullDatas.split("&");
				dataInfo.swfPath=realDatas[0].split("=")[1];
				dataInfo.accountInfoFlag=realDatas[1].split("=")[1];
				dataInfo.classType=realDatas[2].split("=")[1];
				return dataInfo;
			}
			return null;
		}
		/**
		 * my-customuri://result=" + resourceUri+”&product_type=teachingbox&resource_type=xsd&teaching_status=0&teaching_resource_id=123456
		 * &family_media_id=1234&family_material_id=123456
		 */
		public static function parseDataInfo(args:Array):JollyClassDataInfo
		{
			var dataInfo:JollyClassDataInfo=new JollyClassDataInfo();
			var datas:String=args[0] as String;
			var resultIndex:int=datas.indexOf("result=");
			var productIndex:int=datas.indexOf("product_type=");
			var resourceIndex:int=datas.indexOf("resource_type=");
			var statusIndex:int=datas.indexOf("teaching_status=");
			var triIndex:int=datas.indexOf("teaching_resource_id=");
			var fmiIndex:int=datas.indexOf("family_media_id=");
			var fliIndex:int=datas.indexOf("family_material_id=");
			if(resultIndex!=-1&&productIndex!=-1&&resourceIndex!=-1&&statusIndex!=-1&&triIndex!=-1&&fmiIndex!=-1&&fliIndex!=-1)
			{
				var fullDatas:String = datas.substr(datas.indexOf("result"));
				var realDatas:Array = fullDatas.split("&");
				dataInfo.swfPath=realDatas[0].split("=")[1];
				dataInfo.product_type==realDatas[1].split("=")[1];
				dataInfo.resource_type=realDatas[2].split("=")[1];
				dataInfo.teaching_status=realDatas[3].split("=")[1];
				dataInfo.teaching_resource_id=realDatas[4].split("=")[1];
				dataInfo.family_media_id=realDatas[5].split("=")[1];
				dataInfo.family_material_id=realDatas[6].split("=")[1];
				return dataInfo;
			}
			return null;
		}
	}
}