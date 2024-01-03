//
//  FLPlugin.swift
//  Runner
//
//  Created by Martin De Simone on 03/01/2024.
//

import Foundation
import Flutter
class FLPlugin: NSObject, FlutterPlugin {
    public static func register(with registrar: FlutterPluginRegistrar) {
        let factory = FLNativeViewFactory(messenger: registrar.messenger())
        registrar.register(factory, withId: "<platform-view-type>")
    }
}
