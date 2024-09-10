import 'package:flutter/material.dart';

// main class for post
class Post extends StatelessWidget {
  const Post({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white, // Set the background color to white
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,  // alignment of content - left
          children: [
            // row with avatar and text
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CircleAvatar(
                  backgroundImage: AssetImage('lib/images/avatar.jpg'),  // avatar picture of individual user
                  radius: 28,
                ),
                SizedBox(width: 10),  // distance between avatar and text

                // column for user name and team
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // styling
                      RichText(
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
                      SizedBox(height: 4),  // distance to post text

                      // post text
                      Text(
                        'Hier kommt der Beitragstext hin! Erfolge, Meilensteine, Positive News werden geteilt',
                        style: TextStyle(
                          color: Colors.black,
                          fontFamily: 'Futura',
                          fontSize: 14,
                        ),
                      ),
                      SizedBox(height: 16),  // distance to image

                      // Image preview with click function for full screen view
                      GestureDetector(
                        onTap: () {
                          // show image in full screen view - function
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return Dialog(
                                backgroundColor: Colors.transparent,
                                insetPadding: EdgeInsets.all(10),
                                child: GestureDetector(
                                  onTap: () {
                                    Navigator.of(context).pop();  // closing dialog with second click
                                  },
                                  child: Center(
                                    child: Container(
                                      width: MediaQuery.of(context).size.width,
                                      height: MediaQuery.of(context).size.height,
                                      child: Image.asset(
                                        'lib/images/test.jpg',  // image of assets -> soon function for database
                                        fit: BoxFit.contain,  // scales image
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            },
                          );
                        },
                        child: AspectRatio(
                          aspectRatio: 21 / 9,  // Aspect ratio of image preview
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(5.0),
                            child: Image.asset(
                              'lib/images/test.jpg',  // image in preview
                              fit: BoxFit.cover,  // scales image
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 5),  // distance below image

                      // row with interaction buttons (Gefällt mir, Liebe, Applaus, Chat)
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,  // Distribution of buttons
                        children: [
                          InteractionButton(icon: Icons.thumb_up_alt_outlined, label: 'Gefällt mir!'),
                          InteractionButton(icon: Icons.favorite_border, label: 'Liebe'),
                          InteractionButton(icon: Icons.emoji_emotions_outlined, label: 'Applaus'),
                          ChatButton(),  // special button for chat - possible API for Teams
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: 16),  // distance to divider

            // divider styling
            Container(
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color: Color.fromARGB(255, 229, 229, 229),
                    width: 0.5,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// definition of interaction button (e.g. "Gefällt mir", "Liebe", "Applaus")
class InteractionButton extends StatelessWidget {
  final IconData icon;
  final String label;

  const InteractionButton({required this.icon, required this.label, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        IconButton(
          icon: Icon(icon),  // icon of button
          onPressed: () {},  // FUNCTIONALITY COMING SOON!
        ),
        SizedBox(height: 2),  // distance below button
        Text(
          label,  // description below button
          style: const TextStyle(
            color: Colors.grey,
            fontFamily: 'Futura Condensed',
            fontSize: 14,
          ),
        ),
      ],
    );
  }
}

// Definition of Chat-Button
class ChatButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ElevatedButton(
          onPressed: () {},  // FUNCTIONALITY COMING SOON
          style: ElevatedButton.styleFrom( // styling of ChatButton
            backgroundColor: Color.fromARGB(255, 7, 110, 23),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.zero,
            ),
            padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 8.0),  // Button-distance inside
            minimumSize: Size(80, 25),
          ),
          child: const Text( // text of button and styling
            "Let's chat!",
            style: TextStyle(
              color: Colors.white,
              fontFamily: 'Futura',
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
          ),
        ),
        SizedBox(height: 2),  // distance below button
        Text(
          'Talk in Teams',  // Text below the button, indicating Teams chat
          style: TextStyle(
            color: Colors.grey,
            fontFamily: 'Futura Condensed',
            fontSize: 14,
          ),
        ),
      ],
    );
  }
}
