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

  if (response.statusCode == 200) {
    return json.decode(response.body);
  } else {
    print('Request failed with status: ${response.statusCode}.');
    print('Response body: ${response.body}');
    throw Exception('Failed to load topics: Server responded with ${response.statusCode}');
  }
}


