import 'package:flutter/material.dart';
import 'package:positeams_programmierung2/pages/home_page.dart';
import 'package:positeams_programmierung2/pages/explore_page.dart';
import 'package:positeams_programmierung2/pages/addPost_page.dart';
import 'package:positeams_programmierung2/pages/myprofile_page.dart';
import 'package:positeams_programmierung2/components/navigationbar.dart';
import 'package:positeams_programmierung2/pages/search_page.dart';

import 'menu_page.dart';

class MainScreen extends StatefulWidget {
  final int selectedIndex; // Parameter to set the selected tab index

  const MainScreen({super.key, this.selectedIndex = 0}); // Default index is 0 (Home)

  @override
  MainScreenState createState() => MainScreenState();
}

class MainScreenState extends State<MainScreen> {
  late int _selectedIndex;
  late int _previousIndex;

  @override
  void initState() {
    super.initState();
    // Set the initial index and previous index
    _selectedIndex = widget.selectedIndex;
    _previousIndex = _selectedIndex;
  }

  // Getter for current selected index
  int get currentIndex => _selectedIndex;

  // List of pages for navigation, including the SearchPage
  final List<Widget> _pages = [
    const Homepage(),
    const Explore(),
    const AddPost(previousIndex: 0), // Pass previous index dynamically
    const MyProfile(),
    const Search(), // SearchPage as an additional page
    const MenuPage(),
  ];

  // Function to handle tab selection
  void onItemTapped(int index) {
    setState(() {
      _previousIndex = _selectedIndex; // Store current index before switching
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _selectedIndex,
        children: _pages.map((page) {
          // Special handling for AddPost to pass the previous index
          if (page is AddPost) {
            return AddPost(previousIndex: _previousIndex); // Pass correct previous index
          }
          return page;
        }).toList(),
      ),
      // Hide the BottomNavigationBar on AddPost (index 2) and Search (index 4)
      bottomNavigationBar: (_selectedIndex == 2 || _selectedIndex == 4 || _selectedIndex == 5)
          ? null
          : MyNavigationBar(
        currentIndex: _selectedIndex,
        onTap: onItemTapped,
      ),
    );
  }
}