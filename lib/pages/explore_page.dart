import 'package:flutter/material.dart';
import 'package:positeams_programmierung2/pages/search_page.dart';
import 'package:positeams_programmierung2/components/post.dart';
import 'package:positeams_programmierung2/components/navigationbar.dart';

class Explore extends StatelessWidget {
  const Explore({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false, // delete back-narrow
        title: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text: 'Posi',
                    style: TextStyle(
                      fontFamily: 'futura Condensed',
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
            padding: const EdgeInsets.only(right: 16.0),
            child: IconButton(
              icon: Icon(
                  Icons.search,
                  size: 32),
              onPressed: () {
                // navigation to search class
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const Search()),
                );
              },
            ),
          ),
        ],
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(1.0), // Height of the bottom border
          child: Container(
            color: Color.fromARGB(255, 229, 229, 229), // Color of the bottom border
            height: 1.0,
          ),
        ),
      ),
      body: ListView( // scrollen
        children: [
          SizedBox(height: 8),
          Post(),
          Post(),
          Post(),
          Post(),
        ],
      ),
      bottomNavigationBar: const MyNavigationBar(currentIndex: 1), // integration of navigationbar
    );
  }
}