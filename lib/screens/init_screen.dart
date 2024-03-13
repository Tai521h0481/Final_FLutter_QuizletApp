import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shop_app/constants.dart';
import 'package:shop_app/screens/favorite/favorite_screen.dart';
import 'package:shop_app/screens/home/home_screen.dart';
import 'package:shop_app/screens/profile/profile_screen.dart';

const Color inActiveIconColor = Color(0xFFB6B6B6);

class InitScreen extends StatefulWidget {
  const InitScreen({super.key});

  static String routeName = "/";

  @override
  State<InitScreen> createState() => _InitScreenState();
}

class _InitScreenState extends State<InitScreen> {
  int currentSelectedIndex = 0;

  void updateCurrentIndex(int index) {
    setState(() {
      currentSelectedIndex = index;
    });
  }

  final pages = [
    const HomeScreen(),
    const FavoriteScreen(),
    Container(),
    const Center(
      child: Text("Chat"),
    ),
    ProfileScreen()
  ];

  Future<Map<String, dynamic>?> getUserInfo() async {
    final prefs = await SharedPreferences.getInstance();
    String? userJson = prefs.getString('data');
    if (userJson == null) return null;
    Map<String, dynamic> userData = json.decode(userJson);
    return userData;
  }

  Future show() {
    return showModalBottomSheet(
      showDragHandle: true,
      context: context,
      builder: (BuildContext context) {
        return Wrap(
          children: <Widget>[
            Container(
              margin:
                  const EdgeInsets.only(left: 20, top: 5, right: 20, bottom: 5),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                color: kSecondaryColor.withOpacity(0.1),
              ),
              child: ListTile(
                leading: const Icon(Icons.copy_all_sharp),
                title: const Text(
                  'Module',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                onTap: () {
                  // Handle EDIT action
                  Navigator.pop(context);
                },
              ),
            ),
            Container(
              margin:
                  const EdgeInsets.only(left: 20, top: 5, right: 20, bottom: 5),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                color: kSecondaryColor.withOpacity(0.1),
              ),
              child: ListTile(
                leading: const Icon(Icons.folder),
                title: const Text(
                  'Folder',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                onTap: () {
                  // Handle ADD TOPIC action
                  Navigator.pop(context);
                },
              ),
            ),
            Container(
              margin: const EdgeInsets.only(
                  left: 20, top: 5, right: 20, bottom: 30),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                color: kSecondaryColor.withOpacity(0.1),
              ),
              child: ListTile(
                leading: const Icon(Icons.person),
                title: const Text(
                  'Classroom',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                onTap: () {
                  // Handle REMOVE action
                  Navigator.pop(context);
                },
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: pages[currentSelectedIndex],
      bottomNavigationBar: BottomAppBar(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            IconButton(
              icon: SvgPicture.asset(
                "assets/icons/Shop Icon.svg",
                color: currentSelectedIndex == 0
                    ? Color(0xFF4C56FF)
                    : inActiveIconColor,
                width: 22,
                height: 22,
              ),
              onPressed: () => updateCurrentIndex(0),
            ),
            IconButton(
              icon: SvgPicture.asset(
                "assets/icons/Discover Icon.svg",
                color: currentSelectedIndex == 1
                    ? Color(0xFF4C56FF)
                    : inActiveIconColor,
                width: 25,
                height: 25,
              ),
              onPressed: () => updateCurrentIndex(1),
            ),
            IconButton(
              icon: Icon(
                Icons.add_circle_outline_sharp,
                color: inActiveIconColor,
                size: 55 - 10,
              ),
              onPressed: () => show(),
            ),
            IconButton(
              icon: SvgPicture.asset(
                "assets/icons/folder icon.svg",
                color: currentSelectedIndex == 3
                    ? Color(0xFF4C56FF)
                    : inActiveIconColor,
                width: 25,
                height: 25,
              ),
              onPressed: () => updateCurrentIndex(3),
            ),
            IconButton(
              icon: Icon(
                Icons.account_circle_outlined,
                color: currentSelectedIndex == 4
                    ? Color(0xFF4C56FF)
                    : inActiveIconColor,
                size: 32,
              ),
              onPressed: () => updateCurrentIndex(4),
            ),
          ],
        ),
      ),
    );
  }
}
