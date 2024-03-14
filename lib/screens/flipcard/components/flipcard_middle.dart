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
            title,
            style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.grey.shade700),
          ),
        ),
        listTile,
        const SizedBox(height: 10),
        ListView(
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          children: <Widget>[
            buildListTile(Icons.copy_all, 'Flashcards',
                 const Color(0xFF3F56FF)),
            buildListTile(
                Icons.school, 'Learn', const Color(0xFF3F56FF)),
            buildListTile(Icons.check_circle, 'Test',
                const Color(0xFF3F56FF)),
            buildListTile(
                Icons.layers, 'Match', const Color(0xFF3F56FF)),
          ],
        ),
      ],
    );
  }

  Widget buildListTile(IconData icon, String title, Color iconColor) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 2,
            blurRadius: 4,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: ListTile(
        leading: Icon(icon, color: iconColor),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        onTap: () {},
      ),
    );
  }
}
