package
{
	import com.jollyclass.airplayer.constant.PathConst;
	import com.jollyclass.airplayer.constant.SwfKeyCode;
	import com.jollyclass.airplayer.domain.InvokeDataInfo;
	import com.jollyclass.airplayer.domain.SwfInfo;
	import com.jollyclass.airplayer.factory.KeyCodeServiceFactory;
	import com.jollyclass.airplayer.factory.impl.JollyClassKeyCodeFactoryImpl;
	import com.jollyclass.airplayer.service.KeyCodeService;
	import com.jollyclass.airplayer.util.AneUtils;
	import com.jollyclass.airplayer.util.LoggerUtils;
	import com.jollyclass.airplayer.util.ParseDataUtils;
	import com.jollyclass.airplayer.util.SwfInfoUtils;
	
	import flash.desktop.NativeApplication;
	import flash.display.DisplayObject;
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
		[Embed(source="/swf/loading-teacher.swf")]
		private var LoadingUI:Class;
		private var loading_obj:DisplayObject;
		private var _error_loading:Loader=new Loader();
		private var error_info:String;
		public function JollyClassAirPlayer()
		{
			super();
			stage.align = StageAlign.TOP_LEFT;
			stage.scaleMode = StageScaleMode.NO_SCALE;
			this.onStart();
		}
		/**
		 * 启动
		 */
		public function onStart():void{
			showLoadingUI();
			addMainApplicationKeyEvent();
			NativeApplication.nativeApplication.addEventListener(InvokeEvent.INVOKE,onInvokeHandler);
			NativeApplication.nativeApplication.addEventListener(Event.DEACTIVATE,onDeactivateHandler);
		}
		/**
		 * 添加加载动画
		 */
		private function showLoadingUI():void
		{
			loading_obj=new LoadingUI();
			addChild(loading_obj);	
		}
		
		/**
		 * 显示错误对话框，提示用户拨打客服电话
		 */
		private function showErroMsg(info:String):void
		{
			_error_loading.load(new URLRequest(PathConst.ERROR_SWF));
			_error_loading.contentLoaderInfo.addEventListener(Event.COMPLETE,function(event:Event):void{
				addChild(_error_loading);
				var error_mc:MovieClip=event.target.content as MovieClip;
				error_mc.setText(info);
				initErrorKeyEvent();
			});
		}	
		/**
		 * 上报错误信息以及显示错误ui
		 */
		private function sendAndShowErrorMsg(info:String):void
		{
			AneUtils.sendErrorMsg(info);
			showErroMsg(info);
		}
		/**
		 * 监听应用状态为不激活状态时，则直接退出应用。
		 */
		protected function onDeactivateHandler(event:Event):void
		{
			NativeApplication.nativeApplication.removeEventListener(Event.DEACTIVATE,onDeactivateHandler);
			NativeApplication.nativeApplication.exit(0);
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
				if(dataInfo!=null){
					readFileFromAndroidDIC(dataInfo.swfPath);
				}else{
					sendAndShowErrorMsg("jx01");
				}
			}else{
				sendAndShowErrorMsg("jx02");
			}
		}
		
		private function initErrorKeyEvent():void
		{
			stage.addEventListener(KeyboardEvent.KEY_DOWN,onErrorKeyDown);
			stage.removeEventListener(KeyboardEvent.KEY_DOWN,onKeyDownHandler);			
		}
		
		protected function onErrorKeyDown(event:KeyboardEvent):void
		{
			var keycode:int=event.keyCode;
			switch(keycode){
				case SwfKeyCode.BACK_CODE:
				case SwfKeyCode.BACK_DEFAULT_CODE:
				case SwfKeyCode.ENTER_CODE:
					AneUtils.sendData(false);
					NativeApplication.nativeApplication.exit(0);
					break;
				default:
					logger.info(keycode+"","");
					break;
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
				if(file.exists){
					file.addEventListener(Event.COMPLETE,onFileCompleteHandler);
					file.addEventListener(IOErrorEvent.IO_ERROR,onFileErrorHandler);
					try
					{
						file.load();//load方法是异步加载，只有等load完成才能获取子swf文件的数据
					} 
					catch(error:Error) 
					{
						logger.error(error.message,"readFileFromAndroidDIC");
					}
				}else{
					sendAndShowErrorMsg("jx03");
				}
			}
		}
		protected  function onFileErrorHandler(event:IOErrorEvent):void
		{
			sendAndShowErrorMsg("jx04");
		}
		
		protected  function onFileCompleteHandler(event:Event):void
		{
			var fileData:ByteArray=event.currentTarget.data;
			loadSwfFileFromBytes(fileData);
		}
		/**
		 * 加载swf文件，通过bytearray方式
		 */
		private  function loadSwfFileFromBytes(fileDataByteArray:ByteArray):void
		{
			try
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
			catch(error:Error) 
			{
				sendAndShowErrorMsg("jx05");
			}			
		}
		protected function onSwfInitHandler(event:Event):void
		{
			//AneUtils.showShortToast("onSwfInitHandler");
		}
		
		protected function onIOErrorHandler(event:IOErrorEvent):void
		{
			sendAndShowErrorMsg("jx06");
		}
		
		protected function onProgressHandler(event:ProgressEvent):void
		{
			//logger.info("load swf progress","onProgressHandler");
		}
		
		protected function onCompleteHandler(event:Event):void
		{
			//logger.info("load swf complete","onCompleteHandler");
			//AneUtils.showShortToast("loadSwf onCompleteHandler");
			var _loaderInfo:LoaderInfo=event.currentTarget as LoaderInfo;
			_mc = event.target.content as MovieClip;
			addChild(_loader);
			removeChild(loading_obj);
			AneUtils.sendData(true);
			//开始计时
			if(dataInfo.accountInfoFlag==0){
				stopTimer();
			}else{
				startTimer();
			}
		}
		/**
		 * 开启主swf的键盘事件和循环事件
		 */
		private function addMainApplicationKeyEvent():void
		{
			stage.addEventListener(KeyboardEvent.KEY_DOWN,onKeyDownHandler);
			//stage.addEventListener(Event.ENTER_FRAME,onEnterFrameHandler);	
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
			//logger.info("================onkeyDownHandler================","onKeyDownHandler");
			var keyCode:int=event.keyCode;
			//AneUtils.showShortToast("映射之前的键值："+keyCode);
			//映射代码
			event.keyCode=switchKeyCode(keyCode);
			if (event.keyCode==SwfKeyCode.BACK_REFLECT_CODE) 
			{
				onDestory();	
			}
			//通过子swf文件调用父类的方法
			_mc.getParentMethod(this);			
		}
		/**
		 * 执行遥控器键值映射
		 */
		private function switchKeyCode(keyCode:int):int
		{
			var keyCodeServiceFactory:KeyCodeServiceFactory=new JollyClassKeyCodeFactoryImpl();
			var keyCodeService:KeyCodeService=keyCodeServiceFactory.build();
			return keyCodeService.switchKeyCode(keyCode);
		}
		/**
		 * 开启计时
		 */
		private function startTimer():void
		{
			timer=new Timer(10000,1);
			timer.addEventListener(TimerEvent.TIMER,onTimer);
			timer.addEventListener(TimerEvent.TIMER_COMPLETE,onTimerCompleteHandler);
			timer.start();	
		}
		/**
		 * 停止计时
		 */
		private  function stopTimer():void
		{
			if (timer!=null) 
			{
				timer.stop();
			}	
		}
		protected function onTimerCompleteHandler(event:TimerEvent):void
		{
			//logger.info("========onTimerCompleteHandler================","onTimerCompleteHandler");
			loadDialogSwf(PathConst.DAILOG_SWF);
		}
		protected function onTimer(event:TimerEvent):void
		{
			//logger.info("========onTimer================","onTimer");	
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
			logger.error("================onDialogErrorHandler================","onDialogErrorHandler");
		}
		
		protected function onDialogProgressHandler(event:ProgressEvent):void
		{
			//logger.info("================onDialogProgressHandler================","onDialogProgressHandler");
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
			AneUtils.sendData(false);
			//根据账户的类型，显示不同的页面。
			switch(dataInfo.accountInfoFlag)
			{
				case 1:
				{
					_dialog_mc.initConnectUI();
					break;
				}
				case 2:
				case 3:
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
			//stage.removeEventListener(Event.ENTER_FRAME,onEnterFrameHandler);	
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
			//AneUtils.showShortToast("当前键值代码："+event.keyCode+":当前帧数"+_dialog_mc.currentFrame)
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
			//logger.info("app exit","onDestory");
			var exitInfo:SwfInfo=SwfInfoUtils.getSwfInfo(dataInfo,_mc);
			AneUtils.sendDataFromAction(exitInfo.isPlaying,PathConst.APK_BROADCAST,exitInfo.resource_name,exitInfo.play_time,exitInfo.total_time,exitInfo.isPlayFinished);
			NativeApplication.nativeApplication.exit(0);
		}
		
		
	}
}