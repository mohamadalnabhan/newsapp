import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'display_news.dart';
import 'news_articles.dart';
 // Adjust the import to reflect the new folder name
 // Replace with the correct  // Ensure this contains your model class

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: DisplayNews(),
    );
  }
}
