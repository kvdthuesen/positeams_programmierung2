import 'package:flutter/material.dart';
import 'package:positeams_programmierung2/pages/authentication_page.dart'; // Importiere die neue Anmeldeseite
//import 'package:positeams_programmierung2/pages/addPost_page.dart';



void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(debugShowCheckedModeBanner: false, //remove debug banner
      home: AuthPage(), // start with homepage
    );
  }
}
