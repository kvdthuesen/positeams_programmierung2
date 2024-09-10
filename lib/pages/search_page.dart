import 'package:flutter/material.dart';
import 'package:positeams_programmierung2/pages/explore_page.dart';
import 'package:positeams_programmierung2/components/appbar.dart';

/// Stateful Search page that retains its state during tab switching.
/// Uses AutomaticKeepAliveClientMixin to preserve the state of the search field and recent searches.
class Search extends StatefulWidget {
  const Search({super.key});

  @override
  _SearchState createState() => _SearchState();
}

class _SearchState extends State<Search> with AutomaticKeepAliveClientMixin {

  /// Ensures that the widget's state (such as the search field input) is preserved when switching tabs.
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context); // Ensures AutomaticKeepAliveClientMixin works properly.

    return Scaffold(
      // Custom AppBar with no leading back button and a cancel action
      appBar: MyAppBar(
        title: 'PosiTeams',
        titleAlign: TextAlign.left,
        automaticallyImplyLeading: false, // Removes default back button
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextButton(
              onPressed: () {
                // Navigate back to the explore page using pushReplacement
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const Explore()),
                );
              },
              child: const Text(
                'Abbrechen',
                style: TextStyle(
                  color: Color.fromARGB(255, 7, 110, 23),
                  fontSize: 20,
                  fontFamily: 'Futura',
                ),
              ),
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
            // Search input field with a rounded border and search icon
            Container(
              height: 40,
              decoration: BoxDecoration(
                color: const Color.fromARGB(100, 220, 220, 220),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: Colors.black,
                ),
              ),
              child: TextField(
                style: const TextStyle(
                  fontFamily: 'Futura',
                  fontSize: 16,
                ),
                decoration: const InputDecoration(
                  prefixIcon: Icon(Icons.search, color: Colors.black),
                  hintText: 'Finde Kolleg*innen, Teams, Stichworte...',
                  hintStyle: TextStyle(
                    fontFamily: 'Futura',
                    fontSize: 16,
                    color: Colors.grey,
                  ),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(vertical: 10),
                ),
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
        borderRadius: BorderRadius.circular(8),
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
