package
{
	import com.jollyclass.airplayer.constant.PathConst;
	import com.jollyclass.airplayer.constant.SwfKeyCode;
	import com.jollyclass.airplayer.domain.DataInfo;
	import com.jollyclass.airplayer.domain.SwfInfo;
	import com.jollyclass.airplayer.factory.KeyCodeServiceFactory;
	import com.jollyclass.airplayer.factory.impl.JollyClassKeyCodeFactoryImpl;
	import com.jollyclass.airplayer.service.KeyCodeService;
	import com.jollyclass.airplayer.util.AneUtils;
	import com.jollyclass.airplayer.util.LoggerUtils;
	import com.jollyclass.airplayer.util.ParseDataUtils;
	import com.jollyclass.airplayer.util.ShapeUtil;
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
		private var dataInfo:DataInfo;
		private var _loader:Loader=new Loader();
		private var _mc:MovieClip;
		private var teacherTimer:Timer;
		private var familyTimer:Timer;
		private var _dialog_loader:Loader=new Loader();
		private var _dialog_mc:MovieClip;
		[Embed(source="/swf/loading-teacher.swf")]
		private var LoadingTeacherUI:Class;
		[Embed(source="/swf/loading-family.swf")]
		private var LoadingFamilyUI:Class;
		private var loading_obj:DisplayObject;
		private var _error_loading:Loader=new Loader();
		private var _player_loading:Loader=new Loader();
		private var player_mc:MovieClip;
		private var swfInfo:SwfInfo;
		private var isShowing:Boolean=false;
		private var blackShape:Shape;
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
			showBlackUI();
			addMainApplicationKeyEvent();
			NativeApplication.nativeApplication.addEventListener(InvokeEvent.INVOKE,onInvokeHandler);
			NativeApplication.nativeApplication.addEventListener(Event.DEACTIVATE,onDeactivateHandler);
		}
		/**
		 * 显示首屏的黑屏画面，避免flash加载的白屏出现
		 */
		private function showBlackUI():void
		{
			blackShape=ShapeUtil.createShape();
			addChild(blackShape);
		}
		/**
		 * 添加加载动画,根据type值判定加载哪个加载动画
		 */
		private function showLoadingUI(type:int):void
		{
			if(type==1){
				loading_obj=new LoadingFamilyUI();
			}else{
				loading_obj=new LoadingTeacherUI();
			}
			addChild(loading_obj);	
		}
		
		/**
		 * 显示错误对话框，提示用户拨打客服电话
		 */
		private function showErroMsg( info:String):void
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
		 * 添加播放器皮肤，获得皮肤的影片剪辑，但不显示在stage中。
		 */
		private function addPlayer():void
		{
			_player_loading.load(new URLRequest(PathConst.PLAYER_SWF));
			_player_loading.contentLoaderInfo.addEventListener(Event.COMPLETE,function(event:Event):void{
				player_mc=event.target.content as MovieClip;
				//添加播放器皮肤，并隐藏
				player_mc.hidePlayer();
				addChild(_player_loading);
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
				dataInfo=ParseDataUtils.parseDataFor2Platform(args);
				if(dataInfo!=null){
					if(dataInfo.classType==1){
						showLoadingUI(dataInfo.classType);
						removeChild(blackShape);
					}
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
		}
		
		protected function onIOErrorHandler(event:IOErrorEvent):void
		{
			sendAndShowErrorMsg("jx06");
		}
		
		protected function onProgressHandler(event:ProgressEvent):void
		{
		}
		
		protected function onCompleteHandler(event:Event):void
		{
			var _loaderInfo:LoaderInfo=event.currentTarget as LoaderInfo;
			_mc = event.target.content as MovieClip;
			addChild(_loader);
			removeChild(loading_obj);
			
			AneUtils.sendData(true);
			if(dataInfo.classType==1){
				addPlayer();
			}else{
				//开始计时
				if(dataInfo.accountInfoFlag==0){
					stopTimer();
				}else{
					startTimer();
				}
			}
			swfInfo=SwfInfoUtils.getSwfInfo(dataInfo,_mc);
			swfInfo.isPlaying=true;
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
				player_mc.setNowTime(SwfInfoUtils.getSwfTimeFormatter(_currentFrame));
				var _rate:int=Math.round(Math.abs(_mc.currentFrame/_mc.totalFrames)*100);
				player_mc.setProgressTxPlay(_rate);
			}		
		}
		/**
		 * 1、播放状态，执行ok键，则swf文件暂停，画面显示暂停标志和进度条、课件名称。
		 * 2、播放状态下，执行左右按钮，快进快退功能，进度条和时间也进行相应的变化，不进行任何操作5s后，进度条消失。
		 * 3、播放状态下，执行上下操作显示进度条，不操作5s后，自动消失。
		 * 4、暂停状态下，不进行任何操作时，一直显示进度条和暂停按钮；
		 * 5、暂停状态下，执行左右按钮快进快退，进度条和时间相应变化，但暂停按钮也一直存在。若不进行任何操作5s后，进度条和时间消失，暂停按钮也还在。
		 * 6、打开flash课件时，首先播放加载动画，flash课件加载完成后，加载动画消失。
		 * 7、打开flash课件失败时，则显示失败的对话框。
		 */
		protected function onKeyDownHandler(event:KeyboardEvent):void
		{
			var keyCode:int=event.keyCode;
			//映射代码
			event.keyCode=switchKeyCode(keyCode);
			if (event.keyCode==SwfKeyCode.BACK_REFLECT_CODE) 
			{
				onDestory();	
			}
			if(dataInfo.classType==1){
				player_mc.setSwfNameText(swfInfo.resource_name);
				player_mc.setTotalTime(swfInfo.total_time);
				switch(event.keyCode)
				{					
					case SwfKeyCode.ENTER_REFLECT_CODE:
					{
						if(swfInfo.isPlaying){
							_mc.stop();
							player_mc.pause_mc.visible=true;
							player_mc.setNowTime(SwfInfoUtils.getSwfTimeFormatter(_mc.currentFrame));
							var _rate:int=Math.round(Math.abs(_mc.currentFrame/_mc.totalFrames)*100);
							player_mc.setProgressTxStop(_rate);
							player_mc.showPlayer();
							isShowing=true;
							swfInfo.isPlaying=true;
							startPlayerTimer();
						}else{
							player_mc.hidePlayer()
							_mc.play();
							isShowing=false;
							swfInfo.isPlaying=false;
							stopPlayerTimer();
						}
						swfInfo.isPlaying=!swfInfo.isPlaying;
						break;
					}
					case SwfKeyCode.LEFT_REFLECT_CODE:
						stopPlayerTimer();
						var preFrame:int=_mc.currentFrame-120;
						if(preFrame<=0){
							preFrame=1;
						}
						var _left_rate:int=Math.round(Math.abs(_mc.currentFrame/_mc.totalFrames)*100);
						if(swfInfo.isPlaying){
							_mc.gotoAndPlay(preFrame);
							player_mc.setNowTime(SwfInfoUtils.getSwfTimeFormatter(preFrame));
							player_mc.setProgressTxPlay(_left_rate);
						}else{
							_mc.gotoAndStop(preFrame);
							player_mc.setNowTime(SwfInfoUtils.getSwfTimeFormatter(preFrame));
							player_mc.setProgressTxStop(_left_rate);
						}
						if(isShowing){
							startPlayerTimer();
						}
						break;
					case SwfKeyCode.RIGHT_REFLECT_CODE:
						stopPlayerTimer();
						var nextFrame:int=_mc.currentFrame+120;
						if(nextFrame>_mc.totalFrames){
							nextFrame=_mc.totalFrames;
						}
						
						if(nextFrame==_mc.totalFrames){
							_mc.gotoAndStop(nextFrame);
							swfInfo.isPlaying=false;
						}
						var _right_rate:int=Math.round(Math.abs(_mc.currentFrame/_mc.totalFrames)*100);
						var _right_nowTime:String=SwfInfoUtils.getSwfTimeFormatter(nextFrame);
						if(swfInfo.isPlaying){
							_mc.gotoAndPlay(nextFrame);
							player_mc.setNowTime(_right_nowTime);
							player_mc.setProgressTxPlay(_right_rate);
						}else{
							_mc.gotoAndStop(nextFrame);
							player_mc.setNowTime(_right_nowTime);
							player_mc.setProgressTxStop(_right_rate);
						}
						if(isShowing){
							startPlayerTimer();
						}
						break;
					case SwfKeyCode.UP_REFLECT_CODE:
						//开启循环获取时间
						if(!isShowing){
							player_mc.showNameAndProgress();
							if(swfInfo.isPlaying){
								stage.addEventListener(Event.ENTER_FRAME,onEnterFrameHandler);
							}else{
								stage.removeEventListener(Event.ENTER_FRAME,onEnterFrameHandler);
							}
						}
						isShowing=!isShowing;
						startPlayerTimer();
						break;
					case SwfKeyCode.DOWN_REFLECT_CODE:
						if(isShowing){
							player_mc. hideNameAndProgress();
							stage.removeEventListener(Event.ENTER_FRAME,onEnterFrameHandler);
						}
						isShowing=!isShowing;
						stopPlayerTimer();
						break;
					default:
					{
						break;
					}
				}
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
		 * 开启关联和开通服务计时
		 */
		private function startTimer():void
		{
			teacherTimer=new Timer(10000,1);
			teacherTimer.addEventListener(TimerEvent.TIMER_COMPLETE,function(event:TimerEvent):void{
				loadDialogSwf(PathConst.DAILOG_SWF);
			});
			teacherTimer.start();	
		}
		/**
		 * 停止计时
		 */
		private  function stopTimer():void
		{
			if (teacherTimer!=null) 
			{
				teacherTimer.stop();
			}	
		}
		/**
		 * 开启家庭端播放计时
		 */
		private function startPlayerTimer():void
		{
			familyTimer=new Timer(3000,1);
			familyTimer.addEventListener(TimerEvent.TIMER_COMPLETE,function(event:TimerEvent):void{
				if(isShowing){
					player_mc.hideNameAndProgress();
					stage.removeEventListener(Event.ENTER_FRAME,onEnterFrameHandler);
					isShowing=false;
				}
			});
			familyTimer.start();
		}
		private function stopPlayerTimer():void
		{
			if(familyTimer!=null){
				familyTimer.stop();
			}
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
		}
		
		protected function onDialogProgressHandler(event:ProgressEvent):void
		{
		}
		protected function onDialogCompleteHandler(event:Event):void
		{
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
			var exitInfo:SwfInfo=SwfInfoUtils.getSwfInfo(dataInfo,_mc);
			AneUtils.sendDataFromAction(exitInfo.isPlaying,PathConst.APK_BROADCAST,exitInfo.resource_name,exitInfo.play_time,exitInfo.total_time,exitInfo.isPlayFinished);
			NativeApplication.nativeApplication.exit(0);
		}
		
	}
}