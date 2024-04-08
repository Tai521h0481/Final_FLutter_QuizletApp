import 'package:flutter/material.dart';
import 'package:shop_app/screens/folders/folders_screen.dart';
import 'package:shop_app/screens/home/components/special_folders.dart';

class SpecialFolderFactory {
  static Widget createList({
    required Map<String, dynamic> filteredFolders,
    required BuildContext context,
    required String image,
    required String name,
  }) {
    return SpecialFolder(
      image: image,
      title: filteredFolders["folderNameEnglish"] ?? '',
      words: filteredFolders["topicCount"] ?? 0,
      name: name,
      sets: filteredFolders["topicCount"] ?? 0,
      press: () {
        Navigator.pushNamed(
          context,
          FolderScreen.routeName,
          arguments: {
            'folderID': filteredFolders["_id"],
            'title': filteredFolders["folderNameEnglish"],
            'username': name,
            'image': image,
            'sets': filteredFolders["topicCount"],
          },
        );
      },
    );
  }
}
