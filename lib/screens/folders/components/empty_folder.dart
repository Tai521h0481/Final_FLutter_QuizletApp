import 'package:flutter/material.dart';

class EmptyFolder extends StatelessWidget {
  const EmptyFolder({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(16.0), // Add margin
      padding: EdgeInsets.all(16.0), // Add padding
      decoration: BoxDecoration(
        color: Colors.white, // Set the background color to white
        borderRadius: BorderRadius.circular(12.0), // Rounded corners
        boxShadow: [ // Apply shadow
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 1,
            blurRadius: 3,
            offset: Offset(0, 3), // changes position of shadow
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min, // To wrap content in the column
        children: [
          Text(
            'This folder has no sets',
            style: TextStyle(
              fontSize: 18.0, // Set font size
              fontWeight: FontWeight.bold, // Set font weight
            ),
          ),
          SizedBox(height: 8.0), // Spacing between text and subtitle
          Text(
            'Organize your study sets by adding them to this folder.',
            textAlign: TextAlign.center, // Center align text
            style: TextStyle(
              fontSize: 16.0, // Set font size
              color: Colors.grey, // Set font color
            ),
          ),
          SizedBox(height: 24.0), // Spacing between text and button
          ElevatedButton(
            onPressed: () {
              // Add set action
            },
            child: Text('Add a set'),
            style: ElevatedButton.styleFrom(
              primary: Colors.blue, // Set background color of the button
              onPrimary: Colors.white, // Set text color of the button
              padding: EdgeInsets.symmetric(horizontal: 32.0, vertical: 16.0), // Button padding
            ),
          ),
        ],
      ),
    );
  }
}
