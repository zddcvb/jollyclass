package
{
	import com.jollyclass.airplayer.constant.ErrorMsgNumber;
	import com.jollyclass.airplayer.constant.FieldConst;
	import com.jollyclass.airplayer.constant.PathConst;
	import com.jollyclass.airplayer.constant.SwfKeyCode;
	import com.jollyclass.airplayer.domain.JollyClassDataInfo;
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
	import flash.display.MovieClip;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.InvokeEvent;
	import flash.events.KeyboardEvent;
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
		/**
		 * 2个动画的加载器和元件
		 */
		private var _loader:Loader=new Loader();
		private var _dialog_loader:Loader=new Loader();
		private var course_mc:MovieClip;
		private var player_mc:MovieClip;
		private var dialog_mc:MovieClip;
		/**
		 * 两个类型的计时器
		 */
		private var teacherTimer:Timer;
		private var familyTimer:Timer;
		/**
		 * 两个内嵌的加载动画
		 */
		[Embed(source="/swf/loading-teacher.swf")]
		private var LoadingTeacherUI:Class;
		[Embed(source="/swf/loading-family.swf")]
		private var LoadingFamilyUI:Class;
		private var loading_obj:DisplayObject;
		private var dataInfo:JollyClassDataInfo;
		private var swfInfo:SwfInfo;
		private var blackShape:Shape;
		private var isShowing:Boolean=false;
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
		private function showLoadingUI(type:String):void
		{
			if(type==FieldConst.FAMILY_BOX){
				loading_obj=new LoadingFamilyUI();
			}else if(type==FieldConst.TEACHING_BOX){
				loading_obj=new LoadingTeacherUI();
			}
			addChild(loading_obj);	
		}
		
		/**
		 * 显示错误对话框，提示用户拨打客服电话
		 */
		private function showErroMsg( info:String,telNum:String):void
		{
			var _error_loading:Loader=new Loader();
			_error_loading.load(new URLRequest(PathConst.ERROR_SWF));
			_error_loading.contentLoaderInfo.addEventListener(Event.COMPLETE,function(event:Event):void{
				addChild(_error_loading);
				var error_mc:MovieClip=event.target.content as MovieClip;
				error_mc.setText(info,telNum);
				initErrorKeyEvent();
			});
		}
		/**
		 * 添加播放器皮肤，获得皮肤的影片剪辑，但不显示在stage中。
		 */
		private function addPlayer():void
		{
			var _player_loading:Loader=new Loader();
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
		private function sendAndShowErrorMsg(info:String,telNum:String):void
		{
			AneUtils.sendErrorMsg(info);
			showErroMsg(info,telNum);
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
				dataInfo=ParseDataUtils.parseDataInfo(args);
				if(dataInfo!=null){
					showLoadingUI(dataInfo.product_type);
					removeChild(blackShape);
					readFileFromAndroidDIC(dataInfo.swfPath);
				}else{
					sendAndShowErrorMsg(ErrorMsgNumber.PARSE_DATA_ERROR,dataInfo.customer_service_tel);
				}
			}else{
				sendAndShowErrorMsg(ErrorMsgNumber.INOVKE_DATA_LENGTH_ERROR,FieldConst.DEFAULT_TELPHONE);
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
					onDestroy();
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
					sendAndShowErrorMsg(ErrorMsgNumber.FILE_NOT_EXITS,dataInfo.customer_service_tel);
				}
			}
		}
		protected  function onFileErrorHandler(event:IOErrorEvent):void
		{
			sendAndShowErrorMsg(ErrorMsgNumber.FILE_READ_ERROR,dataInfo.customer_service_tel);
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
				_loader.contentLoaderInfo.addEventListener(Event.COMPLETE,onCompleteHandler);
				_loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR,onIOErrorHandler);	
			} 
			catch(error:Error) 
			{
				sendAndShowErrorMsg(ErrorMsgNumber.SWF_BYTE_LENGTH_ERROR,dataInfo.customer_service_tel);
			}			
		}
		protected function onIOErrorHandler(event:IOErrorEvent):void
		{
			sendAndShowErrorMsg(ErrorMsgNumber.LOAD_SWF_ERROR,dataInfo.customer_service_tel);
		}
		
		protected function onCompleteHandler(event:Event):void
		{
			course_mc = event.target.content as MovieClip;
			addChild(_loader);
			removeChild(loading_obj);
			AneUtils.sendData(true);
			switchPlayerByProductType(dataInfo.product_type);
			swfInfo=SwfInfoUtils.getSwfInfo(dataInfo,course_mc);
			swfInfo.isPlaying=true;
		}
		/**
		 * 根据产品类型切换对应的播放器，执行相应的操作
		 * type=familybox:添加家庭端播放器皮肤
		 * type=teachingbox:根据teaching_status值判定是否已经开通服务和关联园所了
		 */
		private function switchPlayerByProductType(type:String):void{
			switch(type)
			{
				case FieldConst.FAMILY_BOX:
				{
					addPlayer();
					stage.addEventListener(Event.ENTER_FRAME,onEnterFrameHandler);
					break;
				}
				case FieldConst.TEACHING_BOX:
				{
					if(dataInfo.teaching_status==0){
						stopTimer();
					}else{
						startTimer();
					}
					break;
				}
				default:
				{
					break;
				}
			}
		}
		/**
		 * 开启主swf的键盘事件和循环事件
		 */
		private function addMainApplicationKeyEvent():void
		{
			stage.addEventListener(KeyboardEvent.KEY_DOWN,onKeyDownHandler);
		}
		/**
		 * 循环获取当前swf文件的帧数
		 */
		protected function onEnterFrameHandler(event:Event):void
		{
			if(course_mc!=null){
				var _currentFrame:int=course_mc.currentFrame;
				player_mc.setNowTime(SwfInfoUtils.getSwfTimeFormatter(_currentFrame));
				var _rate:int=SwfInfoUtils.getSwfProgressRate(course_mc);;
				player_mc.setProgressTxPlay(_rate);
				if(_currentFrame==course_mc.totalFrames){
					course_mc.stop();
					swfInfo.isPlaying=false;
					player_mc.showPlayer();
					isShowing=true;
					stage.removeEventListener(Event.ENTER_FRAME,onEnterFrameHandler);
					startPlayerTimer();
				}
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
				onDestoryAndSendData();	
			}
			if(dataInfo.product_type=="familybox"){
				player_mc.setSwfNameText(swfInfo.resource_name);
				player_mc.setTotalTime(swfInfo.total_time);
				switch(event.keyCode)
				{					
					case SwfKeyCode.ENTER_REFLECT_CODE:
					{
						swfPlayAndPauseController();
						break;
					}
					case SwfKeyCode.LEFT_REFLECT_CODE:
						playRewind();
						break;
					case SwfKeyCode.RIGHT_REFLECT_CODE:
						playForward();
						break;
					case SwfKeyCode.UP_REFLECT_CODE:
						showPg()
						break;
					case SwfKeyCode.DOWN_REFLECT_CODE:
						hidePg()
						break;
					default:
					{
						break;
					}
				}
			}
			//通过子swf文件调用父类的方法
			course_mc.getParentMethod(this);			
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
		 * 控制播放器的播放暂停，针对家庭端纯播放的课件
		 */
		private function swfPlayAndPauseController():void
		{
			if(swfInfo.isPlaying){
				course_mc.stop();
				var _now_time:String=SwfInfoUtils.getSwfTimeFormatter(course_mc.currentFrame);
				var _now_rate:int=SwfInfoUtils.getSwfProgressRate(course_mc);
				player_mc.setNowTime(_now_time);
				player_mc.setProgressTxStop(_now_rate);
				player_mc.showPlayer();
				isShowing=true;
				startPlayerTimer();
			}else{
				if(course_mc.currentFrame==course_mc.totalFrames){
					course_mc.stop();
				}else{
					course_mc.play();
					player_mc.hidePlayer();
					isShowing=false;
					stage.addEventListener(Event.ENTER_FRAME,onEnterFrameHandler);
				}
				stopPlayerTimer();
			}
			swfInfo.isPlaying=!swfInfo.isPlaying;
		}
		/**
		 * 快进功能
		 */
		private function playForward():void
		{
			stopPlayerTimer();
			var nextFrame:int=course_mc.currentFrame+120;
			if(nextFrame>course_mc.totalFrames){
				nextFrame=course_mc.totalFrames;
			}
			if(nextFrame==course_mc.totalFrames){
				course_mc.gotoAndStop(nextFrame);
				swfInfo.isPlaying=false;
			}
			var _right_rate:int=SwfInfoUtils.getSwfProgressRate(course_mc);;
			var _right_time:String=SwfInfoUtils.getSwfTimeFormatter(nextFrame);
			player_mc.setNowTime(_right_time);
			if(swfInfo.isPlaying){
				course_mc.gotoAndPlay(nextFrame);
				player_mc.setProgressTxPlay(_right_rate);
			}else{
				course_mc.gotoAndStop(nextFrame);
				player_mc.setProgressTxStop(_right_rate);
			}
			if(isShowing){
				startPlayerTimer();
			}
		}
		/**
		 * 快退功能
		 */
		private function playRewind():void
		{
			stopPlayerTimer();
			var preFrame:int=course_mc.currentFrame-120;
			if(preFrame<=0){
				preFrame=1;
			}
			var _left_rate:int=SwfInfoUtils.getSwfProgressRate(course_mc);
			var _left_time:String=SwfInfoUtils.getSwfTimeFormatter(preFrame);
			player_mc.setNowTime(_left_time);
			if(swfInfo.isPlaying){
				course_mc.gotoAndPlay(preFrame);
				player_mc.setProgressTxPlay(_left_rate);
			}else{
				course_mc.gotoAndStop(preFrame);
				player_mc.setProgressTxStop(_left_rate);
			}
			if(isShowing){
				startPlayerTimer();
			}
		}
		/**
		 * 显示进度条
		 */
		private function showPg():void
		{
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
		}
		/**
		 * 隐藏进度条
		 */
		private function hidePg():void
		{
			if(isShowing){
				player_mc. hideNameAndProgress();
				stage.removeEventListener(Event.ENTER_FRAME,onEnterFrameHandler);
			}
			isShowing=!isShowing;
			stopPlayerTimer();
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
		/**
		 * 停止familyTimer
		 */
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
		}
		protected function onDialogCompleteHandler(event:Event):void
		{
			dialog_mc=event.target.content as MovieClip;
			addChild(_dialog_loader);
			pauseMainSwf();
			initDialogSwf();
			stopTimer();
			AneUtils.sendData(false);
			switchConnectOrService(dataInfo.teaching_status)
		}
		/**
		 * //根据账户的类型,显示关联园所，还是开启服务。
		 */
		private function switchConnectOrService(status:int):void
		{
			switch(status)
			{
				case 1:
				{
					dialog_mc.initConnectUI();
					break;
				}
				case 2:
				case 3:
				{
					dialog_mc.goServiceUI();
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
			course_mc.stopAllMovieClips();
			stage.removeEventListener(KeyboardEvent.KEY_DOWN,onKeyDownHandler);
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
				onDestoryAndSendData();
			}
			dialog_mc.getParentMethod(this);
		}
		/**
		 * 打开系统扫码注册页面
		 */
		public function openConnectApk():void{
			unloadDialogUI();
			AneUtils.openApk(PathConst.PACKAGE_NAME,PathConst.CONNECT_CLASS_NAME);
			onDestroy();
		}
		/**
		 * 不注册时，退出对话框
		 */
		public function unloadDialogUI():void{
			removeDialgoSwfEvent()
			_dialog_loader.unloadAndStop(true);
			onDestroy();
		}
		/**
		 * 开通服务页面
		 */
		public function openServiceApk():void{
			unloadDialogUI();
			AneUtils.openApk(PathConst.PACKAGE_NAME,PathConst.SERVER_OPEN_NAME);
			onDestroy();
		}
		/**
		 * 销毁当前应用之前广播数据
		 */
		public function onDestoryAndSendData():void
		{
			var exitInfo:SwfInfo=SwfInfoUtils.getSwfInfo(dataInfo,course_mc);
			AneUtils.sendDataFromAction(PathConst.APK_BROADCAST,exitInfo.isPlaying,exitInfo.isEnd,exitInfo.teaching_resource_id,exitInfo.family_media_id,exitInfo.family_material_id,exitInfo.play_time,exitInfo.total_time);
			NativeApplication.nativeApplication.exit(0);
		}
		/**
		 * 直接销毁应用
		 */
		public function onDestroy():void
		{
			NativeApplication.nativeApplication.exit(0);
		}
		
	}
}