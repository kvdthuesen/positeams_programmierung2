import 'package:flutter/material.dart';
import 'package:positeams_programmierung2/pages/main_screen.dart';
import 'package:positeams_programmierung2/components/appbar.dart';

// Defines custom colors
const Color greenThumbColor = Color.fromARGB(255, 7, 110, 23); // Color for the switch thumb
const Color lightGreenTrackColor = Color(0xFF82A685); // Color for the switch track

/// Stateful Menu page that retains its state during tab switching.
class MenuPage extends StatefulWidget {
  final int previousIndex; // Index of the previous tab for navigation

  // Constructor for MenuPage, optionally takes an index for navigating back
  const MenuPage({super.key, this.previousIndex = 3});

  @override
  _MenuPageState createState() => _MenuPageState(); // Creates the state for MenuPage
}

class _MenuPageState extends State<MenuPage> with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true; // Ensures the page state is preserved

  @override
  Widget build(BuildContext context) {
    super.build(context); // Calls method from AutomaticKeepAliveClientMixin

    return Scaffold(
      appBar: MyAppBar(
        title: 'Teams',
        titleAlign: TextAlign.left,
        automaticallyImplyLeading: false, // Prevents automatic addition of a back button
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0), // Padding - close button
            child: IconButton(
              icon: const Icon(Icons.close, size: 32, color: Colors.black),
              onPressed: _navigateBackToPreviousTab,
            ),
          ),
        ],
        showBottomBorder: true, // divider
      ),
      body: Padding(
        padding: const EdgeInsets.all(6.0), // Padding - body content
        child: ListView(
          children: [
            _buildMenuItem(Icons.settings, 'Kontoeinstellungen', [ // Menu item for account settings
              ListTile(
                title: Text('Passwort oder Namen ändern', style: _contentStyle), // Text for the list item - account settings
                onTap: () {},
              ),
              ListTile(
                title: Text('Profilbild oder Titelbild ändern', style: _contentStyle), // Text for the list item - profile images
                onTap: () {},
              ),
            ]),
            _buildMenuItem(Icons.dark_mode, 'Dark Mode', [ // Menu item for Dark Mode
              ListTile(
                title: Text('Wechseln zwischen Tag und Nacht', style: _contentStyle), // Text for the list item  - dark mode
                trailing: SwitchTheme(
                  data: SwitchThemeData(
                    thumbColor: WidgetStateProperty.all<Color>(greenThumbColor), // Switch thumb color - change general listVies design with SwitchThemeData
                    trackColor: WidgetStateProperty.all<Color>(lightGreenTrackColor), // Switch track color
                  ),
                  child: Switch(
                    value: false, // Initial value of the switch
                    onChanged: (bool value) {}, // Callback for switch changes
                  ),
                ),
              ),
            ]),
            _buildMenuItem(Icons.privacy_tip, 'Datenschutz', [ // Menu item for Privacy Policy
              Padding(
                padding: const EdgeInsets.all(16.0), // Padding for the text
                child: Text(
                  '''Datenschutzerklärung

1. Einleitung

Willkommen bei PosiTeams! Der Schutz Ihrer persönlichen Daten ist uns sehr wichtig. Diese Datenschutzerklärung erläutert, wie wir Ihre personenbezogenen Daten sammeln, verwenden und schützen, wenn Sie unsere interne Social Media-Plattform nutzen.

2. Verantwortlicher

Verantwortlich für die Verarbeitung Ihrer personenbezogenen Daten im Rahmen von PosiTeams ist:

PosiTeams GmbH  
Musterstraße 123  
12345 Musterstadt  
Deutschland  
Telefon: +49 123 456 789  
E-Mail: datenschutz@positeams.de  
Datenschutzbeauftragter: [Name des Datenschutzbeauftragten, falls vorhanden]

...

11. Kontakt

Bei Fragen oder Anliegen bezüglich Ihrer personenbezogenen Daten können Sie uns unter folgenden Kontaktdaten erreichen:

PosiTeams GmbH  
Musterstraße 123  
12345 Musterstadt  
Deutschland  
E-Mail: datenschutz@positeams.de
                  ''',
                  style: _contentStyle, // Style for the text
                  textAlign: TextAlign.justify, // Justifies the text alignment
                ),
              ),
            ]),
            _buildMenuItem(Icons.article, 'AGB', [ // Menu item for Terms and Conditions
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  '''Allgemeine Geschäftsbedingungen

1. Geltungsbereich

Diese Allgemeinen Geschäftsbedingungen (AGB) gelten für die Nutzung der internen Social Media-Plattform PosiTeams. Mit der Nutzung von PosiTeams akzeptieren Sie diese AGB.

2. Vertragsgegenstand

PosiTeams bietet eine Plattform für die interne Kommunikation und den Austausch von Informationen innerhalb des Unternehmens. Die Nutzung der Plattform erfolgt gemäß diesen AGB und den geltenden gesetzlichen Bestimmungen.

...

9. Schlussbestimmungen

Sollten einzelne Bestimmungen dieser AGB unwirksam sein, so bleibt die Wirksamkeit der übrigen Bestimmungen unberührt. Es gilt das Recht der Bundesrepublik Deutschland.

Für Fragen oder Anliegen zu diesen AGB können Sie uns unter den folgenden Kontaktdaten erreichen:

PosiTeams GmbH  
Musterstraße 123  
12345 Musterstadt  
Deutschland  
E-Mail: support@positeams.de
                  ''',
                  style: _contentStyle, // text style
                  textAlign: TextAlign.justify,
                ),
              ),
            ]),
            _buildMenuItem(Icons.logout, 'Abmelden', [ // Menu item for Sign Out
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  'Von Deinem Konto abmelden.', // Text for the list item
                  style: _contentStyle, // text style
                ),
              ),
            ]),
          ],
        ),
      ),
    );
  }

  // Method to navigate back to the previous tab
  void _navigateBackToPreviousTab() {
    final mainScreenState = context.findAncestorStateOfType<MainScreenState>(); // Finds the state of the main screen
    if (mainScreenState != null) {
      mainScreenState.onItemTapped(widget.previousIndex); // Navigates back to the previous tab
    }
  }

  // Method to build a menu item with icon, title, and content
  Widget _buildMenuItem(IconData icon, String title, List<Widget> content) {
    return Container(
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: Colors.transparent, // Transparent bottom border for menu items
          ),
        ),
      ),
      child: Theme(
        data: ThemeData(
          dividerColor: Colors.transparent, // Transparent divider color for the theme
        ),
        child: MenuItem(
          icon: icon,
          title: title,
          content: content,
        ),
      ),
    );
  }

  // Style for the text content in menu items
  TextStyle get _contentStyle => const TextStyle(
    fontSize: 16,
    fontFamily: 'Futura',
    color: Colors.black, // Font color - in list view
  );
}

// Widget for a menu item with an expandable content
class MenuItem extends StatefulWidget {
  final IconData icon; // Icon for the menu item
  final String title; // Title of the menu item
  final List<Widget> content; // Content of the menu item

  // Constructor for MenuItem
  const MenuItem({
    super.key,
    required this.icon,
    required this.title,
    required this.content,
  });

  @override
  _MenuItemState createState() => _MenuItemState(); // Creates the state for the menu item
}

class _MenuItemState extends State<MenuItem> {
  bool isExpanded = false; // State to track if the menu item is expanded

  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      leading: Icon(
        widget.icon, // Icon for the menu item
        size: 28, // Icon size
        color: isExpanded ? greenThumbColor : Colors.black87, // Icon color based on expanded state
      ),
      title: Text(
        widget.title, // Title of the menu item
        style: const TextStyle(
          fontSize: 18,
          fontFamily: 'Futura',
        ),
      ),
      onExpansionChanged: (bool expanded) {
        setState(() {
          isExpanded = expanded; // Updates state based on expansion
        });
      },
      children: widget.content, // Content of the menu item
    );
  }
}
