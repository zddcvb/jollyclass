package com.jollyclass.airplayer.domain
{
	
	/**
	 * 小水滴课堂独有的属性字段
	 * @author 邹丹丹
	 */
	public class JollyClassDataInfo
	{
		/**
		 * swf文件的绝对路径
		 */
		private var _swfPath:String;
		/**
		 * 产品类型--teachingbox代表教学盒子；familybox代表客厅盒子；
		 */
		private var _product_type:String;
		/**
		 * 资源类型--xsd代表小水滴资源；other代表第三方资源；
		 */
		private var _resource_type:String;
		/**
		 * 客服电话,默认电话：020-38556685
		 */
		private var _customer_service_tel:String;
		/**
		 * 教学系统账户信息
		 * 0:已付费会员可以正常播放
		 * 1:绑定激活码，盒子当前日期不在服务有效期内（播放10s,弹出开通服务窗口）
		 * 2:未开通服务（播放10s,弹出开通服务窗口）
		 */
		private var _teaching_status:int;
		/**
		 * 资源id
		 */
		private var _teaching_resource_id:String;
		/**
		 * 媒资id
		 */
		private var _family_media_id:String;
		/**
		 * 素材id
		 */
		private var _family_material_id:String;
		
		public function JollyClassDataInfo()
		{
		}
		
		public function get customer_service_tel():String
		{
			return _customer_service_tel;
		}
		
		public function set customer_service_tel(value:String):void
		{
			_customer_service_tel = value;
		}
		
		public function get swfPath():String
		{
			return _swfPath;
		}
		
		public function set swfPath(value:String):void
		{
			_swfPath = value;
		}
		
		public function get family_material_id():String
		{
			return _family_material_id;
		}
		
		public function set family_material_id(value:String):void
		{
			_family_material_id = value;
		}
		
		public function get family_media_id():String
		{
			return _family_media_id;
		}
		
		public function set family_media_id(value:String):void
		{
			_family_media_id = value;
		}
		
		public function get teaching_resource_id():String
		{
			return _teaching_resource_id;
		}
		
		public function set teaching_resource_id(value:String):void
		{
			_teaching_resource_id = value;
		}
		
		public function get teaching_status():int
		{
			return _teaching_status;
		}
		
		public function set teaching_status(value:int):void
		{
			_teaching_status = value;
		}
		
		public function get resource_type():String
		{
			return _resource_type;
		}
		
		public function set resource_type(value:String):void
		{
			_resource_type = value;
		}
		
		public function get product_type():String
		{
			return _product_type;
		}
		
		public function set product_type(value:String):void
		{
			_product_type = value;
		}
		
		public function toString():String
		{
			return "JollyClassDataInfo[swfPath:"+_swfPath+",product_type:"+_product_type+",resource_type:"+_resource_type+",customer_service_tel"+_customer_service_tel+
				",teaching_status:"+_teaching_status+",teaching_resource_id:"+_teaching_resource_id+",family_media_id:"+_family_media_id+",family_material_id:"+_family_material_id+"]";
		}
		
	}
}