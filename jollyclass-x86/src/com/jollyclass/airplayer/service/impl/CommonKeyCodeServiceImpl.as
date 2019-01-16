package com.jollyclass.airplayer.service.impl
{
	import com.jollyclass.airplayer.constant.SwfKeyCode;
	import com.jollyclass.airplayer.service.KeyCodeService;
	
	public class CommonKeyCodeServiceImpl implements KeyCodeService
	{
		public function CommonKeyCodeServiceImpl()
		{
		}
		
		public function switchKeyCode(keyCode:int):int
		{
			var code:int;
			if(keyCode==SwfKeyCode.BACK_CODE){
				code=SwfKeyCode.BACK_COMMON_CODE;
			}else{
				code=keyCode;
			}
			return code;
		}
	}
}