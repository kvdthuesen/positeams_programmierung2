import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
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
  final TextEditingController _searchController = TextEditingController(); // Controller for search input
  final FirebaseAuth _auth = FirebaseAuth.instance; // Firebase authentication instance
  final FirebaseFirestore _firestore = FirebaseFirestore.instance; // Firestore instance for database operations

  List<String> _recentSearches = []; // To store recent search queries
  String? _lastSelectedSearch; // Variable to store the last selected search

  /// Ensures that the widget's state (such as the search field input) is preserved when switching tabs.
  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    _loadRecentSearches(); // Load recent searches when the page is initialized
  }

  // Function to load the recent searches from Firebase
  Future<void> _loadRecentSearches() async {
    User? user = _auth.currentUser; // Get the current user

    if (user != null) {
      // Retrieve the document using the user's ID as the document ID
      DocumentSnapshot searchSnapshot = await _firestore
          .collection('searches')
          .doc(user.uid)
          .get(); // Get the user's search document

      if (searchSnapshot.exists) {
        setState(() {
          // Load the recent searches list from the document and reverse the order for recent first
          _recentSearches = List<String>.from(searchSnapshot['recentSearches']).reversed.toList();
        });
      }
    }
  }

  // Function to save the search query in Firebase
  Future<void> _saveSearch(String query) async {
    User? user = _auth.currentUser; // Get the current user

    if (user != null && query.isNotEmpty) {
      // Get the document reference for the user's searches
      DocumentReference userSearchDoc = _firestore.collection('searches').doc(user.uid);

      // Update the recent searches list by adding new search query
      await userSearchDoc.set({
        'recentSearches': FieldValue.arrayUnion([query]) // Add new query to the list
      }, SetOptions(merge: true));

      // Reload recent searches after saving the new one
      _loadRecentSearches();
    }
  }

  // Function to delete a search query from Firebase
  Future<void> _deleteSearch(String query) async {
    User? user = _auth.currentUser; // Get current user

    if (user != null) {
      // Get document reference for the user's searches
      DocumentReference userSearchDoc = _firestore.collection('searches').doc(user.uid);

      // Remove the search query from the list in Firebase
      await userSearchDoc.update({
        'recentSearches': FieldValue.arrayRemove([query])
      });

      // Clear the search field only if the deleted search is currently active in the search field
      if (_searchController.text == query && _lastSelectedSearch != query) {
        _searchController.clear();
      }

      // Reload the recent searches after one is deleted
      _loadRecentSearches();
    }
  }

// Function that triggers when the user presses enter in the search field or clicks the search icon
  void _onSearch() {
    String searchQuery = _searchController.text.trim(); // Get search query from the input field

    if (searchQuery.isNotEmpty) {
      // Save the search query to Firebase
      _saveSearch(searchQuery);

      // Call the method to update the search query in MainScreen
      MainScreenState? mainScreenState = context.findAncestorStateOfType<MainScreenState>();
      if (mainScreenState != null) {
        mainScreenState.updateSearchQuery(searchQuery); // Pass the search query to MainScreen
      }
    } else {
      // Set the search query to null if the input is empty
      MainScreenState? mainScreenState = context.findAncestorStateOfType<MainScreenState>();
      if (mainScreenState != null) {
        mainScreenState.updateSearchQuery(''); // Pass an empty string or null to reset the search
      }
    }

    // Clear the search field after the search is performed
    _searchController.clear();

    // After performing the search or reset, navigate back to the previous tab (Explore page)
    _navigateBack();
  }

  // Navigate back to the previous page (Explore page or previous tab)
  void _navigateBack() async {
    MainScreenState? mainScreenState = context.findAncestorStateOfType<MainScreenState>();
    if (mainScreenState != null) {
      // Introduce a short delay to give Explore page time to load
      await Future.delayed(const Duration(milliseconds: 150));

      // Trigger navigation back to the previous index
      mainScreenState.onItemTapped(widget.previousIndex);
    }
  }

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
              icon: const Icon(Icons.close, size: 32, color: Colors.black),
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
              maxLength: 25,
              decoration: InputDecoration(
                labelText: "Suche Kolleg*innen, Teams, Stichworte ...",
                labelStyle: const TextStyle(color: Color.fromARGB(255, 7, 110, 23)),
                fillColor: Colors.white,
                filled: true,
                border: const OutlineInputBorder(),
                focusedBorder: const OutlineInputBorder(
                  borderSide: BorderSide(color: Color.fromARGB(255, 7, 110, 23)), // frame in green in focus
                ),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.search, color: Colors.black, size: 32), // Search-Icon now on the right
                  onPressed: () {
                    _onSearch(); // Trigger search when the search icon is pressed
                  },
                ),
              ),
              style: const TextStyle(
                fontFamily: 'Futura',
                fontSize: 16,
              ),
              onSubmitted: (value) {
                _onSearch(); // Trigger search logic when the Enter key is pressed
              },
            ),
            const SizedBox(height: 16),
            // Display recent search title
            // Only show "Zuletzt Gesucht" if there are recent searches
            if (_recentSearches.isNotEmpty) ...[
              const Text(
                'Zuletzt Gesucht',
                style: TextStyle(
                  fontSize: 16,
                  fontFamily: 'Futura',
                  color: Colors.grey,
                ),
              ),
              const SizedBox(height: 8),
            ],
            // List of recent search items displayed in a scrollable ListView
            Expanded(
              child: ListView(
                children: _recentSearches.map((search) => _buildSearchItem(search)).toList(), // Display each search query
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Builds an individual search item with a close icon
  Widget _buildSearchItem(String text) {
    return GestureDetector(
      onTap: () {
        _onPastSearchSelected(text); // Handle when a past search is tapped (restores it in the search field)
      },
      child: Container(
        height: 40,
        margin: const EdgeInsets.symmetric(vertical: 1.0),
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
                text, // Display the search text
                style: const TextStyle(
                  fontFamily: 'Futura',
                  color: Colors.grey,
                ),
              ),
            ),
            IconButton(
              icon: const Icon(Icons.close, color: Colors.grey), // Close icon to delete the search
              onPressed: () {
                _deleteSearch(text); // Delete the search when the "X" is clicked
              },
            ),
          ],
        ),
      ),
    );
  }

  // Function to handle when a past search is selected
  void _onPastSearchSelected(String query) {
    setState(() {
      _lastSelectedSearch = query; // Store selected search
      _searchController.text = query; // Set tapped search term in the search field
    });

    // Remove query from the list of searches and re-add it as the newest search
    _deleteSearch(query).then((_) {
      _saveSearch(query); // Read the search as the most recent
    });
  }
}