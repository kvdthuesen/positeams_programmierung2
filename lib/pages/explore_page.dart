import 'package:flutter/material.dart';
import 'package:positeams_programmierung2/components/post.dart';
import 'package:positeams_programmierung2/components/appbar.dart';
import 'package:positeams_programmierung2/pages/main_screen.dart';

/// Explore page displaying a list of posts.
class Explore extends StatefulWidget {
  const Explore({super.key});

  @override
  _ExploreState createState() => _ExploreState();
}

class _ExploreState extends State<Explore> with AutomaticKeepAliveClientMixin {

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return Scaffold(
      // Custom AppBar with search functionality
      appBar: MyAppBar(
        title: 'PosiTeams',
        titleAlign: TextAlign.left,
        automaticallyImplyLeading: false, // remove the back button
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: IconButton(
              icon: const Icon(Icons.search, size: 32),
              onPressed: () {
                // Use MainScreen's tab navigation to go to the Search page
                MainScreenState? mainScreenState = context.findAncestorStateOfType<MainScreenState>();
                if (mainScreenState != null) {
                  mainScreenState.onItemTapped(4); // Correct index for SearchPage
                }
              },
            ),
          ),
        ],
        showBottomBorder: true,
      ),

      // Main content of the Explore page
      body: ListView(
        children: const [
          SizedBox(height: 8), // Adds spacing at the top
          Post(),  // Post widget displaying content
          Post(),
          Post(),
          Post(),
        ],
      ),
    );
  }
}