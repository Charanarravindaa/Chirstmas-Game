import 'package:flutter/material.dart';
import 'startpage.dart';

void main() {
  runApp(ChristmasQuizApp());
}

class ChristmasQuizApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Christmas Quiz',
      theme: ThemeData(
        primarySwatch: Colors.red,
        scaffoldBackgroundColor: Colors.green[50],
      ),
      home: StartPage(), // Initial screen: StartPage
    );
  }
}
