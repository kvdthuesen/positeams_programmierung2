import 'package:flutter/material.dart';
import 'package:positeams_programmierung2/components/post.dart';
import 'package:positeams_programmierung2/components/appbar.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> with AutomaticKeepAliveClientMixin {
  /// Ensures that the state of this widget is preserved when switching tabs.
  @override
  bool get wantKeepAlive => true;

  // Variable to keep track of the currently selected option for sorting
  String _selectedSortOption = 'oldest'; // Default selection for sorting

  // List to keep track of the selected options for filtering
  List<String> _selectedFilterOptions = []; // No filters selected by default

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
      actions: [
        _buildPopupMenu(
          icon: Icons.swap_vert,
          selectedValue: _selectedSortOption,
          options: ['Älteste', 'Neuste', 'Beliebteste'],
          onSelected: _sortPosts,
        ),
        _buildMultiSelectPopupMenu(
          icon: Icons.filter_list,
          selectedValues: _selectedFilterOptions,
          options: ['Team', 'Abteilung', 'Firma'],
          onSelected: _filterPosts,
        ),
      ],
    );
  }

  // Builds a reusable popup menu for single selection (sorting)
  Widget _buildPopupMenu({
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

  // Builds a reusable popup menu for multi-selection (filtering)
  Widget _buildMultiSelectPopupMenu({
    required IconData icon,
    required List<String> selectedValues,
    required List<String> options,
    required void Function(String) onSelected,
  }) {
    return Padding(
      padding: const EdgeInsets.only(right: 8.0), // distance to page-end
      child: PopupMenuButton<String>(
        onSelected: onSelected,
        itemBuilder: (BuildContext context) {
          return options.map((option) {
            return PopupMenuItem<String>(
              value: option,
              child: _buildMultiSelectMenuItem(option, selectedValues),
            );
          }).toList();
        },
        icon: Icon(icon, size: 35),
        color: Colors.white.withOpacity(0.95),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
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

  // Builds individual menu items for multi-selection (filters)
  Widget _buildMultiSelectMenuItem(String text, List<String> selectedValues) {
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
              color: selectedValues.contains(text) ? Colors.black : Colors.grey,
            ),
          ),
          if (selectedValues.contains(text)) const Icon(Icons.check, color: Colors.black),
        ],
      ),
    );
  }

  // Builds the body of the homepage, including the list of posts
  Widget _buildBody() {
    return ListView(
      children: const [
        SizedBox(height: 8),
        Post(),
        Post(),
        Post(),
        Post(),
      ],
    );
  }

  // Updates the selected sorting option and sorts the posts
  void _sortPosts(String sortOption) {
    setState(() {
      _selectedSortOption = sortOption;
      // Implement sorting logic based on 'sortOption'
    });
  }

  // Updates the selected filtering options
  void _filterPosts(String filterOption) {
    setState(() {
      if (_selectedFilterOptions.contains(filterOption)) {
        _selectedFilterOptions.remove(filterOption); // Deselect if already selected
      } else {
        _selectedFilterOptions.add(filterOption); // Add if not selected
      }
      // Implement filtering logic based on '_selectedFilterOptions'
    });
  }
}
