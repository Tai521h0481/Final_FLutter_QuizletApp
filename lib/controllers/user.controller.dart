import 'dart:convert';

import 'package:http/http.dart' as http;

String baseUrl = "http://192.168.83.67:3000";
String register = baseUrl + "/android/users/register";
String login = baseUrl + "/android/users/login";

Future<Map<String, dynamic>> registerAPI({required email, required password}) async {
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

Future<Map<String, dynamic>> loginAPI({required email, required password}) async {
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
