import 'package:flutter/material.dart';
import 'package:positeams_programmierung2/components/appbar.dart';
import 'package:positeams_programmierung2/pages/main_screen.dart';

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
  String? _selectedShareOption; // Start with no selection

  @override
  void initState() {
    super.initState();
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
    super.build(context); // Ensure state is preserved with AutomaticKeepAliveClientMixin.

    return Scaffold(
      appBar: _buildAppBar(context),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildShareDropdown(),
            const SizedBox(height: 30),
            _buildPostInput(),
            const SizedBox(height: 20),
            const Divider(), // Horizontal divider
            const SizedBox(height: 5),
            _buildPreview(),
          ],
        ),
      ),
    );
  }

  // AppBar with close button and post button
  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return MyAppBar(
      title: 'PosiNews',
      titleAlign: TextAlign.center,
      leading: IconButton(
        icon: const Icon(Icons.close, size: 30),
        onPressed: () {
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
            onPressed: () {
              MainScreenState? mainScreenState = context.findAncestorStateOfType<MainScreenState>();
              if (mainScreenState != null) {
                mainScreenState.onItemTapped(3); // Switch to the Profile tab (index 3)
              }
            },
            style: ElevatedButton.styleFrom(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4.0)),
              backgroundColor: const Color.fromARGB(255, 7, 110, 23),
              padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 0.0), // Styling post button
              minimumSize: const Size(0, 30), // Minimum height post button!
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
      showBottomBorder: true,
    );
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
          onTap: () => _showPopupMenu(context),
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
                  _selectedShareOption ?? 'Auswählen',
                  style: TextStyle(
                    fontFamily: 'Futura',
                    fontSize: 16,
                    fontWeight: FontWeight.w300,
                    color: _selectedShareOption == null ? Colors.grey : Colors.black,
                  ),
                ),
                const Icon(Icons.arrow_drop_down, color: Colors.black),
              ],
            ),
          ),
        ),
      ],
    );
  }

  // Popup-Menü for "Teilen mit"-Options
  void _showPopupMenu(BuildContext context) {
    showMenu<String>(
      context: context,
      position: const RelativeRect.fromLTRB(242, 135, 1000, 0), // position of dropdown menu
      items: <PopupMenuEntry<String>>[
        _buildPopupMenuItem('Team'),
        _buildPopupMenuItem('Abteilung'),
        _buildPopupMenuItem('Firma'),
      ],
      color: Colors.white.withOpacity(0.95),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8.0),
      ),
    ).then((newValue) {
      if (newValue != null) {
        setState(() {
          _selectedShareOption = newValue;
        });
      }
    });
  }

  // Popup-Menu Item
  PopupMenuItem<String> _buildPopupMenuItem(String text) {
    return PopupMenuItem<String>(
      value: text,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              text,
              style: TextStyle(
                fontFamily: 'Futura',
                fontSize: 16,
                fontWeight: FontWeight.w300,
                color: _selectedShareOption == text ? Colors.black : Colors.grey,
              ),
            ),
            if (_selectedShareOption == text) const Icon(Icons.check, color: Colors.black),
          ],
        ),
      ),
    );
  }

  // Text input field for the post
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
            controller: _textController,
            minLines: 1,
            maxLines: null,
            decoration: InputDecoration(
              filled: true,
              fillColor: const Color.fromARGB(255, 229, 229, 229),
              hintText: 'Teile deinen Kolleg*innen deine PosiNews mit!',
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

  // Preview section for the post
  Widget _buildPreview() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Vorschau',
          style: TextStyle(fontSize: 20, fontFamily: 'Futura Condensed', color: Colors.grey),
        ),
        const SizedBox(height: 8),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const CircleAvatar(
              radius: 28,
              backgroundImage: AssetImage('lib/images/avatar.jpg'),
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
                          style: TextStyle(color: Colors.grey, fontFamily: 'Futura', fontSize: 15),
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
                        style: const TextStyle(fontSize: 14, color: Colors.grey, fontFamily: 'Futura'),
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
                              style: TextStyle(fontSize: 16, color: Colors.grey, fontFamily: 'Futura'),
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
    );
  }
}






