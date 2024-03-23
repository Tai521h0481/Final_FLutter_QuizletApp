import 'dart:convert';
import 'package:http/http.dart' as http;
import 'config.dart';

Future<Map<String, dynamic>> getTopicByID(String id, String token) async {
  var response = await http.get(
    Uri.parse(getTopicByIdUrl + id),
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
    String? descriptionEnglish,
    List<Map<String, String>> vocabularyList,
    String token,
    bool isPublic) async {
  Map<String, dynamic> studySetMap = {
    "topicNameEnglish": topicNameEnglish,
    "descriptionEnglish": descriptionEnglish ?? '',
    "vocabularyList": vocabularyList,
    "isPublic": isPublic,
  };

  var response = await http.post(
    Uri.parse(createTopicUrl),
    headers: {'Content-Type': 'application/json', 'token': '$token'},
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

Future<Map<String, dynamic>> updateTopic(String token, String id,
    String topicNameEnglish, String descriptionEnglish) async {
  Map<String, dynamic> data = {
    "topicNameEnglish": topicNameEnglish,
    "descriptionEnglish": descriptionEnglish,
  };

  var response = await http.put(
    Uri.parse(updateTopicUrl + id),
    headers: {
      'Content-Type': 'application/json',
      'token': '$token',
    },
    body: jsonEncode(data),
  );

  if (response.statusCode == 200 || response.statusCode != 500) {
    return json.decode(response.body);
  } else {
    throw Exception(
        'Failed to load topics: Server responded with ${response.statusCode}');
  }
}

Future<Map<String, dynamic>> updateVocabInTopic(
  String token,
  String topicId,
  String vocabId,
  String englishWord,
  String vietnameseWord,
) async {
  Map<String, dynamic> data = {
    "englishWord": englishWord,
    "vietnameseWord": vietnameseWord,
  };

  var response = await http.put(
    Uri.parse(updateVocabInTopicUrl
        .replaceAll(':id', topicId)
        .replaceAll(':vocabularyId', vocabId)),
    headers: {
      'Content-Type': 'application/json',
      'token': '$token',
    },
    body: jsonEncode(data),
  );

  if (response.statusCode == 200 || response.statusCode != 500) {
    return json.decode(response.body);
  } else {
    throw Exception(
        'Failed to load topics: Server responded with ${response.statusCode}');
  }
}

Future<Map<String, dynamic>> createVocabToTopic(String token, String topicId,
    String englishWord, String vietnameseWord) async {
  Map<String, dynamic> data = {
    "englishWord": englishWord,
    "vietnameseWord": vietnameseWord,
  };

  var response = await http.post(
    Uri.parse(createVocabToTopicUrl.replaceAll(':id', topicId)),
    headers: {
      'Content-Type': 'application/json',
      'token': '$token',
    },
    body: jsonEncode(data),
  );

  if (response.statusCode == 200 || response.statusCode != 500) {
    return json.decode(response.body);
  } else {
    throw Exception(
        'Failed to load topics: Server responded with ${response.statusCode}');
  }
}

Future<Map<String, dynamic>> deleteVocabInTopic(String token, String topicId, String vocabId) async {
  var response = await http.delete(
    Uri.parse(deleteVocabInTopicUrl
        .replaceAll(':id', topicId)
        .replaceAll(':vocabularyId', vocabId)),
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