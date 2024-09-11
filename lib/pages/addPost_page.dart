import 'package:flutter/material.dart';
import 'package:positeams_programmierung2/components/appbar.dart'; // Import custom app bar component
import 'package:positeams_programmierung2/pages/main_screen.dart'; // Import main screen to navigate back to the correct tab

/// AddPost page where users can create and preview new posts.
/// This page retains its state during tab switching using StatefulWidget.
class AddPost extends StatefulWidget {
  final int previousIndex; // Stores the index of the previous page (to return after closing)

  // Constructor accepts an optional `previousIndex` parameter (default is 0).
  // This parameter is used to return to the previously selected tab when navigating back.
  const AddPost({super.key, this.previousIndex = 0});

  @override
  _AddPostState createState() => _AddPostState();
}

// _AddPostState manages the state for AddPost
class _AddPostState extends State<AddPost> with AutomaticKeepAliveClientMixin {

  /// Ensures that the state of this page (e.g., form input, dropdown selection) is preserved.
  @override
  bool get wantKeepAlive => true;

  // TextEditingController to manage the text input
  final TextEditingController _textController = TextEditingController();
  // ValueNotifier to notify listeners about text changes
  final ValueNotifier<String> _textNotifier = ValueNotifier<String>('');

  @override
  void initState() {
    super.initState();
    // Listener to update _textNotifier when _textController text changes
    _textController.addListener(() {
      _textNotifier.value = _textController.text;
    });
  }

  @override
  void dispose() {
    _textController.dispose();
    _textNotifier.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context); // Ensures the AutomaticKeepAliveClientMixin works.

    return Scaffold(
      // Custom AppBar with centered title and close action
      appBar: MyAppBar(
        title: 'PosiNews', // Custom app bar title
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
                    borderRadius: BorderRadius.circular(4.0),
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
        showBottomBorder: true, // Divider
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start, // Aligns children to the start
          children: [
            // DropdownButtonFormField for post sharing options
            Row(
              crossAxisAlignment: CrossAxisAlignment.center, // Center vertically
              children: [
                const Text(
                  'Teilen mit:',
                  style: TextStyle(
                    fontSize: 20,
                    fontFamily: 'Futura Condensed',
                  ),
                ),
                const SizedBox(width: 28),
                SizedBox(
                  width: 300,
                  height: 40,
                  child: DropdownButtonFormField<String>(
                    decoration: InputDecoration(
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5.0),
                        borderSide: const BorderSide(
                          color: Color.fromARGB(255, 7, 110, 23),
                          width: 1.0,
                        ),
                      ),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                    ),
                    dropdownColor: Colors.white,
                    isDense: true, // Compact dropdown
                    items: <String>[
                      'Mein PosiTeam',
                      'Meine PosiFirma',
                      'Ausgewählte PosiKolleg*innen'
                    ].map((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(
                          value,
                          style: const TextStyle(
                            fontFamily: 'Futura Condensed',
                            fontSize: 20,
                            height: 1.2, // Adjusts text height
                            fontWeight: FontWeight.w500,
                            color: Colors.black,
                          ),
                        ),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      // Handle selection change
                    },
                    hint: const Text(
                      'Bitte auswählen',
                      style: TextStyle(
                        color: Color.fromARGB(255, 7, 110, 23),
                        fontFamily: 'Futura Condensed',
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
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
                    controller: _textController,
                    minLines: 1, // Minimum number of lines
                    maxLines: null, // Expands as needed
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: const Color.fromARGB(255, 229, 229, 229),
                      hintText: 'Teile deinen Kolleg*innen deine PosiNews mit!',
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
            const Divider(), // Horizontal divider

            // Preview section for the post
            const SizedBox(height: 5),
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
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const CircleAvatar(
                  radius: 28, // Matches the Post class
                  backgroundImage: AssetImage('lib/images/avatar.jpg'), // Placeholder avatar image
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      RichText(
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
                                fontSize: 15,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 8),
                      ValueListenableBuilder<String>(
                        valueListenable: _textNotifier,
                        builder: (context, text, child) {
                          return Text(
                            text.isEmpty
                                ? 'Hier werden dein News Text angezeigt. Klasse. Toll. Wuhuu. Erfolge. Projekte  '
                                : text,
                            style: const TextStyle(
                              fontSize: 14,
                              color: Colors.grey,
                              fontFamily: 'Futura',
                            ),
                          );
                        },
                      ),
                      const SizedBox(height: 16),
                      GestureDetector(
                        onTap: () {
                          // Placeholder for adding image functionality
                        },
                        child: AspectRatio(
                          aspectRatio: 21 / 9,
                          child: Container(
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
                                    color: Colors.grey,
                                    fontFamily: 'Futura',
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
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
