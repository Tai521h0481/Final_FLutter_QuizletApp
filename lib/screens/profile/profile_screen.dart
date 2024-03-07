import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shop_app/screens/profile/profile_edit_screen.dart';
import 'package:shop_app/screens/sign_in/sign_in_screen.dart';

import 'components/profile_menu.dart';
import 'components/profile_pic.dart';

class ProfileScreen extends StatefulWidget {
  static String routeName = "/profile";

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String _userName = "User";
  String _userEmail = "user@gmail.com";
  String _profileImageUrl = "";

  @override
  void initState() {
    super.initState();
    loadUserData();
  }

  Future<void> loadUserData() async {
    final prefs = await SharedPreferences.getInstance();
    String token = prefs.getString('token') ?? '';
    final dataString = prefs.getString('data') ?? '';
    print("data: $dataString");
    if (token.isEmpty) {
      print('Token is empty. Cannot load topics.');
      return;
    }

    if (dataString.isNotEmpty) {
      try {
        final Map<String, dynamic> data = json.decode(dataString);
        setState(() {
          _userName = data["username"] ?? "Default Name";
          _userEmail = data["email"] ?? "default@email.com";
          _profileImageUrl = data["profileImage"];
        });
      } catch (e) {
        print('Error parsing user data: $e');
      }
    } else {
      print('User data is empty.');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(vertical: 20),
          child: Column(
            children: [
              const SizedBox(height: 50),
              ProfilePic(profileImageUrl: _profileImageUrl),
              const SizedBox(height: 10),
              Text(
                _userName,
                style: const TextStyle(
                  fontSize: 20,
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                _userEmail,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 10),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                decoration: BoxDecoration(
                  color: const Color(0xFFFDC204),
                  borderRadius: BorderRadius.circular(29),
                ),
                child: const Text(
                  "Upgrade to Premium",
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.black,
                  ),
                ),
              ),
              const SizedBox(height: 30),
              ProfileMenu(
                text: "My Account",
                icon: "assets/icons/User Icon.svg",
                press: () {
                  Navigator.pushNamed(context, ProfileEditScreen.routeName);
                },
              ),
              ProfileMenu(
                text: "Achievements",
                icon: "assets/icons/Bell.svg",
                press: () {},
              ),
              ProfileMenu(
                text: "Settings",
                icon: "assets/icons/Settings.svg",
                press: () {},
              ),
              ProfileMenu(
                text: "Log Out",
                icon: "assets/icons/Log out.svg",
                press: () async {
                  SharedPreferences preferences =
                      await SharedPreferences.getInstance();
                  await preferences.remove("data");
                  Navigator.pushNamedAndRemoveUntil(
                      context, SignInScreen.routeName, (route) => false);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
