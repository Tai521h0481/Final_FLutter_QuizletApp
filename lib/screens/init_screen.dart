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
    const Center(
      child: Text("Chat"),
    ),
    const ProfileScreen()
  ];

  Future<Map<String, dynamic>?> getUserInfo() async {
    final prefs = await SharedPreferences.getInstance();
    String? userJson = prefs.getString('data');
    if (userJson == null) return null;
    Map<String, dynamic> userData = json.decode(userJson);
    return userData;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: pages[currentSelectedIndex],
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        shape: const CircleBorder(),
        onPressed: () {
          print("Data: ${getUserInfo()}");
          getUserInfo().then((data) {
            if (data != null) {
              print(data['_id']);
            }
          });
          showModalBottomSheet(
            showDragHandle: true,
            context: context,
            builder: (BuildContext context) {
              return Wrap(
                children: <Widget>[
                  Container(
                    margin:
                        EdgeInsets.only(left: 20, top: 5, right: 20, bottom: 5),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      color: kSecondaryColor.withOpacity(0.1),
                    ),
                    child: ListTile(
                      leading: Icon(Icons.copy_all_sharp),
                      title: Text(
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
                        EdgeInsets.only(left: 20, top: 5, right: 20, bottom: 5),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      color: kSecondaryColor.withOpacity(0.1),
                    ),
                    child: ListTile(
                      leading: Icon(Icons.folder),
                      title: Text(
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
                    margin: EdgeInsets.only(
                        left: 20, top: 5, right: 20, bottom: 30),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      color: kSecondaryColor.withOpacity(0.1),
                    ),
                    child: ListTile(
                      leading: Icon(Icons.person),
                      title: Text(
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
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomNavigationBar(
        onTap: updateCurrentIndex,
        currentIndex: currentSelectedIndex,
        showSelectedLabels: false,
        showUnselectedLabels: false,
        type: BottomNavigationBarType.fixed,
        items: [
          BottomNavigationBarItem(
            icon: SvgPicture.asset(
              "assets/icons/Shop Icon.svg",
              colorFilter: const ColorFilter.mode(
                inActiveIconColor,
                BlendMode.srcIn,
              ),
            ),
            activeIcon: SvgPicture.asset(
              "assets/icons/Shop Icon.svg",
              colorFilter: const ColorFilter.mode(
                kPrimaryColor,
                BlendMode.srcIn,
              ),
            ),
            label: "Home",
          ),
          const BottomNavigationBarItem(
            icon: Padding(
              padding: EdgeInsets.only(right: 32),
              child: Icon(
                Icons.search,
                color: inActiveIconColor,
              ),
            ),
            activeIcon: Padding(
              padding: EdgeInsets.only(right: 32),
              child: Icon(
                Icons.search,
                color: kPrimaryColor,
              ),
            ),
            label: "Fav",
          ),
          const BottomNavigationBarItem(
            icon: Padding(
              padding: EdgeInsets.only(left: 32),
              child: Icon(
                Icons.folder,
                color: inActiveIconColor,
              ),
            ),
            activeIcon: Padding(
              padding: EdgeInsets.only(left: 32),
              child: Icon(
                Icons.folder,
                color: kPrimaryColor,
              ),
            ),
            label: "Library",
          ),
          BottomNavigationBarItem(
            icon: SvgPicture.asset(
              "assets/icons/User Icon.svg",
              colorFilter: const ColorFilter.mode(
                inActiveIconColor,
                BlendMode.srcIn,
              ),
            ),
            activeIcon: SvgPicture.asset(
              "assets/icons/User Icon.svg",
              colorFilter: const ColorFilter.mode(
                kPrimaryColor,
                BlendMode.srcIn,
              ),
            ),
            label: "Fav",
          ),
        ],
      ),
    );
  }
}
