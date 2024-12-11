import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:positeams_programmierung2/components/post_service.dart';

/// Main widget for displaying a post with user info, post content, image preview, and interaction buttons.
/// StatefulWidget is appropriate here as dynamic state management is needed.
class Post extends StatelessWidget {
  final String postId;
  final String firstName;
  final String teamId;
  final String departmentId;
  final String contentText;
  final String contentImage;
  final String profileImage;

  const Post({
    super.key,
    required this.postId,
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
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,  // Space between buttons
                      children: [
                        InteractionButton(
                          icon: Icons.thumb_up_alt_outlined,
                          label: 'Gefällt mir!',
                          postId: postId, // Pass the postId dynamically
                          reactionType: 'ThumbUp',
                        ),
                        InteractionButton(
                          icon: Icons.favorite_border,
                          label: 'Liebe',
                          postId: postId, // Pass the postId dynamically
                          reactionType: 'Favorite',
                        ),
                        InteractionButton(
                          icon: Icons.emoji_emotions_outlined,
                          label: 'Applaus',
                          postId: postId, // Pass the postId dynamically
                          reactionType: 'Emotion',
                        ),
                        const ChatButton(),  // Custom chat button with placeholder functionality - Mockup
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
/// The button updates Firebase when clicked and reflects the user's current reaction status.
class InteractionButton extends StatefulWidget {
  final IconData icon;
  final String label;
  final String postId; // Post ID for which the interaction is being made
  final String reactionType; // Type of reaction: "ThumbUp", "Favorite", or "Emotion"

  const InteractionButton({
    required this.icon,
    required this.label,
    required this.postId,
    required this.reactionType,
    super.key,
  });

  @override
  State<InteractionButton> createState() => _InteractionButtonState();
}

class _InteractionButtonState extends State<InteractionButton> {
  bool isActive = false; // Track if the button is active
  String userId = FirebaseAuth.instance.currentUser?.uid ?? ''; // Current authenticated user ID

  @override
  void initState() {
    super.initState();
    _checkReactionStatus(); // Check if the current user has reacted
  }

  /// Checks if the user has already reacted to the post.
  /// Sets the button to active if their ID is found in the reaction list.
  Future<void> _checkReactionStatus() async {
    final postRef = FirebaseFirestore.instance.collection('posts').doc(widget.postId);

    final postSnapshot = await postRef.get();
    if (postSnapshot.exists) {
      final reactionIds = List<String>.from(postSnapshot.data()?[widget.reactionType + "Id"] ?? []);
      setState(() {
        isActive = reactionIds.contains(userId); // Activate button if user has already reacted
      });
    }
  }

  /// Toggles the reaction by calling the appropriate service methods.
  Future<void> _toggleReaction() async {
    final postService = PostService();

    try {
      if (isActive) {
        // Remove the reaction if the button is active
        await postService.removeReaction(postId: widget.postId);
      } else {
        // Add the reaction if the button is not active
        await postService.saveReaction(
          postId: widget.postId,
          reactionType: widget.reactionType,
        );

        // Deactivate other reactions by resetting their active state
        await _deactivateOtherReactions();
      }

      // Update the UI state
      setState(() {
        isActive = !isActive;
      });
    } catch (e) {
      debugPrint('Error toggling reaction: $e');
    }
  }

  /// Deactivates all other reaction types for this post.
  Future<void> _deactivateOtherReactions() async {
    final postRef = FirebaseFirestore.instance.collection('posts').doc(widget.postId);

    // Determine other reaction types
    const reactionTypes = ['ThumbUp', 'Favorite', 'Emotion'];
    final otherReactions = reactionTypes.where((type) => type != widget.reactionType).toList();

    for (final reactionType in otherReactions) {
      await postRef.update({
        reactionType + "Id": FieldValue.arrayRemove([userId]),
        reactionType + "Counter": FieldValue.increment(-1),
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        IconButton(
          icon: Icon(
            widget.icon,
            color: isActive ? const Color.fromARGB(255, 7, 110, 23) : Colors.grey, // Change color if active
          ),
          onPressed: _toggleReaction, // Toggle reaction on press
        ),
        const SizedBox(height: 2), // Space between icon and label
        Text(
          widget.label, // Display interaction label
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
