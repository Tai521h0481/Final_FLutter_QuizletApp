import 'package:flutter/material.dart';

class StudySets extends StatelessWidget {
  const StudySets({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: 10,
      itemBuilder: (BuildContext context, int index) {
        return ListTile(
          title: Text('Study set $index'),
          onTap: () {},
        );
      },
    );
  }
}
