package com.jollyclass.airplayer.domain
{

	public class AirPlayerExitInfo
	{
		private var _isPlaying:Boolean;
		private var _resource_name:String;
		private var _play_time:String;
		private var _total_time:String;
		public function AirPlayerExitInfo()
		{
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
			return "AirPlayerExitInfo[isPlaying："+isPlaying+",resource_name:"+resource_name+",play_time:"+play_time+",total_time:"+total_time+"]";
		}

	}
}