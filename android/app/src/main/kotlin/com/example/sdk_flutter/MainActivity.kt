package com.example.sdk_flutter

import android.widget.Toast
import com.viafourasdk.src.ViafouraSDK
import com.viafourasdk.src.model.network.authentication.cookieLogin.CookieLoginResponse
import com.viafourasdk.src.model.network.authentication.login.LoginResponse
import com.viafourasdk.src.model.network.authentication.signup.SignUpResponse
import com.viafourasdk.src.model.network.error.NetworkError
import com.viafourasdk.src.services.auth.AuthService.CookieLoginCallback
import com.viafourasdk.src.services.auth.AuthService.LoginCallback
import com.viafourasdk.src.services.auth.AuthService.SignUpCallback
import io.flutter.embedding.android.FlutterFragmentActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugins.webviewflutter.WebViewFlutterPlugin

internal class MainActivity : FlutterFragmentActivity() {
    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        flutterEngine.plugins.add(WebViewFlutterPlugin())
        flutterEngine
            .platformViewsController
            .registry
            .registerViewFactory("vfCommentsFragment", NativeViewFactory(flutterEngine))

        setupAuthChannel()
    }

    fun setupAuthChannel(){
        val authChannel =
            MethodChannel(flutterEngine!!.dartExecutor.binaryMessenger, Constants.AUTH_CHANNEL)

        val auth = ViafouraSDK.auth()
        authChannel.setMethodCallHandler { call, result ->
            if(call.method.equals("emailLogin")){
                val email = call.argument<String>("email");
                val password = call.argument<String>("password");

                auth.login(email, password, object : LoginCallback {
                    override fun onSuccess(loginResponse: LoginResponse) {
                        result.success("200");
                    }
                    override fun onError(err: NetworkError) {
                        result.success("400");
                    }
                })
            } else if(call.method.equals("signup")){
                val name = call.argument<String>("name");
                val email = call.argument<String>("email");
                val password = call.argument<String>("password");

                auth.signup(name, email, password, object : SignUpCallback {
                    override fun onSuccess(loginResponse: SignUpResponse) {
                        result.success("200");
                    }
                    override fun onError(err: NetworkError) {
                        result.success("400");
                    }
                })
            } else if(call.method.equals("logout")){
                auth.logout();
            } else if(call.method.equals("cookieLogin")){
                val token = call.argument<String>("token");
                auth.cookieLogin(token, object : CookieLoginCallback {
                    override fun onSuccess(loginResponse: CookieLoginResponse) {
                        result.success("200");
                    }
                    override fun onError(err: NetworkError) {
                        result.success("400");
                    }
                })
            }
        }
    }
}