package com.jollyclass.airplayer.service.impl
{
	import com.jollyclass.airplayer.constant.SwfKeyCode;
	import com.jollyclass.airplayer.service.KeyCodeService;
	/**
	 * 通用键值映射，将遥控器发送的键值转换成通用键值，即与键盘的键值一致，主要针对左、上、右、下、返回、确定/播放/暂停进行映射，改成键盘方向键和backspace、enter键
	 * @author 邹丹丹
	 */
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