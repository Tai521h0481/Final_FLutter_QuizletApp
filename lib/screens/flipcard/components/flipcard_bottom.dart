import 'package:flutter/material.dart';
import 'package:shop_app/screens/flipcard/components/buildTerm.dart';

class Bottom extends StatelessWidget {
  const Bottom({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: Text(
            'Terms',
            style: TextStyle(
                fontSize: 17, fontWeight: FontWeight.w800, color: Colors.black),
          ),
        ),
        CreateTerm("Your Text Here"),
        CreateTerm("Your Text Here"),
        CreateTerm("DEF"),
        CreateTerm("Your Text Here"),

        SizedBox(height: 20),
      ],
    );
  }
}
