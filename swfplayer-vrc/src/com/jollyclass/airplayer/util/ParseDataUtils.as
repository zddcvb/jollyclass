package com.jollyclass.airplayer.util
{
	import com.jollyclass.airplayer.constant.FieldConst;
	import com.jollyclass.airplayer.domain.InvokeDataInfo;
	import com.jollyclass.airplayer.domain.JollyClassDataInfo;
	
	/**
	 * 数据解析工具类
	 * @author 邹丹丹
	 */
	public class ParseDataUtils
	{
		public function ParseDataUtils()
		{
		}
		/**
		 * 接收系统发送的数据，解析获得需要的信息，返回InvokeDataInfo
		 * my-customuri://result=" + resouceUri+”&status=0
		 * @param args my-customuri://result=file:///storage/emulated/0/1/大声说爱_故事理解.swf&status=1
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
		 * @param args my-customuri://result=" + resourceUri+”&product_type=teachingbox&resource_type=xsd&customer_service_tel=12342453&teaching_status=0&teaching_resource_id=123456
		 * &package_name=com.ishuidi.boxproject&
		 * &family_media_id=1234&family_material_id=123456
		 */
		public static function parseDataInfo(args:Array):JollyClassDataInfo
		{
			var dataInfo:JollyClassDataInfo=new JollyClassDataInfo();
			var datas:String=args[0] as String;
			var resultIndex:int=datas.indexOf("result=");
			var productIndex:int=datas.indexOf("product_type=");
			var resourceIndex:int=datas.indexOf("resource_type=");
			var serviceIndex:int=datas.indexOf("customer_service_tel=");
			if(resultIndex!=-1&&productIndex!=-1&&resourceIndex!=-1&&serviceIndex!=-1)
			{
				var fullDatas:String = datas.substr(datas.indexOf("result"));
				var realDatas:Array = fullDatas.split("&");
				dataInfo.swfPath=realDatas[0].split("=")[1];
				dataInfo.product_type=realDatas[1].split("=")[1];
				dataInfo.resource_type=realDatas[2].split("=")[1];
				dataInfo.customer_service_tel=realDatas[3].split("=")[1];
				switch(dataInfo.product_type){
					case FieldConst.TEACHING_BOX:
						dataInfo.teaching_resource_id=realDatas[4].split("=")[1];
						dataInfo.teaching_status=realDatas[5].split("=")[1];
						dataInfo.package_name=realDatas[6].split("=")[1];
						break;
					case FieldConst.FAMILY_BOX:
						dataInfo.package_name=realDatas[4].split("=")[1];
						dataInfo.family_media_id=realDatas[5].split("=")[1];
						dataInfo.family_material_id=realDatas[6].split("=")[1];
						break;
				}
				return dataInfo;
			}
			return null;
		}
	}
}