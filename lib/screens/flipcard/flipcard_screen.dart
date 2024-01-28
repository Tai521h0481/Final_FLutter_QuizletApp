import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shop_app/controllers/user.controller.dart';
import 'components/flipcard_header.dart';
import 'components/flipcard_bottom.dart';
import 'components/flipcard_middle.dart';

class FlipCardScreen extends StatefulWidget {
  static String routeName = "/flipcards";
  final String topicId;

  const FlipCardScreen({Key? key, required this.topicId}) : super(key: key);

  @override
  _FlipCardScreenState createState() => _FlipCardScreenState();
}

class _FlipCardScreenState extends State<FlipCardScreen> {
  PageController pageController = PageController(viewportFraction: 0.9);
  int currentPage = 0;
  Map<String, dynamic> userData = {};
  String token = '';
  Map<String, dynamic> topicData = {};

  @override
  void initState() {
    super.initState();
    getUserInfo();
    pageController.addListener(() {
      int next = pageController.page!.round();
      if (currentPage != next) {
        setState(() {
          currentPage = next;
        });
      }
    });
  }

  void getUserInfo() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      String? userJson = prefs.getString('data');
      String? tk = prefs.getString('token');
      if (userJson != null) {
        Map<String, dynamic> data = json.decode(userJson);
        if (mounted) {
          setState(() {
            userData = data;
            token = tk ?? '';

            getVocabularyByTopicId(widget.topicId, token).then((value) {
              if (mounted) {
                setState(() {
                  topicData = value ?? {};
                  print('Topic data: $topicData');
                });
              }
            });
          });
        }
      }
    } catch (e) {
      print('Error loading user info: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text('Flip Card'),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.more_horiz),
            onPressed: () {},
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            color: const Color(0xFFF6F7FB),
            child: Column(
              children: <Widget>[
                Header(
                  pageController: pageController,
                  currentPage: currentPage,
                  vocabularies: topicData['vocabularies'] ?? [],
                ),
                Middle(
                  listTile: const ListTile(
                    leading: CircleAvatar(
                      backgroundImage:
                          AssetImage('assets/images/Profile Image.png'),
                    ),
                    title: Text(
                      'Topic Name',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                const Bottom(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }
}
