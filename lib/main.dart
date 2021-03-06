import 'package:flutter/material.dart';
import 'package:maptest/map_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Map Test',
      theme: ThemeData(
        primarySwatch: Colors.orange,
      ),
      home: const MapPage(),
    );
  }
}
