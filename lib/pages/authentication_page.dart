import 'package:flutter/material.dart';
import 'package:positeams_programmierung2/components/appbar.dart'; // Import MyAppBar component
import 'package:positeams_programmierung2/pages/registration_page.dart'; // Import RegisterPage
import 'package:positeams_programmierung2/pages/main_screen.dart'; // Import MainScreen for navigation after login

/// The AuthPage handles user login and navigation to the registration page.
/// After a successful login, it navigates to the MainScreen.
class AuthPage extends StatefulWidget {
  const AuthPage({super.key});

  @override
  _AuthPageState createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  /// Simulates the login process. Replace this logic with actual authentication later.
  /// Navigates to the MainScreen upon successful login.
  void _login() {
    final email = _emailController.text;
    final password = _passwordController.text;

    // Placeholder authentication logic (to be replaced with real logic)
    if (email.isNotEmpty && password.isNotEmpty) {
      // Navigate to MainScreen after login
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const MainScreen()),
      );
    } else {
      // Show an error (e.g., empty fields)
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter both email and password.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(
        title: 'PosiTeams', // Title of the app
        titleAlign: TextAlign.center, // Center the title
        automaticallyImplyLeading: false, // Remove the default back button
        showBottomBorder: true, // Enable a bottom divider under the AppBar
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
                fontFamily: 'futura Condensed', // Font style
              ),
            ),
            const SizedBox(height: 16),
            // Email input field
            TextField(
              controller: _emailController,
              decoration: InputDecoration(
                labelText: "E-Mail",
                labelStyle: const TextStyle(color: Color.fromARGB(255, 7, 110, 23)),
                border: const OutlineInputBorder(),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: const Color.fromARGB(255, 7, 110, 23)),
                ),
              ),
            ),
            const SizedBox(height: 16),
            // Password input field
            TextField(
              controller: _passwordController,
              obscureText: true, // Hide the password input
              decoration: InputDecoration(
                labelText: "Passwort",
                labelStyle: const TextStyle(color: Color.fromARGB(255, 7, 110, 23)),
                border: const OutlineInputBorder(),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: const Color.fromARGB(255, 7, 110, 23)),
                ),
              ),
            ),
            const SizedBox(height: 28), // Padding between input and button
            // Login button
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: _login, // Calls the _login function when pressed
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(255, 7, 110, 23), // Green color
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
            // Navigation to registration page
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text("Noch keinen Account?"),
                TextButton(
                  onPressed: () {
                    // Navigate to the registration page
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
        ),
      ),
    );
  }
}