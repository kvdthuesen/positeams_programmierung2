import 'package:flutter/material.dart';

class Post extends StatelessWidget {
  const Post({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row( // Profile row with avatar and user details
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
          ClipRRect( // post image
            borderRadius: BorderRadius.circular(5.0),
            child: Image.asset('lib/images/hermes.jpg'),
          ),
          SizedBox(height: 16),
          // Interaction buttons row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              // Like button
              Column(
                children: [
                  IconButton(
                    icon: Icon(Icons.thumb_up_alt_outlined),
                    onPressed: () {},
                  ),
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
              // Love button
              Column(
                children: [
                  IconButton(
                    icon: Icon(Icons.favorite_border),
                    onPressed: () {},
                  ),
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
              // Applause button
              Column(
                children: [
                  IconButton(
                    icon: Icon(Icons.emoji_emotions_outlined),
                    onPressed: () {},
                  ),
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
              Column( // "Let's chat!" button with "Talk in Teams" text
                children: [
                  ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color.fromARGB(255, 7, 110, 23),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.zero,
                      ),
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
                  SizedBox(height: 4),
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
          SizedBox(height: 16), // Space between row and border
          // Bottom border
          Container(
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: Colors.grey,
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
