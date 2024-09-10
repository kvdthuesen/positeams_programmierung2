import 'package:flutter/material.dart';
import 'package:positeams_programmierung2/pages/search_page.dart';
import 'package:positeams_programmierung2/components/post.dart';
import 'package:positeams_programmierung2/components/navigationbar.dart';
import 'package:positeams_programmierung2/components/appbar.dart';

/// Explore page displaying a list of posts.
/// Converted to a StatefulWidget to ensure it retains its state when switching tabs.
class Explore extends StatefulWidget {
  const Explore({super.key});

  @override
  _ExploreState createState() => _ExploreState();
}

class _ExploreState extends State<Explore> with AutomaticKeepAliveClientMixin {

  /// Ensures that the widget's state is preserved across tab switches.
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context); // Required to maintain the state through AutomaticKeepAliveClientMixin

    return Scaffold(
      // Custom AppBar for the Explore page with search functionality
      appBar: MyAppBar(
        title: 'PosiTeams',
        titleAlign: TextAlign.left,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: IconButton(
              icon: const Icon(Icons.search, size: 32),
              onPressed: () {
                // Navigate to the search page when the search icon is pressed
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const Search()),
                );
              },
            ),
          ),
        ],
        showBottomBorder: true, // Adds a bottom border (divider)
      ),

      // Main content of the Explore page, displaying a list of posts
      body: ListView(
        children: const [
          SizedBox(height: 8), // Adds spacing at the top
          Post(),  // Post widget displaying content
          Post(),
          Post(),
          Post(),
        ],
      ),

      // Bottom navigation bar with the current index set to 1 (Explore page active)
      bottomNavigationBar: const MyNavigationBar(currentIndex: 1),
    );
  }
}