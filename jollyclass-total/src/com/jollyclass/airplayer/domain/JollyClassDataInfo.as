package com.jollyclass.airplayer.domain
{
	import flash.sampler.Sample;
	
	/**
	 * 公共参数：
	 product_type:产品类型--teachingbox代表教学盒子；familybox代表客厅盒子；
	 resource_type:资源类型--xsd代表小水滴资源；other代表第三方资源；
	 教学盒子专有参数：
	 teaching_status=0://已付费会员可以正常播放
	 teaching_status=1://未开通服务且未绑定园所（播放10s,弹出扫码关联园所窗口）
	 teaching_status=2://未开通服务已经绑定园所（播放10s,弹出开通服务窗口）
	 teaching_status=3://开通服务已到期;（播放10s,弹出开通服务窗口）
	 teaching_resource_id：资源id--123456
	 客厅盒子专有参数：
	 family_media_id：媒资id--1234
	 family_material_id:素材id--123456
	 */
	public class JollyClassDataInfo
	{
		private var _swfPath:String;
		private var _product_type:String;
		private var _resource_type:String;
		private var _teaching_status:int;
		private var _teaching_resource_id:String;
		private var _family_media_id:String;
		private var _family_material_id:String;
		public function JollyClassDataInfo()
		{
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
			return "JollyClassDataInfo[swfPath:"+_swfPath+",product_type:"+_product_type+",resource_type:"+_resource_type+
				",teaching_status:"+_teaching_status+",teaching_resource_id:"+_teaching_resource_id+",family_media_id:"+_family_media_id+",family_material_id:"+_family_material_id+"]";
		}

	}
}