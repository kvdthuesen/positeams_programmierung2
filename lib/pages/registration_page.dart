import 'package:flutter/material.dart'; // Import flutter material
import 'package:positeams_programmierung2/components/appbar.dart'; // Import Appbar component
import 'package:positeams_programmierung2/pages/main_screen.dart'; // Import MainScreen
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'authentication_page.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _companyIdController = TextEditingController();
  final TextEditingController _teamIdController = TextEditingController();
  final TextEditingController _departmentIdController = TextEditingController();

  int _currentStep = 0; // To track the current step
  String? _allowedEmail; // To reduce load times if e-mail is already allowed
  bool _isLoading = false; // Variable to track the loading state
  File? _profileImage; // Variable to store the selected image
  String? _profileImageUrl; // URL of the uploaded profile image
  bool _isUploadingProfileImage = false; // Variable to track the uploading state

  /// Check if password meets security requirements
  bool _isPasswordValid(String password) {
    final passwordRegex = RegExp(r'^(?=.*[A-Z])(?=.*\d)(?=.*[!@#\$&*~]).{8,}$');
    return passwordRegex.hasMatch(password);
  }

  /// Validate the initial fields before moving to the next step
  Future<bool> _validateInitialFields() async {
    final email = _emailController.text;
    final password = _passwordController.text;
    final confirmPassword = _confirmPasswordController.text;

    // Check if the email is already allowed
    if (_allowedEmail == email) {
      return true; // Skip the registration check if the email was previously validated
    }

    // Start loading
    setState(() {
      _isLoading = true;
    });

    if (email.isEmpty || password.isEmpty || confirmPassword.isEmpty) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Bitte füllen Sie alle Felder aus.')),
        );
      }
      setState(() {
        _isLoading = false;
      });
      return false;
    }

    if (password != confirmPassword) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Die Passwörter stimmen nicht überein.')),
        );
      }
      setState(() {
        _isLoading = false;
      });
      return false;
    }

    if (!_isPasswordValid(password)) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Das Passwort muss mindestens 8 Zeichen lang sein, eine Zahl, einen Großbuchstaben und ein Sonderzeichen enthalten.')),
        );
      }
      setState(() {
        _isLoading = false;
      });
      return false;
    }

    // Try to create a user with the email and password to check if the email is in use
    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(email: email, password: password);
      // If user creation was successful, delete the user immediately so they can re-register in the next steps
      await FirebaseAuth.instance.currentUser?.delete();

      // Save the email as allowed
      _allowedEmail = email;

      setState(() {
        _isLoading = false;
      });
      return true;
    } on FirebaseAuthException catch (e) {
      if (mounted) {
        if (e.code == 'email-already-in-use') {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('E-Mail wird bereits verwendet.')),
          );
        } else if (e.code == 'invalid-email') {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Ungültige E-Mail-Adresse.')),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Fehler: ${e.message}')),
          );
        }
      }
      setState(() {
        _isLoading = false;
      });
      return false;
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Fehler bei der E-Mail-Überprüfung: $e')),
        );
      }
      setState(() {
        _isLoading = false;
      });
      return false;
    }
  }
  /// Validate the second and third step fields
  bool _validatePersonalFields() {
    final firstName = _firstNameController.text;
    final lastName = _lastNameController.text;

    if (firstName.isEmpty || lastName.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Bitte füllen Sie alle Felder aus.')),
      );
      return false;
    }
    return true;
  }

  bool _validateCompanyFields() {
    final companyId = _companyIdController.text;
    final teamId = _teamIdController.text;
    final departmentId = _departmentIdController.text;

    if (companyId.isEmpty || teamId.isEmpty || departmentId.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Bitte füllen Sie alle Felder aus.')),
      );
      return false;
    }
    return true;
  }

  /// Handle the registration process
  void _register() async {
    setState(() {
      _isLoading = true; // Start loading when registration begins
    });

    final email = _emailController.text;
    final password = _passwordController.text;
    final firstName = _firstNameController.text;
    final lastName = _lastNameController.text;
    final companyId = _companyIdController.text;
    final teamId = _teamIdController.text;
    final departmentId = _departmentIdController.text;

    try {
      // Firebase Authentication: Create user
      UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      String uid = userCredential.user!.uid;

      // Firestore: Save additional user details, including profileImageUrl
      await FirebaseFirestore.instance.collection('users').doc(uid).set({
        'firstName': firstName,
        'lastName': lastName,
        'email': email,
        'companyId': companyId,
        'teamId': teamId,
        'departmentId': departmentId,
        'userId': uid,
        'profileImage': _profileImageUrl ?? '', // Save profile image URL if available
      });

      // After registration, navigate to the main screen
      if (!mounted) return;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const MainScreen()),
      );
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Fehler bei der Registrierung: $e')),
        );
      }
    } finally {
      setState(() {
        _isLoading = false; // Reset loading state after registration is complete
      });
    }
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String labelText,
    bool obscureText = false,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextField(
        controller: controller,
        obscureText: obscureText,
        decoration: InputDecoration(
          labelText: labelText,
          labelStyle: const TextStyle(color: Color.fromARGB(255, 7, 110, 23)),
          border: const OutlineInputBorder(),
          focusedBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: Color.fromARGB(255, 7, 110, 23)),
          ),
        ),
      ),
    );
  }

  /// Build the buttons for the bottom part of each step
  Widget _buildBottomButtons({required VoidCallback onNext, VoidCallback? onBack}) {
    return Column(
      children: [
        if (_isLoading) ...[
          const Center(
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Color.fromARGB(255, 7, 110, 23)), // Green color
            ),
          ),
          const SizedBox(height: 16),
          Text(
            _currentStep == 2 ? 'Registriere...' : 'Überprüfe E-Mail...',
            style: const TextStyle(
              fontSize: 16,
              fontFamily: 'futura',
              color: Color.fromARGB(255, 7, 110, 23),
            ),
          ),
        ] else ...[
          if (onBack != null) ...[
            SizedBox(
              width: double.infinity,
              child: OutlinedButton(
                onPressed: onBack,
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: Color.fromARGB(255, 7, 110, 23)),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
                child: const Text(
                  'Zurück',
                  style: TextStyle(
                    fontSize: 16,
                    color: Color.fromARGB(255, 7, 110, 23),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
          ],
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: onNext,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromARGB(255, 7, 110, 23),
                padding: const EdgeInsets.symmetric(vertical: 14),
              ),
              child: Text(
                _currentStep == 2 ? 'Registrieren' : 'Weiter',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                ),
              ),
            ),
          ),
        ],
      ],
    );
  }

  Future<void> _pickAndUploadProfileImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _profileImage = File(pickedFile.path);
        _isUploadingProfileImage = true; // Set loading state
      });

      // Upload to Firebase Storage
      try {
        String fileName = 'profile_images/${DateTime.now().millisecondsSinceEpoch}';
        Reference storageRef = FirebaseStorage.instance.ref().child(fileName);

        UploadTask uploadTask = storageRef.putFile(_profileImage!);
        TaskSnapshot taskSnapshot = await uploadTask;

        // Get the download URL
        _profileImageUrl = await taskSnapshot.ref.getDownloadURL();

        //  ScaffoldMessenger.of(context).showSnackBar(
        //   const SnackBar(content: Text('Profilbild erfolgreich hochgeladen!')),
        // );
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Fehler beim Hochladen des Profilbildes: $e')),
          );
        }
      } finally {
        if (mounted) {
          setState(() {
            _isUploadingProfileImage = false; // Reset loading state
          });
        }
      }
    }  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: MyAppBar(
          title: 'PosiTeams',
          titleAlign: TextAlign.center,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, size: 30),
            onPressed: () {
              Navigator.of(context).pushReplacement(PageRouteBuilder(
                pageBuilder: (context, animation, secondaryAnimation) => const AuthPage(),
                transitionsBuilder: (context, animation, secondaryAnimation, child) {
                  const begin = Offset(-1.0, 0.0); // Slide from left to right
                  const end = Offset.zero;
                  const curve = Curves.easeInOut;

                  var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
                  var offsetAnimation = animation.drive(tween);

                  return SlideTransition(
                    position: offsetAnimation,
                    child: child,
                  );
                },
                transitionDuration: const Duration(milliseconds: 150), // Standard duration
              ));
            },
          ),
          actions: const [
            Opacity(
              opacity: 0,
              child: IconButton(
                icon: Icon(Icons.menu),
                onPressed: null,
              ),
            ),
          ],
          showBottomBorder: true,
        ),
        body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                Text(
                _currentStep == 0
                ? 'Anmeldedaten'
                      : _currentStep == 1
                  ? 'Persönliche Daten'
                      : 'Unternehmensdaten',
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w300,
                    fontFamily: 'futura Condensed',
                  ),
                ),
                const SizedBox(height: 16),

                if (_currentStep == 0) ...[
            _buildTextField(controller: _emailController, labelText: "Email"),
        _buildTextField(controller: _passwordController, labelText: "Passwort", obscureText: true),
        _buildTextField(controller: _confirmPasswordController, labelText: "Passwort bestätigen", obscureText: true),
        ],

                    if (_currentStep == 1) ...[
                      Center(
                        child: Stack(
                          alignment: Alignment.center, // Center everything inside the stack
                          children: [
                            // Circle for profile image or loading indicator
                            CircleAvatar(
                              radius: 100,
                              backgroundImage: _profileImage != null
                                  ? FileImage(_profileImage!)
                                  : const AssetImage('lib/assets/default_avatar.png') as ImageProvider,
                              backgroundColor: const Color.fromARGB(255, 229, 229, 229), // Grey background for default avatar
                            ),

                            // Show loading indicator when uploading
                            if (_isUploadingProfileImage)
                              const CircularProgressIndicator(
                                valueColor: AlwaysStoppedAnimation<Color>(Color.fromARGB(255, 7, 110, 23)), // Green loading circle
                              ),

                            // Show the icon button when no image is being uploaded
                            if (!_isUploadingProfileImage)
                              Positioned(
                                top: _profileImage == null ? 57 : 60,  // Higher when no image is selected
                                child: IconButton(
                                  icon: Icon(
                                    Icons.camera_alt,
                                    size: 60,
                                    color: _profileImage == null
                                        ? const Color.fromARGB(255, 7, 110, 23) // Green before selecting image
                                        : const Color.fromARGB(210, 255, 255, 255), // White after selecting image
                                  ),
                                  onPressed: _pickAndUploadProfileImage,
                                ),
                              ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Text fields for first name and last name
                      _buildTextField(controller: _firstNameController, labelText: "Vorname"),
                      _buildTextField(controller: _lastNameController, labelText: "Nachname"),
                    ],

                    if (_currentStep == 2) ...[
                      _buildTextField(controller: _companyIdController, labelText: "Firmenname"),
                      _buildTextField(controller: _departmentIdController, labelText: "Abteilung"),
                      _buildTextField(controller: _teamIdController, labelText: "Team"),
                    ],

                    const SizedBox(height: 28),

                    // Build the bottom buttons with Next and Back logic
                    _buildBottomButtons(
                      onNext: () async {
                        FocusScope.of(context).unfocus();  // Unfocus all input fields

                        if (_currentStep == 0) {
                          if (await _validateInitialFields()) {
                            setState(() {
                              _currentStep++;
                            });
                          }
                        } else if (_currentStep == 1) {
                          if (_validatePersonalFields()) {
                            setState(() {
                              _currentStep++;
                            });
                          }
                        } else if (_currentStep == 2) {
                          if (_validateCompanyFields()) {
                            _register(); // Register the user when on the final step
                          }
                        }
                      },
                      onBack: _currentStep > 0
                          ? () {
                        FocusScope.of(context).unfocus();  // Unfocus all input fields
                        setState(() {
                          _currentStep--;
                        });
                      }
                          : null, // Disable the back button on the first step
                    ),
                  ],
                ),
            ),
        ),
    );
  }
}