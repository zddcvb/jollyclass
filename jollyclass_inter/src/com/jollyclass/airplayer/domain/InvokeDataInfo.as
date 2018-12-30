package com.jollyclass.airplayer.domain
{
	public class InvokeDataInfo
	{
		private var _swfPath:String;
		private var _accountInfoFlag:Number;
		public function InvokeDataInfo()
		{
		}

		public function get accountInfoFlag():Number
		{
			return _accountInfoFlag;
		}

		public function set accountInfoFlag(value:Number):void
		{
			_accountInfoFlag = value;
		}

		public function get swfPath():String
		{
			return _swfPath;
		}

		public function set swfPath(value:String):void
		{
			_swfPath = value;
		}

		public function toString():String
		{
			return "InvokeDataInfo:[swfPath:"+_swfPath+",accountInfoFlag:"+accountInfoFlag+"]";
		}
	}
}