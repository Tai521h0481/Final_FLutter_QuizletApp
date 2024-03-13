import 'dart:convert';
import 'dart:io';

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