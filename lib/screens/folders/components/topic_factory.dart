import 'package:flutter/material.dart';
import 'package:shop_app/screens/flipcard/flipcard_screen.dart';
import 'topic_in_folder.dart';

class TopicWidgetFactory {
  static Widget createWidget(Map<String, dynamic> topic, BuildContext context) {
    String title = topic['topicNameEnglish'] ?? 'Title';
    String image = topic['ownerId']['profileImage'] ?? '';
    int words = topic['vocabularyCount'] ?? 0;
    String name = topic['ownerId']['username'] ?? 'Name';

    return TopicInFolder(
      title: title,
      image: image,
      words: words,
      name: name,
      press: () {
        Navigator.pushNamed(
          context,
          FlipCardScreen.routeName,
          arguments: {
            "_id": topic["_id"],
            "title": title,
            'image': image,
            'username': name,
            'terms': words.toString(),
          },
        );
      },
    );
  }
}
