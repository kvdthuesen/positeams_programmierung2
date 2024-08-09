import 'package:flutter/material.dart';

class Post extends StatelessWidget {
  const Post({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0), // padding after one post - distance between posts
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row( // profile row with avatar and user details
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CircleAvatar(
                backgroundImage: AssetImage('lib/images/avatar.jpg'), //profile picture
                radius: 30,
              ),
              SizedBox(width: 10),
              // User details
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    RichText(  // user name and role
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: 'Maya ',
                            style: TextStyle(
                              fontFamily: 'Futura',
                              fontWeight: FontWeight.bold,
                              fontSize: 15,
                              color: Colors.black,
                            ),
                          ),
                          TextSpan(
                            text: '- Team Data Science (Business Intelligence)',
                            style: TextStyle(
                              color: Colors.grey,
                              fontFamily: 'Futura',
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 4), // Post text
                    Text(
                      'Hier kommt der Beitragstext hin! Erfolge, Meilensteine, Positive News werden geteilt',
                      style: TextStyle(
                        color: Colors.black,
                        fontFamily: 'Futura',
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 16),
          Row( // New Row to align the image
            mainAxisAlignment: MainAxisAlignment.end, // Align image to the right
            children: [
              ClipRRect( // post image
                borderRadius: BorderRadius.circular(5.0),
                child: Image.asset(
                  'lib/images/hermes.jpg',
                  width: 335, // adjust the width if needed
                ),
              ),
            ],
          ),
          SizedBox(height: 5),
          // Interaction buttons row
          Row(
            mainAxisAlignment: MainAxisAlignment.end, // Align buttons to the right
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Column(
                children: [
                  IconButton(
                    icon: Icon(Icons.thumb_up_alt_outlined),
                    onPressed: () {},
                  ),
                  SizedBox(height: 2,), // Added this line
                  Text(
                    'Gefällt mir!',
                    style: TextStyle(
                      color: Colors.grey,
                      fontFamily: 'futura Condensed',
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
              SizedBox(width:20), // Spacing between buttons
              Column(
                children: [
                  IconButton(
                    icon: Icon(Icons.favorite_border),
                    onPressed: () {},
                  ),
                  SizedBox(height: 2, width: 60,), // Added this line
                  Text(
                    'Liebe',
                    style: TextStyle(
                      color: Colors.grey,
                      fontFamily: 'futura Condensed',
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
              SizedBox(width: 30), // Spacing between buttons
              Column(
                children: [
                  IconButton(
                    icon: Icon(Icons.emoji_emotions_outlined),
                    onPressed: () {},
                  ),
                  SizedBox(height: 2), // Added this line
                  Text(
                    'Applaus',
                    style: TextStyle(
                      color: Colors.grey,
                      fontFamily: 'futura Condensed',
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
              SizedBox(width: 40), // Spacing between buttons
              Column( // "Let's chat!" button with "Talk in Teams" text
                children: [
                  ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color.fromARGB(255, 7, 110, 23),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.zero,
                      ),
                      minimumSize: Size(80, 30), // minimum size of box
                      padding: EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0), // Adjust padding
                    ),
                    child: Text(
                      "Let's chat!",
                      style: TextStyle(
                        color: Colors.white,
                        fontFamily: 'futura',
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                  ),
                  SizedBox(height: 2), // Added this line
                  Text(
                    'Talk in Teams',
                    style: TextStyle(
                      color: Colors.grey,
                      fontFamily: 'futura Condensed',
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ],
          ),
          // divider
          SizedBox(height: 16), // Space between row and border
          // Bottom border
          Container( //divider
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: Color.fromARGB(255, 229, 229, 229),
                  width: 0.5, // Thin border
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
