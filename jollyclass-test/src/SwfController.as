package 
{
	
	import flash.display.MovieClip;
	import flash.events.KeyboardEvent;
	
	
	public class SwfController extends MovieClip
	{
		private var playNum:Number = 1;
		private var mSkipState:Boolean = false;//true允许动画跳转,,false不允许状态
		private var mPlayState:Number = 0;//0动画不允许播放暂停和高亮确定，1动画播放暂停继续状态,,2高亮状态
		
		private var enterLabel:String;
		private var upLabel:String;
		private var downLabel:String;
		
		private var flag:Boolean = true;
		
		//按键码
		private var ENTER_CODE:Number = 83;//确认码值常量
		private var UP_CODE:Number = 82;//上一曲码值常量
		private var DOWN_CODE:Number = 76;//下一曲码值常量
		private var BACK_CODE:Number = 66;//返回码值常量
		private var labels:Array;
		private var swfCurrentLableIndex:int = 0;
		
		public function SwfController()
		{
			//initUI();
		}
		private function initUI():void
		{
			labels = getLables();
			trace(this.currentLabel);
			backGroundMusic_mc.play();
			execSkip(this.currentLabel);
		}
		
		protected function onSkipControllerHandler(event:KeyboardEvent):void
		{
			var code:int = event.keyCode;
			if (code == ENTER_CODE && mPlayState == 2)
			{
				if (enterLabel != "null")
				{
					gotoAndPlay(enterLabel);
					execSkip(this.currentLabel);
				}
			}
			if (code == UP_CODE && mSkipState)
			{
				if (upLabel != "null")
				{
					gotoAndPlay(upLabel);
					trace(this.currentLabel);
					execSkip(this.currentLabel);
				}
			}
			if (code == DOWN_CODE && mSkipState)
			{
				if (downLabel != "null")
				{
					gotoAndPlay(downLabel);
					trace(this.currentLabel);
					execSkip(this.currentLabel);
				}
			}
		}
		
		/**
		 * 
		 * @param event
		 * 
		 */
		protected function onPlayControllerHandler(event:KeyboardEvent):void
		{
			var mKeyCode:int = event.keyCode;
			if (mKeyCode == ENTER_CODE && mPlayState == 1)
			{
				if (flag)
				{
					stop();
					backGroundMusic_mc.stop();
					trace("STOP SUCCESS");
				}
				else
				{
					if (playNum == 1 )
					{
						trace("play play");
						play();
						backGroundMusic_mc.play();
					}
					else
					{
						trace("play stop");
						play();
						backGroundMusic_mc.stop();
					}
					trace("play SUCCESS");
				}
				flag = ! flag;
			}
		}
		//前进后退或者高亮
		private function checkKeyCodeSkip(enterL:String,upL:String,downL:String):void
		{
			enterLabel = enterL;
			upLabel = upL;
			downLabel = downL;
		}
		//=========================动画传参内容===========================
		//正常内容播放返回无跳转
		private function nomalBackToOption():void
		{
			flag = true;
			mPlayState = 1;
			mSkipState = false;
			backGroundMusic_mc.play();
			stage.removeEventListener(KeyboardEvent.KEY_DOWN,onSkipControllerHandler);
			stage.addEventListener(KeyboardEvent.KEY_DOWN,onPlayControllerHandler);
		}
		//正常内容播放返回带有跳转
		private function skipBackToOption():void
		{
			flag = true;
			mPlayState = 1;
			mSkipState = true;
			backGroundMusic_mc.play();
			stage.addEventListener(KeyboardEvent.KEY_DOWN,onSkipControllerHandler);
			stage.addEventListener(KeyboardEvent.KEY_DOWN,onPlayControllerHandler);
		}
		//高亮暂停返回;
		private function hightlightBack():void
		{
			mPlayState = 2;
			mSkipState = true;
			backGroundMusic_mc.stop();
			stage.addEventListener(KeyboardEvent.KEY_DOWN,onSkipControllerHandler);
			stage.removeEventListener(KeyboardEvent.KEY_DOWN,onPlayControllerHandler);
		}
		/*
		1画面暂停无跳转
		2画面暂停带跳转
		*/
		public function onEnd(num:Number):void
		{
			stop();
			backGroundMusic_mc.stop();
			stage.removeEventListener(KeyboardEvent.KEY_DOWN,onPlayControllerHandler);
			if (num == 2)
			{
				mPlayState = 2;
				mSkipState = true;
				stage.addEventListener(KeyboardEvent.KEY_DOWN,onSkipControllerHandler);
			}
		}
		//监听暂停播放
		/*
		0是无反应
		1是普通暂停播放
		2是画面暂停，背景音一直暂停
		*/
		private function setPlayNum(num:Number):int
		{
			return num;
		}
		private function getLables():Array
		{
			var arr:Array = this.currentLabels;
			trace("标签长度："+arr.length);
			for (var i:int=0; i<arr.length; i++)
			{
				trace("name:"+arr[i].name);
			}
			return arr;
		}
		/**
		 
		 处理跳转之后的跳转逻辑
		 */
		private function skipLables(_currentLable:String):void
		{
			trace("skipLables");
			var index:int = getCurrentLableInde(_currentLable);
			if (index!=-1)
			{
				switch (index)
				{
					case 0 :
						trace("labels[i]:"+labels[index].name);
						checkKeyCodeSkip("null",labels[index+1].name,"null");
						break;
					case labels.length-1 :
						onEnd(2);
						break;
					case labels.length-2 :
						checkKeyCodeSkip("null","null",labels[index-1].name);
						break;
					default :
						checkKeyCodeSkip("null",labels[index+1].name,labels[index-1].name);
						break;
				}
			}
		}
		//获取当前标签所在数组的角标
		private function getCurrentLableInde(_currentLable:String):int
		{
			for (var i:int=0; i<labels.length; i++)
			{
				trace("for");
				trace("labels[i] :"+labels[i].name );
				if (labels[i].name == _currentLable)
				{
					trace("start");
					swfCurrentLableIndex = i;
					return i;
				}
			}
			return -1;
		}
		//执行跳转后执行的代码
		private function execSkip(_currentLable:String):void
		{
			skipBackToOption();
			playNum=setPlayNum(1);
			skipLables(this.currentLabel);
		}
		//高亮执行代码
		public function hightCode():void
		{
			trace("arr:"+labels.length);
			stop();
			hightlightBack();
			var nextLable:String = labels[swfCurrentLableIndex + 1].name;
			if (this.currentLabel == labels[0].name)
			{
				checkKeyCodeSkip(nextLable,nextLable,"null");
			}
			else
			{
				var preLable:String = labels[swfCurrentLableIndex - 1].name;
				checkKeyCodeSkip(nextLable,nextLable,preLable);
			}
		}
	}
}