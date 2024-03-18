import 'package:flutter/material.dart';

import '../../../constants.dart';

class SearchField extends StatelessWidget {
  final Function(String)? onChanged;

  const SearchField({
    Key? key,
    this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(25),
      ),
      child: Form(
        child: TextFormField(
          onChanged: onChanged,
          decoration: InputDecoration(
              filled: true,
              fillColor: kSecondaryColor.withOpacity(0.1),
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              border: searchOutlineInputBorder,
              focusedBorder: searchOutlineInputBorder,
              enabledBorder: searchOutlineInputBorder,
              hintText: "Topic, Folder",
              hintStyle: TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
              prefixIcon: const Icon(Icons.search),
              suffixIcon: Icon(Icons.camera_alt_outlined)),
        ),
      ),
    );
  }
}

const searchOutlineInputBorder = OutlineInputBorder(
  borderRadius: BorderRadius.all(Radius.circular(12)),
  borderSide: BorderSide.none,
);
