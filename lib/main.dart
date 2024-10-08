import 'package:flutter/material.dart';
import 'package:positeams_programmierung2/pages/authentication_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';


Future<void> main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false, // Remove debug banner
      home: const AuthPage(), // Start with homepage
      theme: ThemeData(
        scaffoldBackgroundColor: Colors.white, // Set global background color to white
      ),
    );
  }
}
