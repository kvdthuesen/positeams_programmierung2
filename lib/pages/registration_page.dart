import 'package:flutter/material.dart'; // Import flutter material
import 'package:positeams_programmierung2/components/appbar.dart'; // Import Appbar component
import 'package:positeams_programmierung2/pages/main_screen.dart'; // Import MainScreen

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();

  void _register() {
    final email = _emailController.text;
    final password = _passwordController.text;
    final confirmPassword = _confirmPasswordController.text;

    // Placeholder registration logic (to be replaced with real logic)
    print("Email: $email, Password: $password, Confirm Password: $confirmPassword");

    // Navigate to MainScreen
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const MainScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(
        title: 'PosiTeams', // Use title for the AppBar
        titleAlign: TextAlign.center, // Center the title
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, size: 30), // Back arrow icon
          onPressed: () {
            Navigator.pop(context); // Navigate back to the previous page
          },
        ),
        actions: [
          Opacity(
            opacity: 0, // Invisible placeholder to perfectly center the title
            child: IconButton(
              icon: const Icon(Icons.menu), // Example icon as placeholder
              onPressed: null, // No action for this button
            ),
          ),
        ],
        showBottomBorder: true, // Show the bottom border in the AppBar
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Erstelle ein Konto.',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w300, // Set light weight (300)
                fontFamily: 'futura Condensed', // Use futura Condensed font
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _emailController,
              decoration: InputDecoration(
                labelText: "Email",
                labelStyle: const TextStyle(color: Color.fromARGB(255, 7, 110, 23)), // Label in green
                border: const OutlineInputBorder(),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: const Color.fromARGB(255, 7, 110, 23)), // Green border when focused
                ),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _passwordController,
              obscureText: true,
              decoration: InputDecoration(
                labelText: "Passwort",
                labelStyle: const TextStyle(color: Color.fromARGB(255, 7, 110, 23)), // Label in green
                border: const OutlineInputBorder(),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: const Color.fromARGB(255, 7, 110, 23)), // Green border when focused
                ),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _confirmPasswordController,
              obscureText: true,
              decoration: InputDecoration(
                labelText: "Passwort bestätigen",
                labelStyle: const TextStyle(color: Color.fromARGB(255, 7, 110, 23)), // Label in green
                border: const OutlineInputBorder(),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: const Color.fromARGB(255, 7, 110, 23)), // Green border when focused
                ),
              ),
            ),
            const SizedBox(height: 28), // Add space between elements for better layout
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: _register, // Call _register method when pressed
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(255, 7, 110, 23), // Green button
                      padding: const EdgeInsets.symmetric(vertical: 14), // Medium button height
                    ),
                    child: const Text(
                      "Registrieren",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16, // Medium text size
                      ),
                    ),
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