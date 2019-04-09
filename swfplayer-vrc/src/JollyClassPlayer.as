package
{
	import com.jollyclass.airplayer.constant.ErrorMsgNumber;
	import com.jollyclass.airplayer.constant.FieldConst;
	import com.jollyclass.airplayer.constant.PathConst;
	import com.jollyclass.airplayer.constant.SwfKeyCode;
	import com.jollyclass.airplayer.domain.JollyClassDataInfo;
	import com.jollyclass.airplayer.domain.SwfInfo;
	import com.jollyclass.airplayer.factory.KeyCodeServiceFactory;
	import com.jollyclass.airplayer.factory.impl.CommonKeyCodeFactoryImpl;
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

	/**
	 * 小水滴课堂主类，启动类，通过onstart方法启动。
	 * @author 邹丹丹
	 */
	public class JollyClassPlayer extends Sprite
	{
		private static var logger:LoggerUtils=new LoggerUtils("JollyClassPlayer");
		/**
		 * 2个动画的加载器和元件
		 */
		private var _loader:Loader=new Loader();
		private var _dialog_loader:Loader=new Loader();
		private var _player_loading:Loader=new Loader();
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
		public function JollyClassPlayer()
		{
			super();
			stage.align = StageAlign.TOP_LEFT;
			stage.scaleMode = StageScaleMode.NO_SCALE;
			this.onStart();
		}
		/**
		 * 启动应用
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
		 * @param info 需要显示的错误代码
		 * @param telNum 动态指定客服电话
		 */
		private function showErroMsg( info:String,telNum:String):void
		{
			var _error_loading:Loader=new Loader();
			_error_loading.contentLoaderInfo.addEventListener(Event.COMPLETE,function(event:Event):void{
				addChild(_error_loading);
				var error_mc:MovieClip=event.target.content as MovieClip;
				if(telNum==null||telNum==""){
					telNum=FieldConst.DEFAULT_TELPHONE;
				}
				error_mc.setText(info,telNum);
				initErrorKeyEvent();
			});
			_error_loading.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR,function(event:IOErrorEvent):void{
				sendAndShowErrorMsg(ErrorMsgNumber.ERROR_LOADING_FAILED,dataInfo.customer_service_tel);
			});
			_error_loading.load(new URLRequest(PathConst.ERROR_SWF));
		}
		/**
		 * 添加播放器皮肤，获得皮肤的影片剪辑,显示到界面中，但是visible属性为fasle，hiderPlayer方法即为隐藏，具体的方法执行在player.swf文件中。
		 */
		private function addPlayer():void
		{
			
			_player_loading.contentLoaderInfo.addEventListener(Event.COMPLETE,function(event:Event):void{
				player_mc=event.target.content as MovieClip;
				//添加播放器皮肤，并隐藏
				player_mc.hidePlayer();
				addChild(_player_loading);
			});
			_player_loading.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR,function(event:IOErrorEvent):void{
				sendAndShowErrorMsg(ErrorMsgNumber.PLAYER_LOADING_FAILED,dataInfo.customer_service_tel);
			});
			_player_loading.load(new URLRequest(PathConst.PLAYER_SWF));
		}
		/**
		 * 上报错误信息以及显示错误ui
		 * @param info 需要显示的错误代码
		 * @param telNum 动态指定客服电话
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
					sendAndShowErrorMsg(ErrorMsgNumber.PARSE_DATA_ERROR,FieldConst.DEFAULT_TELPHONE);
				}
			}else{
				sendAndShowErrorMsg(ErrorMsgNumber.INOVKE_DATA_LENGTH_ERROR,FieldConst.DEFAULT_TELPHONE);
			}
			NativeApplication.nativeApplication.removeEventListener(InvokeEvent.INVOKE,onInvokeHandler);
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
		 * @param swfPath swf课件的绝对路径
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
						sendAndShowErrorMsg(ErrorMsgNumber.MEMORY_ERROR,dataInfo.customer_service_tel);
					}
				}else{
					sendAndShowErrorMsg(ErrorMsgNumber.FILE_NOT_EXITS,dataInfo.customer_service_tel);
				}
			}
		}
		protected  function onFileErrorHandler(event:IOErrorEvent):void
		{
			sendAndShowErrorMsg(ErrorMsgNumber.FILE_READ_ERROR,dataInfo.customer_service_tel);
			event.currentTarget.addEventListener(IOErrorEvent.IO_ERROR,onFileErrorHandler);
		}
		
		protected  function onFileCompleteHandler(event:Event):void
		{
			var fileData:ByteArray=event.currentTarget.data;
			loadSwfFileFromBytes(fileData);
			event.currentTarget.removeEventListener(Event.COMPLETE,onFileCompleteHandler);
		}
		/**
		 * 加载swf文件，通过bytearray方式
		 */
		private  function loadSwfFileFromBytes(fileDataByteArray:ByteArray):void
		{
			
			var _context:LoaderContext=new LoaderContext();
			_context.allowCodeImport=true;
			_context.applicationDomain=ApplicationDomain.currentDomain;
			_loader.contentLoaderInfo.addEventListener(Event.COMPLETE,onCompleteHandler);
			_loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR,onIOErrorHandler);	
			try
			{
				_loader.loadBytes(fileDataByteArray,_context);	
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
		 * @param type 
		 * 			familybox:添加家庭端播放器皮肤，
		 * 			teachingbox:根据teaching_status值判定是否已经开通服务和关联园所了
		 */
		private function switchPlayerByProductType(type:String):void
		{
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
						stopTeachingTimer();
					}else{
						startTeachingTimer();
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
				if(_currentFrame>=course_mc.totalFrames){
					course_mc.gotoAndStop(course_mc.totalFrames);
					swfInfo.isPlaying=false;
					stage.removeEventListener(Event.ENTER_FRAME,onEnterFrameHandler);
					onDestoryAndSendData();
				}else{
					if(player_mc){
						player_mc.setNowTime(SwfInfoUtils.getSwfTimeFormatter(_currentFrame));
						player_mc.setTotalTime(swfInfo.total_time);
						var _rate:int=SwfInfoUtils.getSwfProgressRate(course_mc);;
						player_mc.setProgressTxPlay(_rate);
					}
				}
			}		
		}
		/**
		 * 1、播放状态，执行ok键，则swf文件暂停，画面显示暂停标志和进度条、课件名称。
		 * 2、播放状态下，执行左右按钮，快进快退功能，进度条和时间也进行相应的变化，不进行任何操作3s后，进度条消失。
		 * 3、播放状态下，执行上下操作显示进度条，不操作3s后，自动消失。
		 * 4、暂停状态下，执行左右按钮快进快退，进度条和时间相应变化，动画播放。若不进行任何操作3s后，进度条和时间消失。
		 * 5、打开flash课件时，首先播放加载动画，flash课件加载完成后，加载动画消失。
		 * 6、打开flash课件失败时，则显示失败的对话框。
		 */
		protected function onKeyDownHandler(event:KeyboardEvent):void
		{
			var keyCode:int=event.keyCode;
			//映射代码
			event.keyCode=switchKeyCode(keyCode,dataInfo.resource_type);
			if (event.keyCode==SwfKeyCode.BACK_XSD_CODE) 
			{
				onDestoryAndSendData();	
			}
			if(dataInfo.product_type==FieldConst.FAMILY_BOX){
				//子swf文件中若存在代码，则移除播放进度条。
				player_mc.setSwfNameText(swfInfo.resource_name);
				player_mc.setTotalTime(swfInfo.total_time);
				switch(event.keyCode)
				{					
					case SwfKeyCode.ENTER_XSD_CODE:
						swfPlayAndPauseController();
						break;
					case SwfKeyCode.LEFT_XSD_CODE:
						playRewind();
						break;
					case SwfKeyCode.RIGHT_XSD_CODE:
						playForward();
						break;
					case SwfKeyCode.UP_XSD_CODE:
						showPg();
						break;
					case SwfKeyCode.DOWN_XSD_CODE:
						hidePg();
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
		 * @param keyCode 遥控器传递的键值
		 * @param resource_type 资源类型，xsd表示小水滴课堂资源，other表示第三方资源，如果是第三方资源采用通用的键盘映射
		 */
		private function switchKeyCode(keyCode:int,resource_type:String):int
		{
			var keyCodeServiceFactory:KeyCodeServiceFactory=null;
			switch(resource_type){
				case FieldConst.XSD_RESOURCES:
					keyCodeServiceFactory=new JollyClassKeyCodeFactoryImpl();
					break;
				case FieldConst.OTHER_RESOURCES:
					keyCodeServiceFactory=new CommonKeyCodeFactoryImpl();
					break;
			}
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
					course_mc.gotoAndStop(course_mc.totalFrames);
					onDestoryAndSendData();
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
			if(nextFrame>=course_mc.totalFrames){
				stage.removeEventListener(Event.ENTER_FRAME,onEnterFrameHandler);
				nextFrame=course_mc.totalFrames;
				course_mc.gotoAndStop(nextFrame);
				swfInfo.isPlaying=false;
				onDestoryAndSendData();
			}else{
				setForwardAndRewind(nextFrame);
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
			setForwardAndRewind(preFrame);
		}
		private function setForwardAndRewind(frame:int):void
		{
			var _rate:int=SwfInfoUtils.getSwfProgressRate(course_mc);
			var _time:String=SwfInfoUtils.getSwfTimeFormatter(frame);
			player_mc.setNowTime(_time);
			course_mc.gotoAndPlay(frame);
			player_mc.setProgressTxPlay(_rate);
			player_mc.showPg();
			swfInfo.isPlaying=true;
			stage.addEventListener(Event.ENTER_FRAME,onEnterFrameHandler);
			isShowing=true;
			startPlayerTimer();
		}
		/**
		 * 显示进度条
		 */
		private function showPg():void
		{
			stopPlayerTimer();
			//开启循环获取时间
			if(!isShowing){
				player_mc.showNameAndProgress();
				if(swfInfo.isPlaying){
					stage.addEventListener(Event.ENTER_FRAME,onEnterFrameHandler);
				}else{
					var _rate:int=SwfInfoUtils.getSwfProgressRate(course_mc);
					player_mc.setProgressTxStop(_rate);
					stage.removeEventListener(Event.ENTER_FRAME,onEnterFrameHandler);
				}
				isShowing=!isShowing;
			}
			startPlayerTimer();
		}
		/**
		 * 隐藏进度条
		 */
		private function hidePg():void
		{
			stopPlayerTimer();
			if(isShowing){
				player_mc. hideNameAndProgress();
				stage.removeEventListener(Event.ENTER_FRAME,onEnterFrameHandler);
				isShowing=!isShowing;
			}
		}
		/**
		 * 开启关联和开通服务计时
		 */
		private function startTeachingTimer():void
		{
			teacherTimer=new Timer(10000,1);
			teacherTimer.addEventListener(TimerEvent.TIMER_COMPLETE,function(event:TimerEvent):void{
				loadDialogSwf(PathConst.DAILOG_SWF);
				stopTeachingTimer();
			});
			teacherTimer.start();	
		}
		/**
		 * 停止计时
		 */
		private  function stopTeachingTimer():void
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
					//stage.removeEventListener(Event.ENTER_FRAME,onEnterFrameHandler);
					isShowing=false;
					stopPlayerTimer();
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
			_dialog_loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR,onDialogErrorHandler);
		}
		protected function onDialogCompleteHandler(event:Event):void
		{
			dialog_mc=event.target.content as MovieClip;
			addChild(_dialog_loader);
			pauseMainSwf();
			initDialogSwf();
			stopTeachingTimer();
			AneUtils.sendData(false);
			switchConnectOrService(dataInfo.teaching_status)
		}
		protected function onDialogErrorHandler(event:IOErrorEvent):void
		{
			sendAndShowErrorMsg(ErrorMsgNumber.DIALOG_LAODING_ERROR,dataInfo.customer_service_tel);
		}
		/**
		 * 根据账户的类型,显示关联园所，还是开启服务。
		 * @param status 账户的状态码
		 * 			0：已付费会员可以正常播放
		 * 			1:绑定激活码，盒子当前日期不在服务有效期内（播放10s,弹出开通服务窗口）
		 * 			2：未开通服务（播放10s,弹出开通服务窗口）
		 * 现有的状态码只有这三种，其中0状态码不会执行此方法，只接受1/2以及其他的状态码，除了1/2状态码之外，系统暂无规定其他的状态码。
		 */
		private function switchConnectOrService(status:int):void
		{
			switch(status)
			{
				case 1:
				case 2:
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
			event.keyCode=switchKeyCode(event.keyCode,dataInfo.resource_type);
			if (event.keyCode==SwfKeyCode.BACK_XSD_CODE) 
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
			AneUtils.openApk(dataInfo.package_name,PathConst.CONNECT_CLASS_NAME);
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
			if(dataInfo.teaching_status==1){
				AneUtils.openApk(dataInfo.package_name,PathConst.MAL_RENEW_NAME);
			}else{
				AneUtils.openApk(dataInfo.package_name,PathConst.SERVER_OPEN_NAME);
			}
			onDestroy();
		}
		/**
		 * 销毁当前应用之前广播数据
		 */
		public function onDestoryAndSendData():void
		{
			var exitInfo:SwfInfo=SwfInfoUtils.getSwfInfo(dataInfo,course_mc);
			switch(dataInfo.product_type){
				case FieldConst.TEACHING_BOX:
					AneUtils.sendTeachingData(PathConst.APK_BROADCAST,exitInfo.isPlaying,exitInfo.isEnd,exitInfo.teaching_resource_id,exitInfo.play_time,exitInfo.total_time);
					break;
				case FieldConst.FAMILY_BOX:
					AneUtils.sendFamilyData(PathConst.APK_BROADCAST,exitInfo.isPlaying,exitInfo.isEnd,exitInfo.family_media_id,exitInfo.family_material_id,exitInfo.play_time,exitInfo.total_time);
					break;
			}
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