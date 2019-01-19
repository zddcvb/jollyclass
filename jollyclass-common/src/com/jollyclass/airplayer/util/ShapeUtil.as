package com.jollyclass.airplayer.util
{
	import flash.display.Shape;

	/**
	 * 为主应用创建各种元件
	 * @author 邹丹丹
	 */
	public class ShapeUtil
	{
		public function ShapeUtil()
		{
		}
		/**
		 * 为主应用创建遮罩
		 */
		public static function createShape():Shape
		{
			var shape:Shape=new Shape();
			shape.graphics.beginFill(0x000000,1);
			shape.graphics.drawRect(0,0,1920,1080);
			shape.graphics.endFill();
			return shape;
		}
		
	}
}