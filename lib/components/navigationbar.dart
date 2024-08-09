import 'package:flutter/material.dart';
import 'package:positeams_programmierung2/pages/addPost_page.dart';

class MyNavigationBar extends StatelessWidget {
  const MyNavigationBar({super.key});

  void _onItemTapped(BuildContext context, int index) {
    switch (index) {
      /*case 0:
      // Navigate to Home Page
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => Homepage()),
        );
        break;*/
      //case 1:
      // Navigate to Search Page (if you have one)
        //break;
      case 2:
      // Navigate to Add Post Page
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => AddPost()),
        );
        break;
      /*case 3:
      // Navigate to Profile Page (if you have one)
        break;*/
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
