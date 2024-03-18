import 'package:flutter/material.dart';

class DescriptionFieldWidget extends StatelessWidget {
  final FocusNode focusNode;
  final bool showDescription;
  final VoidCallback toggleDescription;

  const DescriptionFieldWidget({
    Key? key,
    required this.focusNode,
    required this.showDescription,
    required this.toggleDescription,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (!showDescription)
          Align(
            alignment: Alignment.topRight,
            child: TextButton(
              onPressed: toggleDescription,
              child: const Text('+ Description', style: TextStyle(fontWeight: FontWeight.bold)),
            ),
          ),
        if (showDescription)
          _buildField("What's your set about", "Description", focusNode),
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
