import 'package:flutter/material.dart';
import 'package:sdk_flutter/src/auth/login/login_view.dart';

import 'article_view.dart';
import 'article.dart';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Displays a list of SampleItems.
class ArticleListView extends StatelessWidget {
  const ArticleListView(
      {super.key,
      this.items = const [Article("a0335064233e55d-4442-aa6b-7fdcfe54636b", "Korean Fusion Delight", "https://viafoura-mobile-demo.vercel.app/posts/brexit-to-cost-gbp1-200-for-each-person-in-uk", "https://www.datocms-assets.com/67251/1701970811-tacos.jpg?fit=crop&fm=webp&h=428&w=856", "Homemade Bulgogi Tacos Recipe")],
      this.channel = const MethodChannel('AUTH_CHANNEL')});

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
      appBar: AppBar(title: const Text('Articles'), actions: []),
      body: ListView.builder(
        restorationId: 'sampleItemListView',
        itemCount: items.length,
        itemBuilder: (BuildContext context, int index) {
          final article = items[index];

          return ListTile(
              title: Text('Article ${article.containerId}'),
              leading: const CircleAvatar(
                foregroundImage: AssetImage('assets/images/flutter_logo.png'),
              ),
              onTap: () {
                Navigator.pushNamed(
                  context,
                  ArticleView.routeName,
                  arguments: article
                );
              });
        },
      ),
    );
  }
}
