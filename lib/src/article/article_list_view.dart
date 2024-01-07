import 'package:flutter/material.dart';

import 'article_view.dart';
import 'article.dart';

/// Displays a list of SampleItems.
class ArticleListView extends StatelessWidget {
  const ArticleListView({
    super.key,
    this.items = const [Article("1"), Article("2"), Article("3")],
  });

  static const routeName = '/';

  final List<Article> items;

  @override
  Widget build(BuildContext context) {
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
