import 'dart:convert';
import 'package:http/http.dart' as http;
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

Future<Map<String, dynamic>> createTopic(String topicNameEnglish,
    String? descriptionEnglish, List<Map<String, String>> vocabularyList, String token) async {
  Map<String, dynamic> studySetMap = {
    "topicNameEnglish": topicNameEnglish,
    "descriptionEnglish": descriptionEnglish ?? '',
    "vocabularyList": vocabularyList,
  };

  var response = await http.post(
    Uri.parse(createTopicUrl),
    headers: {
      'Content-Type': 'application/json',
      'token': '$token'
    },
    body: jsonEncode(studySetMap),
  );

  if (response.statusCode == 200 || response.statusCode != 500) {
    return json.decode(response.body);
  } else {
    throw Exception(
        'Failed to load topics: Server responded with ${response.statusCode}');
  }
}


Future<Map<String, dynamic>> deleteTopic(String token, String id) async {
  var response = await http.delete(
    Uri.parse(deleteTopicUrl + id),
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