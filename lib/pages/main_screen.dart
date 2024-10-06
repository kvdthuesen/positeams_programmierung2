import 'package:flutter/material.dart';
import 'package:positeams_programmierung2/pages/home_page.dart';
import 'package:positeams_programmierung2/pages/explore_page.dart';
import 'package:positeams_programmierung2/pages/addpost_page.dart';
import 'package:positeams_programmierung2/pages/myprofile_page.dart';
import 'package:positeams_programmierung2/components/navigationbar.dart';
import 'package:positeams_programmierung2/pages/search_page.dart';

import 'menu_page.dart';

class MainScreen extends StatefulWidget {
  final int selectedIndex;

  const MainScreen({super.key, this.selectedIndex = 0});

  @override
  MainScreenState createState() => MainScreenState();
}

class MainScreenState extends State<MainScreen> {
  late int _selectedIndex;
  late int _previousIndex;
  String _searchQuery = ''; // Stores the current search query

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.selectedIndex;
    _previousIndex = _selectedIndex;
  }

  // Getter for current selected index
  int get currentIndex => _selectedIndex;

  // Updates the search query from the Search page
  void updateSearchQuery(String query) {
    setState(() {
      _searchQuery = query;
    });
  }

  // List of pages for navigation
  final List<Widget> _pages = [
    const Homepage(),
    const Explore(),
    const AddPost(previousIndex: 0),
    const MyProfile(),
    const Search(),
    const MenuPage(),
  ];

  // Handles tab selection
  void onItemTapped(int index) {
    setState(() {
      if (index == 1 && _selectedIndex == 1) {
        // If Explore is already selected and tapped again, clear the search query
        _searchQuery = ''; // Reset search query
      }
      _previousIndex = _selectedIndex;
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
            return AddPost(previousIndex: _previousIndex);
          }
          if (page is Explore) {
            return Explore(searchQuery: _searchQuery);
          }
          return page;
        }).toList(),
      ),
      // Hide the BottomNavigationBar on AddPost, Search, and Menu pages
      bottomNavigationBar: (_selectedIndex == 2 || _selectedIndex == 4 || _selectedIndex == 5)
          ? null
          : MyNavigationBar(
        currentIndex: _selectedIndex,
        onTap: onItemTapped,
      ),
    );
  }
}