import 'package:flutter/material.dart';
import 'package:positeams_programmierung2/components/post.dart';
import 'package:positeams_programmierung2/components/appbar.dart';

/// Homepage widget that maintains state between tab switches.
/// Uses AutomaticKeepAliveClientMixin to retain scroll position and widget state.
class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> with AutomaticKeepAliveClientMixin {

  /// Ensures that the state of this widget is preserved when switching tabs.
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    // Call to super.build is required when using AutomaticKeepAliveClientMixin
    super.build(context);

    return Scaffold(
      // Custom app bar component for consistent branding and layout
      appBar: MyAppBar(
        title: 'PosiTeams',
        titleAlign: TextAlign.left,
        actions: [
          IconButton(
            icon: const Icon(Icons.swap_vert, size: 35),
            onPressed: () {
              // Action for sorting/swapping logic (to be implemented)
            },
          ),
          Padding(
            padding: const EdgeInsets.only(right: 12.0),
            child: IconButton(
              icon: const Icon(Icons.filter_list, size: 35),
              onPressed: () {
                // Action for filtering logic (to be implemented)
              },
            ),
          ),
        ],
      ),
      // Main content of the page, displayed in a ListView to enable scrolling
      body: ListView(
        children: const [
          SizedBox(height: 8),
          Post(), // Individual post widget, repeated multiple times
          Post(),
          Post(),
          Post(),
        ],
      ),
      // Remove bottomNavigationBar since it's handled by MainScreen
    );
  }
}