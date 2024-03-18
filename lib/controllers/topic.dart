import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shop_app/models/Vocabulary.dart';
import 'config.dart';

Future<Map<String, dynamic>> getTopicByID(String id, String token) async {
  var response = await http.get(
    Uri.parse(getTopicById + id),
    headers: {
      'token': '$token',
    },
  );

  if (response.statusCode == 200 || response.statusCode != 500) {
    return json.decode(response.body);
  } else {
    throw Exception(
        'Failed to load topics: Server responded with ${response.statusCode}');
  }
}

Future<Map<String, dynamic>> getTopicByFolderID(String id, String token) async {
  var response = await http.get(
    Uri.parse(getTopicByFolderId + id),
  );

  if (response.statusCode == 200 || response.statusCode != 500) {
    return json.decode(response.body);
  } else {
    throw Exception(
        'Failed to load topics: Server responded with ${response.statusCode}');
  }
}

Future<Map<String, dynamic>> getPublicTopic(String token) async {
  var response = await http.get(
    Uri.parse(getPublicTopicUrl),
    headers: {
      'token': '$token',
    },
  );

  if (response.statusCode == 200 || response.statusCode != 500) {
    return json.decode(response.body);
  } else {
    throw Exception(
        'Failed to load topics: Server responded with ${response.statusCode}');
  }
}

Future<Map<String, dynamic>> createTopic(
    String topicNameEnglish,
    String descriptionEnglish,
    List<Vocabulary> vocabulary,
    bool isPublic) async {
  var response = await http.post(
    Uri.parse(createTopicUrl),
    headers: {
      'Content-Type': 'application/json',
    },
    body: json.encode({}),
  );

  if (response.statusCode == 200 || response.statusCode != 500) {
    return json.decode(response.body);
  } else {
    throw Exception(
        'Failed to load topics: Server responded with ${response.statusCode}');
  }
}
