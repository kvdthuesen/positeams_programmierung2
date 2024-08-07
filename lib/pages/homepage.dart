import 'package:flutter/material.dart';
import 'package:positeams_programmierung2/components/post.dart';
import 'package:positeams_programmierung2/components/navigationbar.dart';

class Homepage extends StatelessWidget {
  const Homepage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          crossAxisAlignment: CrossAxisAlignment.start, // Align children at the start of the cross axis (left)
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
                      color: Color.fromARGB(255, 7, 110, 23), // Green color for "Posi"
                    ),
                  ),
                  TextSpan(
                    text: 'Teams',
                    style: TextStyle(
                      fontFamily: 'futura Condensed',
                      fontSize: 32,
                      fontWeight: FontWeight.w500,
                      color: Colors.black, // Black color for "Teams"
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.swap_vert, size: 35), // Sort icon
            onPressed: () {},
          ),
          Padding(
            padding: const EdgeInsets.only(right: 12.0),
            child: IconButton(
              icon: Icon(Icons.filter_list, size: 35), // Filter icon
              onPressed: () {},
            ),
          ),
        ],
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(1.0), // Height of the bottom border
          child: Container(
            color: Color.fromARGB(255, 229, 229, 229), // Color of the bottom border
            height: 1.0, // Thickness of the bottom border
          ),
        ),
      ),
      body: Column(
        children: [
          SizedBox(height: 3),
          Post(),
          Post(),
        ],
      ),
      bottomNavigationBar: MyNavigationBar(), // integration of navigationbar
    );
  }
}
