import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:positeams_programmierung2/components/post_listwidget.dart';
import 'package:positeams_programmierung2/components/appbar.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true; // Ensures that the state of this widget is preserved when switching tabs.

  // Variable to keep track of the currently selected option for sorting
  String _selectedSortOption = 'oldest'; // Default selection for sorting

  // Variable to keep track of the selected filter option (only one allowed)
  String _selectedFilterOption = 'Firma'; // Default filter option is "Firma"

  // Variables to store user profile details
  String? _companyId;
  String? _teamId;
  String? _departmentId;

  @override
  void initState() {
    super.initState();
    _loadUserProfile(); // Load user profile data when the widget initializes
  }

  // Fetch the user's profile from Firestore
  Future<void> _loadUserProfile() async {
    final userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId != null) {
      final userDoc = await FirebaseFirestore.instance.collection('users').doc(userId).get();

      if (userDoc.exists) {
        setState(() {
          _companyId = userDoc['companyId'];
          _teamId = userDoc['teamId'];
          _departmentId = userDoc['departmentId'];
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context); // Needed for AutomaticKeepAliveClientMixin

    return Scaffold(
      appBar: _buildAppBar(),
      body: _buildBody(),
    );
  }

  // Builds the custom app bar with the sorting and filtering options
  PreferredSizeWidget _buildAppBar() {
    return MyAppBar(
      title: 'PosiTeams',
      titleAlign: TextAlign.left,
      leading: null,
      actions: [
        _buildSingleSelectPopupMenu(
          icon: Icons.swap_vert,
          selectedValue: _selectedSortOption,
          options: ['Älteste', 'Neuste', 'Beliebteste'],
          onSelected: _sortPosts,
        ),
        _buildSingleSelectPopupMenu(
          icon: Icons.filter_list,
          selectedValue: _selectedFilterOption,
          options: ['Team', 'Abteilung', 'Firma'],
          onSelected: _filterPosts,
        ),
      ],
    );
  }

  // Builds the body of the homepage, including the list of posts
  Widget _buildBody() {
    // Ensure the user profile data is loaded before fetching posts
    if (_companyId == null || _teamId == null || _departmentId == null) {
      return const Center(child: CircularProgressIndicator()); // Show loading spinner while user data is being fetched
    }

    // Pass the filter options and user data to the PostListWidget
    return PostListWidget(
      selectedFilterOption: _selectedFilterOption,
      selectedSortOption: _selectedSortOption,
      companyId: _companyId,
      teamId: _teamId,
      departmentId: _departmentId,
    );
  }

  // Updates the selected sorting option and sorts the posts
  void _sortPosts(String sortOption) {
    setState(() {
      _selectedSortOption = sortOption;
    });
  }

  // Updates the selected filtering option (only one allowed)
  void _filterPosts(String filterOption) {
    setState(() {
      _selectedFilterOption = filterOption; // Only one filter is allowed
    });
  }

  // Builds a reusable popup menu for single selection (filtering)
  Widget _buildSingleSelectPopupMenu({
    required IconData icon,
    required String selectedValue,
    required List<String> options,
    required void Function(String) onSelected,
  }) {
    return PopupMenuButton<String>(
      onSelected: onSelected,
      itemBuilder: (BuildContext context) {
        return options.map((option) {
          return PopupMenuItem<String>(
            value: option,
            child: _buildMenuItem(option, selectedValue),
          );
        }).toList();
      },
      icon: Icon(icon, size: 35),
      color: Colors.white.withOpacity(0.95),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8.0),
      ),
    );
  }

  // Builds individual menu items for single selection
  Widget _buildMenuItem(String text, String selectedValue) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            text,
            style: TextStyle(
              fontFamily: 'Futura',
              fontSize: 16,
              fontWeight: FontWeight.w300,
              color: selectedValue == text ? Colors.black : Colors.grey,
            ),
          ),
          if (selectedValue == text) const Icon(Icons.check, color: Colors.black),
        ],
      ),
    );
  }
}
