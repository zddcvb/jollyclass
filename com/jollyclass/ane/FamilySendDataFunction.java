package com.jollyclass.ane;

import android.app.Activity;
import android.content.Intent;

import com.adobe.fre.FREContext;
import com.adobe.fre.FREFunction;
import com.adobe.fre.FREObject;

public class FamilySendDataFunction implements FREFunction{

	@Override
	public FREObject call(FREContext context, FREObject[] args) {
		FREObject object = null;
		JollyClassAneExtensionContext jollyClassAneExtensionContext = (JollyClassAneExtensionContext) context;
		Activity activity = jollyClassAneExtensionContext.getActivity();
		try {
			String action=args[0].getAsString();
			Boolean isPlaying = args[1].getAsBool();
			Boolean isEnd=args[2].getAsBool();
			String family_media_id=args[3].getAsString();
			String family_material_id=args[4].getAsString();
			String play_time=args[5].getAsString();
			String total_time=args[6].getAsString();
			Intent intent = new Intent();
			intent.setAction(action);
			intent.putExtra("isPlaying", isPlaying);
			intent.putExtra("isEnd", isEnd);
			intent.putExtra("family_media_id", family_media_id);
			intent.putExtra("family_material_id", family_material_id);
			intent.putExtra("play_time", play_time);
			intent.putExtra("total_time", total_time);
			activity.getApplication().sendBroadcast(intent);
		} catch (Exception e) {
			e.printStackTrace();
		}
		return object;
	}

}
