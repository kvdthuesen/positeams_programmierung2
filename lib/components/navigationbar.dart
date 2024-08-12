import 'package:flutter/material.dart';
import 'package:positeams_programmierung2/pages/addPost_page.dart';
import 'package:positeams_programmierung2/pages/explore_page.dart';
import 'package:positeams_programmierung2/pages/home_page.dart';

class MyNavigationBar extends StatelessWidget {
  final int currentIndex;

  const MyNavigationBar({super.key, required this.currentIndex});

  void _onItemTapped(BuildContext context, int index) {
    switch (index) {
      case 0:
      // Navigiere zur Home Page
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const Homepage()),
              (Route<dynamic> route) => false,
        );
        break;
      case 1:
      // Navigiere zur Explore Page
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const Explore()),
              (Route<dynamic> route) => false,
        );
        break;
      case 2:
      // Navigiere zur Add Post Page
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const AddPost()),
              (Route<dynamic> route) => false,
        );
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        border: Border(
          top: BorderSide(
            color: Color.fromARGB(255, 229, 229, 229),
            width: 1.0,
          ),
        ),
      ),
      child: BottomNavigationBar(
        currentIndex: currentIndex, // Der aktuelle Index wird gesetzt
        selectedItemColor: Colors.black,
        unselectedItemColor: Colors.grey,
        onTap: (index) => _onItemTapped(context, index),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home, size: 32),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search, size: 32),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add, size: 32),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person, size: 32),
            label: '',
          ),
        ],
      ),
    );
  }
}
