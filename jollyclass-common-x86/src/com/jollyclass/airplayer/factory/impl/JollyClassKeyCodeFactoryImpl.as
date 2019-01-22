package com.jollyclass.airplayer.factory.impl
{
	import com.jollyclass.airplayer.factory.KeyCodeServiceFactory;
	import com.jollyclass.airplayer.service.KeyCodeService;
	import com.jollyclass.airplayer.service.impl.JollyClassKeyCodeServiceImpl;
	/**
	 * 小水滴课堂键值映射方案工厂类
	 * @author 邹丹丹
	 */
	public class JollyClassKeyCodeFactoryImpl implements KeyCodeServiceFactory
	{
		public function JollyClassKeyCodeFactoryImpl()
		{
		}
		
		public function build():KeyCodeService
		{
			return new JollyClassKeyCodeServiceImpl();
		}
		
	}
}