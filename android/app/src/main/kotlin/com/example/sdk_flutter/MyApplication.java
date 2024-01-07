package com.example.sdk_flutter;

import android.app.Application;

import com.viafourasdk.src.ViafouraSDK;

public class MyApplication extends Application {

    @Override
    public void onCreate() {
        super.onCreate();

        ViafouraSDK.initialize(this, "00000000-0000-4000-8000-c8cddfd7b365", "viafoura-mobile-demo.vercel.app");
    }
}
