package com.example.sdk_flutter

import io.flutter.embedding.android.FlutterFragmentActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugins.webviewflutter.WebViewFlutterPlugin

internal class MainActivity : FlutterFragmentActivity() {
    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        flutterEngine.plugins.add(WebViewFlutterPlugin())
        flutterEngine
            .platformViewsController
            .registry
            .registerViewFactory("vfCommentsFragment", NativeViewFactory(flutterEngine))
    }
}