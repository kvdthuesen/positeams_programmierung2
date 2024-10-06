import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:positeams_programmierung2/components/authentication_check.dart';

class PostService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// Fetch posts stream with filtering and sorting based on the user's profile data.
  /// This method streams posts while applying filters based on the user's company, team, or department.
  /// [selectedFilterOption] - Specifies if the filtering is based on 'Firma', 'Team', or 'Abteilung'.
  /// [selectedSortOption] - Defines whether the posts should be sorted by 'Neuste' or 'Älteste'.
  Stream<QuerySnapshot> getPostsStream({
    required String selectedFilterOption,
    required String selectedSortOption,
    required BuildContext context, // Added context for authentication check
  }) async* {
    // Check if the user is authenticated
    await checkAuthentication(context);

    // Retrieve the current authenticated user
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return; // Exit if no user is logged in

    // Fetch the user profile from Firestore
    DocumentSnapshot userProfile = await _firestore.collection('users').doc(user.uid).get();

    // Extract company, team, and department IDs from the user profile
    String? companyId = userProfile['companyId'];
    String? teamId = userProfile['teamId'];
    String? departmentId = userProfile['departmentId'];

    // Begin querying the 'posts' collection
    Query query = _firestore.collection('posts');

    // Apply filters based on the user's profile and selected filter option
    if (companyId != null) {
      query = query.where('companyId', isEqualTo: companyId); // Filter by company

      if (selectedFilterOption == 'Abteilung' && departmentId != null) {
        query = query.where('departmentId', isEqualTo: departmentId); // Further filter by department if selected
      } else if (selectedFilterOption == 'Team' && teamId != null) {
        query = query
            .where('departmentId', isEqualTo: departmentId) // Filter by department
            .where('teamId', isEqualTo: teamId); // Filter by team if selected
      }
    }

    // Apply sorting based on the selected option (newest or oldest posts first)
    if (selectedSortOption == 'Neuste') {
      query = query.orderBy('createdAt', descending: true); // Sort by most recent posts
    } else if (selectedSortOption == 'Älteste') {
      query = query.orderBy('createdAt', descending: false); // Sort by oldest posts
    }

    // Stream the query results and handle any errors during execution
    try {
      yield* query.snapshots(); // Return a real-time stream of the posts
    } catch (e) {
      throw Exception('Error executing Firestore query: $e'); // Use an exception for production-safe error handling
    }
  }

  /// Fetch posts stream specifically for the current authenticated user based on userId.
  Stream<QuerySnapshot> getUserPostsStream(BuildContext context) async* {
    // Check if the user is authenticated
    await checkAuthentication(context);

    // Retrieve the current authenticated user
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return; // Exit if no user is logged in

    // Query the 'posts' collection filtered by the current userId
    Query query = _firestore.collection('posts').where('userId', isEqualTo: user.uid);

    // Return a stream of the user's posts
    try {
      yield* query.snapshots(); // Return a real-time stream of the user's posts
    } catch (e) {
      throw Exception('Error executing Firestore query: $e'); // Handle Firestore query errors
    }
  }

  /// Fetch all posts stream without filtering by userId, used for loading all posts.
  Stream<QuerySnapshot> getAllPostsStream(BuildContext context) async* {
    // Check if the user is authenticated
    await checkAuthentication(context);

    // Query all posts
    Query query = _firestore.collection('posts');

    // Return a stream of all posts
    try {
      yield* query.snapshots(); // Return a real-time stream of all posts
    } catch (e) {
      throw Exception('Error executing Firestore query: $e'); // Handle Firestore query errors
    }
  }
}