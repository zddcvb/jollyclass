package com.jollyclass.airplayer.domain
{
	/**
	 * 播放器传输给android应用的数据信息
	 */
	public class AirPlayerSendInfo
	{
		private var _msg:String;
		private var _type:int;
		public function AirPlayerSendInfo()
		{
		}
		
		public function get type():int
		{
			return _type;
		}

		public function set type(value:int):void
		{
			_type = value;
		}

		public function get msg():String
		{
			return _msg;
		}

		public function set msg(value:String):void
		{
			_msg = value;
		}

		public function toString():String
		{
			return "AirPlayerSendInfo[msg:"+msg+",type:"+type+"]";
		}
	}
}