package com.jollyclass.airplayer.factory
{
	import com.jollyclass.airplayer.service.KeyCodeService;
	/**
	 * 键值映射创建的工厂类
	 * 主要目的是为了后续扩展，增添第三方或者多方的键值映射，特采用工厂设计模式进行扩展，保证各方键值进行解绑，便于创建多方键值映射方案
	 * @author 邹丹丹
	 */
	public interface KeyCodeServiceFactory
	{
		/**
		 * 创建键值映射类，返回一个keyCodeService接口
		 */
		function build():KeyCodeService;
	}
}