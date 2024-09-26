import 'dart:io';
import 'package:flutter/material.dart';

class ProfileHeader extends StatelessWidget {
  final File? profileImage; // User's selected profile image file
  final String? profileImageUrl; // URL of the user's uploaded profile image
  final VoidCallback? onProfileImagePick; // Callback function to pick a profile image
  final File? backgroundImage; // User's selected background image file
  final String? backgroundImageUrl; // URL of the user's uploaded background image
  final VoidCallback? onBackgroundImagePick; // Callback function to pick a background image
  final bool showEditIcons; // Controls the visibility of edit icons
  final bool isUploadingProfileImage; // Indicates if the profile image is uploading
  final bool isUploadingBackgroundImage; // Indicates if the background image is uploading
  final double bottomSpacing; // Customizable bottom spacing after the profile header

  const ProfileHeader({
    super.key,
    required this.profileImage,
    required this.profileImageUrl,
    this.onProfileImagePick,
    required this.backgroundImage,
    required this.backgroundImageUrl,
    this.onBackgroundImagePick,
    this.showEditIcons = true, // Default is true to show icons, unless specified otherwise
    required this.isUploadingProfileImage, // Loading state for profile image
    required this.isUploadingBackgroundImage, // Loading state for background image
    this.bottomSpacing = 10, // Default bottom spacing is set to 10
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Stack(
          clipBehavior: Clip.none, // Allows elements to overflow outside the box
          children: [
            // GestureDetector to make the background image clickable
            GestureDetector(
              onTap: onBackgroundImagePick, // Opens background image picker on tap
              child: Container(
                height: 120, // Height for the background image section
                width: double.infinity,
                decoration: BoxDecoration(
                  image: backgroundImage != null
                      ? DecorationImage(
                      image: FileImage(backgroundImage!), fit: BoxFit.cover)
                      : DecorationImage(
                    image: backgroundImageUrl != null && backgroundImageUrl!.isNotEmpty
                        ? NetworkImage(backgroundImageUrl!) as ImageProvider
                        : const AssetImage('lib/assets/default_background.jpg'),
                    fit: BoxFit.cover,
                  ),
                ),
                child: Stack(
                  children: [
                    // Loader shown when background image is uploading
                    if (isUploadingBackgroundImage)
                      const Center(
                        child: CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                        ),
                      ),
                    // Only show the edit icon if not uploading the background image
                    if (!isUploadingBackgroundImage && showEditIcons && onBackgroundImagePick != null)
                      Align(
                        alignment: Alignment.bottomRight,
                        child: IconButton(
                          icon: const Icon(Icons.edit, color: Colors.white),
                          iconSize: 30,
                          onPressed: onBackgroundImagePick, // Opens background image picker
                        ),
                      ),
                  ],
                ),
              ),
            ),
            // GestureDetector to make the profile image clickable
            Positioned(
              bottom: -50, // Position to make the profile image overlap the background
              left: 24, // Align the profile image to the left side
              child: GestureDetector(
                onTap: onProfileImagePick, // Opens profile image picker on tap
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    // Profile image with white border (increased size)
                    CircleAvatar(
                      radius: 55, // Increase the size of the white border around the profile image
                      backgroundColor: Colors.white, // White ring around the profile image
                      child: CircleAvatar(
                        radius: 50, // Increase the size of the profile image itself
                        backgroundImage: profileImage != null
                            ? FileImage(profileImage!)
                            : profileImageUrl != null && profileImageUrl!.isNotEmpty
                            ? NetworkImage(profileImageUrl!) as ImageProvider
                            : const AssetImage('lib/assets/default_avatar.png'), // Fallback if no profile image
                      ),
                    ),
                    // Loader shown only when profile image is uploading
                    if (isUploadingProfileImage)
                      const CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                  ],
                ),
              ),
            ),
            // Only show the camera icon if not uploading the profile image
            if (!isUploadingProfileImage && showEditIcons && onProfileImagePick != null)
              Positioned(
                bottom: -16, // Position relative to the profile image
                left: 55, // Adjust to keep the icon in place relative to the larger profile image
                child: IconButton(
                  icon: Icon(
                    Icons.camera_alt,
                    color: profileImage == null ? Colors.green : Colors.white,
                  ),
                  iconSize: 30,
                  onPressed: onProfileImagePick, // Opens profile image picker
                ),
              ),
          ],
        ),
        // Add customizable spacing after the profile image
        SizedBox(height: bottomSpacing),
      ],
    );
  }
}