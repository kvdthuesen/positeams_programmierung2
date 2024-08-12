import 'package:flutter/material.dart';
import 'package:positeams_programmierung2/pages/home_page.dart';

class AddPost extends StatelessWidget {
  const AddPost({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //appBar
      appBar: AppBar(
        centerTitle: true,
        title: RichText(
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
                text: 'News',
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
        leading: IconButton(
          icon: Icon(Icons.close, size: 30),
          onPressed: () {
            Navigator.pushReplacement( // push-replacement to turn back to Homepage
              context,
              MaterialPageRoute(builder: (context) => const Homepage()),
            );
          },
        ),
        actions: [ // posten Button
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: SizedBox(
              height: 32,
              child: ElevatedButton(
                onPressed: () {
                  print("Posten");
                },
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  backgroundColor: Color.fromARGB(255, 7, 110, 23),
                  padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 0.0),
                ),
                child: Text(
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
        bottom: PreferredSize( // divider
          preferredSize: Size.fromHeight(1.0),
          child: Container(
            color: Color.fromARGB(255, 229, 229, 229),
            height: 1.0,
          ),
        ),
      ),

      // body
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start, //start with "Teilen mit"
          children: [
            Row(
              children: [
                Text(
                  'Teilen mit:',
                  style: TextStyle(
                    fontSize: 20,
                    fontFamily: 'Futura Condensed',
                  ),
                ),
                SizedBox(width: 20),
                SizedBox(
                  width: 300,
                  height: 30,
                  child: DropdownButtonFormField<String>( //Dropdown
                    decoration: InputDecoration(
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5.0),
                        borderSide: BorderSide(
                          color: Color.fromARGB(255, 7, 110, 23),
                          width: 2.0,
                        ),
                      ),
                      contentPadding: EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    ),
                    items: <String>['Mein PosiTeam', 'Meine PosiFirma', 'Ausgewählte PosiKollegen'].map((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(
                          value,
                          style: TextStyle(
                            fontFamily: 'futura Condensed',
                            fontSize: 20,
                            fontWeight: FontWeight.w500,
                            color: Colors.black,
                          ),
                        ),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {},
                    hint: Text(
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
            SizedBox(height: 30),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Text:',
                  style: TextStyle(
                    fontSize: 20,
                    fontFamily: 'Futura Condensed',
                  ),
                ),
                SizedBox(width: 20),
                Expanded(
                  child: TextField(
                    maxLines: 5,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Color.fromARGB(255, 229, 229, 229),
                      hintText: 'Schreibe hier deine News, Erfolge oder andere positiven Erlebnisse hin',
                      hintStyle: TextStyle(
                        fontFamily: 'Futura',
                      ),
                      border: OutlineInputBorder(),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5.0),
                        borderSide: BorderSide(
                          color: Color.fromARGB(255, 7, 110, 23),
                          width: 2.0,
                        ),
                      ),
                    ),
                    style: TextStyle(
                      fontFamily: 'Futura',
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),
            Container(
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color: Colors.grey,
                    width: 0.5,
                  ),
                ),
              ),
            ),
            SizedBox(height: 12),
            Text(
              'Vorschau',
              style: TextStyle(
                fontSize: 20,
                fontFamily: 'Futura Condensed',
                color: Colors.grey,
              ),
            ),
            SizedBox(height: 8),
            Row(
              children: [
                CircleAvatar(
                  radius: 24,
                  backgroundImage: AssetImage('lib/images/avatar.jpg'),
                ),
                SizedBox(width: 8),
                Expanded(
                  child: RichText(
                    text: TextSpan(
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
            SizedBox(height: 25),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                GestureDetector(
                  onTap: () {

                  },
                  child: Container(
                    width: 350,
                    height: 150,
                    decoration: BoxDecoration(
                      color: Color.fromARGB(26, 0, 0, 0),
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
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
