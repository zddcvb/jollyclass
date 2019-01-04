package com.jollyclass.ane;

import android.app.Activity;
import android.widget.Toast;

import com.adobe.fre.FREContext;
import com.adobe.fre.FREFunction;
import com.adobe.fre.FREInvalidObjectException;
import com.adobe.fre.FREObject;
import com.adobe.fre.FRETypeMismatchException;
import com.adobe.fre.FREWrongThreadException;

public class ToastShortFunction implements FREFunction{

	@Override
	public FREObject call(FREContext context, FREObject[] args) {
		FREObject object=null;
		JollyClassAneExtensionContext toastAneExtensionContext=(JollyClassAneExtensionContext) context;
		Activity activity = toastAneExtensionContext.getActivity();
		try {
			String msg = args[0].getAsString();
			Toast.makeText(activity.getApplicationContext(), msg, Toast.LENGTH_SHORT).show();
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
