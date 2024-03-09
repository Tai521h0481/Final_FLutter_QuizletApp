import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shop_app/controllers/user.controller.dart';
import 'package:shop_app/screens/flipcard/flipcard_screen.dart';
import 'package:shop_app/screens/home/components/special_cards.dart';

import 'section_title.dart';

class SpecialOffers extends StatefulWidget {
  const SpecialOffers({Key? key}) : super(key: key);

  @override
  _SpecialOffersState createState() => _SpecialOffersState();
}

class _SpecialOffersState extends State<SpecialOffers> {
  List<dynamic> topics = [];
  Map<String, dynamic> userInfo = {};

  @override
  void initState() {
    super.initState();
    loadTopics();
  }

  Future<void> loadTopics() async {
    final prefs = await SharedPreferences.getInstance();
    String token = prefs.getString('token') ?? '';

    if (token.isEmpty) {
      print('Token is empty. Cannot load topics.');
      return;
    }

    try {
      var data = await getTopicByUserAPI(token);
      setState(() {
        topics = data['user']['topicId'] ?? [];
        userInfo = data['user'] ?? {};
      });
    } catch (e) {
      print('Exception occurred while loading topics: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    if (topics.isEmpty) {
      return Container();
    }

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: SectionTitle(title: "Sets", press: () {}),
        ),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: List.generate(
              topics.length,
              (index) => SpecialOfferCard(
                image: userInfo["profileImage"] ?? '',
                title: topics[index]["topicNameEnglish"] ?? '',
                words: topics[index]["vocabularyCount"] ?? 0,
                name: userInfo["username"] ?? '',
                press: () {
                  Navigator.pushNamed(
                    context,
                    FlipCardScreen.routeName,
                    arguments: topics[index]["_id"],
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
