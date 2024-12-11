import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
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
  final int thumbUpCount; // New: Counter for "ThumbUp" reactions
  final int favoriteCount; // New: Counter for "Favorite" reactions
  final int emotionCount; // New: Counter for "Emotion" reactions

  const Post({
    super.key,
    required this.postId,
    required this.firstName,
    required this.teamId,
    required this.departmentId,
    required this.contentText,
    required this.contentImage,
    required this.profileImage,
    required this.thumbUpCount, // Pass thumbUpCount dynamically
    required this.favoriteCount, // Pass favoriteCount dynamically
    required this.emotionCount, // Pass emotionCount dynamically
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
  void initState() {
    super.initState();
    _initializeReactionStatus(); // Set the initial reaction status
  }

  /// Initialize the reaction status based on the user's previous interaction.
  Future<void> _initializeReactionStatus() async {
    final userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId == null) return;

    final postRef = FirebaseFirestore.instance.collection('posts').doc(widget.postId);
    final postSnapshot = await postRef.get();

    if (postSnapshot.exists) {
      final data = postSnapshot.data() as Map<String, dynamic>;
      if ((data['ThumbUpId'] ?? []).contains(userId)) {
        setState(() {
          activeReactionType = 'ThumbUp';
        });
      } else if ((data['FavoriteId'] ?? []).contains(userId)) {
        setState(() {
          activeReactionType = 'Favorite';
        });
      } else if ((data['EmotionId'] ?? []).contains(userId)) {
        setState(() {
          activeReactionType = 'Emotion';
        });
      }
    }
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
                          postId: widget.postId,
                          reactionType: 'ThumbUp',
                          count: widget.thumbUpCount, // Replace this with actual ThumbUpCounter from your backend
                          isActive: activeReactionType == 'ThumbUp',
                          onToggled: _onReactionToggled,
                        ),
                        InteractionButton(
                          icon: Icons.favorite_border,
                          label: 'Liebe',
                          postId: widget.postId,
                          reactionType: 'Favorite',
                          count: widget.favoriteCount, // Replace this with actual FavoriteCounter from your backend
                          isActive: activeReactionType == 'Favorite',
                          onToggled: _onReactionToggled,
                        ),
                        InteractionButton(
                          icon: Icons.emoji_emotions_outlined,
                          label: 'Applaus',
                          postId: widget.postId,
                          reactionType: 'Emotion',
                          count: widget.emotionCount, // Replace this with actual EmotionCounter from your backend
                          isActive: activeReactionType == 'Emotion',
                          onToggled: _onReactionToggled,
                        ),
                        const ChatButton(),
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
class InteractionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final String postId;
  final String reactionType;
  final int count; // Counter for the reaction
  final bool isActive; // Determines if this button is active
  final void Function(String reactionType) onToggled; // Callback for toggling reaction

  const InteractionButton({
    required this.icon,
    required this.label,
    required this.postId,
    required this.reactionType,
    required this.count,
    required this.isActive,
    required this.onToggled,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Stack(
          clipBehavior: Clip.none,
          alignment: Alignment.center,
          children: [
            IconButton(
              icon: Icon(
                isActive
                    ? _getFilledIcon(icon) // Filled icon when active
                    : icon, // Outlined icon when inactive
                color: isActive ? const Color.fromARGB(255, 7, 110, 23) : Colors.grey,
              ),
              onPressed: () async {
                // Toggle reaction and notify parent widget
                onToggled(reactionType);
                if (isActive) {
                  await PostService().removeReaction(postId: postId);
                } else {
                  await PostService().saveReaction(
                    postId: postId,
                    reactionType: reactionType,
                  );
                }
              },
            ),
            if (count > 0)
              Positioned(
                bottom: 0,
                right: 0,
                child: Badge(
                  label: Text(
                    '$count',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  backgroundColor: Color.fromARGB(255, 7, 110, 23), // Customize badge color
                ),
              ),
          ],
        ),
        const SizedBox(height: 2),
        Text(
          label,
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

IconData _getFilledIcon(IconData icon) {
  if (icon == Icons.thumb_up_alt_outlined) {
    return Icons.thumb_up; // Filled version for "Like"
  } else if (icon == Icons.favorite_border) {
    return Icons.favorite; // Filled version for "Love"
  } else if (icon == Icons.emoji_emotions_outlined) {
    return Icons.emoji_emotions; // Filled version for "Applause"
  }
  return icon; // Fallback to the original icon
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
