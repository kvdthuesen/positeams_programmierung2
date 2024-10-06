import 'dart:io';
import 'package:flutter/material.dart';

class ProfileHeader extends StatelessWidget {
  final File? profileImage; // User's selected profile image file
  final String? profileImageUrl; // URL of the user's uploaded profile image
  final VoidCallback? onProfileImagePick; // Callback to pick a profile image
  final File? backgroundImage; // User's selected background image file
  final String? backgroundImageUrl; // URL of the user's uploaded background image
  final VoidCallback? onBackgroundImagePick; // Callback to pick a background image
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
    this.showEditIcons = true,
    required this.isUploadingProfileImage,
    required this.isUploadingBackgroundImage,
    this.bottomSpacing = 10,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Stack(
          clipBehavior: Clip.none,
          children: [
            // Clickable background image with an optional edit icon
            GestureDetector(
              onTap: onBackgroundImagePick,
              child: Container(
                height: 120,
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
                    // Background image loader
                    if (isUploadingBackgroundImage)
                      const Center(
                        child: CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                        ),
                      ),
                    // Edit icon for background image
                    if (!isUploadingBackgroundImage && showEditIcons && onBackgroundImagePick != null)
                      Align(
                        alignment: Alignment.bottomRight,
                        child: IconButton(
                          icon: const Icon(Icons.edit, color: Colors.white),
                          iconSize: 30,
                          onPressed: onBackgroundImagePick,
                        ),
                      ),
                  ],
                ),
              ),
            ),
            // Profile image with an optional edit icon and loader
            Positioned(
              bottom: -50,
              left: 24,
              child: GestureDetector(
                onTap: onProfileImagePick,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    // Profile image with white border
                    CircleAvatar(
                      radius: 55,
                      backgroundColor: Colors.white,
                      child: CircleAvatar(
                        radius: 50,
                        backgroundImage: profileImage != null
                            ? FileImage(profileImage!)
                            : profileImageUrl != null && profileImageUrl!.isNotEmpty
                            ? NetworkImage(profileImageUrl!) as ImageProvider
                            : const AssetImage('lib/assets/default_avatar.png'),
                      ),
                    ),
                    // Profile image loader
                    if (isUploadingProfileImage)
                      const CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                  ],
                ),
              ),
            ),
            // Edit icon for profile image
            if (!isUploadingProfileImage && showEditIcons && onProfileImagePick != null)
              Positioned(
                bottom: -16,
                left: 55,
                child: IconButton(
                  icon: Icon(
                    Icons.camera_alt,
                    color: profileImage == null ? Colors.green : Colors.white,
                  ),
                  iconSize: 30,
                  onPressed: onProfileImagePick,
                ),
              ),
          ],
        ),
        // Customizable spacing below the profile header
        SizedBox(height: bottomSpacing),
      ],
    );
  }
}