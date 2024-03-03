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
  Map<String, dynamic> userInfo = {};
  String token = '';
  Map<String, dynamic> topics = {};

  @override
  void initState() {
    super.initState();
    loadTopics();
    pageController.addListener(() {
      int next = pageController.page!.round();
      if (currentPage != next) {
        setState(() {
          currentPage = next;
        });
      }
    });
  }

  Future<void> loadTopics() async {
    final prefs = await SharedPreferences.getInstance();
    String token = prefs.getString('token') ?? '';

    if (token.isEmpty) {
      print('Token is empty. Cannot load topics.');
      return;
    }

    try {
      await getTopicByUserAPI(token).then((value) => setState(() {
            userInfo = value['user'] ?? {};
            print('User info: $userInfo');
          }));
      await getVocabularyByTopicId(widget.topicId, token).then((value) {
        if (mounted) {
          setState(() {
            topics = value ?? {};
            print('Topics: $topics');
            print('Vocabularies: ${topics['vocabularies']}');
          });
        }
        ;
      });
    } catch (e) {
      print('Exception occurred while loading topics: $e');
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
                  vocabularies: topics['vocabularies'] ?? [],
                ),
                Middle(
                  title: 'Title',
                  listTile: ListTile(
                    leading: CircleAvatar(
                      backgroundImage:
                          NetworkImage(userInfo['profileImage'] ?? ''),
                    ),
                    title: Text(
                      userInfo['username'] ?? '',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                Bottom(
                  currentPage: currentPage,
                  vocabularies: topics['vocabularies'] ?? [],
                ),
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
