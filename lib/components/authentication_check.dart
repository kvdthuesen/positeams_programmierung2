import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:positeams_programmierung2/pages/authentication_page.dart';

/// Function to check if the user is authenticated.
/// If not authenticated, it shows a message and navigates to the AuthPage.
Future<void> checkAuthentication(BuildContext context) async {
  final user = FirebaseAuth.instance.currentUser;
  if (user == null) {
    // Show a message to the user
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Sie wurden automatisch abgemeldet. Bitte melden Sie sich erneut an')),
    );

    // Wait a short time to ensure the message is displayed before navigating
    await Future.delayed(const Duration(seconds: 2));

    // Navigate to the authentication page
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const AuthPage()),
    );
  }
}