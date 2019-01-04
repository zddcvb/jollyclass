package com.jollyclass.ane;

import com.adobe.fre.FREContext;
import com.adobe.fre.FREExtension;

public class JollyClassAneExtension implements FREExtension{

	@Override
	public FREContext createContext(String arg0) {
		return new JollyClassAneExtensionContext();
	}

	@Override
	public void dispose() {
		
	}

	@Override
	public void initialize() {
		
	}

}
