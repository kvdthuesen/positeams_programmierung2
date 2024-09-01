import 'package:flutter/material.dart';
import 'package:positeams_programmierung2/components/post.dart';
import 'package:positeams_programmierung2/components/navigationbar.dart';
import 'package:positeams_programmierung2/components/appbar.dart';


class Homepage extends StatelessWidget {
  const Homepage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar( // certain customization of the app bar class
        title: 'PosiTeams',
        titleAlign: TextAlign.left,
        actions: [
          IconButton(
            icon: Icon(Icons.swap_vert, size: 35),
            onPressed: () {},
          ),
          Padding(
            padding: EdgeInsets.only(right: 12.0),
            child: IconButton(
              icon: Icon(Icons.filter_list, size: 35),
              onPressed: () {},
            ),
          ),
        ],
      ),
      body: ListView(
        children: const [
          SizedBox(height: 8),
          Post(),
          Post(),
          Post(),
          Post(),
        ],
      ),
      bottomNavigationBar: const MyNavigationBar(currentIndex: 0),
    );
  }
}