import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:positeams_programmierung2/components/post.dart';
import 'package:positeams_programmierung2/components/post_service.dart';

class PostListWidget extends StatelessWidget {
  final String selectedFilterOption; // Required filter option
  final String selectedSortOption;   // Required sort option
  final String? companyId;           // Pass companyId dynamically
  final String? teamId;              // Pass teamId dynamically
  final String? departmentId;        // Pass departmentId dynamically

  const PostListWidget({
    super.key,
    required this.selectedFilterOption,
    required this.selectedSortOption,
    this.companyId,
    this.teamId,
    this.departmentId,
  });

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: PostService().getPostsStream(
        selectedFilterOption: selectedFilterOption,
        selectedSortOption: selectedSortOption,
      ),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return const Center(child: Text('Error loading posts'));
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        final posts = snapshot.data?.docs ?? [];

        if (posts.isEmpty) {
          return const Center(child: Text('No posts available.'));
        }

        return ListView.builder(
          itemCount: posts.length,
          itemBuilder: (context, index) {
            final post = posts[index].data() as Map<String, dynamic>;

            return Post(
              firstName: post['firstName'] ?? 'Unknown',
              teamId: post['teamId'] ?? 'Unknown Team',
              departmentId: post['departmentId'] ?? 'Unknown Department',
              contentText: post['contentText'] ?? 'No content',
              contentImage: post['contentImage'] ?? '',
              profileImage: post['profileImage'] ?? '',
            );
          },
        );
      },
    );
  }
}
