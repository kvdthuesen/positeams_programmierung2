import 'package:flutter/material.dart';

class MyNavigationBar extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;

  final Color selectedColor = Colors.black;
  final Color unselectedColor = Colors.grey;
  final double iconSize = 32.0;

  const MyNavigationBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 80,
      decoration: const BoxDecoration(
        color: Colors.white, // Background color for the entire navigation bar
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
          selectedIndex: currentIndex,
          onDestinationSelected: onTap,
          destinations: const [
            NavigationDestination(icon: Icon(Icons.home), label: ''), // Home
            NavigationDestination(icon: Icon(Icons.search), label: ''), // Explore
            NavigationDestination(icon: Icon(Icons.add), label: ''), // AddPost
            NavigationDestination(icon: Icon(Icons.person), label: ''),// MyProfile
          ],
        ),
      ),
    );
  }
}