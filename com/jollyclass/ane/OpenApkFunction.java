package com.jollyclass.ane;

import android.app.Activity;
import android.content.Intent;
import android.widget.Toast;

import com.adobe.fre.FREContext;
import com.adobe.fre.FREFunction;
import com.adobe.fre.FREInvalidObjectException;
import com.adobe.fre.FREObject;
import com.adobe.fre.FRETypeMismatchException;
import com.adobe.fre.FREWrongThreadException;

public class OpenApkFunction implements FREFunction {

	@Override
	public FREObject call(FREContext context, FREObject[] args) {
		FREObject object = null;
		JollyClassAneExtensionContext toastAneExtensionContext = (JollyClassAneExtensionContext) context;
		Activity activity = toastAneExtensionContext.getActivity();
		Intent intent = new Intent();
		try {
			String packageName = args[0].getAsString();
			String className = args[1].getAsString();
			Toast.makeText(activity.getApplicationContext(),
					packageName + ":" + className, Toast.LENGTH_LONG).show();
			intent.setClassName(packageName, className);
			intent.addCategory(Intent.CATEGORY_LAUNCHER);
			intent.setAction(Intent.ACTION_MAIN);
			intent.setFlags(Intent.FLAG_ACTIVITY_NEW_TASK);
			activity.startActivity(intent);
		} catch (IllegalStateException e) {
			e.printStackTrace();
		} catch (FRETypeMismatchException e) {
			e.printStackTrace();
		} catch (FREInvalidObjectException e) {
			e.printStackTrace();
		} catch (FREWrongThreadException e) {
			e.printStackTrace();
		}
		return object;
	}

}
