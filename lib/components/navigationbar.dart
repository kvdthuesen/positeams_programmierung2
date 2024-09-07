import 'package:flutter/material.dart';
import 'package:positeams_programmierung2/pages/addPost_page.dart'; // Imports page for adding a post
import 'package:positeams_programmierung2/pages/explore_page.dart'; // Imports page for exploring content
import 'package:positeams_programmierung2/pages/home_page.dart'; // Imports homepage
import 'package:positeams_programmierung2/pages/Profile_page.dart'; // Imports profile page

// Custom navigation bar widget that allows users to navigate between main app pages
class MyNavigationBar extends StatelessWidget {
  // The index of the currently selected tab
  final int currentIndex;

  // Define colors and icon size for selected and unselected items
  final Color selectedColor = Colors.black; // Color for the selected icon
  final Color unselectedColor = Colors.grey; // Color for unselected icons
  final Color backgroundColor = Colors.white; // Background color of the navigation bar
  final double iconSize = 32.0; // Size of the icons

  const MyNavigationBar({super.key, required this.currentIndex});

  // Handles the navigation logic when an item in the bottom navigation is tapped
  // It will navigate to the appropriate page and clear the previous navigation stack
  void _onItemTapped(BuildContext context, int index) {
    switch (index) {
      case 0:
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const Homepage()), // Navigate to Homepage
              (Route<dynamic> route) => false, // Clear back stack
        );
        break;
      case 1:
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const Explore()), // Navigate to Explore page
              (Route<dynamic> route) => false, // Clear back stack
        );
        break;
      case 2:
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const AddPost()), // Navigate to AddPost page
              (Route<dynamic> route) => false, // Clear back stack
        );
        break;
      case 3:
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const MyProfile()), // Navigate to Profile page
              (Route<dynamic> route) => false, // Clear back stack
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    // Builds the themed navigation bar
    return NavigationBarTheme(
      data: NavigationBarThemeData(
        backgroundColor: backgroundColor, // Sets the background color to white
        indicatorColor: Colors.transparent, // No background highlight on the selected item
        iconTheme: WidgetStateProperty.resolveWith<IconThemeData>((states) {
          // Conditionally set the icon theme based on whether the state is selected
          if (states.contains(WidgetState.selected)) {
            return IconThemeData(color: selectedColor, size: iconSize); // Black icon for selected tab
          }
          return IconThemeData(color: unselectedColor, size: iconSize); // Grey icon for unselected tabs
        }),
        labelTextStyle: WidgetStateProperty.all(
          const TextStyle(fontSize: 0), // Hide labels by setting font size to 0
        ),
      ),
      child: NavigationBar(
        selectedIndex: currentIndex, // The currently active tab index
        onDestinationSelected: (index) => _onItemTapped(context, index), // Handle tab change
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home), // Icon for Home tab
            label: '', // No label text
          ),
          NavigationDestination(
            icon: Icon(Icons.search), // Icon for Explore/Search tab
            label: '', // No label text
          ),
          NavigationDestination(
            icon: Icon(Icons.add), // Icon for Add Post tab
            label: '', // No label text
          ),
          NavigationDestination(
            icon: Icon(Icons.person), // Icon for Profile tab
            label: '', // No label text
          ),
        ],
      ),
    );
  }
}