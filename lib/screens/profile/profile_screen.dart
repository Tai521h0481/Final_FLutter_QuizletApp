import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shop_app/screens/profile/profile_edit_screen.dart';
import 'package:shop_app/screens/sign_in/sign_in_screen.dart';

import 'components/profile_menu.dart';
import 'components/profile_pic.dart';

class ProfileScreen extends StatelessWidget {
  static String routeName = "/profile";
  Map<String, dynamic> userInfo = {};
  String token = '';
  Map<String, dynamic> topics = {};

  Future<void> loadUserData() async {
    final prefs = await SharedPreferences.getInstance();
    String token = prefs.getString('token') ?? '';
    final data = prefs.getString('data') ?? '';
    print(data);
    if (token.isEmpty) {
      print('Token is empty. Cannot load topics.');
      return;
    }

    try {
      // await getTopicByUserAPI(token).then((value) => setState(() {
      //       userInfo = value['user'] ?? {};
      //       print('User info: $userInfo');
      //     }));
      // await getVocabularyByTopicId(widget.topicId, token).then((value) {
      //   if (mounted) {
      //     setState(() {
      //       topics = value ?? {};
      //       print('Topics: $topics');
      //       print('Vocabularies: ${topics['vocabularies']}');
      //     });
      //   }
      //   ;
      // });
    } catch (e) {
      print('Exception occurred while loading topics: $e');
    }
  }

  ProfileScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(vertical: 20),
          child: Column(
            children: [
              const SizedBox(height: 50),
              const ProfilePic(),
              const SizedBox(height: 10),
              const Text(
                "John Doe",
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Text(
                "abc@gmail.com",
                style: TextStyle(
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
                  preferences.clear();
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
