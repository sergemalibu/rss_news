import 'package:flutter/material.dart';
import 'package:rss_news/pages/homescreen_rss.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const HomeScreenRSS();
  }
}
