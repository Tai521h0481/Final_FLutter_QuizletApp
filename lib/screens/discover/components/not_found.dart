import 'package:flutter/material.dart';

class NotFound extends StatelessWidget {
  const NotFound({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.error,
            size: 100,
            color: Colors.grey,
          ),
          Text('Not found'),
        ],
      ),
    );
  }
}
