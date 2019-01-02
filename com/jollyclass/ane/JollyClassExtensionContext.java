package com.jollyclass.ane;

import java.util.HashMap;
import java.util.Map;

import com.adobe.fre.FREContext;
import com.adobe.fre.FREFunction;

public class JollyClassExtensionContext extends FREContext {

	@Override
	public void dispose() {

	}

	@Override
	public Map<String, FREFunction> getFunctions() {
		Map<String, FREFunction> map=new HashMap<String, FREFunction>();
		map.put("jollyClassToastFunction", new JollyClassToastFunction());
		map.put("openApkFunction", new OpenApkFunction());
		map.put("sendBroadcastDataFunction", new SendBroadcastDataFunction());
		return map;
	}

}
