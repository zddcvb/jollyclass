package com.jollyclass.ane;

import android.app.Activity;
import android.content.Intent;

import com.adobe.fre.FREContext;
import com.adobe.fre.FREFunction;
import com.adobe.fre.FREObject;

public class SendErrorMsgFunction implements FREFunction {

	@Override
	public FREObject call(FREContext context, FREObject[] args) {
		FREObject object = null;
		JollyClassAneExtensionContext joAneExtensionContext = (JollyClassAneExtensionContext) context;
		Activity activity = joAneExtensionContext.getActivity();
		try {
			String msg = args[0].getAsString();
			Intent intent = new Intent();
			intent.setAction("android.intent.action.SWF_ISPLAYING");
			intent.putExtra("error_msg", msg);
			activity.getApplication().sendBroadcast(intent);
		} catch (Exception e) {
			e.printStackTrace();
		}
		return object;
	}

}
