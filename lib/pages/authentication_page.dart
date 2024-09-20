import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';  // Firebase Auth import for user authentication
import 'package:positeams_programmierung2/components/appbar.dart';
import 'package:positeams_programmierung2/pages/registration_page.dart';
import 'package:positeams_programmierung2/pages/main_screen.dart';

/// The AuthPage handles user login via Firebase Authentication.
/// If the login is successful, it navigates to the MainScreen.
class AuthPage extends StatefulWidget {
  const AuthPage({super.key});

  @override
  _AuthPageState createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  final TextEditingController _emailController = TextEditingController();  // Controller to handle email input
  final TextEditingController _passwordController = TextEditingController();  // Controller to handle password input
  bool _isLoading = false; // Variable to track the loading state

  /// Handles the login process using Firebase Authentication.
  /// If the login is successful, navigates to the MainScreen.
  void _login() async {
    final email = _emailController.text;
    final password = _passwordController.text;

    // Check if email or password fields are empty
    if (email.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Bitte E-Mail und Passwort eingeben.')),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      // Attempt to sign in the user with Firebase Authentication
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (!mounted) return; // Ensure the widget is still mounted before navigating

      // Navigate to the MainScreen after a successful login
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const MainScreen()),
      );
    } on FirebaseAuthException catch (e) {
      if (!mounted) return; // Ensure the widget is still mounted before using context

      // Handle specific Firebase Authentication errors
      if (e.code == 'user-not-found') {
        // No user found with the provided email
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Kein Nutzer mit dieser E-Mail gefunden.')),
        );
      } else if (e.code == 'wrong-password') {
        // Incorrect password
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Falsches Passwort.')),
        );
      } else if (e.code == 'invalid-email') {
        // Invalid email format
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Ungültige E-Mail-Adresse.')),
        );
      } else if (e.code == 'user-disabled') {
        // User account disabled
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Dieses Konto wurde deaktiviert.')),
        );
      } else if (e.code == 'too-many-requests') {
        // Too many failed login attempts
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Zu viele fehlgeschlagene Anmeldeversuche. Versuchen Sie es später erneut.')),
        );
      } else {
        // Generic error message for any other authentication errors
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Fehler bei der Anmeldung: ${e.message}')),
        );
      }
    } finally {
      if (mounted) {
        // Stop loading after login attempt only if still mounted
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const MyAppBar(
        title: 'PosiTeams',
        titleAlign: TextAlign.center,
        automaticallyImplyLeading: false,
        showBottomBorder: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Zeit für gute Nachrichten.',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w300,
                fontFamily: 'futura Condensed',
              ),
            ),
            const SizedBox(height: 16),

            // Email input field
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(
                labelText: "E-Mail",
                labelStyle: TextStyle(color: Color.fromARGB(255, 7, 110, 23)),
                border: OutlineInputBorder(),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Color.fromARGB(255, 7, 110, 23)),
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Password input field
            TextField(
              controller: _passwordController,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: "Passwort",
                labelStyle: TextStyle(color: Color.fromARGB(255, 7, 110, 23)),
                border: OutlineInputBorder(),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Color.fromARGB(255, 7, 110, 23)),
                ),
              ),
            ),
            const SizedBox(height: 28),

            if (_isLoading) ...[
              const Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Color.fromARGB(255, 7, 110, 23)), // Green color
                ),
              ),
              const SizedBox(height: 16),
              const Center(
                child: Text(
                  'Anmeldung läuft...',
                  style: TextStyle(
                    fontSize: 16,
                    fontFamily: 'futura',
                    color: Color.fromARGB(255, 7, 110, 23),
                  ),
                ),
              ),
            ] else ...[
              // Login button
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: _login,  // Calls the _login function when pressed
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color.fromARGB(255, 7, 110, 23),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                      child: const Text(
                        "Anmelden",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Registration link
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("Noch keinen Account?"),
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const RegisterPage()),
                      );
                    },
                    child: const Text(
                      "Registrieren",
                      style: TextStyle(color: Color.fromARGB(255, 7, 110, 23)),
                    ),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }
}