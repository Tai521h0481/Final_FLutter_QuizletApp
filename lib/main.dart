import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shop_app/screens/home/home_screen.dart';
import 'package:shop_app/screens/init_screen.dart';
import 'package:shop_app/screens/splash/splash_screen.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

import 'routes.dart';
import 'theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'TNN App',
      theme: AppTheme.lightTheme(context),
      initialRoute: mainScreen(),
      routes: routes,
      builder: EasyLoading.init(),
    );
  }

  dynamic getInfo() async {
    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getString('data');
    return data;
  }

  String mainScreen() {
    getInfo().then((value) {
      if (value == null) {
        return SplashScreen.routeName;
      } 
    });
    return InitScreen.routeName;
  }
}
