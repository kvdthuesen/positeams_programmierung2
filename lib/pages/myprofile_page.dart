import 'package:flutter/material.dart';
import 'package:positeams_programmierung2/components/appbar.dart';
import 'package:positeams_programmierung2/components/post.dart';
import 'package:positeams_programmierung2/pages/main_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:positeams_programmierung2/components/profileheader.dart';

class MyProfile extends StatefulWidget {
  const MyProfile({super.key});

  @override
  _MyProfileState createState() => _MyProfileState();
}

class _MyProfileState extends State<MyProfile> {
  // Track which button is selected: 'Beiträge' or 'Reaktionen'
  String _selectedButton = 'Beiträge'; // Default selected button
  String? profileImageUrl;
  String? backgroundImageUrl;
  String? firstName;
  String? lastName;
  String? team;
  String? department;

  @override
  void initState() {
    super.initState();
    _loadProfileData(); // Load profile data on initialization
  }

  // Load the profile data from Firestore
  Future<void> _loadProfileData() async {
    final userId = FirebaseAuth.instance.currentUser?.uid;

    if (userId != null) {
      try {
        DocumentSnapshot userDoc = await FirebaseFirestore.instance
            .collection('users')
            .doc(userId)
            .get();

        setState(() {
          profileImageUrl = userDoc['profileImage'];
          backgroundImageUrl = userDoc['backgroundImage'];
          firstName = userDoc['firstName'];
          lastName = userDoc['lastName'];
          team = userDoc['teamId'];
          department = userDoc['departmentId'];
        });
      } catch (e) {
        // Verwende ScaffoldMessenger für Fehlermeldungen
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error loading profile data: $e')),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // entire background to white
      appBar: MyAppBar(
        title: 'PosiTeams',
        titleAlign: TextAlign.start,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: IconButton(
              icon: const Icon(Icons.menu, size: 32),
              onPressed: () {
                MainScreenState? mainScreenState = context.findAncestorStateOfType<MainScreenState>();
                if (mainScreenState != null) {
                  mainScreenState.onItemTapped(5); // navigate to menu
                }
              },
            ),
          ),
        ],
      ),
      body: CustomScrollView(
        slivers: [
          // Sliver for profile header, image, and avatar
          SliverToBoxAdapter(
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                ProfileHeader(
                  profileImage: null,
                  profileImageUrl: profileImageUrl,
                  onProfileImagePick: null,
                  backgroundImage: null,
                  backgroundImageUrl: backgroundImageUrl,
                  onBackgroundImagePick: null,
                  showEditIcons: false,
                  isUploadingProfileImage: false,
                  isUploadingBackgroundImage: false,
                  bottomSpacing: 50,
                ),
              ],
            ),
          ),
          // Sliver for the name and description
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.only(left: 10.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          firstName != null && lastName != null
                              ? '$firstName $lastName'
                              : 'Loading...',
                          style: const TextStyle(
                            fontSize: 25,
                            fontFamily: 'futura Condensed',
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Text(
                          'Team $team ${department != null && department!.isNotEmpty ? '($department)' : ''}',
                          style: const TextStyle(
                            fontSize: 16,
                            color: Colors.grey,
                            fontFamily: 'Futura',
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10), // space between the text and divider
                  const Divider( // Divider between the text and buttons
                    color: Colors.grey,
                    thickness: 0.5,
                    height: 1,
                    indent: 3, // Left margin
                    endIndent: 3, // Right margin
                  ),
                ],
              ),
            ),
          ),
          // SliverAppBar for the buttons that will be pinned (fixiert)
          SliverPersistentHeader(
            pinned: true,
            floating: false,
            delegate: _SliverAppBarDelegate(
              minHeight: 50.0,
              maxHeight: 50.0,
              child: Container(
                color: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Row(
                  children: [
                    _buildProfileButton(
                      text: 'Beiträge',
                      isSelected: _selectedButton == 'Beiträge',
                      onPressed: () {
                        setState(() {
                          _selectedButton = 'Beiträge';
                        });
                      },
                    ),
                    const SizedBox(width: 10), // gap between the buttons
                    _buildProfileButton(
                      text: 'Reaktionen',
                      isSelected: _selectedButton == 'Reaktionen',
                      onPressed: () {
                        setState(() {
                          _selectedButton = 'Reaktionen';
                        });
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
          // Sliver for posts content
          SliverList(
            delegate: SliverChildListDelegate(
              const [
                Post(),
                Post(),
                Post(),
              ],
            ),
          ),
        ],
      ),
      // Remove bottomNavigationBar since it's handled by MainScreen
    );
  }

  // Method to build profile buttons with color change based on selection
  Widget _buildProfileButton({
    required String text,
    required bool isSelected,
    required VoidCallback onPressed,
  }) {
    return Expanded(
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color.fromARGB(255, 220, 220, 220),
          padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 8),
          minimumSize: const Size(0, 30),
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(5.0),
            ),
          ),
        ),
        child: Text(
          text,
          style: TextStyle(
            fontSize: 16,
            color: isSelected ? Colors.black : Colors.grey, // Change color based on selection
            fontFamily: 'Futura',
          ),
        ),
      ),
    );
  }
}

// Custom SliverAppBarDelegate to handle pinned and floating behavior
// fix 'Beiträge' and 'Reaktionen' buttons when scrolling
class _SliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  final double minHeight; // Minimum height of the SliverAppBar (when fully collapsed)
  final double maxHeight; // Maximum height of the SliverAppBar (when fully expanded)
  final Widget child; // The widget (UI component) to be displayed in the SliverAppBar

  // Constructor to initialize the minHeight, maxHeight, and the child widget
  _SliverAppBarDelegate({
    required this.minHeight,
    required this.maxHeight,
    required this.child,
  });

  // Returns the minimum extent (height) of the Sliver when it's collapsed
  @override
  double get minExtent => minHeight;

  // Returns the maximum extent (height) of the Sliver when it's fully expanded
  @override
  double get maxExtent => maxHeight;

  // Builds the content of the Sliver, using the provided 'child' widget.
  // SizedBox.expand ensures that the child widget takes up all available space.
  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return SizedBox.expand(child: child);
  }

  // Determines if the SliverAppBarDelegate should rebuild when its properties change
  // Returns true if the heights or the child widget are different from the previous state
  @override
  bool shouldRebuild(_SliverAppBarDelegate oldDelegate) {
    return maxHeight != oldDelegate.maxHeight || // Rebuild if maxHeight changes
        minHeight != oldDelegate.minHeight ||  // Rebuild if minHeight changes
        child != oldDelegate.child; // Rebuild if child widget changes
  }
}