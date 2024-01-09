import 'package:flutter/material.dart';
import 'package:sdk_flutter/src/article/article.dart';
import 'package:sdk_flutter/src/comments/comments_view.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:flutter/services.dart';
import 'package:flutter/gestures.dart';

class ArticleView extends StatefulWidget {
  const ArticleView({Key? key, required this.article}) : super(key: key);

  final Article? article;
  static const routeName = '/article';

  @override
  State<ArticleView> createState() => _MyArticleView();
}

class _MyArticleView extends State<ArticleView> {
  double commentsContainerHeight = 3000;
  double webviewHeight = 200;
  late WebViewController controller;

  MethodChannel channel = const MethodChannel('HEIGHT_UPDATED_CHANNEL');

  @override
  void initState() {
    super.initState();
    channel.setMethodCallHandler(invokedMethods);

    controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
          NavigationDelegate(onNavigationRequest: (request) {
        return NavigationDecision.navigate;
      }, onPageFinished: (x) async {
        var x = await controller.runJavaScriptReturningResult(
            "document.documentElement.scrollHeight");
        double? y = double.tryParse(x.toString());
        setState(() {
          webviewHeight = y ?? 0;
        });
      }))
      ..loadRequest(Uri.parse(widget.article?.url ?? ""));
  }

  Future<dynamic> invokedMethods(MethodCall methodCall) async {
    switch (methodCall.method) {
      case "heightUpdated":
        setState(() {
          commentsContainerHeight = methodCall.arguments;
        });
        break;
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Article"),
        ),
        body: Expanded(
          child: SingleChildScrollView(
              child: Column(children: <Widget>[
            SizedBox(
                height: webviewHeight,
                child: WebViewWidget(controller: controller)),
            SizedBox(
                height: commentsContainerHeight,
                child: CommentsFragment(
                  title: widget.article?.title,
                  url: widget.article?.url,
                  thubmnailUrl: widget.article?.thumbnailUrl,
                  description: widget.article?.description,
                  containerId: widget.article?.containerId,
                )),
          ])),
        ));
  }
}
