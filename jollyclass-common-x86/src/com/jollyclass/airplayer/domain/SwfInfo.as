package com.jollyclass.airplayer.domain
{
	/**
	 * 描述swf课件信息
	 * @author 邹丹丹
	 */
	public class SwfInfo
	{
		/**
		 * swf是否播放
		 */
		private var _isPlaying:Boolean;
		/**
		 * swf的名称
		 */
		private var _resource_name:String;
		/**
		 * swf当前播放的时间
		 */
		private var _play_time:String;
		/**
		 * swf的总时长
		 */
		private var _total_time:String;
		/**
		 * swf文件是否播放完成
		 */
		private var _isEnd:Boolean;
		/**
		 * 媒资id
		 */
		private var _family_media_id:String;
		/**
		 * 素材id
		 */
		private var _family_material_id:String;
		/**
		 * 资源id
		 */
		private var _teaching_resource_id:String;
		
		public function SwfInfo()
		{
		}

		public function get family_material_id():String
		{
			return _family_material_id;
		}

		public function set family_material_id(value:String):void
		{
			_family_material_id = value;
		}

		public function get teaching_resource_id():String
		{
			return _teaching_resource_id;
		}

		public function set teaching_resource_id(value:String):void
		{
			_teaching_resource_id = value;
		}

		public function get family_media_id():String
		{
			return _family_media_id;
		}

		public function set family_media_id(value:String):void
		{
			_family_media_id = value;
		}

		/**
		 * 判断swf文件是否播放完成
		 */
		public function get isEnd():Boolean
		{
			return _isEnd;
		}

		public function set isEnd(value:Boolean):void
		{
			_isEnd = value;
		}

		public function get total_time():String
		{
			return _total_time;
		}

		public function set total_time(value:String):void
		{
			_total_time = value;
		}

		public function get play_time():String
		{
			return _play_time;
		}

		public function set play_time(value:String):void
		{
			_play_time = value;
		}

		public function get resource_name():String
		{
			return _resource_name;
		}

		public function set resource_name(value:String):void
		{
			_resource_name = value;
		}

		public function get isPlaying():Boolean
		{
			return _isPlaying;
		}

		public function set isPlaying(value:Boolean):void
		{
			_isPlaying = value;
		}
		public function toString():String
		{
			return "SwfInfo[isPlaying："+isPlaying+",resource_name:"+resource_name+",play_time:"+play_time+",total_time:"+total_time+",isEnd:"+_isEnd+"]";
		}

	}
}