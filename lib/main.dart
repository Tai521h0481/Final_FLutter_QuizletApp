import 'package:flutter/material.dart';
import 'package:shop_app/screens/init_screen.dart';
import 'package:shop_app/screens/splash/splash_screen.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:shop_app/utils/local/save_local.dart';

import 'routes.dart';
import 'theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final initialRoute = await getInitialRoute();
  runApp(MyApp(initialRoute: initialRoute));
}

Future<String> getInitialRoute() async {
  final data = await LocalStorageService().getData("data");
  return data == null ? SplashScreen.routeName : InitScreen.routeName;
}

class MyApp extends StatelessWidget {
  final String initialRoute;
  const MyApp({super.key, required this.initialRoute});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'TNN App',
      theme: AppTheme.lightTheme(context),
      initialRoute: initialRoute,
      routes: routes,
      builder: EasyLoading.init(),
    );
  }
}
