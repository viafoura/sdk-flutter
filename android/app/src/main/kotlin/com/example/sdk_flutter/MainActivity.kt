package com.example.sdk_flutter

import androidx.annotation.NonNull
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel


class MainActivity: FlutterActivity() {

    private val CHANNEL = "com.example.platform_channel_in_flutter/test"

    override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
        flutterEngine
            .platformViewsController
            .registry
            .registerViewFactory("vfCommentsFragment", NativeViewFactory())

        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL)
            .setMethodCallHandler { call: MethodCall, result: MethodChannel.Result ->
                if (call.method == "getDeviceModel") {
                    result.success("")
                } else {
                    // if called undefined method
                    result.notImplemented()
                }
            }
    }
}
