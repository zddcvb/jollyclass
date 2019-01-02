package com.jollyclass.ane;

import android.app.Activity;
import android.content.Intent;

import com.adobe.fre.FREContext;
import com.adobe.fre.FREFunction;
import com.adobe.fre.FREObject;

public class OpenApkFunction implements FREFunction {

	@Override
	public FREObject call(FREContext context, FREObject[] args) {
		FREObject object = null;
		JollyClassExtensionContext toastFunction = (JollyClassExtensionContext) context;
		Activity activity = toastFunction.getActivity();
		try {
			String packageName = args[0].getAsString();
			String className = args[1].getAsString();
			Intent intent = new Intent();
			intent.setClassName(packageName, className);
			intent.setAction(Intent.ACTION_MAIN);
			intent.addCategory(Intent.CATEGORY_LAUNCHER);
			intent.setFlags(Intent.FLAG_ACTIVITY_NEW_TASK);
			activity.startActivity(intent);
		} catch (Exception e) {
			// TODO: handle exception
		}
		return object;
	}

}
