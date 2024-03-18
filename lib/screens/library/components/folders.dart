import 'package:flutter/material.dart';

class Folders extends StatelessWidget {
  const Folders({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: 10,
      itemBuilder: (BuildContext context, int index) {
        return ListTile(
          title: Text('Folder $index'),
          onTap: () {},
        );
      },
    );
  }
}
