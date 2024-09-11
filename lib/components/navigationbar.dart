import 'package:flutter/material.dart';

class MyNavigationBar extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;  // Callback for tab changes

  // Define colors and icon size for selected and unselected items
  final Color selectedColor = Colors.black; // Color for the selected icon
  final Color unselectedColor = Colors.grey; // Color for unselected icons
  final Color backgroundColor = Colors.white; // Background color of the navigation bar
  final double iconSize = 32.0; // Size of the icons

  const MyNavigationBar({
    super.key,
    required this.currentIndex,
    required this.onTap,  // Require the callback for navigation
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 80,  // Set the desired height of the NavigationBar here
      decoration: BoxDecoration(
        color: backgroundColor,  // Set background color for the container
      ),
      child: NavigationBarTheme(
        data: NavigationBarThemeData(
          backgroundColor: Colors.transparent,  // Set background to transparent for the inner NavigationBar
          indicatorColor: Colors.transparent,  // No background highlight on the selected item
          iconTheme: WidgetStateProperty.resolveWith<IconThemeData>((states) {
            if (states.contains(WidgetState.selected)) {
              return IconThemeData(color: selectedColor, size: iconSize);  // Black icon for selected tab
            }
            return IconThemeData(color: unselectedColor, size: iconSize);  // Grey icon for unselected tabs
          }),
          labelTextStyle: WidgetStateProperty.all(
            const TextStyle(fontSize: 0),  // Hide labels by setting font size to 0
          ),
        ),
        child: NavigationBar(
          selectedIndex: currentIndex,  // The currently active tab index
          onDestinationSelected: onTap,  // Forward the onTap callback from MainScreen
          destinations: const [
            NavigationDestination(
              icon: Icon(Icons.home),  // Icon for Home tab
              label: '',  // No label text
            ),
            NavigationDestination(
              icon: Icon(Icons.search),  // Icon for Explore/Search tab
              label: '',  // No label text
            ),
            NavigationDestination(
              icon: Icon(Icons.add),  // Icon for Add Post tab
              label: '',  // No label text
            ),
            NavigationDestination(
              icon: Icon(Icons.person),  // Icon for Profile tab
              label: '',  // No label text
            ),
          ],
        ),
      ),
    );
  }
}