import 'package:flutter/material.dart';
import 'package:positeams_programmierung2/components/appbar.dart'; // Import custom app bar component
import 'package:positeams_programmierung2/pages/main_screen.dart'; // Import main screen to navigate back to the correct tab

class AddPost extends StatefulWidget {
  final int previousIndex; // Stores the index of the previous page (to return after closing)

  // Constructor accepts an optional `previousIndex` parameter (default is 0).
  // This parameter is used to return to the previously selected tab when navigating back.
  const AddPost({super.key, this.previousIndex = 0});

  @override
  _AddPostState createState() => _AddPostState();
}

class _AddPostState extends State<AddPost> with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context); // Ensures the state is kept alive during navigation.

    return Scaffold(
      // Custom AppBar with centered title and close action
      appBar: MyAppBar(
        title: 'PosiNews',
        titleAlign: TextAlign.center,
        leading: IconButton(
          icon: const Icon(Icons.close, size: 30),
          onPressed: () {
            // Get access to MainScreenState and switch back to the previous tab
            MainScreenState? mainScreenState = context.findAncestorStateOfType<MainScreenState>();

            // If MainScreenState is available, switch to the previous tab
            if (mainScreenState != null && widget.previousIndex != mainScreenState.currentIndex) {
              mainScreenState.onItemTapped(widget.previousIndex); // Switch to the previous tab
            }
          },
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: SizedBox(
              height: 32,
              child: ElevatedButton(
                  onPressed: () {
                    // Instead of navigating to a new screen, simply switch the tab in MainScreenState
                    MainScreenState? mainScreenState = context.findAncestorStateOfType<MainScreenState>();

                    // Check if MainScreenState exists in the widget tree
                    if (mainScreenState != null) {
                      mainScreenState.onItemTapped(3); // Switch to the Profile tab (index 3)
                    }
                  },
                  style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  backgroundColor: const Color.fromARGB(255, 7, 110, 23),
                  padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 0.0),
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
          ),
        ],
        showBottomBorder: true,
      ),

      // Body with form input fields and a preview section
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start, // Aligns the text to the start
          children: [
            // Dropdown for selecting who to share the post with
            Row(
              children: [
                const Text(
                  'Teilen mit:',
                  style: TextStyle(
                    fontSize: 20,
                    fontFamily: 'Futura Condensed',
                  ),
                ),
                const SizedBox(width: 20),
                SizedBox(
                  width: 300,
                  height: 30,
                  child: DropdownButtonFormField<String>(
                    decoration: InputDecoration(
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5.0),
                        borderSide: const BorderSide(
                          color: Color.fromARGB(255, 7, 110, 23),
                          width: 2.0,
                        ),
                      ),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    ),
                    items: <String>[
                      'Mein PosiTeam',
                      'Meine PosiFirma',
                      'Ausgewählte PosiKollegen'
                    ].map((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(
                          value,
                          style: const TextStyle(
                            fontFamily: 'futura Condensed',
                            fontSize: 20,
                            fontWeight: FontWeight.w500,
                            color: Colors.black,
                          ),
                        ),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      // Handle dropdown selection change
                    },
                    hint: const Text(
                      'Bitte auswählen (Dropdown)',
                      style: TextStyle(
                        color: Color.fromARGB(255, 7, 110, 23),
                        fontFamily: 'Futura',
                        fontStyle: FontStyle.italic,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 30),

            // Input field for writing the post
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Text:',
                  style: TextStyle(
                    fontSize: 20,
                    fontFamily: 'Futura Condensed',
                  ),
                ),
                const SizedBox(width: 20),
                Expanded(
                  child: TextField(
                    maxLines: 5,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: const Color.fromARGB(255, 229, 229, 229),
                      hintText: 'Schreibe hier deine News, Erfolge oder andere positiven Erlebnisse hin',
                      hintStyle: const TextStyle(
                        fontFamily: 'Futura',
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
                    style: const TextStyle(
                      fontFamily: 'Futura',
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 20),
            const Divider(), // Adds a horizontal divider

            // Preview section showing how the post will appear
            const SizedBox(height: 12),
            const Text(
              'Vorschau',
              style: TextStyle(
                fontSize: 20,
                fontFamily: 'Futura Condensed',
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                const CircleAvatar(
                  radius: 24,
                  backgroundImage: AssetImage('lib/images/avatar.jpg'), // Example avatar
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: RichText(
                    text: const TextSpan(
                      children: [
                        TextSpan(
                          text: 'Maya ',
                          style: TextStyle(
                            fontFamily: 'Futura',
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                            color: Colors.black,
                          ),
                        ),
                        TextSpan(
                          text: '- Team Data Science (Business Intelligence)',
                          style: TextStyle(
                            color: Colors.grey,
                            fontFamily: 'Futura',
                          ),
                        ),
                        TextSpan(
                          text: '    Hier werden deine News angezeigt.',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey,
                            fontFamily: 'Futura',
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 25),
            // Section to add an image to the post
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                GestureDetector(
                  onTap: () {
                    // Placeholder for adding image
                  },
                  child: Container(
                    width: 350,
                    height: 150,
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(26, 0, 0, 0),
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Icon(Icons.add, size: 40, color: Colors.black),
                        SizedBox(height: 8),
                        Text(
                          'Bild hinzufügen',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.black,
                            fontFamily: 'Futura',
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}