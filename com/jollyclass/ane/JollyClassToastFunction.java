package com.jollyclass.ane;

import android.app.Activity;
import android.widget.Toast;

import com.adobe.fre.FREContext;
import com.adobe.fre.FREFunction;
import com.adobe.fre.FREObject;

public class JollyClassToastFunction implements FREFunction {

	@Override
	public FREObject call(FREContext context, FREObject[] args) {
		FREObject object = null;
		JollyClassExtensionContext toastContext = (JollyClassExtensionContext) context;
		Activity activity = toastContext.getActivity();
		try {
			String msg = args[0].getAsString();
			Toast.makeText(activity.getApplicationContext(), msg, Toast.LENGTH_LONG)
					.show();
		} catch (Exception e) {
			e.printStackTrace();
		}
		return object;
	}

}
