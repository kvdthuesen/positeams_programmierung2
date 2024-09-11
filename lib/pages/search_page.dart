import 'package:flutter/material.dart';
import 'package:positeams_programmierung2/pages/main_screen.dart';
import 'package:positeams_programmierung2/components/appbar.dart';

/// Stateful Search page that retains its state during tab switching.
/// Uses AutomaticKeepAliveClientMixin to preserve the state of the search field and recent searches.
class Search extends StatefulWidget {
  final int previousIndex; // To return to the previous tab when canceling

  const Search({super.key, this.previousIndex = 1}); // Default to explore (index 1)

  @override
  _SearchState createState() => _SearchState();
}

class _SearchState extends State<Search> with AutomaticKeepAliveClientMixin {

  final TextEditingController _searchController = TextEditingController();

  /// Ensures that the widget's state (such as the search field input) is preserved when switching tabs.
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context); // Ensures AutomaticKeepAliveClientMixin works properly.

    return Scaffold(
      // Custom AppBar with no leading back button and a close action
      appBar: MyAppBar(
        title: 'PosiTeams',
        titleAlign: TextAlign.left,
        automaticallyImplyLeading: false, // Removes default back button
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: IconButton(
              icon: const Icon(Icons.close, size: 32, color: Colors.black), // Same size as the search icon
              onPressed: () {
                // Return to the previous tab using MainScreen's tab navigation
                MainScreenState? mainScreenState = context.findAncestorStateOfType<MainScreenState>();
                if (mainScreenState != null) {
                  mainScreenState.onItemTapped(widget.previousIndex); // Switch back to previous tab
                }
              },
            ),
          ),
        ],
        showBottomBorder: true,
      ),
      // Main content of the search page, including a search bar and recent search items
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Search input field
            TextField(
              controller: _searchController,
              decoration: InputDecoration(
                labelText: "Suche Kolleg*innen, Teams, Stichworte ...",
                labelStyle: const TextStyle(color: Color.fromARGB(255, 7, 110, 23)), // label in green
                fillColor: Colors.white,
                filled: true,
                border: const OutlineInputBorder(),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: const Color.fromARGB(255, 7, 110, 23)), // frame in green in focus
                ),
                prefixIcon: const Icon(Icons.search, color: Colors.black, size: 32), // Search-Icon
              ),
              style: const TextStyle(
                fontFamily: 'Futura',
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 16),
            // Display recent search title
            const Text(
              'Zuletzt Gesucht',
              style: TextStyle(
                fontSize: 16,
                fontFamily: 'Futura',
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 8),
            // List of recent search items displayed in a scrollable ListView
            Expanded(
              child: ListView(
                children: [
                  _buildSearchItem('Maya Morena Grau'),
                  _buildSearchItem('Joggen'),
                  _buildSearchItem('Team Sustainability'),
                  _buildSearchItem('Maya Morena Grau'),
                  _buildSearchItem('Joggen'),
                  _buildSearchItem('Team Sustainability'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Builds an individual search item with a close icon
  Widget _buildSearchItem(String text) {
    return Container(
      height: 40,
      margin: const EdgeInsets.symmetric(vertical: 1.0), // Reduced vertical margin for compact spacing
      decoration: BoxDecoration(
        color: const Color.fromARGB(100, 220, 220, 220),
        borderRadius: BorderRadius.circular(4),
      ),
      alignment: Alignment.center,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween, // Space between text and close icon
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 16.0),
            child: Text(
              text,
              style: const TextStyle(
                fontFamily: 'Futura',
                color: Colors.grey,
              ),
            ),
          ),
          const Padding(
            padding: EdgeInsets.only(right: 16.0),
            child: Icon(
              Icons.close,
              color: Colors.grey,
            ),
          ),
        ],
      ),
    );
  }
}