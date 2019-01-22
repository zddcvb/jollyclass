package com.jollyclass.airplayer.domain
{
	/**
	 * 第一版的数据接收的类，只针对教学端
	 * @author 邹丹丹
	 */
	public class InvokeDataInfo
	{
		/**
		 * swf在android目录中的绝对路径
		 * file:///storage/emulated/0/1/大声说爱_故事理解.swf
		 */
		private var _swfPath:String;
		/**
		 * 0://已付费会员可以正常播放
		 * 1://未开通服务且未绑定园所（播放10s,弹出扫码关联园所窗口）
	     * 2://未开通服务已经绑定园所（播放10s,弹出开通服务窗口）
		 * 3://开通服务已到期;（播放10s,弹出开通服务窗口）
		 */
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
			return "InvokeDataInfo[swfPath:"+_swfPath+",accountInfoFlag:"+accountInfoFlag+"]";
		}
	}
}