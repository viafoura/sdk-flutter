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
      
      registerViafouraSDK()
      return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
    
    func registerViafouraSDK(){
        weak var registrar = self.registrar(forPlugin: "plugin-name")

        let factory = FLNativeViewFactory(messenger: registrar!.messenger())
        self.registrar(forPlugin: "<plugin-name>")!.register(
            factory,
            withId: "vfCommentsFragment")
        
        ViafouraSDK.initialize(siteUUID: "00000000-0000-4000-8000-c8cddfd7b365", siteDomain: "viafoura-mobile-demo.vercel.app")
    }
}
