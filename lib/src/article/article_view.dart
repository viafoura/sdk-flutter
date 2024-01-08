import 'package:flutter/material.dart';
import 'package:sdk_flutter/src/article/article.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/rendering.dart';

/// Displays detailed information about a SampleItem.
class ArticleView extends StatelessWidget {
  const ArticleView({
    super.key,
    this.channel = const MethodChannel('HEIGHT_UPDATED_CHANNEL')
  });
  static const routeName = '/article';
  
    final MethodChannel channel;

static var controller = WebViewController()
  ..setJavaScriptMode(JavaScriptMode.unrestricted)
  ..loadRequest(Uri.parse('https://flutter.dev'));

  @override
  Widget build(BuildContext context) {
         Future<dynamic> invokedMethods(MethodCall methodCall) async {
    switch (methodCall.method) {
        case "heightUpdated":
        //commentsContainerHeight = methodCall.arguments;
      }
  }

    channel.setMethodCallHandler(invokedMethods);
    return Scaffold(
      appBar: AppBar(
        title: const Text("Article"),
      ),
      body: Expanded(
        child: SingleChildScrollView(
      child: Column(
        children: <Widget>[
          Container(
            height: 200,
            child: WebViewWidget(controller: controller)),
          Container(height: 1000, child: CommentsFragment()),

        ])
      ),
    ));
  }
}

class CommentsFragment extends StatelessWidget {
  Widget build(BuildContext context) {
  // This is used in the platform side to register the view.
  const String viewType = 'vfCommentsFragment';
  // Pass parameters to the platform side.
  final Map<String, dynamic> creationParams = <String, dynamic>{};

  switch (defaultTargetPlatform) {
    case TargetPlatform.android:
      return PlatformViewLink(
    viewType: viewType,
    surfaceFactory: (context, controller) {
      return AndroidViewSurface(
        controller: controller as AndroidViewController,
        gestureRecognizers: const <Factory<OneSequenceGestureRecognizer>>{},
        hitTestBehavior: PlatformViewHitTestBehavior.opaque,
      );
    },
    onCreatePlatformView: (params) {
      return PlatformViewsService.initSurfaceAndroidView(
        id: params.id,
        viewType: viewType,
        layoutDirection: TextDirection.ltr,
        creationParams: creationParams,
        creationParamsCodec: const StandardMessageCodec(),
        onFocus: () {
          params.onFocusChanged(true);
        },
      )
        ..addOnPlatformViewCreatedListener(params.onPlatformViewCreated)
        ..create();
    },
  );
    // return widget on Android.
    case TargetPlatform.iOS:
    return UiKitView(
    viewType: viewType,
    layoutDirection: TextDirection.ltr,
    creationParams: creationParams,
    creationParamsCodec: const StandardMessageCodec(),
  );
    default:
      throw UnsupportedError('Unsupported platform view');
  }
}
}