import 'dart:convert';

import 'package:http/http.dart' as http;
import 'config.dart';

Future<Map<String, dynamic>> registerAPI(
    {required email, required password}) async {
  var response = await http.post(
    Uri.parse(register),
    headers: {"Content-Type": "application/json"},
    body: jsonEncode({
      "email": email,
      "password": password,
    }),
  );

  final Map<String, dynamic> data = json.decode(response.body);
  return data;
}

Future<Map<String, dynamic>> loginAPI(
    {required email, required password}) async {
  var response = await http.post(
    Uri.parse(login),
    headers: {"Content-Type": "application/json"},
    body: jsonEncode({
      "email": email,
      "password": password,
    }),
  );

  final Map<String, dynamic> data = json.decode(response.body);
  return data;
}

Future<Map<String, dynamic>> recoverPassword({required email}) async {
  var response = await http.post(
    Uri.parse(recover_Password),
    headers: {"Content-Type": "application/json"},
    body: jsonEncode({
      "email": email,
    }),
  );

  final Map<String, dynamic> data = json.decode(response.body);
  return data;
}

Future<Map<String, dynamic>> getTopicByUserAPI(String token) async {
  var response = await http.get(
    Uri.parse(getTopicByUser),
    headers: {
      'token': '$token',
    },
  );

  if (response.statusCode == 200 && response.statusCode != 500) {
    return json.decode(response.body);
  } else{
    throw Exception(
        'Failed to load topics: Server responded with ${response.statusCode}');
  }
}

Future<Map<String, dynamic>> getTopicByID(String id, String token) async {
  var response = await http.get(
    Uri.parse(getTopic + id),
    headers: {
      'token': '$token',
    },
  );

  if (response.statusCode == 200 && response.statusCode != 500) {
    return json.decode(response.body);
  } else{
    throw Exception(
        'Failed to load topics: Server responded with ${response.statusCode}');
  }
}

Future<Map<String, dynamic>> getVocabularyByTopicId(
    String id, String token) async {
  var response = await http.get(
    Uri.parse(getVocabByTopicId + id),
    headers: {
      'token': '$token',
    },
  );

  if (response.statusCode == 200 && response.statusCode != 500) {
    return json.decode(response.body);
  } else{
    throw Exception(
        'Failed to load topics: Server responded with ${response.statusCode}');
  }
}

// change password
Future<Map<String, dynamic>> changePassword(
    String id, String token, String oldPassword, String newPassword) async {
  var response = await http.put(
    Uri.parse(changePasswordUrl + id),
    headers: {
      'Content-Type': 'application/json', // Explicitly set the content type
      'token': '$token', // Use a more standard Authorization header
    },
    body: jsonEncode({
      "password": oldPassword,
      "newPassword": newPassword,
    }),
  );

  if (response.statusCode == 200 || response.statusCode != 500) {
    return json.decode(response.body);
  } else{
    throw Exception(
        'Failed to load topics: Server responded with ${response.statusCode}');
  }
}

// update user
Future<Map<String, dynamic>> updateUser(
    String id, String token, String username) async {
  var response = await http.put(
    Uri.parse(updateUsername + id),
    headers: {
      'token': '$token',
    },
    body: jsonEncode({
      "username": username,
    }),
  );

  if (response.statusCode == 200 && response.statusCode != 500) {
    return json.decode(response.body);
  } else{
    throw Exception(
        'Failed to load topics: Server responded with ${response.statusCode}');
  }
}

// upload avatar
Future<Map<String, dynamic>> uploadAvatar(
    String id, String token, String username) async {
  var response = await http.put(
    Uri.parse(uploadAvatarUrl + id),
    headers: {
      'token': '$token',
    },
    // body: add image
  );

  if (response.statusCode == 200 && response.statusCode != 500) {
    return json.decode(response.body);
  } else{
    throw Exception(
        'Failed to load topics: Server responded with ${response.statusCode}');
  }
}
