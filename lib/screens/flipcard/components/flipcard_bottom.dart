import 'package:flutter/material.dart';
import 'package:shop_app/screens/flipcard/components/buildTerm.dart';

class Bottom extends StatelessWidget {
  Bottom({
    Key? key,
    required this.vocabularies,
    required this.currentPage,
  }) : super(key: key);

  final int currentPage;
  final List<dynamic> vocabularies;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Text(
                'Terms',
                style: TextStyle(
                    fontSize: 17, fontWeight: FontWeight.w800, color: Colors.black),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Icon(Icons.sort),
            )
          ],
        ),
        SizedBox(
          height: 250,
          width: double.infinity,
          child: PageView.builder(
            scrollDirection: Axis.vertical,
            itemCount: vocabularies.length,
            itemBuilder: (context, index) {
              return CreateTerm(vocabularies[index]["englishWord"]);
            },
          ),
        ),

        // CreateTerm("Your Text Here"),
        // CreateTerm("Your Text Here"),
        // CreateTerm("DEF"),
        // CreateTerm("Your Text Here"),

        const SizedBox(height: 20),
      ],
    );
  }
}
