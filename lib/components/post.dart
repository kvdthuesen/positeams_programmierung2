import 'package:flutter/material.dart';

/// Main widget for displaying a post with user info, post content, image preview, and interaction buttons.
/// StatelessWidget is appropriate here as no dynamic state management is needed.
class Post extends StatelessWidget {
  const Post({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 16.0), // Reduced vertical padding
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Row displaying user avatar and post content
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // User avatar
              const CircleAvatar(
                backgroundImage: AssetImage('lib/images/avatar.jpg'), // User's avatar image
                radius: 28,
              ),
              const SizedBox(width: 10), // Space between avatar and text

              // Column for user name, team, and post text
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // User name and team
                    RichText(
                      text: const TextSpan(
                        children: [
                          TextSpan(
                            text: 'Maya ',  // User's name
                            style: TextStyle(
                              fontFamily: 'Futura',
                              fontWeight: FontWeight.bold,
                              fontSize: 15,
                              color: Colors.black,
                            ),
                          ),
                          TextSpan(
                            text: '- Team Data Science (Business Intelligence)',  // User's team
                            style: TextStyle(
                              color: Colors.grey,
                              fontFamily: 'Futura',
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 4), // Space between name/team and post text

                    // Post text content
                    const Text(
                      'Hier kommt der Beitragstext hin! Erfolge, Meilensteine, Positive News werden geteilt',  // Post text
                      style: TextStyle(
                        color: Colors.black,
                        fontFamily: 'Futura',
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 16), // Space before image

                    // Image preview with tap to expand functionality
                    GestureDetector(
                      onTap: () {
                        _showFullImage(context);
                      },
                      child: AspectRatio(
                        aspectRatio: 21 / 9, // Image aspect ratio
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(5.0),
                          child: Image.asset(
                            'lib/images/test.jpg', // Post image preview
                            fit: BoxFit.cover,  // Ensures the image fits within the box
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 5), // Space after image

                    // Row of interaction buttons (Like, Love, Applause, Chat)
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,  // Space between buttons
                      children: [
                        InteractionButton(icon: Icons.thumb_up_alt_outlined, label: 'Gefällt mir!'),
                        InteractionButton(icon: Icons.favorite_border, label: 'Liebe'),
                        InteractionButton(icon: Icons.emoji_emotions_outlined, label: 'Applaus'),
                        ChatButton(),  // Custom chat button with placeholder functionality
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),  // Space before divider

          // Divider separating posts
          const Divider(
            color: Color.fromARGB(255, 229, 229, 229),
            thickness: 0.5,
          ),
        ],
      ),
    );
  }

  /// Displays the full-size image in a dialog when tapped
  void _showFullImage(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return GestureDetector(
          onTap: () {
            Navigator.of(context).pop(); // close dialog anywhere
          },
          child: Dialog(
            backgroundColor: Colors.transparent,
            insetPadding: const EdgeInsets.all(10),
            child: Center(
              child: Image.asset(
                'lib/images/test.jpg',  // Full-size image
                fit: BoxFit.contain,  // Ensures the image scales to fit the screen
              ),
            ),
          ),
        );
      },
    );
  }
}

/// Widget for displaying interaction buttons (e.g., "Like", "Love", "Applause").
/// StatelessWidget is suitable here as the button doesn't need dynamic state management.
class InteractionButton extends StatelessWidget {
  final IconData icon;
  final String label;

  const InteractionButton({required this.icon, required this.label, super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        IconButton(
          icon: Icon(icon),  // Interaction icon (e.g., Like, Love)
          onPressed: () {},  // Placeholder for functionality
        ),
        const SizedBox(height: 2),  // Space between icon and label
        Text(
          label,  // Interaction label (e.g., "Gefällt mir!")
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

/// Custom button for initiating a chat.
/// The design hints at integration with a chat platform (e.g., Microsoft Teams).
/// Since no dynamic state is required, this can remain a StatelessWidget.
class ChatButton extends StatelessWidget {
  const ChatButton({super.key}); // Const constructor to resolve error

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ElevatedButton(
          onPressed: () {},  // Placeholder for chat functionality
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color.fromARGB(255, 7, 110, 23),
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.zero,
            ),
            padding: const EdgeInsets.symmetric(vertical: 2.0, horizontal: 8.0),  // Padding inside the button
            minimumSize: const Size(80, 25),  // Button size
          ),
          child: const Text(
            "Let's chat!",
            style: TextStyle(
              color: Colors.white,
              fontFamily: 'Futura',
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
          ),
        ),
        const SizedBox(height: 2),  // Space between button and label
        const Text(
          'Talk in Teams',  // Label indicating integration with a chat platform
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
