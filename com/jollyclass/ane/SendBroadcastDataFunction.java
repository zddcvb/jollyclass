package com.jollyclass.ane;

import android.app.Activity;
import android.content.Intent;

import com.adobe.fre.FREContext;
import com.adobe.fre.FREFunction;
import com.adobe.fre.FREObject;

public class SendBroadcastDataFunction implements FREFunction {

	@Override
	public FREObject call(FREContext context, FREObject[] args) {
		FREObject object = null;
		JollyClassAneExtensionContext toastContext = (JollyClassAneExtensionContext) context;
		Activity activity = toastContext.getActivity();
		try {
			Boolean msg = args[0].getAsBool();
			Intent intent = new Intent();
			intent.setAction("android.intent.action.SWF_ISPLAYING");
			intent.putExtra("isPlaying", msg);
			activity.getApplication().sendBroadcast(intent);
		} catch (Exception e) {
			e.printStackTrace();
		}
		return object;
	}

}
