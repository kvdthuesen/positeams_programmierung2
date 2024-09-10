import 'package:flutter/material.dart';

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
      automaticallyImplyLeading: automaticallyImplyLeading,
      leading: leading, // using the leading parameter
      backgroundColor: Colors.white,
      title: Row(
        mainAxisAlignment: titleAlign == TextAlign.center ? MainAxisAlignment.center : MainAxisAlignment.start,
        children: [
          RichText(
            text: TextSpan(
              children: [
                TextSpan(
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
                  style: TextStyle(
                    fontFamily: 'futura Condensed',
                    fontSize: 32,
                    fontWeight: FontWeight.w500,
                    color: Colors.black,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      centerTitle: titleAlign == TextAlign.center, // centers the title if required
      actions: actions, // adds the icons on the right-hand side
      bottom: showBottomBorder
          ? PreferredSize( // divider - design
        preferredSize: Size.fromHeight(1.0),
        child: Container(
          color: Color.fromARGB(255, 229, 229, 229),
          height: 1.0, //
        ),
      )
          : null,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(56.0);
}

