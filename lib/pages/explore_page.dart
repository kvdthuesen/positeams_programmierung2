import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:positeams_programmierung2/components/post.dart';
import 'package:positeams_programmierung2/components/appbar.dart';
import 'package:positeams_programmierung2/pages/main_screen.dart';
import 'package:positeams_programmierung2/components/authentication_check.dart';

/// Explore page displaying a list of posts.
class Explore extends StatefulWidget {
  final String searchQuery; // The search query passed from the main screen

  const Explore({super.key, this.searchQuery = ''}); // Default query is an empty string

  @override
  _ExploreState createState() => _ExploreState();
}

class _ExploreState extends State<Explore> with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  String? _userCompanyId; // Stores the companyId of the authenticated user

  @override
  void initState() {
    super.initState();
    _initialize(); // Separate authentication check and companyId fetching
  }

  // Function to initialize the authentication check and fetch the companyId
  Future<void> _initialize() async {
    await checkAuthentication(context); // Check if the user is authenticated
    _fetchUserCompanyId(); // Fetch the user's companyId after authentication
  }

  // Function to fetch the companyId of the current authenticated user
  Future<void> _fetchUserCompanyId() async {
    final user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      // Fetch the user's companyId
      DocumentSnapshot userDoc = await FirebaseFirestore.instance.collection('users').doc(user.uid).get();
      setState(() {
        _userCompanyId = userDoc['companyId']; // Save the companyId of the user
      });
    }
  }

  // Fetches posts from Firestore based on the search query and companyId
  Stream<List<DocumentSnapshot>> _getPostsStream() {
    if (_userCompanyId == null) {
      // Return an empty stream until the companyId is available
      return Stream.value([]);
    }

    if (widget.searchQuery.isEmpty) {
      // If searchQuery is empty, return all posts from the same company
      return FirebaseFirestore.instance
          .collection('posts')
          .where('companyId', isEqualTo: _userCompanyId) // Filter posts by the user's company
          .orderBy('randomFactor', descending: true)
          .snapshots()
          .map((snapshot) => snapshot.docs); // Return the documents from the snapshot
    } else {
      String searchQuery = widget.searchQuery.toLowerCase(); // Convert the search query to lowercase

      // Search in the searchableContent array field and filter by companyId
      return FirebaseFirestore.instance
          .collection('posts')
          .where('companyId', isEqualTo: _userCompanyId) // Filter by company
          .where('searchableContent', arrayContains: searchQuery) // Use arrayContains for the search
          .snapshots()
          .map((snapshot) => snapshot.docs); // Return the documents from the snapshot
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return Scaffold(
      // Custom AppBar with search functionality
      appBar: MyAppBar(
        title: 'PosiTeams',
        titleAlign: TextAlign.left,
        automaticallyImplyLeading: false, // Remove the back button
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: IconButton(
              icon: const Icon(Icons.search, size: 32),
              onPressed: () {
                // Use MainScreen's tab navigation to go to the Search page
                MainScreenState? mainScreenState = context.findAncestorStateOfType<MainScreenState>();
                if (mainScreenState != null) {
                  mainScreenState.onItemTapped(4); // Navigate to SearchPage
                }
              },
            ),
          ),
        ],
        showBottomBorder: true,
      ),

      // Main content of the Explore page
      body: StreamBuilder<List<DocumentSnapshot>>(
        stream: _getPostsStream(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Center(child: Text('Error loading posts'));
          }

          // List of posts
          final posts = snapshot.data ?? [];

          if (posts.isEmpty) {
            return const Center(child: Text('Keine Beiträge gefunden'));
          }

          // Return a list of post widgets based on Firestore data
          return ListView.builder(
            itemCount: posts.length,
            itemBuilder: (context, index) {
              final post = posts[index].data() as Map<String, dynamic>;

              return Post(
                firstName: post['firstName'] ?? 'Unknown', // Dynamically display user's first name
                teamId: post['teamId'] ?? 'Unknown Team', // Dynamically display team
                departmentId: post['departmentId'] ?? 'Unknown Department', // Dynamically display department
                contentText: post['contentText'] ?? 'No content', // Dynamically display post text
                contentImage: post['contentImage'] ?? '', // Dynamically display post image
                profileImage: post['profileImage'] ?? '', // Dynamically display profileImage
              );
            },
          );
        },
      ),
    );
  }
}