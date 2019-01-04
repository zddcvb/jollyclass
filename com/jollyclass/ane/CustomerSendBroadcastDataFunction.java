package com.jollyclass.ane;

import android.app.Activity;
import android.content.Intent;

import com.adobe.fre.FREContext;
import com.adobe.fre.FREFunction;
import com.adobe.fre.FREObject;

public class CustomerSendBroadcastDataFunction implements FREFunction{

	@Override
	public FREObject call(FREContext context, FREObject[] args) {
		FREObject object = null;
		JollyClassAneExtensionContext toastContext = (JollyClassAneExtensionContext) context;
		Activity activity = toastContext.getActivity();
		try {
			Boolean isPlaying = args[0].getAsBool();
			String action=args[1].getAsString();
			String resource_name=args[2].getAsString();
			String play_time=args[3].getAsString();
			String total_time=args[4].getAsString();
			Intent intent = new Intent();
			intent.setAction(action);
			intent.putExtra("isPlaying", isPlaying);
			intent.putExtra("resource_name", resource_name);
			intent.putExtra("play_time", play_time);
			intent.putExtra("total_time", total_time);
			activity.getApplication().sendBroadcast(intent);
		} catch (Exception e) {
			e.printStackTrace();
		}
		return object;
	}

}
