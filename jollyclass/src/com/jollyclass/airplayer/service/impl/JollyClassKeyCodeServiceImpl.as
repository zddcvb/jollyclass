package com.jollyclass.airplayer.service.impl
{
	import com.jollyclass.airplayer.constant.SwfKeyCode;
	import com.jollyclass.airplayer.service.KeyCodeService;
	
	public class JollyClassKeyCodeServiceImpl implements KeyCodeService
	{
		public function JollyClassKeyCodeServiceImpl()
		{
		}
		
		public function switchKeyCode(keyCode:int):int
		{
			var code:int;
			switch(keyCode){
				case SwfKeyCode.ENTER_CODE:
					code=SwfKeyCode.ENTER_REFLECT_CODE;
					break;
				case SwfKeyCode.LEFT_CODE:
					code=SwfKeyCode.LEFT_REFLECT_CODE;
					break;
				case SwfKeyCode.RIGHT_CODE:
					code=SwfKeyCode.RIGHT_REFLECT_CODE;
					break;
				case SwfKeyCode.BACK_CODE:
				case SwfKeyCode.BACK_DEFAULT_CODE:
					code=SwfKeyCode.BACK_REFLECT_CODE;
					break;
				case SwfKeyCode.UP_CODE:
					code=SwfKeyCode.UP_REFLECT_CODE;
					break;
				case SwfKeyCode.DOWN_CODE:
					code=SwfKeyCode.DOWN_REFLECT_CODE;
					break;
				default:
					code=keyCode;
					break;
			}
			return code;
		}
	}
}