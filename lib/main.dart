import 'package:flutter/material.dart';
import 'package:positeams_programmierung2/pages/homepage.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(debugShowCheckedModeBanner: false, //remove debug banner
      home: Homepage(), // start with homepage
    );
  }
}
