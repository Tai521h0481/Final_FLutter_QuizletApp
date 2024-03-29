import 'package:flutter/material.dart';
import 'package:shop_app/screens/flashcard/flashcard_screen.dart';
import 'package:shop_app/screens/quiz/quiz_page_screen.dart';

class Middle extends StatelessWidget {
  final Widget listTile;
  final String title, description, topicId;
  final List<dynamic> vocabularies;
  Middle(
      {required this.listTile,
      required this.title,
      required this.description,
      required this.topicId,
      required this.vocabularies});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Text(
            title,
            style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w900,
                color: Colors.black,
                fontFamily: 'Roboto'),
          ),
        ),
        listTile,
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Text(
            description,
            style: TextStyle(
                fontSize: 15, color: Colors.grey, fontFamily: 'Roboto'),
          ),
        ),
        const SizedBox(height: 10),
        ListView(
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          children: <Widget>[
            buildListTile(Icons.copy_all, 'Flashcards', const Color(0xFF3F56FF),
                onTap: () {
              Navigator.pushNamed(
                context,
                FlashcardsView.routeName,
                arguments: {"vocabularies": vocabularies, "topicId": topicId},
              );
            }),
            buildListTile(
              Icons.school,
              'Learn',
              const Color(0xFF3F56FF),
              onTap: () {
                Navigator.pushNamed(
                  context,
                  QuizPage.routeName,
                  arguments: {"vocabularies": vocabularies, "topicId": topicId},
                );
              },
            ),
            buildListTile(Icons.check_circle, 'Test', const Color(0xFF3F56FF)),
            buildListTile(Icons.layers, 'Match', const Color(0xFF3F56FF)),
          ],
        ),
      ],
    );
  }

  Widget buildListTile(IconData icon, String title, Color iconColor,
      {Function()? onTap}) {
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
        onTap: onTap,
      ),
    );
  }
}
