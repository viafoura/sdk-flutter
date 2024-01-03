import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

/// Displays detailed information about a SampleItem.
class SampleItemDetailsView extends StatelessWidget {
  const SampleItemDetailsView({super.key});
  static const routeName = '/sample_item';

static var controller = WebViewController()
  ..setJavaScriptMode(JavaScriptMode.unrestricted)
  ..loadRequest(Uri.parse('https://flutter.dev'));

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Article'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
      child: Column(
        children: <Widget>[
          Container(
            height: 200,
            child: WebViewWidget(controller: controller)),
          Container(height: 100, child: CommentsFragment()),

        ])
      ),
    ));
  }
}

class CommentsFragment extends StatelessWidget {
  Widget build(BuildContext context) {
  // This is used in the platform side to register the view.
  const String viewType = '<platform-view-type>';
  // Pass parameters to the platform side.
  final Map<String, dynamic> creationParams = <String, dynamic>{};

  switch (defaultTargetPlatform) {
    case TargetPlatform.android:
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