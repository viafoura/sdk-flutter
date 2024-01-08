import 'package:flutter/material.dart';
import 'package:sdk_flutter/src/auth/login/login_view.dart';

import 'article_view.dart';
import 'article.dart';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Displays a list of SampleItems.
class ArticleListView extends StatelessWidget {
  const ArticleListView({
    super.key,
    this.items = const [Article("News", "0100010", "", "")],
    this.channel = const MethodChannel('AUTH_CHANNEL')
  });

  static const routeName = '/';

  final List<Article> items;
  final MethodChannel channel;


  @override
  Widget build(BuildContext context) {
     Future<dynamic> invokedMethods(MethodCall methodCall) async {
    switch (methodCall.method) {
        case "startLogin":
           Navigator.restorablePushNamed(
                context,
                LoginView.routeName,
              );
      }
  }

    channel.setMethodCallHandler(invokedMethods);

    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Articles'),
        actions: []
      ),

      body: ListView.builder(
        restorationId: 'sampleItemListView',
        itemCount: items.length,
        itemBuilder: (BuildContext context, int index) {
          final item = items[index];

          return ListTile(
            title: Text('Article ${item.containerId}'),
            leading: const CircleAvatar(
              foregroundImage: AssetImage('assets/images/flutter_logo.png'),
            ),
            onTap: () {
              Navigator.restorablePushNamed(
                context,
                ArticleView.routeName,
              );
            }
          );
        },
      ),
    );
  }
}
