import 'package:flutter/material.dart';

class TermDefinitionContainer extends StatelessWidget {
  final String subFirst;
  final String subSecond;
  final FocusNode focusNode1;
  final FocusNode focusNode2;

  const TermDefinitionContainer({
    Key? key,
    required this.subFirst,
    required this.subSecond,
    required this.focusNode1,
    required this.focusNode2,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: 10),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.2),
                spreadRadius: 5,
                blurRadius: 7,
                offset: Offset(0, 3),
              ),
            ],
          ),
          child: Column(
            children: [
              _buildField('', subFirst, focusNode1),
              SizedBox(height: 10),
              _buildField('', subSecond, focusNode2),
              SizedBox(height: 30),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildField(String hint, String subTitle, FocusNode focusNode) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextFormField(
            decoration: InputDecoration(
              hintText: hint,
              contentPadding: const EdgeInsets.only(bottom: -5, top: 6),
              enabledBorder: const UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.black, width: 1.5),
              ),
              focusedBorder: const UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.black, width: 4.0),
              ),
              hintStyle: const TextStyle(
                fontSize: 20,
                color: Color.fromARGB(255, 179, 179, 179),
              ),
            ),
            focusNode: focusNode,
          ),
          Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Text(
              subTitle,
              style: const TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.bold,
                color: Color.fromARGB(255, 132, 131, 131),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
