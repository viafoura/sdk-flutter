import UIKit
import Flutter
import ViafouraSDK

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
      GeneratedPluginRegistrant.register(with: self)
      
      registerViafouraSDK()
      return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
    
    func registerViafouraSDK(){
        weak var registrar = self.registrar(forPlugin: "plugin-name")

        let factory = FLNativeViewFactory(messenger: registrar!.messenger())
        self.registrar(forPlugin: "<plugin-name>")!.register(
            factory,
            withId: "<platform-view-type>")
        
        ViafouraSDK.initialize(siteUUID: "00000000-0000-4000-8000-c8cddfd7b365", siteDomain: "viafoura-mobile-demo.vercel.app")
    }
}
