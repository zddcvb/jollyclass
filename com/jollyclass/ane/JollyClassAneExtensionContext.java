package com.jollyclass.ane;

import java.util.HashMap;
import java.util.Map;

import com.adobe.fre.FREContext;
import com.adobe.fre.FREFunction;

public class JollyClassAneExtensionContext extends FREContext {

	@Override
	public void dispose() {

	}

	@Override
	public Map<String, FREFunction> getFunctions() {
		Map<String, FREFunction> functionMap = new HashMap<String, FREFunction>();
		functionMap.put("toastFunction", new ToastLongFunction());
		functionMap.put("toastShortFunction", new ToastShortFunction());
		functionMap.put("openApkFunction", new OpenApkFunction());
		functionMap.put("sendBroadcastDataFunction",
				new SendBroadcastDataFunction());
		functionMap.put("sendErrorMsgFunction", new SendErrorMsgFunction());
		functionMap.put("teachingSendDataFunction", new TeachingSendDataFunction());
		functionMap.put("familySendDataFunction", new FamilySendDataFunction());
		return functionMap;
	}

}
