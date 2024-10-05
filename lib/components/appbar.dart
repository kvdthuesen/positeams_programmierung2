import 'package:flutter/material.dart';

//Custom AppBar with the following configurations
class MyAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final TextAlign titleAlign;
  final List<Widget>? actions;
  final bool showBottomBorder;
  final bool automaticallyImplyLeading;
  final Widget? leading;

  const MyAppBar({
    super.key,  // Calls the superclass constructor to initialize the widget's key
    required this.title,  // Requires a title to be passed for the AppBar
    this.titleAlign = TextAlign.left,  // optional: Aligns the title, default is left
    this.actions,  // optional: List of widgets displayed on the right side of the AppBar
    this.showBottomBorder = true,  // optional: Shows a bottom border if true (default)
    this.automaticallyImplyLeading = true,  // optional: Automatically shows a back button if true (default)
    this.leading, // adjusts the automaticallyImplyLeading - insert any widgets
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: false, // removes the back button
      leading: leading, // Enables the use of a custom widget on the left-hand side
      backgroundColor: Colors.white,
      title: Row(
        mainAxisAlignment: titleAlign == TextAlign.center ? MainAxisAlignment.center : MainAxisAlignment.start,
        children: [
          _buildTitleText(), // Call the method to build the RichText widget
        ],
      ),
      centerTitle: titleAlign == TextAlign.center, // centers the title if required
      actions: actions, // adds the icons on the right-hand side
      bottom: showBottomBorder
          ? PreferredSize( // divider - design
        preferredSize: const Size.fromHeight(1.0),
        child: Container(
          color: const Color.fromARGB(255, 229, 229, 229),
          height: 1.0,
        ),
      )
          : null,
    );
  }

  // Method to create the RichText widget for the title
  Widget _buildTitleText() {
    return RichText(
      // Creates RichText widget that combines several text styles in a single text widget
      text: TextSpan(
        children: [
          const TextSpan(
            text: 'Posi',
            style: TextStyle(
              fontFamily: 'futura Condensed',
              fontSize: 32,
              fontWeight: FontWeight.w500,
              color: Color.fromARGB(255, 7, 110, 23),
            ),
          ),
          TextSpan(
            text: title.replaceFirst('Posi', ''),
            style: const TextStyle(
              fontFamily: 'futura Condensed',
              fontSize: 32,
              fontWeight: FontWeight.w500,
              color: Colors.black,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(56.0); // specifies the preferred height of the AppBar
}
