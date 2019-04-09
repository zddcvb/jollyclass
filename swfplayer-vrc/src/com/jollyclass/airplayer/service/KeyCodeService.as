package com.jollyclass.airplayer.service
{
	/**
	 * 键值映射的接口类
	 */
	public interface KeyCodeService
	{
		/**
		 * 处理键值映射，根据keyCode值，转换成所需的键值，并返回
		 */
		 function switchKeyCode(keyCode:int):int;
	}
}