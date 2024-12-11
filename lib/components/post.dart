import 'package:flutter/material.dart';
import 'package:badges/badges.dart';
import 'package:positeams_programmierung2/components/post_service.dart';

/// Main widget for displaying a post with user info, post content, image preview, and interaction buttons.
/// StatefulWidget is appropriate here for dynamic state management.
class Post extends StatefulWidget {
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
  State<Post> createState() => _PostState();
}

class _PostState extends State<Post> {
  String? activeReactionType; // Tracks the currently active reaction type

  /// Handles the state when a reaction is toggled.
  void _onReactionToggled(String reactionType) {
    setState(() {
      // If the same reaction is toggled, deactivate it
      activeReactionType = (activeReactionType == reactionType) ? null : reactionType;
    });
  }

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
                backgroundImage: widget.profileImage.isNotEmpty
                    ? NetworkImage(widget.profileImage)  // Load dynamic profile image
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
                            text: '${widget.firstName} ', // Dynamically showing the user's name
                            style: const TextStyle(
                              fontFamily: 'Futura',
                              fontWeight: FontWeight.bold,
                              fontSize: 15,
                              color: Colors.black,
                            ),
                          ),
                          TextSpan(
                            text: '- Team ${widget.teamId} (${widget.departmentId})',  // Dynamically showing the user's team and department
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
                      widget.contentText,  // Dynamically showing the post text content
                      style: const TextStyle(
                        color: Colors.black,
                        fontFamily: 'Futura',
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 16), // Space before image

                    // Check if contentImage is not empty
                    if (widget.contentImage.isNotEmpty)
                      GestureDetector(
                        onTap: () {
                          _showFullImage(context, widget.contentImage);
                        },
                        child: AspectRatio(
                          aspectRatio: 21 / 9, // Image aspect ratio
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(5.0),
                            child: Image.network(
                              widget.contentImage, // Dynamically showing the post image
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
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        InteractionButton(
                          icon: Icons.thumb_up_alt_outlined,
                          label: 'Gefällt mir!',
                          postId: widget.postId, // Pass the postId dynamically
                          reactionType: 'ThumbUp',
                          isActive: activeReactionType == 'ThumbUp',
                          onToggled: _onReactionToggled,
                        ),
                        InteractionButton(
                          icon: Icons.favorite_border,
                          label: 'Liebe',
                          postId: widget.postId,
                          reactionType: 'Favorite',
                          isActive: activeReactionType == 'Favorite',
                          onToggled: _onReactionToggled,
                        ),
                        InteractionButton(
                          icon: Icons.emoji_emotions_outlined,
                          label: 'Applaus',
                          postId: widget.postId,
                          reactionType: 'Emotion',
                          isActive: activeReactionType == 'Emotion',
                          onToggled: _onReactionToggled,
                        ),
                        const ChatButton(),  // Custom chat button with placeholder functionality
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
            Navigator.of(context).pop();
          },
          child: Dialog(
            backgroundColor: Colors.transparent,
            insetPadding: const EdgeInsets.all(10),
            child: Center(
              child: Image.network(
                imageUrl,
                fit: BoxFit.contain,
                errorBuilder: (context, error, stackTrace) {
                  return const Text('Image failed to load');
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
  final bool isActive; // Determines if this button is active
  final void Function(String reactionType) onToggled; // Callback for toggling reaction

  const InteractionButton({
    required this.icon,
    required this.label,
    required this.postId,
    required this.reactionType,
    required this.isActive,
    required this.onToggled,
    super.key,
  });

  @override
  State<InteractionButton> createState() => _InteractionButtonState();
}

class _InteractionButtonState extends State<InteractionButton> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        IconButton(
          icon: Icon(
            widget.icon,
            color: widget.isActive ? const Color.fromARGB(255, 7, 110, 23) : Colors.grey,
          ),
          onPressed: () async {
            // Toggle reaction and notify parent widget
            widget.onToggled(widget.reactionType);
            if (widget.isActive) {
              await PostService().removeReaction(postId: widget.postId);
            } else {
              await PostService().saveReaction(
                postId: widget.postId,
                reactionType: widget.reactionType,
              );
            }
          },
        ),
        const SizedBox(height: 2),
        Text(
          widget.label,
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
class ChatButton extends StatelessWidget {
  const ChatButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ElevatedButton(
          onPressed: () {},
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color.fromARGB(255, 7, 110, 23),
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.zero,
            ),
            padding: const EdgeInsets.symmetric(vertical: 2.0, horizontal: 8.0),
            minimumSize: const Size(80, 25),
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
        const SizedBox(height: 2),
        const Text(
          'Talk in Teams',
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
