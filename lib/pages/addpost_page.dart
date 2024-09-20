import 'package:positeams_programmierung2/components/appbar.dart';
import 'package:positeams_programmierung2/pages/main_screen.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';

class AddPost extends StatefulWidget {
  final int previousIndex; // Stores the index of the previous page (to return after closing)

  const AddPost({super.key, this.previousIndex = 0});

  @override
  _AddPostState createState() => _AddPostState();
}

class _AddPostState extends State<AddPost> with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  final TextEditingController _textController = TextEditingController();
  final ValueNotifier<String> _textNotifier = ValueNotifier<String>('');
  String? _selectedShareOption;
  String? _imageUrl;
  String? _firstName; // Stores the first name of the current user
  String? _companyId; // Stores the company ID of the current user
  String? _teamId; // Stores the team ID of the current user
  String? _departmentId; // Stores the department ID of the current user
  String? _profileImage; // Stores the URL of the user's profile image

  @override
  void initState() {
    super.initState();
    _textController.addListener(() {
      _textNotifier.value = _textController.text; // Update the text notifier when text changes
    });
    _fetchUserData(); // Fetch user data from Firestore on initialization
  }

  Future<void> _fetchUserData() async {
    User? user = FirebaseAuth.instance.currentUser; // Get the current authenticated user
    if (user != null) {
      DocumentSnapshot userDoc = await FirebaseFirestore.instance.collection('users').doc(user.uid).get();
      setState(() {
        // Update the state with user data retrieved from Firestore
        _firstName = userDoc['firstName'];
        _companyId = userDoc['companyId'];
        _teamId = userDoc['teamId'];
        _departmentId = userDoc['departmentId'];
        _profileImage = userDoc['profileImage']; // Fetch profile image URL
      });
    }
  }

  @override
  void dispose() {
    _textController.dispose(); // Dispose the text controller
    _textNotifier.dispose(); // Dispose the value notifier
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context); // Ensure the state is rebuilt when necessary

    return Scaffold(
      appBar: _buildAppBar(context), // Build the custom app bar
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildShareDropdown(), // Dropdown for selecting share options
            const SizedBox(height: 30),
            _buildPostInput(), // Text input for the post content
            const SizedBox(height: 20),
            const Divider(),
            const SizedBox(height: 5),
            _buildPreview(), // Preview of the post
          ],
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return MyAppBar(
      title: 'PosiNews',
      titleAlign: TextAlign.center,
      leading: IconButton(
        icon: const Icon(Icons.close, size: 30), // Close button
        onPressed: () {
          // Navigate back to the previous index in the main screen
          MainScreenState? mainScreenState = context.findAncestorStateOfType<MainScreenState>();
          if (mainScreenState != null && widget.previousIndex != mainScreenState.currentIndex) {
            mainScreenState.onItemTapped(widget.previousIndex); // Switch to the previous tab
          }
        },
      ),
      actions: [
        Padding(
          padding: const EdgeInsets.only(right: 16.0),
          child: ElevatedButton(
            onPressed: () async {
              await _savePost(); // Save the post when the button is pressed
            },
            style: ElevatedButton.styleFrom(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4.0)),
              backgroundColor: const Color.fromARGB(255, 7, 110, 23),
              padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 0.0),
              minimumSize: const Size(0, 30),
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
            child: const Text(
              'Posten',
              style: TextStyle(
                fontSize: 16,
                fontFamily: 'Futura',
                fontWeight: FontWeight.w300,
                fontStyle: FontStyle.italic,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ],
      showBottomBorder: true, // divider
    );
  }
// Function to save the post in Firestore
  Future<void> _savePost() async {
    // Validate input before saving the post
    if (_textController.text.isEmpty || _selectedShareOption == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Bitte Text eingeben und Sichtbarkeit auswählen.')),
      );
      return;
    }

    try {
      await FirebaseFirestore.instance.collection('posts').add({
        'companyId': _companyId ?? 'Unknown', // Save company ID
        'contentText': _textController.text, // Save post content
        'contentImage': _imageUrl ?? '', // Save image URL if available
        'createdAt': FieldValue.serverTimestamp(), // Save timestamp
        'teamId': _teamId ?? 'Unknown', // Save team ID
        'departmentId': _departmentId ?? 'Unknown', // Save department ID
        'firstName': _firstName ?? 'Unknown', // Save user's first name
        'visibility': _selectedShareOption, // Save visibility option
      });

      if (!mounted) return; // Ensures the context is still valid before using it

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Beitrag gepostet!')), // Notify user of successful post
      );

      _textController.clear();  // Clear the text field
      setState(() {
        _selectedShareOption = null; // Reset share option/dropdown
        _imageUrl = null; // Reset image URL
      });

      // Navigation to myprofile_page after posting
      MainScreenState? mainScreenState = context.findAncestorStateOfType<MainScreenState>();
      if (mainScreenState != null) {
        mainScreenState.onItemTapped(3); // change to Profile-Tab (Index 3)
      }

    } catch (e) {
      if (!mounted) return; // Ensures the context is still valid before using it

      // Handle errors while saving the post
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Fehler beim Speichern: $e')),
      );
    }
  }

  Future<String?> _pickAndUploadImage() async {
    try {
      // Use the image_picker package to pick an image
      final picker = ImagePicker();
      final pickedFile = await picker.pickImage(source: ImageSource.gallery); // Open image picker

      if (pickedFile == null) {
        return null; // Return if no image was selected
      }

      File imageFile = File(pickedFile.path);

      // Create a reference to Firebase Storage
      String fileName = DateTime.now().millisecondsSinceEpoch.toString();
      Reference storageRef = FirebaseStorage.instance.ref().child('post_images/$fileName');

      // Upload the image to Firebase Storage
      UploadTask uploadTask = storageRef.putFile(imageFile);
      TaskSnapshot taskSnapshot = await uploadTask;

      // Get the download URL of the uploaded image
      String downloadUrl = await taskSnapshot.ref.getDownloadURL();
      return downloadUrl;  // Return the download URL to store in Firestore

    } catch (e) {
      if (mounted) {
        // Handle errors while uploading the image
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Fehler beim Hochladen des Bildes: $e')),
        );
      }
      return null;
    }
  }

  // Dropdown for "Teilen mit" in AddPost-page
  Widget _buildShareDropdown() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const Text(
          'Teilen mit:',
          style: TextStyle(fontSize: 20, fontFamily: 'Futura Condensed'),
        ),
        const SizedBox(width: 28),
        GestureDetector(
          onTap: () => _showPopupMenu(context), // Show dropdown menu on tap
          child: Container(
            width: 300,
            height: 40,
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
            decoration: BoxDecoration(
              border: Border.all(color: const Color.fromARGB(255, 7, 110, 23), width: 1.0),
              borderRadius: BorderRadius.circular(5.0),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  _selectedShareOption ?? 'Auswählen', // Display selected option or placeholder
                  style: TextStyle(
                    fontFamily: 'Futura',
                    fontSize: 16,
                    fontWeight: FontWeight.w300,
                    color: _selectedShareOption == null ? Colors.grey : Colors.black,
                  ),
                ),
                const Icon(Icons.arrow_drop_down, color: Colors.black), // Dropdown icon
              ],
            ),
          ),
        ),
      ],
    );
  }

  void _showPopupMenu(BuildContext context) {
    // Show a popup menu to select sharing options
    showMenu(
      context: context,
      position: const RelativeRect.fromLTRB(300, 135, 1000, 0),
      items: [
        const PopupMenuItem<String>(
          value: 'Team',
          child: Text('Team', style: TextStyle(fontFamily: 'Futura')),
        ),
        const PopupMenuItem<String>(
          value: 'Abteilung',
          child: Text('Abteilung', style: TextStyle(fontFamily: 'Futura')),
        ),
        const PopupMenuItem<String>(
          value: 'Firma',
          child: Text('Firma', style: TextStyle(fontFamily: 'Futura')),
        ),
      ],
      elevation: 8.0,
    ).then((value) {
      setState(() {
        _selectedShareOption = value; // Update selected share option
      });
    });
  }

  Widget _buildPostInput() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Text:',
          style: TextStyle(fontSize: 20, fontFamily: 'Futura Condensed'),
        ),
        const SizedBox(width: 20),
        Expanded(
          child: TextField(
            controller: _textController, // Attach the text controller
            minLines: 1,
            maxLines: null,
            decoration: InputDecoration(
              filled: true,
              fillColor: const Color.fromARGB(255, 229, 229, 229),
              hintText: 'Teile deinen Kolleg*innen deine PosiNews mit!', // Placeholder text
              hintStyle: const TextStyle(
                fontFamily: 'Futura',
                fontSize: 16,
              ),
              border: const OutlineInputBorder(),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(5.0),
                borderSide: const BorderSide(
                  color: Color.fromARGB(255, 7, 110, 23),
                  width: 2.0,
                ),
              ),
            ),
            style: const TextStyle(fontFamily: 'Futura'),
          ),
        ),
      ],
    );
  }

  Widget _buildPreview() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Vorschau', // Label for preview section
          style: TextStyle(fontSize: 20, fontFamily: 'Futura Condensed', color: Colors.grey),
        ),
        const SizedBox(height: 8),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Load profile image dynamically
            CircleAvatar(
              radius: 28,
              backgroundImage: _profileImage != null ? NetworkImage(_profileImage!) : null,
              child: _profileImage == null
                  ? const Icon(Icons.person, size: 28, color: Colors.grey) // Fallback icon if no image
                  : null,
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Dynamic user display using user data
                  RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: '${_firstName ?? 'Unbekannter Benutzer'} ', // Display first name
                          style: const TextStyle(
                            fontFamily: 'Futura',
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                            color: Colors.black,
                          ),
                        ),
                        TextSpan(
                          text: '- Team ${_teamId ?? 'Unbekanntes Team'} ( ${_departmentId ?? 'Unbekannte Abteilung'})', // Display team and department
                          style: const TextStyle(color: Colors.grey, fontFamily: 'Futura', fontSize: 15),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 8),
                  ValueListenableBuilder<String>(
                    valueListenable: _textNotifier, // Listen to changes in the text notifier
                    builder: (context, text, child) {
                      return Text(
                        text.isEmpty
                            ? 'Hier werden dein News Text angezeigt. Klasse. Toll. Wuhuu. Erfolge. Projekte.' // Placeholder for empty text
                            : text,
                        style: const TextStyle(fontSize: 14, color: Colors.grey, fontFamily: 'Futura'),
                      );
                    },
                  ),
                  const SizedBox(height: 16),
                  GestureDetector(
                    onTap: () async {
                      // Pick an image and upload it to Firebase Storage
                      String? imageUrl = await _pickAndUploadImage();

                      if (imageUrl != null) {
                        setState(() {
                          _imageUrl = imageUrl;  // Save the image URL locally to display it in the UI
                        });
                      } else {
                        if (mounted) {
                          // Notify user if no image was selected
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Kein Bild ausgewählt.')),
                          );
                        }
                      }
                    },
                    child: AspectRatio(
                      aspectRatio: 21 / 9,
                      child: Container(
                        decoration: BoxDecoration(
                          color: const Color.fromARGB(26, 0, 0, 0),
                          border: Border.all(color: Colors.grey),
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: _imageUrl == null  // Check if image is already selected
                            ? const Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.add, size: 40, color: Colors.black),
                            SizedBox(height: 8),
                            Text(
                              'Bild hinzufügen',
                              style: TextStyle(fontSize: 16, color: Colors.grey, fontFamily: 'Futura'),
                            ),
                          ],
                        )
                            : Image.network(_imageUrl!, fit: BoxFit.cover),  // Display the selected image
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }
}
