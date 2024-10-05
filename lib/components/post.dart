import 'package:flutter/material.dart';

/// Main widget for displaying a post with user info, post content, image preview, and interaction buttons.
/// StatelessWidget is appropriate here as no dynamic state management is needed.
class Post extends StatelessWidget {
  final String firstName;
  final String teamId;
  final String departmentId;
  final String contentText;
  final String contentImage;
  final String profileImage;

  const Post({
    super.key,
    required this.firstName,
    required this.teamId,
    required this.departmentId,
    required this.contentText,
    required this.contentImage,
    required this.profileImage,
  });

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
              // User avatar (dynamic profile image or default avatar)
              CircleAvatar(
                backgroundImage: profileImage.isNotEmpty
                    ? NetworkImage(profileImage)  // Load dynamic profile image
                    : const AssetImage('lib/assets/default_avatar.png') as ImageProvider,  // Fallback to default image
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
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: '$firstName ',  // Dynamically showing the user's name
                            style: const TextStyle(
                              fontFamily: 'Futura',
                              fontWeight: FontWeight.bold,
                              fontSize: 15,
                              color: Colors.black,
                            ),
                          ),
                          TextSpan(
                            text: '- Team $teamId ($departmentId)',  // Dynamically showing the user's team and department
                            style: const TextStyle(
                              color: Colors.grey,
                              fontFamily: 'Futura',
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 4), // Space between name/team and post text

                    // Post text content
                    Text(
                      contentText,  // Dynamically showing the post text content
                      style: const TextStyle(
                        color: Colors.black,
                        fontFamily: 'Futura',
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 16), // Space before image

                    // Check if contentImage is not empty
                    if (contentImage.isNotEmpty)
                      GestureDetector(
                        onTap: () {
                          _showFullImage(context, contentImage);
                        },
                        child: AspectRatio(
                          aspectRatio: 21 / 9, // Image aspect ratio
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(5.0),
                            child: Image.network(
                              contentImage, // Dynamically showing the post image
                              fit: BoxFit.cover,  // Ensures the image fits within the box
                              errorBuilder: (context, error, stackTrace) {
                                return const Text('Image failed to load'); // Handle loading error
                              },
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
                        ChatButton(),  // Custom chat button with placeholder functionality - Mockup
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
  void _showFullImage(BuildContext context, String imageUrl) {
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
              child: Image.network(
                imageUrl,  // Dynamically showing the full-size image
                fit: BoxFit.contain,  // Ensures the image scales to fit the screen
                errorBuilder: (context, error, stackTrace) {
                  return const Text('Image failed to load'); // Handle loading error
                },
              ),
            ),
          ),
        );
      },
    );
  }
}

/// Widget for displaying interaction buttons ( "Like", "Love", "Applause").
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
          icon: Icon(icon),  // Interaction icon
          onPressed: () {},  // Placeholder for functionality
        ),
        const SizedBox(height: 2),  // Space between icon and label
        Text(
          label,  // Interaction label
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
          'Talk in Teams',  // Mockup: Button indicating integration with a chat platform
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
