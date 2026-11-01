import 'package:flutter/material.dart';

import 'data/content_store.dart';
import 'pages/home_page.dart';
import 'theme/app_theme.dart';

void main() {
  runApp(const ContentFlowApp());
}

class ContentFlowApp extends StatefulWidget {
  const ContentFlowApp({super.key});

  @override
  State<ContentFlowApp> createState() => _ContentFlowAppState();
}

class _ContentFlowAppState extends State<ContentFlowApp> {
  late final ContentStore _store = ContentStore();

  @override
  void dispose() {
    _store.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ContentFlow',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light(),
      home: HomePage(store: _store),
    );
  }
}
