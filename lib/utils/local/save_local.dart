import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class LocalStorageService {
  Future<void> saveData(String name, dynamic data) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String encodedData;
    if (data is String) {
      encodedData = data;
    } else {
      encodedData = json.encode(data);
    }

    await prefs.setString(name, encodedData);
  }

  Future<dynamic> getData(String name) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? data = prefs.getString(name);

    if (data != null) {
      try {
        return json.decode(data);
      } catch (e) {
        return data;
      }
    }
    return null;
  }
}
