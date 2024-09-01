import 'package:flutter/material.dart';
import 'package:positeams_programmierung2/components/appbar.dart'; // Importiere die MyAppBar
import 'package:positeams_programmierung2/pages/home_page.dart'; // Importiere die HomePage

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

    // Hier kannst du Logik zur Registrierung hinzufügen (wird später mit Firebase ergänzt)
    print("Email: $email, Passwort: $password, Passwort bestätigen: $confirmPassword");

    // Leite zur HomePage weiter
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const Homepage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(
        title: 'PosiTeams', // Verwende den Titel für die AppBar
        titleAlign: TextAlign.center, // Zentriere den Titel
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, size: 30), // Zurück-Pfeil
          onPressed: () {
            Navigator.pop(context); // Zurück zur vorherigen Seite
          },
        ),
        actions: [
          Opacity(
            opacity: 0, // Unsichtbarer Platzhalter, um den Titel genau zu zentrieren
            child: IconButton(
              icon: const Icon(Icons.menu), // Beispiel-Icon als Platzhalter
              onPressed: null, // Keine Aktion
            ),
          ),
        ],
        showBottomBorder: true, // Zeige die Trennlinie unter der AppBar
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
            const SizedBox(height: 16),
            TextField(
              controller: _confirmPasswordController,
              obscureText: true,
              decoration: InputDecoration(
                labelText: "Passwort bestätigen",
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
                    onPressed: _register, // Beim Klick wird die _register-Methode aufgerufen
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(255, 7, 110, 23), // Schaltfläche in Grün
                      padding: const EdgeInsets.symmetric(vertical: 14), // Mittelgroße Höhe
                    ),
                    child: const Text(
                      "Registrieren",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16, // Mittlere Textgröße
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