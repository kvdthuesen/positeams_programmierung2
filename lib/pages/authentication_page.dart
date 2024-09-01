import 'package:flutter/material.dart';
import 'package:positeams_programmierung2/components/appbar.dart'; // Importiere die MyAppBar
import 'package:positeams_programmierung2/pages/home_page.dart'; // Importiere die HomePage
import 'package:positeams_programmierung2/pages/registration_page.dart'; // Importiere die RegisterPage

class AuthPage extends StatefulWidget {
  const AuthPage({super.key});

  @override
  _AuthPageState createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  void _login() {
    final email = _emailController.text;
    final password = _passwordController.text;

    // Hier kannst du Logik zur Authentifizierung hinzufügen (wird später mit Firebase ergänzt)

    // Leite zur HomePage weiter
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const Homepage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(  // Verwende die MyAppBar-Komponente
        title: 'PosiTeams', // Der Titel, der für die AppBar verwendet wird
        titleAlign: TextAlign.center, // Zentriere den Titel
        automaticallyImplyLeading: false, // Entferne den Zurück-Button
        showBottomBorder: true, // Trennlinie unter der AppBar aktivieren
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
                fontWeight: FontWeight.w300, // Setze das Gewicht auf Light (300)
                fontFamily: 'futura Condensed', // Setze die Schriftart auf futura Condensed
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _emailController,
              decoration: InputDecoration(
                labelText: "E-Mail",
                labelStyle: const TextStyle(color: Color.fromARGB(255, 7, 110, 23)), // Label in Grün
                border: const OutlineInputBorder(),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: const Color.fromARGB(255, 7, 110, 23)), // Rahmen in Grün bei Fokus
                ),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _passwordController,
              obscureText: true,
              decoration: InputDecoration(
                labelText: "Passwort",
                labelStyle: const TextStyle(color: Color.fromARGB(255, 7, 110, 23)), // Label in Grün
                border: const OutlineInputBorder(),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: const Color.fromARGB(255, 7, 110, 23)), // Rahmen in Grün bei Fokus
                ),
              ),
            ),
            const SizedBox(height: 28), // Zwischen den Abständen für bessere Höhe
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: _login, // Beim Klick wird die _login-Methode aufgerufen
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(255, 7, 110, 23), // Schaltfläche in Grün
                      padding: const EdgeInsets.symmetric(vertical: 14), // Mittelgroße Höhe
                    ),
                    child: const Text(
                      "Anmelden",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16, // Mittlere Textgröße
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text("Noch keinen Account?"),
                TextButton(
                  onPressed: () {
                    // Navigiere zur Registrierungsseite
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const RegisterPage()),
                    );
                  },
                  child: const Text(
                    "Registrieren",
                    style: TextStyle(color: Color.fromARGB(255, 7, 110, 23)), // Link in Grün
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