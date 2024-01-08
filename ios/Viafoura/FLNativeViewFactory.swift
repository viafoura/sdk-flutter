//
//  FLNativeViewFactory.swift
//  Runner
//
//  Created by Martin De Simone on 03/01/2024.
//

import Foundation
import Flutter
import ViafouraSDK

class FLNativeViewFactory: NSObject, FlutterPlatformViewFactory {
    private var messenger: FlutterBinaryMessenger

    init(messenger: FlutterBinaryMessenger) {
        self.messenger = messenger
        super.init()
    }

    func create(
        withFrame frame: CGRect,
        viewIdentifier viewId: Int64,
        arguments args: Any?
    ) -> FlutterPlatformView {
        return FLNativeView(
            frame: frame,
            viewIdentifier: viewId,
            arguments: args,
            binaryMessenger: messenger)
    }

    /// Implementing this method is only necessary when the `arguments` in `createWithFrame` is not `nil`.
    public func createArgsCodec() -> FlutterMessageCodec & NSObjectProtocol {
          return FlutterStandardMessageCodec.sharedInstance()
    }
}

class FLNativeView: NSObject, FlutterPlatformView, VFLoginDelegate, VFLayoutDelegate {
    private var _view: UIView

    var settings: VFSettings?
    var articleMetadata: VFArticleMetadata?
    
    let containerId = "91992921"
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    init(
        frame: CGRect,
        viewIdentifier viewId: Int64,
        arguments args: Any?,
        binaryMessenger messenger: FlutterBinaryMessenger?
    ) {
        _view = UIView()
        super.init()
        // iOS views can be created here
        createNativeView(view: _view)
    }

    func view() -> UIView {
        return _view
    }

    func createNativeView(view _view: UIView){
        guard let parentViewController  = UIApplication.shared.windows.first?.rootViewController else {
            return
        }
        
        let callbacks: VFActionsCallbacks = { [weak self] type in
            switch type {
            case .writeNewCommentPressed(let actionType):
                self?.presentNewCommentViewController(actionType: actionType)
            case .openProfilePressed(let userUUID, let presentationType):
                self?.presentProfileViewController(userUUID: userUUID, presentationType: presentationType)
            default:
                break
            }
        }

        let colors = VFColors(colorPrimary: .red, colorPrimaryLight: .blue)
        settings = VFSettings(colors: colors)
        articleMetadata = VFArticleMetadata(url: URL(string: "https://test.com")!, title: "Title", subtitle: "Subtitle", thumbnailUrl: URL(string: "https://test.com")!)
        guard let settings, let articleMetadata else {
            return
        }

        guard let commentsFragment = VFPreviewCommentsViewController.new(containerId: containerId, articleMetadata: articleMetadata, loginDelegate: self, settings: settings) else {
            return
        }
        
        commentsFragment.setActionCallbacks(callbacks: callbacks)
        commentsFragment.setLayoutDelegate(layoutDelegate: self)
        
        parentViewController.addChild(commentsFragment)
        _view.addSubview(commentsFragment.view)
        commentsFragment.view.frame = _view.bounds
        commentsFragment.didMove(toParent: parentViewController)
    }
    
    func presentProfileViewController(userUUID: UUID, presentationType: VFProfilePresentationType){
        guard let parentViewController  = UIApplication.shared.windows.first?.rootViewController, let settings = settings else {
            return
        }

        let callbacks: VFActionsCallbacks = { [weak self] type in
            switch type {
            case .notificationPressed(let presentationType):
                switch presentationType {
                case .profile(let userUUID):
                    self?.presentProfileViewController(userUUID: userUUID, presentationType: .feed)
                    break
                case .content(let containerUUID, let contentUUID, let containerId):
                    break
                }
            default:
                break
            }
        }
        
        guard let profileViewController = VFProfileViewController.new(userUUID: userUUID, presentationType: presentationType, loginDelegate: self, settings: settings) else{
            return
        }

        profileViewController.setActionCallbacks(callbacks: callbacks)
        parentViewController.present(profileViewController, animated: true)
    }
    
    func presentNewCommentViewController(actionType: VFNewCommentActionType){
        guard let parentViewController  = UIApplication.shared.windows.first?.rootViewController, let settings = settings, let articleMetadata = articleMetadata else {
            return
        }

        let callbacks: VFActionsCallbacks = { type in
            switch type {
            case .commentPosted(let contentUUID):

                break
            case .replyPosted(let contentUUID):
              break
            default:
                break
            }
        }

        guard let newCommentViewController = VFNewCommentViewController.new(newCommentActionType: actionType, containerId: containerId, articleMetadata: articleMetadata, loginDelegate: self, settings: settings) else{
            return
        }
        newCommentViewController.setActionCallbacks(callbacks: callbacks)
        parentViewController.present(newCommentViewController, animated: true)
    }
    
    func containerHeightUpdated(viewController: VFUIViewController, height: CGFloat) {
        appDelegate.heightChannel?.invokeMethod("heightUpdated", arguments: height)
    }
    
    func startLogin() {
        appDelegate.authChannel?.invokeMethod("startLogin", arguments: nil)
    }
}
