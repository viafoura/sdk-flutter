import UIKit
import Flutter
import ViafouraSDK

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
    
    var authChannel, heightChannel: FlutterMethodChannel?
    
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
      GeneratedPluginRegistrant.register(with: self)
      
      let controller : FlutterViewController = window?.rootViewController as! FlutterViewController
      
      authChannel = FlutterMethodChannel(name: AUTH_CHANNEL, binaryMessenger: controller.binaryMessenger)
      heightChannel = FlutterMethodChannel(name: HEIGHT_CHANNEL, binaryMessenger: controller.binaryMessenger)
      
      setupAuthChannel()
      registerViafouraSDK()
      return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
    
    func setupAuthChannel(){
        let auth = ViafouraSDK.auth()
        authChannel?.setMethodCallHandler({ result, result2 in
            let arguments: [String: String] = result.arguments as! [String: String]
            let type = arguments["type"]
            if type == "login"{
                let email = arguments["email"] ?? ""
                let password = arguments["password"] ?? ""
                
                auth.login(email: email, password: password, completion: { result in
                    switch result {
                    case .success(let user):
                        result2("200")
                    case .failure(let error):
                        result2("400")
                    }
                })
            } else if type == "signup" {
                let name = arguments["name"] ?? ""
                let email = arguments["email"] ?? ""
                let password = arguments["password"] ?? ""
                
                auth.signup(name: name, email: email, password: password, completion: { result in
                    switch result {
                    case .success(let user):
                        result2("200")
                    case .failure(let error):
                        result2("400")
                    }
                })
            } else if type == "logout" {
                auth.logout()
            } else if type == "cookieLogin" {
                let token = arguments["token"] ?? ""
                auth.cookieLogin(token: token, completion: { result in
                    switch result {
                    case .success(let user):
                        result2("200")
                    case .failure(let error):
                        result2("400")
                    }
                })
            }
        })
    }
    
    func registerViafouraSDK(){
        weak var registrar = self.registrar(forPlugin: "plugin-name")

        let factory = FLNativeViewFactory(messenger: registrar!.messenger())
        self.registrar(forPlugin: "<plugin-name>")!.register(
            factory,
            withId: "vfCommentsFragment")
        
        ViafouraSDK.initialize(siteUUID: "00000000-0000-4000-8000-c8cddfd7b365", siteDomain: "viafoura-mobile-demo.vercel.app")
        ViafouraSDK.setLoggingEnabled(true)
    }
}
