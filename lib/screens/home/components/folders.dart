import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get_connect/http/src/utils/utils.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shop_app/controllers/folder.dart';
import 'package:shop_app/screens/folders/components/topic_in_folder.dart';
import 'package:shop_app/screens/folders/folders_screen.dart';
import 'package:shop_app/screens/home/components/special_folders.dart';

import 'section_title.dart';

class Folders extends StatefulWidget {
  const Folders({super.key});

  @override
  State<Folders> createState() => _PopularProductsState();
}

class _PopularProductsState extends State<Folders> {
  List<dynamic> folders = [];
  Map<String, dynamic> userInfo = {};

  @override
  void initState() {
    super.initState();
    loadFolder();
  }

  Future<void> loadFolder() async {
    final prefs = await SharedPreferences.getInstance();
    String token = prefs.getString('token') ?? '';
    String dataString = prefs.getString('data') ?? '';
    if (token.isEmpty) {
      print('Token is empty. Cannot load topics.');
      return;
    }

    try {
      userInfo = json.decode(dataString);
      var res = await getFolderByID(userInfo["_id"], token);
      setState(() {
        folders = res['folders'] ?? [];
      });
    } catch (e) {
      print('Exception occurred while loading topics: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    var image = userInfo["profileImage"] ?? '';
    var name = userInfo["username"] ?? '';
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: SectionTitle(
            title: "Folders",
            press: () {
              
            },
          ),
        ),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: List.generate(
              folders.length,
              (index) => SpecialFolder(
                image: image,
                title: folders[index]["folderNameEnglish"] ?? '',
                words: folders[index]["topicCount"] ?? 0,
                name: name,
                sets: folders[index]["topicCount"] ?? 0,
                press: () {
                  Navigator.pushNamed(
                    context,
                    FolderScreen.routeName,
                    arguments: {
                      'folderID': folders[index]["_id"],
                      'title': folders[index]["folderNameEnglish"],
                      'username' : name,
                      'image' : "$image",
                      'sets': folders[index]["topicCount"]
                    },
                  );
                },
              ),
            ),
          ),
        ),
      ],
    );
  }
}
