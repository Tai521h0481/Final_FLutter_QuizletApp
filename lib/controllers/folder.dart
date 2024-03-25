import 'dart:convert';

import 'package:http/http.dart' as http;
import 'config.dart';

Future<Map<String, dynamic>> getFolderByID(String id, String token) async {
  var response = await http.get(
    Uri.parse(getFolderByUser + id),
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

Future<Map<String, dynamic>> createFolder(
    String token, String folderNameEnglish, String folderNameVietnamese) async {
  Map<String, dynamic> data = {
    "folderNameEnglish": folderNameEnglish,
    "folderNameVietnamese": folderNameVietnamese,
  };

  var response = await http.post(
    Uri.parse(createFolderUrl),
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

Future<Map<String, dynamic>> deleteFolder(String token, String id) async {
  var response = await http.delete(
    Uri.parse(deleteFolderUrl + id),
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

Future<Map<String, dynamic>> updateFolder(
    String token, String folderID, String folderNameEnglish, String folderNameVietnamese) async {
  Map<String, dynamic> data = {
    "folderNameEnglish": folderNameEnglish,
    "folderNameVietnamese": folderNameVietnamese,
  };

  var response = await http.put(
    Uri.parse(editFolderUrl + folderID),
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
