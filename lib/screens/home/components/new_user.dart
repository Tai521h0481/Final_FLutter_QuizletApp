import 'package:flutter/material.dart';
import 'package:shop_app/screens/studyset/studyset_screen.dart';

class NewUser extends StatelessWidget {
  const NewUser({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(
          height: 20,
        ),
        const Text(
          "Here's how to get started",
          style: TextStyle(
            fontFamily: 'Muli',
            fontSize: 20,
            fontWeight: FontWeight.w900,
          ),
        ),
        const SizedBox(height: 20),
        InkWell(
          onTap: () {
            Navigator.pushNamed(context, StudySetScreen.routeName);
          },
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(color: Colors.blue, width: 1),
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.add, color: Colors.blue),
                SizedBox(width: 10),
                Text(
                  "Create your own flashcards",
                  style: TextStyle(color: Colors.blue, fontSize: 17),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
