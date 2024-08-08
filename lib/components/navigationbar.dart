import 'package:flutter/material.dart';

class MyNavigationBar extends StatelessWidget {
  const MyNavigationBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        border: Border( // Border at the top of navigation bar
          top: BorderSide(
            color: Color.fromARGB(255, 229, 229, 229),
            width: 1.0,
          ),
        ),
      ),
      child: BottomNavigationBar(
        selectedItemColor: Colors.black, // Color for selected icons
        unselectedItemColor: Colors.grey, // Color for unselected icons
        showSelectedLabels: false, // Hide labels for selected items
        showUnselectedLabels: false, // Hide labels for unselected items
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home, size: 32),
            label: '', // Empty label
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search, size: 32),
            label: '', // Empty label
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add, size: 32),
            label: '', // Empty label
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person, size: 32),
            label: '', // Empty label
          ),
        ],
      ),
    );
  }
}
