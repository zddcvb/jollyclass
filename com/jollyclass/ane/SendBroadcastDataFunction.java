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
		JollyClassExtensionContext toastFunction = (JollyClassExtensionContext) context;
		Activity activity = toastFunction.getActivity();
		try {
			String msg = args[0].getAsString();
			sendDataFromBroadCast(activity, msg);
		} catch (Exception e) {
			e.printStackTrace();
		}
		return object;
	}

	private void sendDataFromBroadCast(Activity activity, String msg) {
		Intent intent = new Intent();
		intent.setAction("android.intent.action.AIR_DATA");
		intent.putExtra("air_data", msg);
		activity.sendBroadcast(intent);
	}

}
