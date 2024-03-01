import 'package:flutter/material.dart';

class Middle extends StatelessWidget {
  final Widget listTile;
  final String title;
  Middle({required this.listTile, required this.title});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: Text(
            'Title',
            style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.grey.shade700),
          ),
        ),
        listTile,
        SizedBox(height: 10),
        ListView(
          physics: NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          children: <Widget>[
            buildListTile(
                Icons.copy_all, 'Flashcards', Color.fromARGB(255, 91, 25, 184)),
            buildListTile(
                Icons.school, 'Learn', Color.fromARGB(255, 91, 25, 184)),
            buildListTile(
                Icons.check_circle, 'Test', Color.fromARGB(255, 91, 25, 184)),
            buildListTile(
                Icons.layers, 'Match', Color.fromARGB(255, 91, 25, 184)),
          ],
        ),
      ],
    );
  }

  Widget buildListTile(IconData icon, String title, Color iconColor) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 2,
            blurRadius: 4,
            offset: Offset(0, 3), // changes position of shadow
          ),
        ],
      ),
      child: ListTile(
        leading: Icon(icon, color: iconColor),
        title: Text(title, style: TextStyle(fontWeight: FontWeight.bold)),
        onTap: () {},
      ),
    );
  }
}
