package com.jollyclass.airplayer.domain
{

	public class AirPlayerExitInfo
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
		 * 判断swf文件是否播放完成
		 */
		private var _isPlayFinished:Boolean;
		public function AirPlayerExitInfo()
		{
		}
		
		public function get isPlayFinished():Boolean
		{
			return _isPlayFinished;
		}

		/**
		 * @private
		 */
		public function set isPlayFinished(value:Boolean):void
		{
			_isPlayFinished = value;
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
			return "AirPlayerExitInfo[isPlaying："+isPlaying+",resource_name:"+resource_name+",play_time:"+play_time+",total_time:"+total_time+",isPlayFinished:"+isPlayFinished+"]";
		}

	}
}