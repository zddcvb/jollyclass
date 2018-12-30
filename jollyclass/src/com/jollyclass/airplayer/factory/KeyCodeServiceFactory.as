package com.jollyclass.airplayer.factory
{
	import com.jollyclass.airplayer.service.KeyCodeService;

	public interface KeyCodeServiceFactory
	{
		function build():KeyCodeService;
	}
}