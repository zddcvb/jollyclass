package
{
	import com.jollyclass.airplayer.constant.MessageConst;
	import com.jollyclass.airplayer.constant.PathConst;
	import com.jollyclass.airplayer.constant.SwfKeyCode;
	import com.jollyclass.airplayer.domain.InvokeDataInfo;
	import com.jollyclass.airplayer.util.AneUtils;
	import com.jollyclass.airplayer.util.LoggerUtils;
	import com.jollyclass.airplayer.util.ParseDataUtils;
	import com.jollyclass.airplayer.util.ShapeUtil;
	
	import flash.desktop.NativeApplication;
	import flash.display.Loader;
	import flash.display.LoaderInfo;
	import flash.display.MovieClip;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.InvokeEvent;
	import flash.events.KeyboardEvent;
	import flash.events.ProgressEvent;
	import flash.events.TimerEvent;
	import flash.filesystem.File;
	import flash.net.URLRequest;
	import flash.system.ApplicationDomain;
	import flash.system.LoaderContext;
	import flash.utils.ByteArray;
	import flash.utils.Timer;
	
	public class JollyClassAirPlayer extends Sprite
	{
		private static var logger:LoggerUtils=new LoggerUtils("JollyClassAirPlayer");
		private var dataInfo:InvokeDataInfo;
		private var fileDataByteArray:ByteArray;
		private var _loader:Loader=new Loader();
		private var screenMaskShape:Shape;
		private var _mc:MovieClip;
		private var timer:Timer;
		private var _dialog_loader:Loader=new Loader();
		private var _dialog_mc:MovieClip;
		public function JollyClassAirPlayer()
		{
			super();
			stage.align = StageAlign.TOP_LEFT;
			stage.scaleMode = StageScaleMode.NO_SCALE;
			this.onStart();
		}
		
		public function onStart():void{
			logger.info("airplayer onStart","onStart");
			AneUtils.sendData("airplayer start");
			screenMaskShape=ShapeUtil.createShape();
			addChild(screenMaskShape);
			NativeApplication.nativeApplication.addEventListener(InvokeEvent.INVOKE,onInvokeHandler);
		}
		/**
		 * 接收android系统发送的消息
		 */
		protected function onInvokeHandler(event:InvokeEvent):void
		{
			var args:Array=event.arguments;
			if (args.length>0) 
			{
				dataInfo=ParseDataUtils.parseDataFromSystem(args);
				logger.info(dataInfo.toString(),"");
				AneUtils.showShortToast(dataInfo.toString());
				readFileFromAndroidDIC(dataInfo.swfPath);
			}			
		}
		/**
		 * 从android目录下读取文件
		 */
		private function readFileFromAndroidDIC(swfPath:String):void
		{
			if (swfPath!=null) 
			{
				var file:File=new File(swfPath);
				file.addEventListener(Event.COMPLETE,onFileCompleteHandler);
				file.addEventListener(IOErrorEvent.IO_ERROR,onFileErrorHandler);
				file.load();
			}
		}
		protected  function onFileErrorHandler(event:IOErrorEvent):void
		{
			logger.info("file don't exit","onFileErrorHandler");
			AneUtils.sendData(MessageConst.READ_FILE_ERROR);
			NativeApplication.nativeApplication.exit(0);
		}
		
		protected  function onFileCompleteHandler(event:Event):void
		{
			logger.info("onFileCompleteHandler","onFileCompleteHandler");
			var fileData:ByteArray=event.currentTarget.data;	
			AneUtils.showShortToast("fileData"+fileData.toString());
			loadSwfFileFromBytes(fileData);
		}
		/**
		 * 加载swf文件，通过bytearray方式
		 */
		private  function loadSwfFileFromBytes(fileDataByteArray:ByteArray):void
		{
			var _context:LoaderContext=new LoaderContext();
			_context.allowCodeImport=true;
			_context.applicationDomain=ApplicationDomain.currentDomain;
			_loader.loadBytes(fileDataByteArray,_context);	
			_loader.contentLoaderInfo.addEventListener(Event.INIT,onSwfInitHandler);
			_loader.contentLoaderInfo.addEventListener(Event.COMPLETE,onCompleteHandler);
			_loader.contentLoaderInfo.addEventListener(ProgressEvent.PROGRESS,onProgressHandler);
			_loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR,onIOErrorHandler);
		}
		
		protected function onSwfInitHandler(event:Event):void
		{
			AneUtils.showShortToast("onSwfInitHandler");
		}
		
		protected function onIOErrorHandler(event:IOErrorEvent):void
		{
			logger.info("load swf error","onIOErrorHandler");
			AneUtils.sendData(MessageConst.LOAD_SWF_ERROR);
			onDestory();
		}
		
		protected function onProgressHandler(event:ProgressEvent):void
		{
			logger.info("load swf progress","onProgressHandler");
		}
		
		protected function onCompleteHandler(event:Event):void
		{
			logger.info("load swf complete","onCompleteHandler");
			AneUtils.showShortToast("loadSwf onCompleteHandler");
			var _loaderInfo:LoaderInfo=event.currentTarget as LoaderInfo;
			addMainApplicationKeyEvent();
			_mc = event.target.content as MovieClip;
			addChild(_loader);
			removeChild(screenMaskShape);
			//开始计时
			//startTimer();
		}
		/**
		 * 开启主swf的键盘事件和循环事件
		 */
		private function addMainApplicationKeyEvent():void
		{
			stage.addEventListener(KeyboardEvent.KEY_DOWN,onKeyDownHandler);
			stage.addEventListener(Event.ENTER_FRAME,onEnterFrameHandler);	
		}
		/**
		 * 循环获取当前swf文件的帧数
		 */
		protected function onEnterFrameHandler(event:Event):void
		{
			if(_mc!=null){
				var _currentFrame:int=_mc.currentFrame;
				logger.info("onEnterFrameHandler:"+_currentFrame,"onEnterFrameHandler");
			}		
		}
		protected function onKeyDownHandler(event:KeyboardEvent):void
		{
			logger.info("================onkeyDownHandler================","onKeyDownHandler");
			var keycode:int=event.keyCode;
			event.keyCode=switchKeyCode(keycode);
			if (event.keyCode==SwfKeyCode.BACK_REFLECT_CODE) 
			{
				onDestory();	
			}
			//通过子swf文件调用父类的方法
			_mc.getParentMethod(this);			
		}
		/**
		 * 映射遥控器的按键键值
		 */
		private function switchKeyCode(keycode:int):int{
			var code:int;
			switch(keycode){
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
				default:
					break;
			}
			return code;
		}
		private function startTimer():void
		{
			timer=new Timer(10000,1);
			timer.addEventListener(TimerEvent.TIMER,onTimer);
			timer.addEventListener(TimerEvent.TIMER_COMPLETE,onTimerCompleteHandler);
			timer.start();	
		}
		private  function stopTimer():void
		{
			if (timer!=null) 
			{
				timer.stop();
			}	
		}
		protected function onTimerCompleteHandler(event:TimerEvent):void
		{
			logger.info("========onTimerCompleteHandler================","onTimerCompleteHandler");
			loadDialogSwf(PathConst.DAILOG_SWF);
		}
		protected function onTimer(event:TimerEvent):void
		{
			logger.info("========onTimer================","onTimer");	
		}
		/**
		 * 加载内置的对话框界面
		 */
		private function loadDialogSwf(swfPath:String):void
		{
			_dialog_loader.load(new URLRequest(swfPath));
			_dialog_loader.contentLoaderInfo.addEventListener(Event.COMPLETE,onDialogCompleteHandler);
			_dialog_loader.contentLoaderInfo.addEventListener(ProgressEvent.PROGRESS,onDialogProgressHandler);
			_dialog_loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR,onDialogErrorHandler);	
		}
		
		protected function onDialogErrorHandler(event:IOErrorEvent):void
		{
			logger.info("================onDialogErrorHandler================","onDialogErrorHandler");
			AneUtils.sendData(MessageConst.LOAD_SWF_ERROR);
		}
		
		protected function onDialogProgressHandler(event:ProgressEvent):void
		{
			logger.info("================onDialogProgressHandler================","onDialogProgressHandler");
		}
		protected function onDialogCompleteHandler(event:Event):void
		{
			logger.info("================onDialogCompleteHandler================","onDialogCompleteHandler");
			var _loaderInfo:LoaderInfo=event.currentTarget as LoaderInfo;
			_dialog_mc=event.target.content as MovieClip;
			addChild(_dialog_loader);
			pauseMainSwf()
			initDialogSwf();
			stopTimer();
			AneUtils.showShortToast("当前账户类型："+dataInfo.accountInfoFlag);
			//根据账户的类型，显示不同的页面。
			switch(dataInfo.accountInfoFlag)
			{
				case 0:
				{
					_dialog_mc.initConnectUI();
					break;
				}
				case 1:
				{
					_dialog_mc.goServiceUI();
					break;
				}
				default:
				{
					break;
				}
			}
			
		}
		/**
		 * 暂停主swf的播放，移除键盘事件和循环事件
		 */
		private function pauseMainSwf():void
		{
			_mc.stopAllMovieClips();
			stage.removeEventListener(KeyboardEvent.KEY_DOWN,onKeyDownHandler);
			stage.removeEventListener(Event.ENTER_FRAME,onEnterFrameHandler);	
		}
		
		private function initDialogSwf():void{
			stage.addEventListener(KeyboardEvent.KEY_DOWN,onDialogKeyDown);
		}
		private function removeDialgoSwfEvent():void{
			stage.removeEventListener(KeyboardEvent.KEY_DOWN,onDialogKeyDown);
		}
		protected function onDialogKeyDown(event:KeyboardEvent):void
		{
			event.keyCode=switchKeyCode(event.keyCode);
			AneUtils.showShortToast("当前键值代码："+event.keyCode+":当前帧数"+_dialog_mc.currentFrame)
			if (event.keyCode==SwfKeyCode.BACK_REFLECT_CODE) 
			{
				onDestory();
			}
			_dialog_mc.getParentMethod(this);
		}
		/**
		 * 打开系统扫码注册页面
		 */
		public function openConnectApk():void{
			logger.info("================main dialog openConnectApk================","openConnectApk");
			unloadDialogUI();
			AneUtils.openApk(PathConst.PACKAGE_NAME,PathConst.CONNECT_CLASS_NAME);
			onDestory();
		}
		/**
		 * 不注册时，退出对话框
		 */
		public function unloadDialogUI():void{
			logger.info("================main dialogunloadDialogUI================","unloadDialogUI");
			removeDialgoSwfEvent()
			_dialog_loader.unloadAndStop(true);
			onDestory();
		}
		/**
		 * 开通服务页面
		 */
		public function openServiceApk():void{
			logger.info("================main dialog openServiceApk================","openServiceApk");
			unloadDialogUI();
			AneUtils.openApk(PathConst.PACKAGE_NAME,PathConst.SERVER_OPEN_NAME);
			onDestory();
		}
		/**
		 * 销毁当前应用
		 */
		public function onDestory():void
		{
			logger.info("onDestory","onDestory");
			AneUtils.sendData(MessageConst.AIRPLAYER_EIXT);
			NativeApplication.nativeApplication.exit(0);
		}
	}
}