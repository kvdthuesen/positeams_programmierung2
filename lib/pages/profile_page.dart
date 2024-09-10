import 'package:flutter/material.dart';
import 'package:positeams_programmierung2/components/appbar.dart';
import 'package:positeams_programmierung2/components/post.dart';
import 'package:positeams_programmierung2/components/navigationbar.dart';

class MyProfile extends StatefulWidget {
  const MyProfile({super.key});

  @override
  _MyProfileState createState() => _MyProfileState();
}

class _MyProfileState extends State<MyProfile> {
  // Track which button is selected: 'Beiträge' or 'Reaktionen'
  String _selectedButton = 'Beiträge'; // Default selected button

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // entire background white !!!
      appBar: MyAppBar(
        title: 'PosiTeams',
        titleAlign: TextAlign.start,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: IconButton(
              icon: const Icon(Icons.menu, size: 30),
              onPressed: () {
                print("Menu button pressed");
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
              clipBehavior: Clip.none, // allows the avatar to overflow the stack - bc white background
              children: [
                // Header image
                Container(
                  height: 100,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5.0),
                    image: const DecorationImage(
                      image: AssetImage('lib/images/hermes.jpg'),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                // Profile picture (floating above the header image)
                Positioned(
                  left: 24, // Positioning avatar
                  bottom: -40, // Pulling avatar up
                  child: const CircleAvatar(
                    radius: 45,
                    backgroundColor: Colors.white,
                    child: CircleAvatar(
                      radius: 40,
                      backgroundImage: AssetImage('lib/images/avatar.jpg'),
                    ),
                  ),
                ),
              ],
            ),
          ),
          SliverToBoxAdapter(
            child: const SizedBox(height: 40),
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
                      children: const [
                        Text(
                          'Maya -',
                          style: TextStyle(
                            fontSize: 20,
                            fontFamily: 'Futura',
                          ),
                        ),
                        Text(
                          'Team Data Science (Business Intelligence)',
                          style: TextStyle(
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
          // Regular SliverToBoxAdapter for buttons (not pinned)
          SliverToBoxAdapter(
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
      bottomNavigationBar: const MyNavigationBar(currentIndex: 3),
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

