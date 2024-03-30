import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class QuizOption extends StatelessWidget {
  final String text;
  final Color color;
  final VoidCallback onTap;

  const QuizOption(
      {Key? key, required this.text, required this.color, required this.onTap})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.all(10),
        decoration: BoxDecoration(
          shape: BoxShape.rectangle,
          color: color,
          borderRadius: BorderRadius.circular(10),
        ),
        height: 50,
        width: MediaQuery.of(context).size.width / 2.5,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Center(
            child: Text(
              textAlign: TextAlign.center,
              text,
              style: TextStyle(color: Colors.white, fontWeight: FontWeight.w500),
            ),
          ),
        ),
      ),
    );
  }
}