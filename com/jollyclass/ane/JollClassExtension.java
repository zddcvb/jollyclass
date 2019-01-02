package com.jollyclass.ane;

import com.adobe.fre.FREContext;
import com.adobe.fre.FREExtension;

public class JollClassExtension implements FREExtension{

	@Override
	public FREContext createContext(String arg0) {
		return new JollyClassExtensionContext();
	}

	@Override
	public void dispose() {
		
	}

	@Override
	public void initialize() {
		
	}

}
