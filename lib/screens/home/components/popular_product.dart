import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shop_app/controllers/folder.dart';
import 'package:shop_app/screens/home/components/special_folders.dart';

import '../../products/products_screen.dart';
import 'section_title.dart';

class PopularProducts extends StatefulWidget {
  const PopularProducts({super.key});

  @override
  State<PopularProducts> createState() => _PopularProductsState();
}

class _PopularProductsState extends State<PopularProducts> {
  List<dynamic> folders = [];

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
      final Map<String, dynamic> data = json.decode(dataString);
      var res = await getFolderByID(data["_id"], token);
      setState(() {
        folders = res['folders'] ?? [];
      });
    } catch (e) {
      print('Exception occurred while loading topics: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: SectionTitle(
            title: "Folders",
            press: () {
              Navigator.pushNamed(context, ProductsScreen.routeName);
            },
          ),
        ),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: List.generate(
              folders.length,
              (index) => SectionTitle(
                title: folders[index]['folderNameEnglish'],
                press: () {
                  // Navigator.pushNamed(
                  //   context,
                  //   FlipCardScreen.routeName,
                  //   arguments: topics[index]["_id"],
                  // );
                },
              ),
            ),
            // children: [
            //   SpecialFolder(
            //     image:
            //         "https://s.gravatar.com/avatar/3438c2ed73b30d9314358437c0115705?s=100&r=x&d=retro",
            //     title: "Smartphone",
            //     words: 18,
            //     name: "xinzhao",
            //     press: () {
            //       Navigator.pushNamed(context, ProductsScreen.routeName);
            //     },
            //   ),
            //   SpecialFolder(
            //     image:
            //         "https://s.gravatar.com/avatar/3438c2ed73b30d9314358437c0115705?s=100&r=x&d=retro",
            //     title: "Fashion",
            //     words: 24,
            //     name: "xinzhao",
            //     press: () {
            //       Navigator.pushNamed(context, ProductsScreen.routeName);
            //     },
            //   ),
            //   const SizedBox(width: 20),
            // ],
          ),
        )
      ],
    );
  }
}
