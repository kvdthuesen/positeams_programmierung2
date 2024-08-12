import 'package:flutter/material.dart';
import 'package:positeams_programmierung2/pages/explore_page.dart';

class Search extends StatelessWidget {
  const Search({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false, // Removes the standard back button
        title: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text: 'Posi',
                    style: TextStyle(
                      fontFamily: 'Futura Condensed',
                      fontSize: 32,
                      fontWeight: FontWeight.w500,
                      color: Color.fromARGB(255, 7, 110, 23),
                    ),
                  ),
                  TextSpan(
                    text: 'Teams',
                    style: TextStyle(
                      fontFamily: 'futura Condensed',
                      fontSize: 32,
                      fontWeight: FontWeight.w500,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextButton(
              onPressed: () {
                // navigation back to explore page
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
        bottom: PreferredSize( //divider
          preferredSize: const Size.fromHeight(1.0),
          child: Container(
            color: const Color.fromARGB(255, 229, 229, 229),
            height: 1.0,
          ),
        ),
      ),

      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 40,
              decoration: BoxDecoration(
                color: Color.fromARGB(100, 220, 220, 220),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: Colors.black,
                ),
              ),
              child: TextField(
                style: TextStyle(
                  fontFamily: 'Futura',
                  fontSize: 16,
                ),
                decoration: InputDecoration(
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
            const Text(
              'Zuletzt Gesucht',
              style: TextStyle(
                fontSize: 16,
                fontFamily: 'Futura',
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 8),
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

  Widget _buildSearchItem(String text) {
    return Container(
      height: 40,
      margin: const EdgeInsets.symmetric(vertical: 1.0), // Reduced vertical margin
      decoration: BoxDecoration(
        color: Color.fromARGB(100, 220, 220, 220),
        borderRadius: BorderRadius.circular(8),
      ),
      alignment: Alignment.center,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween, // Space between text and icon
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 16.0),
            child: Text(
              text,
              style: TextStyle(
                fontFamily: 'Futura',
                color: Colors.grey,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
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
