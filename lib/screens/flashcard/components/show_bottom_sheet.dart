import 'package:flutter/material.dart';

void showCustomModalBottomSheet(BuildContext context, Function(bool, bool, String) callback) {
  String selectedFont = 'Term';
  bool shuffle = false;
  bool playAudio = false;

  showModalBottomSheet(
    context: context,
    builder: (BuildContext context) {
      return StatefulBuilder(
        builder: (BuildContext context, StateSetter setState) {
          return Container(
            width: double.infinity,
            padding: EdgeInsets.only(top: 24.0, left: 16.0, right: 16.0, bottom: 16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Text(
                  'Options',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 24.0,
                  ),
                ),
                SizedBox(height: 20),
                SwitchListTile(
                  title: Text('Shuffle'),
                  value: shuffle,
                  onChanged: (bool value) {
                    setState(() {
                      shuffle = value;
                    });
                    callback(value, playAudio, selectedFont);
                  },
                  secondary: Icon(Icons.shuffle),
                ),
                SwitchListTile(
                  title: Text('Play audio'),
                  value: playAudio,
                  onChanged: (bool value) {
                    setState(() {
                      playAudio = value;
                    });
                    callback(shuffle, value, selectedFont);
                  },
                  secondary: Icon(Icons.audiotrack),
                ),
                SizedBox(height: 20),
                Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Icon(Icons.font_download_rounded),
                      Text(
                        'Font: ',
                        style: TextStyle(fontSize: 20),
                      ),
                      SizedBox(
                        width: 20,
                      ),
                      DropdownButton<String>(
                        value: selectedFont,
                        onChanged: (String? newValue) {
                          // Update the selectedFont when dropdown value changes
                          if (newValue != null) {
                            setState(() {
                              selectedFont = newValue;
                            });
                            callback(shuffle, playAudio, selectedFont); // Gọi hàm callback với thay đổi của Font
                          }
                        },
                        items: <String>['Term', 'Definition'].map((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  child: Text('Restart Flashcards'),
                  onPressed: () {
                    setState(() {
                      shuffle = false;
                      playAudio = false;
                      selectedFont = 'Term';
                    });
                    callback(false, false, 'Term'); // Gọi hàm callback khi nhấn nút Restart Flashcards
                    Navigator.pop(context);
                  },
                ),
              ],
            ),
          );
        },
      );
    },
  );
}
