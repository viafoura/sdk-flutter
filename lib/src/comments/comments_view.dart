import 'package:flutter/material.dart';
import 'package:sdk_flutter/src/article/article.dart';
import 'package:sdk_flutter/src/comments/comments_view.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/rendering.dart';

class CommentsFragment extends StatelessWidget {
  const CommentsFragment({
    super.key,
    this.containerId,
    this.title,
    this.description,
    this.url,
    this.thubmnailUrl,
  });

  final String? containerId;
  final String? title;
  final String? description;
  final String? url;
  final String? thubmnailUrl;

  @override
  Widget build(BuildContext context) {
    const String viewType = 'vfCommentsFragment';

    final Map<String, dynamic> creationParams = <String, dynamic>{};
    creationParams["containerId"] = containerId;
    creationParams["title"] = title;
    creationParams["description"] = description;
    creationParams["url"] = url;
    creationParams["thubmnailUrl"] = thubmnailUrl;

    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return PlatformViewLink(
          viewType: viewType,
          surfaceFactory: (context, controller) {
            return AndroidViewSurface(
              controller: controller as AndroidViewController,
              gestureRecognizers: const <Factory<
                  OneSequenceGestureRecognizer>>{},
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
