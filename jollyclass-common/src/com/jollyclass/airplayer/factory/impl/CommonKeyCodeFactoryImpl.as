package com.jollyclass.airplayer.factory.impl
{
	import com.jollyclass.airplayer.factory.KeyCodeServiceFactory;
	import com.jollyclass.airplayer.service.KeyCodeService;
	import com.jollyclass.airplayer.service.impl.CommonKeyCodeServiceImpl;
	
	public class CommonKeyCodeFactoryImpl implements KeyCodeServiceFactory
	{
		public function CommonKeyCodeFactoryImpl()
		{
		}
		
		public function build():KeyCodeService
		{
			return new CommonKeyCodeServiceImpl();
		}
	}
}