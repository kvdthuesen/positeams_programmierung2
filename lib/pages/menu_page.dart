import 'package:flutter/material.dart';
import 'package:positeams_programmierung2/pages/main_screen.dart';
import 'package:positeams_programmierung2/components/appbar.dart';

/// Stateful Menu page that retains its state during tab switching.
class MenuPage extends StatefulWidget {
  final int previousIndex; // To return to the previous tab when canceling

  const MenuPage({super.key, this.previousIndex = 3}); // Default to MyProfile (index 3)

  @override
  _MenuPageState createState() => _MenuPageState();
}

class _MenuPageState extends State<MenuPage> with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return Scaffold(
      // Custom AppBar with an "X" action, positioned like the menu button on MyProfile
      appBar: MyAppBar(
        title: 'Teams',
        titleAlign: TextAlign.left,
        automaticallyImplyLeading: false, // Removes default back button
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0), // Same padding as menu button
            child: IconButton(
              icon: const Icon(Icons.close, size: 32, color: Colors.black), // Styled like the menu button
              onPressed: () {
                // Return to the MyProfile tab using MainScreen's tab navigation
                MainScreenState? mainScreenState = context.findAncestorStateOfType<MainScreenState>();
                if (mainScreenState != null) {
                  mainScreenState.onItemTapped(widget.previousIndex); // Switch back to MyProfile tab
                }
              },
            ),
          ),
        ],
        showBottomBorder: true,
      ),
      // Main content of the Menu page
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Text(
              'Hier kommt das Menü hin.',
              style: TextStyle(
                fontSize: 24,
                fontFamily: 'Futura',
              ),
            ),
          ],
        ),
      ),
    );
  }
}