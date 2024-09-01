import 'package:flutter/material.dart';
import 'package:positeams_programmierung2/pages/home_page.dart';
import 'package:positeams_programmierung2/components/appbar.dart';
import 'package:positeams_programmierung2/components/post.dart';
import 'package:positeams_programmierung2/components/navigationbar.dart';

class MyProfile extends StatelessWidget {
  const MyProfile({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(
        title: 'PosiTeams',
        titleAlign: TextAlign.center,
        leading: IconButton(
          icon: const Icon(Icons.close, size: 30),
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const Homepage()),
            );
          },
        ),
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
      body: Column(
        children: [
          // Non-scrollable part
          Stack(
            clipBehavior: Clip.none, // allows the avatar to overflow the stack
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
          const SizedBox(height: 40), // Space to accommodate the floating avatar
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Name and description
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
                  indent: 3, // Left margin
                  endIndent: 3, // Right margin
                ),
                const SizedBox(height: 5), // space between divider and buttons
                // Buttons for "Beiträge" and "Reaktionen"
                Row(
                  children: [
                    _buildProfileButton(
                      text: 'Beiträge',
                      onPressed: () {},
                    ),
                    const SizedBox(width: 10), // Small gap between the buttons
                    _buildProfileButton(
                      text: 'Reaktionen',
                      onPressed: () {},
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 20), // Add space between the buttons and class "post"
          // Scrollable part starting with class "post"
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.zero, // Remove any default padding
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: const [
                  Post(),
                  Post(),
                  Post(),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: const MyNavigationBar(currentIndex: 3),
    );
  }

  // Method to build profile buttons to avoid repetition !!!
  Widget _buildProfileButton({required String text, required VoidCallback onPressed}) {
    return Expanded(
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color.fromARGB(100, 220, 220, 220),
          padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 8), // Reduce vertical padding for a shorter button
          minimumSize: const Size(0, 36), // Set a minimum height
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(5.0),
            ),
          ),
        ),
        child: Text(
          text,
          style: const TextStyle(
            fontSize: 16,
            color: Colors.black,
            fontFamily: 'Futura',
          ),
        ),
      ),
    );
  }
}