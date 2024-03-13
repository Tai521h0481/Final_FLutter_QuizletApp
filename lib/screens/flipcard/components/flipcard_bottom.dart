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
        const Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
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
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: vocabularies.length,
          itemBuilder: (context, index) {
            return CreateTerm(vocabularies[index]["englishWord"]);
          },
        ),
        const SizedBox(height: 20),
      ],
    );
  }
}
