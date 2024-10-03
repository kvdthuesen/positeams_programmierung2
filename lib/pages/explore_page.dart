import 'package:cloud_firestore/cloud_firestore.dart'; // Import Firestore
import 'package:flutter/material.dart';
import 'package:positeams_programmierung2/components/post.dart';
import 'package:positeams_programmierung2/components/appbar.dart';
import 'package:positeams_programmierung2/pages/main_screen.dart';

/// Explore page displaying a list of posts.
class Explore extends StatefulWidget {
  const Explore({super.key});

  @override
  _ExploreState createState() => _ExploreState();
}

class _ExploreState extends State<Explore> with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  // Fetches posts from Firestore
  Stream<QuerySnapshot> _getPostsStream() {
    return FirebaseFirestore.instance.collection('posts').snapshots();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return Scaffold(
      // Custom AppBar with search functionality
      appBar: MyAppBar(
        title: 'PosiTeams',
        titleAlign: TextAlign.left,
        automaticallyImplyLeading: false, // remove the back button
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: IconButton(
              icon: const Icon(Icons.search, size: 32),
              onPressed: () {
                // Use MainScreen's tab navigation to go to the Search page
                MainScreenState? mainScreenState = context.findAncestorStateOfType<MainScreenState>();
                if (mainScreenState != null) {
                  mainScreenState.onItemTapped(4); // Correct index for SearchPage
                }
              },
            ),
          ),
        ],
        showBottomBorder: true,
      ),

      // Main content of the Explore page
      body: StreamBuilder<QuerySnapshot>(
        stream: _getPostsStream(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Center(child: Text('Error loading posts'));
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          // List of posts
          final posts = snapshot.data!.docs;

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
