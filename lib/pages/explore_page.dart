import 'package:flutter/material.dart';
import 'package:positeams_programmierung2/pages/search_page.dart';
import 'package:positeams_programmierung2/components/post.dart';
import 'package:positeams_programmierung2/components/navigationbar.dart';
import 'package:positeams_programmierung2/components/appbar.dart';

class Explore extends StatelessWidget {
  const Explore({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar( // certain customization of the app bar class
        title: 'PosiTeams',
        titleAlign: TextAlign.left,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: IconButton(
              icon: Icon(Icons.search, size: 32),
              onPressed: () {
                // navigation to search page
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const Search()),
                );
              },
            ),
          ),
        ],
        showBottomBorder: true, // divider
      ),
      body: ListView(
        children: const [
          SizedBox(height: 8),
          Post(),
          Post(),
          Post(),
          Post(),
        ],
      ),
      bottomNavigationBar: const MyNavigationBar(currentIndex: 1), // Integration der Navigationsleiste
    );
  }
}
