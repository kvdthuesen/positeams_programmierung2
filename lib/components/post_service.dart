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
    } else if (selectedSortOption == 'Beliebteste') {
      query = query.orderBy('ReactionCounter', descending: true); // Sort by most reactions
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
    Query query = _firestore
        .collection('posts')
        .where('userId', isEqualTo: user.uid)
        .orderBy('createdAt', descending: true);

    // Return a stream of the user's posts
    try {
      yield* query.snapshots(); // Return a real-time stream of the user's posts
    } catch (e) {
      throw Exception('Error executing Firestore query: $e'); // Handle Firestore query errors
    }
  }

  /// Fetch posts stream where the authenticated user has reacted.
  Stream<QuerySnapshot> getUserReactionStream(BuildContext context) async* {
    // Check if the user is authenticated
    await checkAuthentication(context);

    // Retrieve the current authenticated user
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return; // Exit if no user is logged in

    // Query posts where the authenticated user's ID is in the ReactionId array
    Query query = _firestore
        .collection('posts')
        .where('ReactionId', arrayContains: user.uid)
        .orderBy('createdAt', descending: true); // Sort by most recent posts

    // Return a stream of posts the user has reacted to
    try {
      yield* query.snapshots();
    } catch (e) {
      throw Exception('Error fetching user reactions: $e');
    }
  }

  /// Saves a reaction to the specified post in Firestore.
  ///
  /// This method adds the user's ID to the appropriate reaction array
  /// and ensures that other reactions are removed.
  ///
  /// [postId] - The ID of the post document in Firestore.
  /// [reactionType] - The type of reaction: 'ThumbUp', 'Favorite', or 'Emotion'.
  Future<void> saveReaction({
    required String postId,
    required String reactionType, // 'ThumbUp', 'Favorite', or 'Emotion'
  }) async {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      throw Exception('User is not authenticated');
    }

    final userId = user.uid;
    final postRef = _firestore.collection('posts').doc(postId);

    try {
      // Remove existing reactions
      await removeReaction(postId: postId);

      // Add the new reaction
      await _firestore.runTransaction((transaction) async {
        final postSnapshot = await transaction.get(postRef);

        if (!postSnapshot.exists) {
          throw Exception('Post does not exist');
        }

        final data = postSnapshot.data() as Map<String, dynamic>;

        // Ensure all arrays are initialized
        final List<String> reactionIds = List<String>.from(data['ReactionId'] ?? []);
        final List<String> thumbUpIds = List<String>.from(data['ThumbUpId'] ?? []);
        final List<String> favoriteIds = List<String>.from(data['FavoriteId'] ?? []);
        final List<String> emotionIds = List<String>.from(data['EmotionId'] ?? []);

        // Add the user's ID to the specified reaction array
        if (reactionType == 'ThumbUp') {
          thumbUpIds.add(userId);
          reactionIds.add(userId);
        } else if (reactionType == 'Favorite') {
          favoriteIds.add(userId);
          reactionIds.add(userId);
        } else if (reactionType == 'Emotion') {
          emotionIds.add(userId);
          reactionIds.add(userId);
        }

        // Update Firestore with the modified arrays
        transaction.update(postRef, {
          'ReactionId': reactionIds,
          'ThumbUpId': thumbUpIds,
          'FavoriteId': favoriteIds,
          'EmotionId': emotionIds,
        });
      });

      // Update the counters
      await idCounter(postId);
    } catch (e) {
      throw Exception('Error saving reaction: $e');
    }
  }


  /// Removes a reaction from the specified post in Firestore.
  /// This method removes the user's ID from the associated arrays
  /// without handling the counter logic directly.
  /// [postId] - The ID of the post document in Firestore.
  Future<void> removeReaction({
    required String postId,
  }) async {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      throw Exception('User is not authenticated');
    }

    final userId = user.uid; // Authenticated user's ID
    final postRef = _firestore.collection('posts').doc(postId);

    try {
      await _firestore.runTransaction((transaction) async {
        final postSnapshot = await transaction.get(postRef);

        if (!postSnapshot.exists) {
          throw Exception('Post does not exist');
        }

        final data = postSnapshot.data() as Map<String, dynamic>;

        // Retrieve reaction arrays or set empty arrays if null
        final List<String> reactionIds = List<String>.from(data['ReactionId'] ?? []);
        final List<String> thumbUpIds = List<String>.from(data['ThumbUpId'] ?? []);
        final List<String> favoriteIds = List<String>.from(data['FavoriteId'] ?? []);
        final List<String> emotionIds = List<String>.from(data['EmotionId'] ?? []);

        // Remove the user ID only if it exists in the respective arrays
        reactionIds.remove(userId);
        thumbUpIds.remove(userId);
        favoriteIds.remove(userId);
        emotionIds.remove(userId);

        // Update the document with the modified arrays
        transaction.update(postRef, {
          'ReactionId': reactionIds,
          'ThumbUpId': thumbUpIds,
          'FavoriteId': favoriteIds,
          'EmotionId': emotionIds,
        });
      });

      // Call IdCounter to update counters after removing reactions
      await idCounter(postId);
    } catch (e) {
      throw Exception('Error removing reaction: $e');
    }
  }

  /// Updates all reaction counters for the specified post.
  /// This method recalculates the length of each reaction array and updates
  /// the respective counter fields in Firestore.
  /// [postId] - The ID of the post document in Firestore.
  Future<void> idCounter(String postId) async {
    final postRef = _firestore.collection('posts').doc(postId);

    try {
      await _firestore.runTransaction((transaction) async {
        final postSnapshot = await transaction.get(postRef);

        if (!postSnapshot.exists) {
          throw Exception('Post does not exist');
        }

        final data = postSnapshot.data() as Map<String, dynamic>;

        // Retrieve reaction arrays or set empty arrays if null
        final List<String> reactionIds = List<String>.from(data['ReactionId'] ?? []);
        final List<String> thumbUpIds = List<String>.from(data['ThumbUpId'] ?? []);
        final List<String> favoriteIds = List<String>.from(data['FavoriteId'] ?? []);
        final List<String> emotionIds = List<String>.from(data['EmotionId'] ?? []);

        // Update counters based on the array lengths
        transaction.update(postRef, {
          'ReactionCounter': reactionIds.length,
          'ThumbUpCounter': thumbUpIds.length,
          'FavoriteCounter': favoriteIds.length,
          'EmotionCounter': emotionIds.length,
        });
      });
    } catch (e) {
      throw Exception('Error updating counters: $e');
    }
  }
}