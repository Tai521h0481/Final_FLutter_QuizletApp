import 'package:flutter/material.dart';

class ProfilePic extends StatelessWidget {
  final String profileImageUrl;
  const ProfilePic({Key? key, required this.profileImageUrl}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 115,
      width: 115,
      child: Stack(
        fit: StackFit.expand,
        clipBehavior: Clip.none,
        children: [
          CircleAvatar(
            backgroundImage: NetworkImage(profileImageUrl),
          ),
        ],
      ),
    );
  }
}
